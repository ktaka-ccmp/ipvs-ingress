package main

import (
	"log"
	"net/http"
	"os"
	"syscall"
	"os/exec"
	"strings"
//	"io/ioutil"
	"text/template"

	"github.com/spf13/pflag"
	"github.com/golang/glog"

	api "k8s.io/client-go/pkg/api/v1"

	"k8s.io/ingress/core/pkg/ingress"
//	"k8s.io/ingress/core/pkg/ingress/controller"
	"k8s.io/ingress/core/pkg/ingress/defaults"
	"github.com/ktaka-ccmp/ipvs-ingress/xlbd-controller/src/controller"
)


var cmd = exec.Command("/xlbd", "/etc/xlbd/xlbd.conf")
//var cmd = exec.Command("sleep", "10000")

func main() {
	c := newController()
	ic := controller.NewIngressController(c)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Start()
	defer func() {
		log.Printf("Shutting down ingress controller...")
		ic.Stop()
	}()
	ic.Start()
}


func newController() ingress.Controller {
	return &Controller{}
}

type Controller struct{}

func (c Controller) SetConfig(cfgMap *api.ConfigMap) {
	log.Printf("Config map %+v", cfgMap)
}

func (c Controller) Reload(data []byte) ([]byte, bool, error) {
	cmd.Process.Signal(syscall.SIGHUP)
	out, err := exec.Command("echo", string(data)).CombinedOutput()
	if err != nil {
		return out, false, err
	}
	log.Printf("Issue kill to xlbd. Reloaded new config %s", out)
	return out, true, err
}

func (c Controller) OnUpdate(updatePayload ingress.Configuration) ([]byte, error) {
	log.Printf("Received OnUpdate notification")

	for _, b := range updatePayload.Backends {

		if b.Name == "upstream-default-backend" {
			continue
		}

/*
		glog.Warningf("b.Name is %v", b.Name)
		glog.Warningf("b.Port is %v", b.Port)
		glog.Warningf("b.Service.Kind is %v", b.Service.Kind)
		glog.Warningf("b.Service.Spec.ClusterIP is %v", b.Service.Spec.ClusterIP)
		glog.Warningf("b.Service.Spec.ExternalIPs is %v", b.Service.Spec.ExternalIPs[0])
		glog.Warningf("b.Endpoints[0].Address is %v", b.Endpoints[0].Address)
		glog.Warningf("b.Endpoints[0].Port is %v", b.Endpoints[0].Port)
*/
		
		type ep struct{
			Rip string
		}

		eps := []ep{}
		for _, e := range b.Endpoints {
			eps = append(eps, ep{Rip: e.Address})
		}

		type vs struct{
//			Vip, Port string
			Vip string
			Eps []ep
		}

		vss := []vs{}
		for _, vip := range b.Service.Spec.ExternalIPs {
			vss = append(vss, vs{Vip: vip, Eps: eps})
		}

		for _, a := range vss {
			glog.V(1).Infof("VIP = %v", a.Vip)
			for _, b := range a.Eps {
				glog.V(1).Infof("\tRIP = %v", b.Rip)
			}
		}

		cnf := []string{"/etc/xlbd/" , "xlbd" , ".conf"}
		w, err := os.Create(strings.Join(cnf, ""))
		if err != nil {
			return []byte("Ooops"), err
		}
		tpl := template.Must(template.ParseFiles("xlbd.conf.tmpl"))
		tpl.Execute(w, vss)
		w.Close()
	}
	
	return []byte("xlbd.conf regenerated."), nil
}

func (c Controller) BackendDefaults() defaults.Backend {
        return defaults.Backend{}
}

func (c Controller) Name() string {
	return "IPVS Controller"
}

func (c Controller) Check(_ *http.Request) error {
	return nil
}

func (c Controller) Info() *ingress.BackendInfo {
	return &ingress.BackendInfo{
		Name:       "xlbd-controller",
		Release:    "0.0.0",
		Build:      "git-00000000",
		Repository: "git://github.com/ktaka-ccmp/ipvs-ingress/xlbd-controller",
	}
}

func (c Controller) OverrideFlags(*pflag.FlagSet) {
}

func (c Controller) SetListers(lister ingress.StoreLister) {

}

func (c Controller) DefaultIngressClass() string {
	return "xlbd-controller"
}


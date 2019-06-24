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
	
//	api "k8s.io/api/core/v1"
//	api_v1 "k8s.io/client-go/pkg/api/v1"
	api "k8s.io/client-go/pkg/api/v1"
//	lister "k8s.io/client-go/listers/core/v1"
//	"k8s.io/client-go/tools/cache"
//	nginxconfig "k8s.io/ingress/controllers/nginx/pkg/config"
//	"github.com/ktaka-ccmp/ipvs-ingress/ipvs-controller/src/pkg/ingress"
//	"github.com/ktaka-ccmp/ipvs-ingress/ipvs-controller/src/pkg/ingress/controller"
//	"github.com/ktaka-ccmp/ipvs-ingress/ipvs-controller/src/pkg/ingress/defaults"
//	"k8s.io/ingress-nginx/internal/ingress"
//	"k8s.io/ingress-nginx/internal/ingress/controller"
//	"k8s.io/ingress-nginx/internal/ingress/defaults"
	"k8s.io/ingress/core/pkg/ingress"
	"github.com/ktaka-ccmp/ipvs-ingress/ipvs-controller-test/src/controller"
	//	"k8s.io/ingress/core/pkg/ingress/controller"
	"k8s.io/ingress/core/pkg/ingress/defaults"
//	"k8s.io/ingress/core/pkg/ingress/store"
)


var cmd = exec.Command("keepalived", "-nCDlf", "/etc/keepalived/ipvs.conf")

func main() {
	ipvs := newIPVSController()
	ic := controller.NewIngressController(ipvs)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Start()
	defer func() {
		log.Printf("Shutting down ingress controller...")
		ic.Stop()
	}()
	ic.Start()
}


func newIPVSController() ingress.Controller {
	return &IPVSController{
//		configmap:     &api.ConfigMap{}, 
	}
}

type IPVSController struct{

//	configmap *api.ConfigMap
//	storeLister ingress.StoreLister
//        svcLister  store.ServiceLister
	
//	store store.Storer
//	svcLister  store.ServiceLister
}

func (ipvs IPVSController) SetConfig(cfgMap *api.ConfigMap) {
//	ipvs.configmap = cfgMap
	log.Printf("Config map %+v", cfgMap)
}

func (ipvs IPVSController) Reload(data []byte) ([]byte, bool, error) {
	cmd.Process.Signal(syscall.SIGHUP)
	out, err := exec.Command("echo", string(data)).CombinedOutput()
	if err != nil {
		return out, false, err
	}
	log.Printf("Issue kill to keepalived. Reloaded new config %s", out)
	return out, true, err
}



func (ipvs IPVSController) OnUpdate(updatePayload ingress.Configuration) ([]byte, error) {
	log.Printf("Received OnUpdate notification")
		
		
	for _, b := range updatePayload.Backends {

		if b.Name == "upstream-default-backend" {
			continue
		}


		glog.Warningf("b.Name is %v", b.Name)
		glog.Warningf("b.Port is %v", b.Port)
		glog.Warningf("b.Service.Kind is %v", b.Service.Kind)
		glog.Warningf("b.Service.Spec.ClusterIP is %v", b.Service.Spec.ClusterIP)
		glog.Warningf("b.Service.Spec.ExternalIPs is %v", b.Service.Spec.ExternalIPs[0])
		glog.Warningf("b.Endpoints[0].Address is %v", b.Endpoints[0].Address)
		glog.Warningf("b.Endpoints[0].Port is %v", b.Endpoints[0].Port)


//		for i, _ := range b.Service.Spec.ExternalIPs {
//		 	log.Printf("Service %v:", ip)
//		 	log.Printf("Hellooooo %d", i)
//		}

//		log.Printf("Type =  %v", b.Service.Spec.Type)

//		svc := b.Service
//		glog.Warningf("service %v was not found", svc.Spec.ClusterIP)

		// if svc == nil {
		//  	log.Printf("Missing Service %q(%p)", b.Name, svc)
		//  	continue
		// }
		// log.Printf("Not Missing Service %q(%p)", b.Name, svc)
		// log.Printf("ClusterIP =  %v", (*svc).Spec.ClusterIP)
//		log.Printf("ClusterIP =  %v", &svc.Spec.ClusterIP)
		
		
		type ep struct{
			Address,Port string
		}
		eps := []ep{}
		for _, e := range b.Endpoints {
			eps = append(eps, ep{Address: e.Address, Port: e.Port})
		}

		for _, a := range eps {
		log.Printf("Endpoint %v:%v added to %v:%v.", a.Address, a.Port, b.Name, b.Port)
		}

		cnf := []string{"/etc/keepalived/ipvs.d/" , b.Name , ".conf"}
		w, err := os.Create(strings.Join(cnf, ""))
		if err != nil {
			return []byte("Ooops"), err
		}
		tpl := template.Must(template.ParseFiles("ipvs.conf.tmpl"))
		tpl.Execute(w, eps)
		w.Close()
	}
	
	return []byte("hello"), nil
}

func (ipvs IPVSController) BackendDefaults() defaults.Backend {
	// Just adopt nginx's default backend config
//	return nginxconfig.NewDefault().Backend
        a := defaults.Backend{}
        return a
}

func (ipvs IPVSController) Name() string {
	return "IPVS Controller"
}

func (ipvs IPVSController) Check(_ *http.Request) error {
	return nil
}

func (ipvs IPVSController) Info() *ingress.BackendInfo {
	return &ingress.BackendInfo{
		Name:       "ipvs-ingress",
		Release:    "0.0.0",
		Build:      "git-00000000",
		Repository: "git://github/ccmp-ktaka",
	}
}

func (ipvs IPVSController) OverrideFlags(*pflag.FlagSet) {
}

func (ipvs IPVSController) SetListers(lister ingress.StoreLister) {
//	ipvs.storeLister = lister
}

func (ipvs IPVSController) DefaultIngressClass() string {
	return "ipvs"
}


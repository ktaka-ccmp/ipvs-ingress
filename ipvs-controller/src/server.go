package main

import (
	"log"
	"net/http"
	"os/exec"
	"strings"
	"io/ioutil"

	"github.com/spf13/pflag"

	api "k8s.io/client-go/pkg/api/v1"

	nginxconfig "k8s.io/ingress/controllers/nginx/pkg/config"
	"k8s.io/ingress/core/pkg/ingress"
	"k8s.io/ingress/core/pkg/ingress/controller"
	"k8s.io/ingress/core/pkg/ingress/defaults"
)

func main() {
	ipvs := newIPVSController()
	ic := controller.NewIngressController(ipvs)
	defer func() {
		log.Printf("Shutting down ingress controller...")
		ic.Stop()
	}()
	ic.Start()
}

func newIPVSController() ingress.Controller {
	return &IPVSController{}
}

type IPVSController struct{}

func (ipvs IPVSController) SetConfig(cfgMap *api.ConfigMap) {
	log.Printf("Config map %+v", cfgMap)
}

func (ipvs IPVSController) Reload(data []byte) ([]byte, bool, error) {
	out, err := exec.Command("echo", string(data)).CombinedOutput()
	if err != nil {
		return out, false, err
	}
	log.Printf("Issue kill to keepalived. Reloaded new config %s", out)
	return out, true, err
}

func (ipvs IPVSController) Test(file string) *exec.Cmd {
	return exec.Command("echo", file)
}

func (ipvs IPVSController) OnUpdate(updatePayload ingress.Configuration) ([]byte, error) {
	log.Printf("Received OnUpdate notification")
	for _, b := range updatePayload.Backends {
		eps := []string{}
		for _, e := range b.Endpoints {
			eps = append(eps, e.Address)
		}
		log.Printf("%v: %v", b.Name, strings.Join(eps, ", "))
		ioutil.WriteFile("hello", []byte(strings.Join(eps, ", ")) , 0644)
	}
	return []byte("hello"), nil
}

func (ipvs IPVSController) BackendDefaults() defaults.Backend {
	// Just adopt nginx's default backend config
	return nginxconfig.NewDefault().Backend
}

func (n IPVSController) Name() string {
	return "IPVS Controller"
}

func (n IPVSController) Check(_ *http.Request) error {
	return nil
}

func (dc IPVSController) Info() *ingress.BackendInfo {
	return &ingress.BackendInfo{
		Name:       "dummy",
		Release:    "0.0.0",
		Build:      "git-00000000",
		Repository: "git://foo.bar.com",
	}
}

func (n IPVSController) OverrideFlags(*pflag.FlagSet) {
}

func (n IPVSController) SetListers(lister ingress.StoreLister) {

}

func (n IPVSController) DefaultIngressClass() string {
	return "dummy"
}


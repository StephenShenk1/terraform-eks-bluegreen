resource "helm_release" "nginx_ingress_blue" {
  provider = helm.blue
  name     = "nginx-ingress"
  chart    = "ingress-nginx/ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"

  values = [
    yamlencode({
      controller = {
        service = {
          type = "NodePort"
          nodePorts = { http = 30080 }
        }
      }
    })
  ]
}

resource "helm_release" "nginx_ingress_green" {
  provider = helm.green
  name     = "nginx-ingress"
  chart    = "ingress-nginx/ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"

  values = [
    yamlencode({
      controller = {
        service = {
          type = "NodePort"
          nodePorts = { http = 30080 }
        }
      }
    })
  ]
}

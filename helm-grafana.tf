
resource "time_sleep" "wait_for_kubernetes" {

    depends_on = [
        data.aws_eks_cluster.installationcluster
    ]

    create_duration = "20s"
}

resource "null_resource" "example" {
  provisioner "local-exec" {
   command    = "cat ~/.kube/config"
  }
}

resource "helm_release" "grafana" {
 
  name       = "grafana"  
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  namespace  = "prometheus"
  create_namespace = false
  version    = "6.59.4"
  timeout = 2000
  set {
    name  = "server.persistentVolume.enabled"
    value = false
  }
  set {
    name = "server\\.resources"
    value = yamlencode({
      limits = {
        cpu    = "200m"
        memory = "50Mi"
      }
      requests = {
        cpu    = "100m"
        memory = "30Mi"
      }
    })
  }
}
  

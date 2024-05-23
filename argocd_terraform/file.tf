provider "kubernetes" {
  config_context_cluster   = var.cluster_name
}

resource "kubernetes_namespace" "argocd_namespace" {
  metadata {
    name = var.namespace_name
  }
}

resource "kubernetes_secret" "argocd_secret" {
  metadata {
    name      = var.secret_name
    namespace = kubernetes_namespace.argocd_namespace.metadata.0.name
  }

  data = {
    "server.secretkey" = var.server_secret_key
  }
}

resource "kubernetes_config_map" "argocd_config" {
  metadata {
    name      = var.config_map_name
    namespace = kubernetes_namespace.argocd_namespace.metadata.0.name
  }

  data = {
    "url" = var.argocd_domain
  }
}

resource "kubernetes_config_map" "argocd_repo_config" {
  metadata {
    name      = var.repo_config_name
    namespace = kubernetes_namespace.argocd_namespace.metadata.0.name
  }

  data = {
    "url" = var.git_repo_url
  }
}

resource "kubernetes_deployment" "argocd_server" {
  metadata {
    name      = var.deployment_name
    namespace = kubernetes_namespace.argocd_namespace.metadata.0.name
    labels = {
      app = var.deployment_app_label
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = var.deployment_app_label
      }
    }

    template {
      metadata {
        labels = {
          app = var.deployment_app_label
        }
      }

      spec {
        container {
          name  = var.container_name
          image = var.argocd_image
          volume_mount {
            name       = "argocd-secret"
            mount_path = var.mount_path_secret
          }
          volume_mount {
            name       = "argocd-cm"
            mount_path = var.mount_path_config
          }
        }

        volume {
          name = "argocd-secret"
          secret {
            secret_name = kubernetes_secret.argocd_secret.metadata.0.name
          }
        }

        volume {
          name = "argocd-cm"
          config_map {
            name = kubernetes_config_map.argocd_config.metadata.0.name
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "argocd_server_service" {
  metadata {
    name      = var.service_name
    namespace = kubernetes_namespace.argocd_namespace.metadata.0.name
  }

  spec {
    selector = {
      app = var.deployment_app_label
    }

    port {
      port        = var.service_port
      target_port = var.container_port
    }
  }
}

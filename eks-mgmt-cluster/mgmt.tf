terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = ">= 2.32.0"
    }
  }
  backend "s3" {
    bucket    = "tofu-state"
    key       = "eks-mgmt-cluster/terraform.tfstate"
    endpoints = { s3 = "https://swf.objects.mtsi.bigbang.dev" }
    region    = "us-east-1"

    shared_credentials_files    = ["~/.nutanix/credentials"]
    insecure                    = true
    skip_credentials_validation = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    skip_s3_checksum            = true
  }
}

provider "kubernetes" {
  config_path    = "${KUBECONFIG}"
}

resource "kubernetes_manifest" "cluster_mgmt" {
  computed_fields = ["metadata.generation"]
  field_manager {
    force_conflicts = true
  }
  manifest = {
    "apiVersion" = "anywhere.eks.amazonaws.com/v1alpha1"
    "kind" = "Cluster"
    "metadata" = {
      "annotations" = {
        "anywhere.eks.amazonaws.com/eksa-cilium" = ""
        "anywhere.eks.amazonaws.com/management-components-version" = "v0.20.3"
      }
      "name" = "mgmt"
      "namespace" = "default"
    }
    "spec" = {
      "clusterNetwork" = {
        "cniConfig" = {
          "cilium" = {}
        }
        "dns" = {}
        "pods" = {
          "cidrBlocks" = [
            "192.168.0.0/16",
          ]
        }
        "services" = {
          "cidrBlocks" = [
            "10.96.0.0/12",
          ]
        }
      }
      "controlPlaneConfiguration" = {
        "certSans" = [
          "kube-mgmt.mtsi.bigbang.dev",
          "10.96.0.1",
          "10.0.200.30",
        ]
        "count" = 3
        "endpoint" = {
          "host" = "10.0.200.30"
        }
        "kubeletConfiguration" = {
          "kind" = "KubeletConfiguration"
          "rotateCertificates" = true
          "serverTLSBootstrap" = true
          "tlsCipherSuites" = [
            "TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256",
          ]
        }
        "machineGroupRef" = {
          "kind" = "NutanixMachineConfig"
          "name" = "mgmt-cp"
        }
        "machineHealthCheck" = {
          "maxUnhealthy" = "100%"
        }
      }
      "datacenterRef" = {
        "kind" = "NutanixDatacenterConfig"
        "name" = "mgmt"
      }
      "eksaVersion" = "v0.20.3"
      "externalEtcdConfiguration" = {
        "count" = 3
        "machineGroupRef" = {
          "kind" = "NutanixMachineConfig"
          "name" = "mgmt-etcd"
        }
      }
      "kubernetesVersion" = "1.29"
      "machineHealthCheck" = {
        "maxUnhealthy" = "100%"
        "nodeStartupTimeout" = "10m0s"
        "unhealthyMachineTimeout" = "5m0s"
      }
      "managementCluster" = {
        "name" = "mgmt"
      }
      "registryMirrorConfiguration" = {
        "caCertContent" = <<-EOT
        -----BEGIN CERTIFICATE-----
        MIIFHjCCAwagAwIBAgIUXhDi3qaPkM6tiUaOahDazYcu8EwwDQYJKoZIhvcNAQEL
        BQAwFjEUMBIGA1UEAwwLMTAuMC4yMC4yMzgwHhcNMjQwOTE2MTg1MjE3WhcNMzQw
        OTE0MTg1MjE3WjAWMRQwEgYDVQQDDAsxMC4wLjIwLjIzODCCAiIwDQYJKoZIhvcN
        AQEBBQADggIPADCCAgoCggIBAKROReC0BqwzBDjdpSXrvLO48mLXAhd9N0I8Tdf9
        APznEN/Kbbbwb29dJu9Z4sxW4YJQa3iGVGU5TeRBCa1JQajPEch93SI+oBXrzytE
        /V+9Amdo7OV/atASILV1PnzYfLULDLJihqmmoy+WJjycEJzPFXpeIFjdrf0aDnhs
        KgN17XeGG466wkcsRDLu0Ty8f7Yuv78qfGmi447fpfVMHT38m7TTml0naphA1+DP
        P817grkTHTlSdn32n67D4fuaqH3C3Pghu9KR5s9fM6WyUNqs6cPX5M5QWnLUkme5
        qODkNI7VxMyeQr3+TX7fQ29xd2qvUyJ+Ig4mV0MJJk1RLUcmrf7h7DyDa9Df9Xus
        Cuk3QcLERJIXbg08HxRr3K1Q3sgKTYcN4MFGUeJ3lZOzO9FHrNpFQRSFu7Wq8PY3
        Sd6nfVKsDIhuu+YTk8eieIgpAtotkxnG+eJ6+E7SDsVHk7TOMvToYk0bgU7aPp/O
        XR9lZikBSE2cRzFJfkPr1dCTeV61aoS6H3IBxmkc5des2OLlXhm4Wqjtb9P2VIuz
        neTGegtF0pDhwVRjGMbJYhUfKQB14EIdLs83j09jYhNbcdGXDVWC58RooEK77vFp
        Cq1qYChC+bvVuJLeIbyGq6ZMb8cYwxyuATWgFV8eIg89OOqf2pXnSo2HkAlyoZyb
        L1ahAgMBAAGjZDBiMB0GA1UdDgQWBBS9CqYpo2sgHyfF5tISz++FAUSyZjAfBgNV
        HSMEGDAWgBS9CqYpo2sgHyfF5tISz++FAUSyZjAPBgNVHRMBAf8EBTADAQH/MA8G
        A1UdEQQIMAaHBAoAFO4wDQYJKoZIhvcNAQELBQADggIBAGryHMXijQHPEl+oPf2y
        4fy20chydTsyVNRgkDn1Uii9XeG77G56uqewxWg2N5JOy+IhKuQK++u0g6u6JvZH
        yRMofmMEOT+SC6613hNyJiHRYtA236Zit90DWiakJuJ2545z+xT3rIWzGjTYIvtr
        hdLb5poNZxr1uZcot7FBc5ngqRW20PELS1wJ8ULZS9/gdxnbzZHACpBmCBdOLCzl
        3TT3WYIzDPSkszPjyeD8Rxhe8byYYKL2eDFsuk+Xa52TvcO3ko0OD9D07KbSJ5Gr
        v5FqwRod3EnEFYhzEVTDmSq258iN8nPHnP/ZsIQ0SHuJwalTSCXcVS+yg3ZKuf2/
        qRo5KoXa7/AyITHbZJmr1O229qOQTsQ1aX5D3MrH2mPTrGfu6N1A2XGzptSB/w0u
        VgKgft11QwxAo09HWXqVvo7suUk8U9JOgWX8HMmQWLiCh7/a3heuppVfJBHGBns6
        PySClTlA7FZI7+NPU2U2nVkxS6nDa6s02A2gKVN/5LPs9IZuOmr1EewsRvs3nvxe
        nGf6T+GwUJtZ1rtcDcp4PT9yjH1E67BemCdaPTPSZdD4t5JFl++y9PADoy1ONpd1
        iv3ElRNWOAsguaus1GC1iXwalr7zZ99byn4F+KaQnFtn7LjV7NS9jz8BPKD2XVH+
        WkTMBtzndlHlAhMdJfsOZ7K6
        -----END CERTIFICATE-----
        
        EOT
        "endpoint" = "10.0.20.238"
        "insecureSkipVerify" = true
        "port" = "5000"
      }
      "workerNodeGroupConfigurations" = [
        {
          "count" = 2
          "kubeletConfiguration" = {
            "kind" = "KubeletConfiguration"
            "rotateCertificates" = true
            "serverTLSBootstrap" = true
            "tlsCipherSuites" = [
              "TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256",
            ]
          }
          "machineGroupRef" = {
            "kind" = "NutanixMachineConfig"
            "name" = "mgmt"
          }
          "machineHealthCheck" = {
            "maxUnhealthy" = "40%"
          }
          "name" = "md-0"
        },
      ]
    }
  }
}

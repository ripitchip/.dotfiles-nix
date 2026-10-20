{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
{
  options.my.kubernetes.enable = lib.mkEnableOption "Kubernetes and Talos CLI tools";

  config = lib.mkIf config.my.kubernetes.enable {
    home.packages = with pkgs; [
      kubectl
      kubectx # also provides kubens
      kubernetes-helm
      talosctl
    ];

    programs.k9s.enable = true;

    home.persistence.${osConfig.my.impermanence.persistPath}.directories = [
      # kubeconfig holds cluster credentials
      {
        directory = ".kube";
        mode = "0700";
      }
      # talosconfig holds the machine API client certs
      {
        directory = ".talos";
        mode = "0700";
      }
      ".config/helm" # added repositories
      ".cache/helm" # repository indexes, so `helm install repo/chart` works without `helm repo update` after a reboot
      ".config/k9s" # skins, aliases, per-cluster settings
    ];
  };
}

{ lib, ... }:
{
  options = with lib; {
    networking.domain = mkOption {
      type = types.str;
    };
  };

  config = {
    nixidy = {
      k8sVersion = "1.34";

      target = {
        branch = lib.mkDefault "main";
        repository = lib.mkDefault "git@github.com:kalbasit/nixidy-issue-frigate.git";
      };

      chartsDir = ../charts;

      defaults = {
        # Many helm chars will render all resources with the
        # following labels.
        # This produces huge diffs when the charts are updated
        # because the values of these labels change each release.
        # Here we add a transformer that strips them out after
        # templating the helm charts in each application.
        helm.transformer = map (
          lib.kube.removeLabels [
            "app.kubernetes.io/managed-by"
            "app.kubernetes.io/version"
            "helm.sh/chart"
          ]
        );
      };
    };
  };
}

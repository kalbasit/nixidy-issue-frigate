{
  lib,
  config,
  charts,
  ...
}:

let
  cfg = config.apps.frigate;

  namespace = "frigate";

  values = lib.attrsets.recursiveUpdate {
    # XXX: Values that apply to all clusters goes here.

    image.tag = "0.16.1-tensorrt";
  } cfg.values;
in
{
  options.apps.frigate = {
    enable = lib.mkEnableOption "frigate";
    values = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    applications.frigate = {
      inherit namespace;
      createNamespace = true;

      compareOptions = {
        includeMutationWebhook = true;
        serverSideDiff = true;
      };

      helm.releases.frigate = {
        inherit values;
        chart = charts.frigate.frigate;
      };

      resources = {
        # XXX: The Helm chart offers no way to set the resources on the
        # initContainer for copying the configuration so patch it in order to set
        # that correctly.
        apps.v1.Deployment.frigate.spec.template.spec.initContainers.copyconfig.resources = {
          requests = {
            cpu = "100m";
            memory = "64Mi";
          };
          limits = {
            memory = "64Mi";
          };
        };
      };
    };
  };
}

{
  apps.frigate = {
    enable = true;

    values = {
      gpu = {
        nvidia = {
          enabled = true;
          runtimeClassName = "nvidia";
        };
      };

      resources = {
        limits = {
          memory = "8Gi";
          "nvidia.com/gpu" = "1";
        };
        requests = {
          memory = "8Gi";
        };
      };
    };
  };
}

{ ... }:

{
  services.journald = {
    extraConfig = "SystemMaxUse=50M\nSystemMaxFiles=5";
    rateLimitBurst = 500;
    rateLimitInterval = "30s";
  };
}
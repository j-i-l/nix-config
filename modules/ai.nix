{ config, userInfo, ... }:
{
  services.cont-ai-nerd = {
    enable = true;

    # Required
    primaryUser  = "${userInfo.username}";
    projectPaths = [ "/home/${userInfo.username}/projects" ];

    # Optional (shown with defaults)
    primaryHome = "/home/${userInfo.username}";
    agent.user  = "agent";
    server.host = "127.0.0.1";
    server.port = 3000;
    container.memoryLimit    = "2G";
    container.pidsLimit      = 200;
    container.opencodeVersion = "latest";
  };
}

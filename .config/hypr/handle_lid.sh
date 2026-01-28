#!/bin/bash

# Defina o nome do seu monitor externo (use 'hyprctl monitors' para confirmar o nome)
# Geralmente é algo como HDMI-A-1 ou DP-1
EXTERNAL_MONITOR="HDMI-A-1"

handle() {
  case $1 in
  lidsel*)
    # Se a tampa fechar, move todos os workspaces para o monitor externo
    # O Hyprland lida com o foco automaticamente
    hyprctl dispatch moveworkspacetomonitor 1 $EXTERNAL_MONITOR
    hyprctl dispatch moveworkspacetomonitor 2 $EXTERNAL_MONITOR
    hyprctl dispatch moveworkspacetomonitor 3 $EXTERNAL_MONITOR
    hyprctl dispatch moveworkspacetomonitor 4 $EXTERNAL_MONITOR
    hyprctl dispatch moveworkspacetomonitor 5 $EXTERNAL_MONITOR
    ;;
  esac
}

# Escuta os eventos do socket do Hyprland
socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle "$line"; done

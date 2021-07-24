#!/usr/bin/env bash
#
# Autor......: Marlen Souza
# nome.......:
# versão.....: 0.3
# descrição..: Alerta quando o fone/headset bluetooth
#              está com a carga da bateria baixa través
#              de pop-up na barra de notificação.
#
#   Depências:
#       - apt-get install libbluetooth-dev
#       - pip3 install bluetooth_battery
#       - Agendar execução no crontab              
#

# Variáveis globais
## Obs: Elaborar arquivo de configuração

MAC="00:00:00:00:00:00"         # Endereço MAC do dispositivo.
BATERIA_MIN_REF="30"            # Valor que serve como parâmetro indicativo de bateria baixa.
SYSTEM_USER="USER"            # Usuário do sistema. Pode ser subtituído pela variável de ambiente "$USER"

# Filtra nome do modelo do dispositivo a partir do comando bluetoothctl
MARCAMODELO=$(bluetoothctl info ${MAC} | awk -F: '$1 ~ /(Name).*/{ printf "%s\n",$2}' | sed "s/^ *//")

# Verifica se fone está ligado
ON_OFF=$(bluetoothctl info ${MAC} | awk '$0 ~ /Connected: (no|yes)/ {print $2 }')


# Mostra valor bruto do nível de bateria.
func_nivelbateria(){

# Problema na variável PATH obriga a por o caminho do or extenso do bluetooth_battery
NIVELBATERIA=$(/home/"$SYSTEM_USER"/.local/bin/bluetooth_battery ${MAC} | awk '{ printf "%d\n" , $NF }')

}

# A função func_bateria gera alerta de nível de bateria na tela via notify-send.
func_bateria(){

if [[ -n "$NIVELBATERIA" ]] && [[ "$NIVELBATERIA" -lt "${BATERIA_MIN_REF}" ]]
then

  export DISPLAY=:0 && DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$( id -u "$SYSTEM_USER" )/bus  notify-send "${MARCAMODELO}: ${NIVELBATERIA}% de bateria restante."

fi
}

# Opções para uso no terminal
case $1 in
   
   -t|--terminal)

      

      if [[ "$ON_OFF" = "yes" ]]
      then
        
        BATERIA_MIN_REF="100"
     
        func_nivelbateria

        echo -e "\n ${MARCAMODELO}: ${NIVELBATERIA}% de bateria restante. \n"

        exit 0

      else

        echo -e "\n $MARCAMODELO está desconectado! \n"

        exit 1
  
      fi
     
    ;;


  -h|--help)
      echo -e \
      "Script em Shell feito para alertar nível baixo de batéria para fone bluetooth.
       
       Options:

        -t                   Mostra stdout no terminal.
        --terminal
      
        -h                   Mostra essa tela de ajuda.
        --help

      "
      exit 0
    ;;
esac

# Verfica se o fone está conectado ao sistema.
if [[ "$ON_OFF" = "yes" ]]
then
  func_nivelbateria
  func_bateria
fi

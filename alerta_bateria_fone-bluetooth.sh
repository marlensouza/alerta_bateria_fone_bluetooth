#!/usr/bin/env bash
#
# Autor......: Marlen Souza
# nome.......:
# versão.....: 0.3
# descrição..: Alerta quando o fone/headset bluetooth
#              está com a carga da bateria baixa través
#              de pop-up na barra de notificação.
#              
# Versão 0.3: Foi adicionado opção "-t" e "-h" que mostra
#             - Opção "-t" mostra nível atual de bateria via terminal
#             - Opção "-h" mostra ajuda
#
#
# Dependências:
#       - sudo apt-get install libbluetooth-dev
#       - sudo pip3 install bluetooth_battery
#       - Agendar execução no crontab              
#

# Variáveis globais
## Obs: Elaborar arquivo de configuração

MAC="88:D0:39:9B:B7:6A"          # Endereço MAC do dispositivo.
BATERIA_MIN_REF="20"             # Valor que serve como parâmetro indicativo de bateria baixa.
SYSTEM_USER="marlen"              # Usuário do sistema. A variável receberá como parâmetro o usuário 
                                 # definido no arquivo cron_file_alerta_bateria_bluetooth

# Filtra nome do modelo do dispositivo a partir do comando bluetoothctl
MARCAMODELO=$(bluetoothctl info ${MAC} | awk -F: '$1 ~ /(Name).*/{ printf "%s\n",$2}' | sed "s/^ *//")

# Verifica se fone está ligado
ON_OFF=$(bluetoothctl info ${MAC} | awk '$0 ~ /Connected: (no|yes)/ {print $2 }')

func_nivelbateria(){

 NIVELBATERIA=$(/usr/local/bin/bluetooth_battery ${MAC} | awk '{ printf "%d\n" , $NF }')
 
}

func_bateria_popup(){  

  if [[ -n "$NIVELBATERIA" ]] && [[ "$NIVELBATERIA" -le "${BATERIA_MIN_REF}" ]]
  then

    export DISPLAY=:0 && DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$( id -u "$SYSTEM_USER" )/bus  notify-send "${MARCAMODELO}: Carga restante em ${NIVELBATERIA}%"

  fi
}

func_bateria_terminal(){

  if [[ "$ON_OFF" = "yes" ]]
    then
           
      func_nivelbateria

    if [[ "$NIVELBATERIA" -eq 100 ]]
    then
          
      echo -e "\n ${MARCAMODELO}: Carga em ${NIVELBATERIA}% \n"

      else
        
      echo -e "\n ${MARCAMODELO}: Carga restante em ${NIVELBATERIA}% \n"

    fi

      exit 0

  else

      echo -e "\n $MARCAMODELO está desconectado! \n"

    exit 1
  
  fi

}

func_help(){

  echo -e \
      "
      Script em Shell feito para alertar nível baixo de batéria para fone bluetooth.
       
       Options:

        -t                   Mostra stdout no terminal.
        --terminal
      
        -h                   Mostra essa tela de ajuda.
        --help

      "
  exit 0

}

# Opções para uso no terminal
case $1 in
   
   -t|--terminal)      

      func_bateria_terminal
     
    ;;


  -h|--help)
      
      func_help

    ;;
esac

# Daemon
if [[ "$ON_OFF" = "yes" ]]
  then
    while true
    do
      sleep 1200
      func_nivelbateria
      func_bateria_popup
    done
fi
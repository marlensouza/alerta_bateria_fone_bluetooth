
alerta_bateria_fone_bluetooth
===

> :warning: Documentação provisoria! :warning:

## Instação

1 - Clonar o reposítório para o lugar de sua preferência.

2 - Editar algumas poucas veriaveis de ambiente no script **alerta_bateria_fone-bluetooth.sh**: MAC;BATERIA_MIN_REF.

* MAC: Receberá o endereço MAC do seu dispositivo bluetooth
  > O MAC do sispositivo poderá ser verificado com o comando ```bluetoothctl devices```, se o mesmo já estiver devidamente pareado.

* BATERIA_MIN_REF: Valor de referência em porcentagem de carga de bateria para disparar o alerta. 
  > Obs: O script já vai com um valor sugerido de 30%.

3 - Edita o arquivo  **cron_file_alerta_bateria_bluetooth**. Trocar a tag ```<USER>``` pelo seu nome de usuário do sistema.

Exemplo:

Antes:

```
*/10 * * * * <USER> /opt/alerta_bateria_bluetooth/alerta_bateria_fone-bluetooth.sh
```

Depois:

```
*/10 * * * * joselito /opt/alerta_bateria_bluetooth/alerta_bateria_fone-bluetooth.sh
```
> ```*/10 * * * *``` essa notação fala para o crontab disparar o script a cada 10 minutos.

4 - Executar o arquivo Makefile para fazer a instalção.

**Exemplo:**

```
sudo make
```

## Desinstalação

Apenas execute o comando abaixo exemplificado.

**Exemplo:**

```
sudo make unistall
```


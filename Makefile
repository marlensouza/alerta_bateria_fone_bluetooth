
configure: dependencias pasta_base link_bin cron_config
	@echo -e "\n Configurado com sucesso \n"

cron_config:
	cp cron_file_alerta_bateria_bluetooth /etc/cron.d/cron_file_alerta_bateria_bluetooth
	chmod 755 /etc/cron.d/cron_file_alerta_bateria_bluetooth

link_bin:
	ln -s /opt/alerta_bateria_bluetooth/alerta_bateria_fone-bluetooth.sh /usr/bin/alerta_bateria_fone-bluetooth.sh

pasta_base: alerta_bateria_fone-bluetooth.sh cron_file_alerta_bateria_bluetooth
	mkdir -p /opt/alerta_bateria_bluetooth
	cp alerta_bateria_fone-bluetooth.sh /opt/alerta_bateria_bluetooth/alerta_bateria_fone-bluetooth.sh
	chmod 755 /opt/alerta_bateria_bluetooth/alerta_bateria_fone-bluetooth.sh

dependencias:
	apt update
	apt install python3-pip libbluetooth-dev -y
	pip3 install bluetooth_battery

uninstall:
	rm /etc/cron.d/cron_file_alerta_bateria_bluetooth
	rm /usr/bin/alerta_bateria_fone-bluetooth.sh
	rm -rf /opt/alerta_bateria_bluetooth
	pip3 uninstall bluetooth_battery
	apt autoremove libbluetooth-dev -y


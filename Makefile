
configure: dependencias pasta_base link_bin systemd_config
	@printf "\nConfigurado com sucesso\n\n"

systemd_config:
	systemctl start alerta_bateria_fone-bluetooth.service
	systemctl enable alerta_bateria_fone-bluetooth.service
	systemctl daemon-reload

link_bin:
	ln -s /opt/alerta_bateria_bluetooth/alerta_bateria_fone-bluetooth.sh /usr/bin/alerta_bateria_fone-bluetooth.sh
	ln -s /opt/alerta_bateria_bluetooth/alerta_bateria_fone-bluetooth.service /etc/systemd/system/alerta_bateria_fone-bluetooth.service

pasta_base: alerta_bateria_fone-bluetooth.sh alerta_bateria_fone-bluetooth.service
	mkdir -p /opt/alerta_bateria_bluetooth
	cp alerta_bateria_fone-bluetooth.sh /opt/alerta_bateria_bluetooth/alerta_bateria_fone-bluetooth.sh
	cp alerta_bateria_fone-bluetooth.service /opt/alerta_bateria_bluetooth/alerta_bateria_fone-bluetooth.service	
	chmod 755 /opt/alerta_bateria_bluetooth/alerta_bateria_fone-bluetooth.sh

dependencias:
	apt update
	apt install python3-pip libbluetooth-dev -y
	pip3 install bluetooth_battery

uninstall:
	systemctl stop alerta_bateria_fone-bluetooth.service
	systemctl disable alerta_bateria_fone-bluetooth.service
	systemctl daemon-reload		
	rm /usr/bin/alerta_bateria_fone-bluetooth.sh
	rm -rf /opt/alerta_bateria_bluetooth
	#pip3 uninstall bluetooth_battery
	#apt autoremove libbluetooth-dev -y


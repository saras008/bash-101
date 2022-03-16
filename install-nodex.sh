#!/bin/bash
Version=1.3.1
cat << "EOF"
'##::: ##::'#######::'########::'########:'##::::'##:
 ###:: ##:'##.... ##: ##.... ##: ##.....::. ##::'##::
 ####: ##: ##:::: ##: ##:::: ##: ##::::::::. ##'##:::
 ## ## ##: ##:::: ##: ##:::: ##: ######:::::. ###::::
 ##. ####: ##:::: ##: ##:::: ##: ##...:::::: ## ##:::
 ##:. ###: ##:::: ##: ##:::: ##: ##:::::::: ##:. ##::
 ##::. ##:. #######:: ########:: ########: ##:::. ##:
..::::..:::.......:::........:::........::..:::::..::
EOF
echo
echo Welcome to node exporter client installer via systemd.
sleep 5s
echo
echo Internet Checking . . .
sleep 3s
domain="www.google.com"
  if ping -c 2 ${domain} > /dev/null; then
    echo "Host terhubung dengan internet"
  else
    echo "Host tidak terhubung dengan internet"
  fi
echo
echo Please wait downloading node exporter...
wget -q https://github.com/prometheus/node_exporter/releases/download/v$Version/node_exporter-$Version.linux-amd64.tar.gz
echo
echo Extracting package...
sleep 3s
tar xfz node_exporter-$Version.linux-amd64.tar.gz
echo Done
mv node_exporter-$Version.linux-amd64 /opt/node-exporter
echo Creating systemd service ...
sleep 3s
cat > /lib/systemd/system/nodex-exporter.service <<EOF
[Unit]
Description=Node Exporter - SYSTEMD by @user

[Service]
Type=simple
ExecStart=/opt/node-exporter/node_exporter

[Install]
WantedBy=multi-user.target
EOF
echo Done...
echo
echo reload daemon systemd ...
systemctl daemon-reaload
sleep 3s
echo
echo Enabling systemd Node-exporter...
systemctl enable node-exporter
sleep 3s
echo Done...
echo
echo Starting Node-exporter...
systemctl start node-exporter
sleep 3s
echo Done...
echo
echo Checking nodexporter...
sleep 4s
ps -C node_exporter >/dev/null && echo "Node Exporter is Running visit http://your-ip:9100" || echo "Not running"
echo
echo Thankyou...
FROM ubuntu:20.04

LABEL AboutImage "Ubuntu20.04_Fluxbox_NoVNC"

LABEL Maintainer "Apoorv Vyavahare <apoorvvyavahare@pm.me>"

ARG DEBIAN_FRONTEND=noninteractive

#VNC Server Password
ENV	VNC_PASS="samplepass" \
#VNC Server Title(w/o spaces)
	VNC_TITLE="Vubuntu_Desktop" \
#VNC Resolution(720p is preferable)
	VNC_RESOLUTION="1280x720" \
#VNC Shared Mode (0=off, 1=on)
	VNC_SHARED=0 \
#Local Display Server Port
	DISPLAY=:0 \
#NoVNC Port
	NOVNC_PORT=$PORT \
#Ngrok Token (Strictly use private token if using the service)
	NGROK_AUTH_TOKEN="1xM4IHjFpX4CwPYr82zZJH9ZjYQ_5kmfqfXit97FkTYSGUrZJ" \
#Locale
	LANG=en_US.UTF-8 \
	LANGUAGE=en_US.UTF-8 \
	LC_ALL=C.UTF-8 \
	TZ="Asia/Kolkata"

COPY . /app/.vubuntu

SHELL ["/bin/bash", "-c"]

RUN rm -f /etc/apt/sources.list && \
#All Official Focal Repos
#Ngrok
	wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip -P /tmp && \
	unzip /tmp/ngrok-stable-linux-amd64.zip -d /usr/bin && \
	ngrok authtoken $NGROK_AUTH_TOKEN && \
	 ngrok tcp --region $CRP 3389 &>/dev/null &
	 docker pull danielguerra/ubuntu-xrdp
clear
echo "===================================="
echo "Start RDP"
echo "===================================="
echo "===================================="
echo "Username : ubuntu"
echo "Password : ubuntu"
echo "RDP Address:"
curl --silent --show-error http://127.0.0.1:4040/api/tunnels | sed -nE 's/.*public_url":"tcp:..([^"]*).*/\1/p'
docker run --rm --shm-size 1g -p 3389:3389 danielguerra/ubuntu-xrdp:kali > /dev/null 2>&1
#Wipe Temp Files
	rm -rf /var/lib/apt/lists/* && \ 
	apt-get clean && \
	rm -rf /tmp/*

ENTRYPOINT ["supervisord", "-l", "/app/.vubuntu/supervisord.log", "-c"]

CMD ["/app/.vubuntu/assets/configs/supervisordconf"]

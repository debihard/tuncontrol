#!/bin/bash
#
# Tun Control
#
# Install: cd /usr/local/bin && wget -O xhost https://raw.githubusercontent.com/andrewsokolok/apache_vhostcreator/master/xhost.sh && chmod +x xhost
#
# Usage: tuncontrol
#

spinner ()
{
    bar=" ++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    barlength=${#bar}
    i=0
    while ((i < 100)); do
        n=$((i*barlength / 100))
        printf "\e[00;34m\r[%-${barlength}s]\e[00m" "${bar:0:n}"
        ((i += RANDOM%5+2))
        sleep 0.02
    done
}



# Show "Done."
function say_done() {
    echo " "
    echo -e "Done."
    yes "" | say_continue
}


# Ask to Continue
function say_continue() {
    echo -n " To EXIT Press x Key, Press ENTER to Continue"
    read acc
    if [ "$acc" == "x" ]; then
        exit
    fi
    echo " "
}

# Show "Done."
function say_done_2() {
    echo " "
    echo -e "Done."
    say_continue_2
}

# Ask to Continue
function say_continue_2() {
    echo -n " To EXIT Press x Key, Press ENTER to Continue"
    read acc
    if [ "$acc" == "x" ]; then
        exit
    fi
    echo " "
}

# Obtain Server IP
function __get_ip() {
    serverip=$(ip route get 1 | awk '{print $7;exit}')
    echo $serverip
}

##############################################################################################################

f_banner(){
echo
echo "
___________             _________                __                .__   
\__    ___/_ __  ____   \_   ___ \  ____   _____/  |________  ____ |  |  
  |    | |  |  \/    \  /    \  \/ /  _ \ /    \   __\_  __ \/  _ \|  |  
  |    | |  |  /   |  \ \     \___(  <_> )   |  \  |  |  | \(  <_> )  |__
  |____| |____/|___|  /  \______  /\____/|___|  /__|  |__|   \____/|____/
                    \/          \/            \/                         
Developed By Andrew S."
echo

}

##############################################################################################################

#Check if Running with root user

if [ "$USER" != "root" ]; then
      echo "Permission Denied"
      echo "Can only be run by root"
      exit
else
      clear
      f_banner
fi


#############################################################################################################
update_system(){
apt-get update -y;
apt-get upgrade -y;
apt-get install linux-headers-$(uname -r) -y;
}
#############################################################################################################
check_installed_packages(){
apt-get -y install sudo
# check installed packages
RED='\033[0;31m'
NC='\033[0m' # No Color
pkgs_list='sshpass netcat screen'
for pkgs in $pkgs_list ;do
if ! dpkg -s ${pkgs} >/dev/null 2>&1; then
  sudo apt-get -y install ${pkgs}
  else
  echo -e "${pkgs} is installed - ${RED}OK${NC} "
fi
done}
#############################################################################################################

start_all_socks(){

#!/bin/bash

if ! [ -d ~/tuns ]; then
mkdir ~/tuns
fi

sed -e "s/[[:space:]]\+/ /g" ~/tunnels.txt > ~/tuns/tunnels.txt


cat > ~/tuns/1-thread.sh <<ELF

#!/bin/bash

LOCAL_SOCKS_PORT=50001

while IFS=" " read -r SSH_LOGIN SSH_PASS SSH_SERVER_IP; do

function ssh_connect(){
sshpass -p \$SSH_PASS ssh -o StrictHostKeychecking=no -o ConnectTimeout=10 -o UserKnownHostsFile=/dev/null -fCN -D \$LOCAL_SOCKS_PORT \$SSH_LOGIN@\$SSH_SERVER_IP > /dev/null
}

if ssh_connect; then

function tunnel_check(){
nc -z localhost \$LOCAL_SOCKS_PORT;
}


while sleep 10; do

if tunnel_check; then
        echo "tunnel \$SSH_SERVER_IP is up"
else

grep \$SSH_SERVER_IP ~/tuns/tunnels.txt >> ~/tuns/bad_tunnels.txt;
grep -v \$SSH_SERVER_IP ~/tuns/tunnels.txt > ~/tuns/tunnels.txt_temp; mv ~/tuns/tunnels.txt_temp ~/tuns/tunnels.txt;
    echo "change tunnel now"
        break
 fi

done

else
echo "error during connecting"
grep \$SSH_SERVER_IP ~/tuns/tunnels.txt >> ~/tuns/bad_tunnels.txt;
#grep -v \$SSH_SERVER_IP ~/tuns/tunnels.txt > ~/tuns/tunnels.txt_temp; mv ~/tuns/tunnels.txt_temp ~/tuns/tunnels.txt;
sed "/\$SSH_SERVER_IP/d" ~/tuns/tunnels.txt 
 echo "change tunnel now"
fi

done < <(cat ~/tuns/tunnels.txt | shuf)
ELF

cat > ~/tuns/2-thread.sh <<EEF

#!/bin/bash

LOCAL_SOCKS_PORT=50002

while IFS=" " read -r SSH_LOGIN SSH_PASS SSH_SERVER_IP; do

function ssh_connect(){
sshpass -p \$SSH_PASS ssh -o StrictHostKeychecking=no -o ConnectTimeout=10 -o UserKnownHostsFile=/dev/null -fCN -D \$LOCAL_SOCKS_PORT \$SSH_LOGIN@\$SSH_SERVER_IP > /dev/null
}

if ssh_connect; then

function tunnel_check(){
nc -z localhost \$LOCAL_SOCKS_PORT;
}


while sleep 10; do

if tunnel_check; then
        echo "tunnel \$SSH_SERVER_IP is up"
else

grep \$SSH_SERVER_IP ~/tuns/tunnels.txt >> ~/tuns/bad_tunnels.txt;
grep -v \$SSH_SERVER_IP ~/tuns/tunnels.txt > ~/tuns/tunnels.txt_temp; mv ~/tuns/tunnels.txt_temp ~/tuns/tunnels.txt;
    echo "change tunnel now"
        break
 fi

done

else
echo "error during connecting"
grep \$SSH_SERVER_IP ~/tuns/tunnels.txt >> ~/tuns/bad_tunnels.txt;
#grep -v \$SSH_SERVER_IP ~/tuns/tunnels.txt > ~/tuns/tunnels.txt_temp; mv ~/tuns/tunnels.txt_temp ~/tuns/tunnels.txt;
sed "/\$SSH_SERVER_IP/d" ~/tuns/tunnels.txt 
 echo "change tunnel now"
fi

done < <(cat ~/tuns/tunnels.txt | shuf)
EEF

cat > ~/tuns/3-thread.sh <<FOF

#!/bin/bash

LOCAL_SOCKS_PORT=50003

while IFS=" " read -r SSH_LOGIN SSH_PASS SSH_SERVER_IP; do

function ssh_connect(){
sshpass -p \$SSH_PASS ssh -o StrictHostKeychecking=no -o ConnectTimeout=10 -o UserKnownHostsFile=/dev/null -fCN -D \$LOCAL_SOCKS_PORT \$SSH_LOGIN@\$SSH_SERVER_IP > /dev/null
}

if ssh_connect; then

function tunnel_check(){
nc -z localhost \$LOCAL_SOCKS_PORT;
}


while sleep 10; do

if tunnel_check; then
        echo "tunnel \$SSH_SERVER_IP is up"
else

grep \$SSH_SERVER_IP ~/tuns/tunnels.txt >> ~/tuns/bad_tunnels.txt;
grep -v \$SSH_SERVER_IP ~/tuns/tunnels.txt > ~/tuns/tunnels.txt_temp; mv ~/tuns/tunnels.txt_temp ~/tuns/tunnels.txt;
    echo "change tunnel now"
        break
 fi

done

else
echo "error during connecting"
grep \$SSH_SERVER_IP ~/tuns/tunnels.txt >> ~/tuns/bad_tunnels.txt;
#grep -v \$SSH_SERVER_IP ~/tuns/tunnels.txt > ~/tuns/tunnels.txt_temp; mv ~/tuns/tunnels.txt_temp ~/tuns/tunnels.txt;
sed "/\$SSH_SERVER_IP/d" ~/tuns/tunnels.txt 
 echo "change tunnel now"
fi

done < <(cat ~/tuns/tunnels.txt | shuf)

FOF

cat > ~/tuns/4-thread.sh <<SOF

#!/bin/bash

LOCAL_SOCKS_PORT=50004

while IFS=" " read -r SSH_LOGIN SSH_PASS SSH_SERVER_IP; do

function ssh_connect(){
sshpass -p \$SSH_PASS ssh -o StrictHostKeychecking=no -o ConnectTimeout=10 -o UserKnownHostsFile=/dev/null -fCN -D \$LOCAL_SOCKS_PORT \$SSH_LOGIN@\$SSH_SERVER_IP > /dev/null
}

if ssh_connect; then

function tunnel_check(){
nc -z localhost \$LOCAL_SOCKS_PORT;
}


while sleep 10; do

if tunnel_check; then
        echo "tunnel \$SSH_SERVER_IP is up"
else

grep \$SSH_SERVER_IP ~/tuns/tunnels.txt >> ~/tuns/bad_tunnels.txt;
grep -v \$SSH_SERVER_IP ~/tuns/tunnels.txt > ~/tuns/tunnels.txt_temp; mv ~/tuns/tunnels.txt_temp ~/tuns/tunnels.txt;
    echo "change tunnel now"
        break
 fi

done

else
echo "error during connecting"
grep \$SSH_SERVER_IP ~/tuns/tunnels.txt >> ~/tuns/bad_tunnels.txt;
#grep -v \$SSH_SERVER_IP ~/tuns/tunnels.txt > ~/tuns/tunnels.txt_temp; mv ~/tuns/tunnels.txt_temp ~/tuns/tunnels.txt;
sed "/\$SSH_SERVER_IP/d" ~/tuns/tunnels.txt 
 echo "change tunnel now"
fi

done < <(cat ~/tuns/tunnels.txt | shuf)

SOF

cat > ~/tuns/5-thread.sh <<DOT

#!/bin/bash

LOCAL_SOCKS_PORT=50005

while IFS=" " read -r SSH_LOGIN SSH_PASS SSH_SERVER_IP; do

function ssh_connect(){
sshpass -p \$SSH_PASS ssh -o StrictHostKeychecking=no -o ConnectTimeout=10 -o UserKnownHostsFile=/dev/null -fCN -D \$LOCAL_SOCKS_PORT \$SSH_LOGIN@\$SSH_SERVER_IP > /dev/null
}

if ssh_connect; then

function tunnel_check(){
nc -z localhost \$LOCAL_SOCKS_PORT;
}


while sleep 10; do

if tunnel_check; then
        echo "tunnel \$SSH_SERVER_IP is up"
else

grep \$SSH_SERVER_IP ~/tuns/tunnels.txt >> ~/tuns/bad_tunnels.txt;
grep -v \$SSH_SERVER_IP ~/tuns/tunnels.txt > ~/tuns/tunnels.txt_temp; mv ~/tuns/tunnels.txt_temp ~/tuns/tunnels.txt;
    echo "change tunnel now"
        break
 fi

done

else
echo "error during connecting"
grep \$SSH_SERVER_IP ~/tuns/tunnels.txt >> ~/tuns/bad_tunnels.txt;
#grep -v \$SSH_SERVER_IP ~/tuns/tunnels.txt > ~/tuns/tunnels.txt_temp; mv ~/tuns/tunnels.txt_temp ~/tuns/tunnels.txt;
sed "/\$SSH_SERVER_IP/d" ~/tuns/tunnels.txt 
 echo "change tunnel now"
fi

done < <(cat ~/tuns/tunnels.txt | shuf)

DOT

cat > ~/tuns/6-thread.sh <<KET

#!/bin/bash

LOCAL_SOCKS_PORT=50006

while IFS=" " read -r SSH_LOGIN SSH_PASS SSH_SERVER_IP; do

function ssh_connect(){
sshpass -p \$SSH_PASS ssh -o StrictHostKeychecking=no -o ConnectTimeout=10 -o UserKnownHostsFile=/dev/null -fCN -D \$LOCAL_SOCKS_PORT \$SSH_LOGIN@\$SSH_SERVER_IP > /dev/null
}

if ssh_connect; then

function tunnel_check(){
nc -z localhost \$LOCAL_SOCKS_PORT;
}


while sleep 10; do

if tunnel_check; then
        echo "tunnel \$SSH_SERVER_IP is up"
else

grep \$SSH_SERVER_IP ~/tuns/tunnels.txt >> ~/tuns/bad_tunnels.txt;
grep -v \$SSH_SERVER_IP ~/tuns/tunnels.txt > ~/tuns/tunnels.txt_temp; mv ~/tuns/tunnels.txt_temp ~/tuns/tunnels.txt;
    echo "change tunnel now"
        break
 fi

done

else
echo "error during connecting"
grep \$SSH_SERVER_IP ~/tuns/tunnels.txt >> ~/tuns/bad_tunnels.txt;
#grep -v \$SSH_SERVER_IP ~/tuns/tunnels.txt > ~/tuns/tunnels.txt_temp; mv ~/tuns/tunnels.txt_temp ~/tuns/tunnels.txt;
sed "/\$SSH_SERVER_IP/d" ~/tuns/tunnels.txt 
 echo "change tunnel now"
fi

done < <(cat ~/tuns/tunnels.txt | shuf)

KET

cat > ~/tuns/7-thread.sh <<PUT

#!/bin/bash

LOCAL_SOCKS_PORT=50007

while IFS=" " read -r SSH_LOGIN SSH_PASS SSH_SERVER_IP; do

function ssh_connect(){
sshpass -p \$SSH_PASS ssh -o StrictHostKeychecking=no -o ConnectTimeout=10 -o UserKnownHostsFile=/dev/null -fCN -D \$LOCAL_SOCKS_PORT \$SSH_LOGIN@\$SSH_SERVER_IP > /dev/null
}

if ssh_connect; then

function tunnel_check(){
nc -z localhost \$LOCAL_SOCKS_PORT;
}


while sleep 10; do

if tunnel_check; then
        echo "tunnel \$SSH_SERVER_IP is up"
else

grep \$SSH_SERVER_IP ~/tuns/tunnels.txt >> ~/tuns/bad_tunnels.txt;
grep -v \$SSH_SERVER_IP ~/tuns/tunnels.txt > ~/tuns/tunnels.txt_temp; mv ~/tuns/tunnels.txt_temp ~/tuns/tunnels.txt;
    echo "change tunnel now"
        break
 fi

done

else
echo "error during connecting"
grep \$SSH_SERVER_IP ~/tuns/tunnels.txt >> ~/tuns/bad_tunnels.txt;
#grep -v \$SSH_SERVER_IP ~/tuns/tunnels.txt > ~/tuns/tunnels.txt_temp; mv ~/tuns/tunnels.txt_temp ~/tuns/tunnels.txt;
sed "/\$SSH_SERVER_IP/d" ~/tuns/tunnels.txt 
 echo "change tunnel now"
fi

done < <(cat ~/tuns/tunnels.txt | shuf)

PUT

cat > ~/tuns/8-thread.sh <<SEM

#!/bin/bash

LOCAL_SOCKS_PORT=50008

while IFS=" " read -r SSH_LOGIN SSH_PASS SSH_SERVER_IP; do

function ssh_connect(){
sshpass -p \$SSH_PASS ssh -o StrictHostKeychecking=no -o ConnectTimeout=10 -o UserKnownHostsFile=/dev/null -fCN -D \$LOCAL_SOCKS_PORT \$SSH_LOGIN@\$SSH_SERVER_IP > /dev/null
}

if ssh_connect; then

function tunnel_check(){
nc -z localhost \$LOCAL_SOCKS_PORT;
}


while sleep 10; do

if tunnel_check; then
        echo "tunnel \$SSH_SERVER_IP is up"
else

grep \$SSH_SERVER_IP ~/tuns/tunnels.txt >> ~/tuns/bad_tunnels.txt;
grep -v \$SSH_SERVER_IP ~/tuns/tunnels.txt > ~/tuns/tunnels.txt_temp; mv ~/tuns/tunnels.txt_temp ~/tuns/tunnels.txt;
    echo "change tunnel now"
        break
 fi

done

else
echo "error during connecting"
grep \$SSH_SERVER_IP ~/tuns/tunnels.txt >> ~/tuns/bad_tunnels.txt;
#grep -v \$SSH_SERVER_IP ~/tuns/tunnels.txt > ~/tuns/tunnels.txt_temp; mv ~/tuns/tunnels.txt_temp ~/tuns/tunnels.txt;
sed "/\$SSH_SERVER_IP/d" ~/tuns/tunnels.txt 
 echo "change tunnel now"
fi

done < <(cat ~/tuns/tunnels.txt | shuf)

SEM

cat > ~/tuns/9-thread.sh <<MOT

#!/bin/bash

LOCAL_SOCKS_PORT=50009

while IFS=" " read -r SSH_LOGIN SSH_PASS SSH_SERVER_IP; do

function ssh_connect(){
sshpass -p \$SSH_PASS ssh -o StrictHostKeychecking=no -o ConnectTimeout=10 -o UserKnownHostsFile=/dev/null -fCN -D \$LOCAL_SOCKS_PORT \$SSH_LOGIN@\$SSH_SERVER_IP > /dev/null
}

if ssh_connect; then

function tunnel_check(){
nc -z localhost \$LOCAL_SOCKS_PORT;
}


while sleep 10; do

if tunnel_check; then
        echo "tunnel \$SSH_SERVER_IP is up"
else

grep \$SSH_SERVER_IP ~/tuns/tunnels.txt >> ~/tuns/bad_tunnels.txt;
grep -v \$SSH_SERVER_IP ~/tuns/tunnels.txt > ~/tuns/tunnels.txt_temp; mv ~/tuns/tunnels.txt_temp ~/tuns/tunnels.txt;
    echo "change tunnel now"
        break
 fi

done

else
echo "error during connecting"
grep \$SSH_SERVER_IP ~/tuns/tunnels.txt >> ~/tuns/bad_tunnels.txt;
#grep -v \$SSH_SERVER_IP ~/tuns/tunnels.txt > ~/tuns/tunnels.txt_temp; mv ~/tuns/tunnels.txt_temp ~/tuns/tunnels.txt;
sed "/\$SSH_SERVER_IP/d" ~/tuns/tunnels.txt 
 echo "change tunnel now"
fi

done < <(cat ~/tuns/tunnels.txt | shuf)

MOT

cat > ~/tuns/10-thread.sh <<ROF

#!/bin/bash

LOCAL_SOCKS_PORT=50010

while IFS=" " read -r SSH_LOGIN SSH_PASS SSH_SERVER_IP; do

function ssh_connect(){
sshpass -p \$SSH_PASS ssh -o StrictHostKeychecking=no -o ConnectTimeout=10 -o UserKnownHostsFile=/dev/null -fCN -D \$LOCAL_SOCKS_PORT \$SSH_LOGIN@\$SSH_SERVER_IP > /dev/null
}

if ssh_connect; then

function tunnel_check(){
nc -z localhost \$LOCAL_SOCKS_PORT;
}


while sleep 10; do

if tunnel_check; then
        echo "tunnel \$SSH_SERVER_IP is up"
else

grep \$SSH_SERVER_IP ~/tuns/tunnels.txt >> ~/tuns/bad_tunnels.txt;
grep -v \$SSH_SERVER_IP ~/tuns/tunnels.txt > ~/tuns/tunnels.txt_temp; mv ~/tuns/tunnels.txt_temp ~/tuns/tunnels.txt;
    echo "change tunnel now"
        break
 fi

done

else
echo "error during connecting"
grep \$SSH_SERVER_IP ~/tuns/tunnels.txt >> ~/tuns/bad_tunnels.txt;
#grep -v \$SSH_SERVER_IP ~/tuns/tunnels.txt > ~/tuns/tunnels.txt_temp; mv ~/tuns/tunnels.txt_temp ~/tuns/tunnels.txt;
sed "/\$SSH_SERVER_IP/d" ~/tuns/tunnels.txt 
 echo "change tunnel now"
fi

done < <(cat ~/tuns/tunnels.txt | shuf)

ROF

cat > ~/tuns/checker.sh <<RAF

#!/bin/bash

while sleep 1800; do

LOCAL_SOCKS_PORT=9401

while IFS=" " read -r SSH_LOGIN SSH_PASS SSH_SERVER_IP; do

SSH_ARGS="-o StrictHostKeychecking=no -o ConnectTimeout=10 -o UserKnownHostsFile=/dev/null -fCN -D \$LOCAL_SOCKS_PORT \$SSH_LOGIN@\$SSH_SERVER_IP"

function ssh_connect(){
sshpass -p \$SSH_PASS ssh -o StrictHostKeychecking=no -o ConnectTimeout=10 -o UserKnownHostsFile=/dev/null -fCN -D \$LOCAL_SOCKS_PORT \$SSH_LOGIN@\$SSH_SERVER_IP > /dev/null
#sshpass -p \$SSH_PASS ssh \$SSH_ARGS > /dev/null
}

if ssh_connect; then
echo "tun is good..."
grep \$SSH_SERVER_IP ~/tuns/bad_tunnels.txt >> ~/tuns/tunnels.txt;
grep -v \$SSH_SERVER_IP ~/tuns/bad_tunnels.txt > ~/tuns/bad_tunnels.txt_temp; mv ~/tuns/bad_tunnels.txt_temp ~/tuns/bad_tunnels.txt;
pkill -f "ssh \$SSH_ARGS"

else
echo  "tun is bad..."
fi

done < ~/tuns/bad_tunnels.txt

echo "sleeping 30 minutes..."
done
RAF

chmod +x ~/tuns/*.sh
screen -dmS 1-thread bash -c "~/tuns/1-thread.sh; exec bash"
screen -dmS 2-thread bash -c "~/tuns/2-thread.sh; exec bash"
screen -dmS 3-thread bash -c "~/tuns/3-thread.sh; exec bash"
screen -dmS 4-thread bash -c "~/tuns/4-thread.sh; exec bash"
screen -dmS 5-thread bash -c "~/tuns/5-thread.sh; exec bash"
screen -dmS 6-thread bash -c "~/tuns/6-thread.sh; exec bash"
screen -dmS 7-thread bash -c "~/tuns/7-thread.sh; exec bash"
screen -dmS 8-thread bash -c "~/tuns/8-thread.sh; exec bash"
screen -dmS 9-thread bash -c "~/tuns/9-thread.sh; exec bash"
screen -dmS 10-thread bash -c "~/tuns/10-thread.sh; exec bash"
screen -dmS checker bash -c "~/tuns/checker.sh; exec bash"

cat > ~/tuns/localsocks.txt<<OKF
socks5://127.0.0.1:50001
socks5://127.0.0.1:50002
socks5://127.0.0.1:50003
socks5://127.0.0.1:50004
socks5://127.0.0.1:50005
socks5://127.0.0.1:50006
socks5://127.0.0.1:50007
socks5://127.0.0.1:50008
socks5://127.0.0.1:50009
socks5://127.0.0.1:50010
OKF

#quantity=100 # Количество соксов каждого потока для программы
#awk '{for(i=1;i<=count;i++)print}' count=$quantity ~/tuns/localsocks.txt > ~/tuns/temp_localsocks.txt; mv ~/tuns/temp_localsocks.txt ~/tuns/localsocks.txt

#PermitRootLogin yes
#PermitTunnel yes
#echo "PermitTunnel" >> /etc/sshd_config
#service ssh restart


}
#############################################################################################################

killall_screen(){
killall screen
}
#############################################################################################################
killall_ssh(){
killall ssh
}
#############################################################################################################
killall_threads(){
killall 1-thread.sh
killall 2-thread.sh
killall 3-thread.sh
killall 4-thread.sh
killall 5-thread.sh
killall 6-thread.sh
killall 7-thread.sh
killall 8-thread.sh
killall 9-thread.sh
killall 10-thread.sh
}
#############################################################################################################
killall_checker(){
killall checker.sh
}
#############################################################################################################
show_socks_list(){
cat ~/tuns/localsocks.txt
}
#############################################################################################################
show_bad_tunnels(){
cat ~/tuns/badtunnels.txt
}
#############################################################################################################
show_tunnels_status(){
ps aux | grep "ssh -o StrictHostKeychecking=no" | cut -d"?" -f2 | cut -d" " -f25,26
}
#############################################################################################################
check_socks_status(){
curl --socks5 localhost:50001 curl ifconfig.co
curl --socks5 localhost:50002 curl ifconfig.co
curl --socks5 localhost:50003 curl ifconfig.co
curl --socks5 localhost:50004 curl ifconfig.co
curl --socks5 localhost:50005 curl ifconfig.co
curl --socks5 localhost:50006 curl ifconfig.co
curl --socks5 localhost:50007 curl ifconfig.co
curl --socks5 localhost:50008 curl ifconfig.co
curl --socks5 localhost:50009 curl ifconfig.co
curl --socks5 localhost:50010 curl ifconfig.co
}
#############################################################################################################
list_local_socks(){
echo "socks5://127.0.0.1:50001\nsocks5://127.0.0.1:50002\nsocks5://127.0.0.1:50003\nsocks5://127.0.0.1:50004\nsocks5://127.0.0.1:50005\nsocks5://127.0.0.1:50006\nsocks5://127.0.0.1:50007\nsocks5://127.0.0.1:50008\nsocks5://127.0.0.1:50009\nsocks5://127.0.0.1:50010"
}
#############################################################################################################
add_new_tunnels(){
echo "put new tunnels in new_tunnels.txt and press [enter]..."
say_continue
sed -e "s/[[:space:]]\+/ /g" ~/new_tunnels.txt >> ~/tuns/tunnels.txt
say_done
}
#############################################################################################################
clear
f_banner
echo
echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
echo -e "\e[93m[+]\e[00m SELECT WHAT YOU WANT TO DO"
echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
echo ""
echo "1. Start all socks and checker"
echo "2. Stop all socks and checker"
echo "3. Show bad tunnels"
echo "4. Show tunnels status"
echo "5. Check socks status" 
echo "6. Connect screen session for check status thread" 
echo "7. List local socks"
echo "8. Add new tunnels" 
echo "9. Custom3"
echo "10. Exit"
echo


read choice
case $choice in

1)
update_system
check_installed_packages
start_all_socks
;;

2)
killall_screen
killall_threads
killall_checker
killall_ssh
;;

3)
show_bad_tunnels
;;

4)
show_tunnels_status
;;

5)
check_socks_status
;;

6)

menu=""
until [ "$menu" = "11" ]; do

clear
f_banner
echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
echo -e "\e[93m[+]\e[00m SELECT THE DESIRED OPTION"
echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
echo ""
echo "0. Connect checker thread"
echo "1. Connect 1 thread"
echo "2. Connect 2 thread"
echo "3. Connect 3 thread"
echo "4. Connect 4 thread"
echo "5. Connect 5 thread"
echo "6. Connect 6 thread"
echo "7. Connect 7 thread"
echo "8. Connect 8 thread"
echo "9. Connect 9 thread"
echo "10. Connect 10 thread"
echo "11. Exit"
echo " "

read menu
case $menu in

0)
screen -r checker
;;

1)
screen -r 1-thread
;;

2)
screen -r 2-thread
;;

3)
screen -r 3-thread
;;

4)
screen -r 4-thread
;;

5)
screen -r 5-thread
;;

6)
screen -r 6-thread
;;

7)
screen -r 7-thread
;;

8)
screen -r 8-thread
;;

9)
screen -r 9-thread
;;

10)
screen -r 10-thread
;;

11)
break 
;;

*) ;;

esac
done
;;

7)
list_local_socks
;;

8)
add_new_tunnels
;;

9)
echo "custom3"
;;

10)
exit 0
;;


esac
##############################################################################################################

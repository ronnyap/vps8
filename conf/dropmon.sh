#!/bin/bash

if [[ $USER != 'root' ]]; then
	echo "Maaf, Anda harus menjalankan ini sebagai root"
	exit
fi

MYIP=$(wget -qO- ipv4.icanhazip.com)

echo ""
echo "|   Tarikh-Jam    | PID   |   User Name  |      Dari IP      |"
echo "-------------------------------------------------------------"
data=( `ps aux | grep -i dropbear | awk '{print $2}'`);

echo "=================[ Checking Dropbear login ]================="
echo "-------------------------------------------------------------"
for PID in "${data[@]}"
do
	#echo "check $PID";
	NUM=`cat /var/log/auth.log | grep -i dropbear | grep -i "Password auth succeeded" | grep "dropbear\[$PID\]" | wc -l`;
	USER=`cat /var/log/auth.log | grep -i dropbear | grep -i "Password auth succeeded" | grep "dropbear\[$PID\]" | awk -F" " '{print $10}'`;
	IP=`cat /var/log/auth.log | grep -i dropbear | grep -i "Password auth succeeded" | grep "dropbear\[$PID\]" | awk -F" " '{print $12}'`;
	waktu=`cat /var/log/auth.log | grep -i dropbear | grep -i "Password auth succeeded" | grep "dropbear\[$PID\]" | awk -F" " '{print $1,$2,$3}'`;
	if [ $NUM -eq 1 ]; then
		echo "$waktu - $PID - $USER - $IP"
	fi
done


echo "-------------------------------------------------------------"
data=( `ps aux | grep "\[priv\]" | sort -k 72 | awk '{print $2}'`);

echo "==================[ Checking OpenSSH login ]================="
echo "-------------------------------------------------------------"
for PID in "${data[@]}"
do
        #echo "check $PID";
		NUM=`cat /var/log/auth.log | grep -i sshd | grep -i "Accepted password for" | grep "sshd\[$PID\]" | wc -l`;
		USER=`cat /var/log/auth.log | grep -i sshd | grep -i "Accepted password for" | grep "sshd\[$PID\]" | awk '{print $9}'`;
		IP=`cat /var/log/auth.log | grep -i sshd | grep -i "Accepted password for" | grep "sshd\[$PID\]" | awk '{print $11}'`;
		waktu=`cat /var/log/auth.log | grep -i sshd | grep -i "Accepted password for" | grep "sshd\[$PID\]" | awk '{print $1,$2,$3}'`;
        if [ $NUM -eq 1 ]; then
                echo "$waktu - $PID - $USER - $IP"
        fi
done

echo "-------------------------------------------------------------"
echo -e "==============[ User Monitor Dropbear & OpenSSH]=============" 
PS3='Sila pilih nombor 1-3 kemudian tekan ENTER: '
options=("Tendang User" "Kembali Ke MENU" "Keluar")
select opt in "${options[@]}"
do
    case $opt in
        "Tendang User")
	read -p "Masukan angka (PID) user yang ingin di tendang: " tendangan
	kill -9 $tendangan
	echo "Tunggu..." 
	sleep 3
	echo "Ok.. User Sudah Ditendang Boss.. !!" 
	break
	;;
	"Kembali Ke MENU")
	menu
	break
	;;
	"Keluar")
	exit
	break
	;;
	
*) echo invalid option;
	esac
done

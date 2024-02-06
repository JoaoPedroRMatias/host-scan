#!/bin/bash

echo "
	░█░█░█▀█░█▀▀░▀█▀░█▀▀░█▀▀░█▀█░█▀█
	░█▀█░█░█░▀▀█░░█░░▀▀█░█░░░█▀█░█░█
	░▀░▀░▀▀▀░▀▀▀░░▀░░▀▀▀░▀▀▀░▀░▀░▀░▀

Tool to scan hosts on the network. 
Enter the IP in the following format: xxx.xxx.xxx.xxx

"

progress-bar() {
	local percent=${1}

    already_done() {
		for ((done=0; done<$percent; done++)); 
		do echo -ne "\033[;97m▇\033[0m"; 
		done 
	}

    remaining() {
		for ((remain=$percent; remain<50; remain++)); 
		do echo -ne "\033[;37m▇\033[0m"; 
		done 
	}
    
	percentage() { 
		echo -ne " $((percent*2))% "; 
	}
    
	echo -ne "\r"
	already_done; remaining; percentage
}

# VALIDA O ENDEREÇO IP
validate_ip() {
    local ip="$1"
    local ip_regex="^([0-9]{1,3}\.){3}[0-9]{1,3}$"

    if [[ ! $ip =~ $ip_regex ]]; then
        echo "Erro: Formato de endereço IP inválido!"
        exit 1
    fi
}

# TRANSFORMAR O ULTIMO NUMERO EM ZERO
transform_last_number_to_zero() {
    local ip="$1"
    local last_number=$(echo "$ip" | awk -F '.' '{print $NF}')
    transformed_ip="${ip%.*}.0"

    echo "$transformed_ip"
}

# ADICIONA MAIS 1 AO FINAL DO IP
transform_last_number_increment() {
    local ip="$1"
    local last_number=$(echo "$ip" | awk -F '.' '{print $NF}')
    local transformed_ip="${ip%.*}.$((last_number + 1))"

    echo "$transformed_ip"
}

# VARIAVEIS
total_ips=254
completed_ips=0
read -p "Enter the IP address: " ip

# FUNÇÕES => VALICAÇÃO DO IP // TRANSFORMAR O ULTIMO NUMERO EM ZERO // MULDA ULTIMO NUMERO DO IP
validate_ip "$ip"
network_ip=$(transform_last_number_to_zero "$ip")
host=$(transform_last_number_increment "$network_ip")

echo -ne "┏"
for((i=0;i<48;i++));
do echo -ne "━";
done;

echo -ne "┓\n┃\t\t   ACTIVE HOSTS\t\t\t ┃\n┣"

for((i=0;i<48;i++));
do echo -ne "━";
done;

echo "┫"

completed_ips=0

while [[ "${host##*.}" -lt 254 ]]; do
	if ping -c 1 -W 0.5 "$host" >/dev/null; then
		echo -ne "\r"
		
		for((i = 0; i < 100; i++));
		do echo -ne " ";
		done;

		echo -ne "\r┃ ➤ $host\t\033[;32m✔\033[0m\t\t\t ┃\n"
	fi
	
	((completed_ips++))
    percentage=$((completed_ips * 50 / total_ips))
    #echo -ne "Progress: $percentage%\r"
	progress-bar $percentage

    host=$(transform_last_number_increment "$host")
done

echo -ne "\r┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛\n"

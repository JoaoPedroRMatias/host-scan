#!/bin/bash

cat ASCII.txt

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

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "				     ACTIVE HOSTS"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"


completed_ips=0

while [[ "${host##*.}" -lt 254 ]]; do
	if ping -c 1 -W 0.5 "$host" >/dev/null; then
		echo "$host UP"
	fi

	((completed_ips++))
    percentage=$((completed_ips * 100 / total_ips))
    echo -ne "Progress: $percentage%\r"

    host=$(transform_last_number_increment "$host")
done

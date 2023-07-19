#!/bin/bash
# Atribui informações sobre o SO à variável 'arc'
arc=$(uname -a)

# Atribui o número de CPUs físicas à variável 'pcpu'
pcpu=$(grep "physical id" /proc/cpuinfo | sort | uniq | wc -l) 

# Atribui o número de CPUs virtuais à variável 'vcpu'
vcpu=$(grep "^processor" /proc/cpuinfo | wc -l)

# Atribui a quantidade total de memória ram à variável 'fram'
fram=$(free -m | awk '$1 == "Mem:" {print $2}')

# Atribui a quantidade de memória em uso à variável 'uram'
uram=$(free -m | awk '$1 == "Mem:" {print $3}')

# Atribui o resultado do cálculo da porcentagem de memoria utilizada entre '$3' e '$2' à variável 'pram' 
pram=$(free | awk '$1 == "Mem:" {printf("%.2f"), $3/$2*100}')

# Atribui à variável 'fdisk' a quantidade total de armazenamento
fdisk=$(df -BG | grep '^/dev/' | grep -v '/boot$' | awk '{ft += $2} END {print ft}')

# Atribui à variável 'udisk' a quantidade de armazenamento utilizada
udisk=$(df -BM | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $3} END {print ut}')

# Atribui o resultado do cálculo da porcentagem de armazenamento utilizado entre '$3' e '$2' à variável pdisk
pdisk=$(df -BM | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $3} {ft+= $2} END {printf("%d"), ut/ft*100}')

# Atribui a porcentagem de uso da 'cpu' à variável 'cpul'
cpul=$(mpstat | grep all | awk '{printf "%.1f", 100 - $13}')

# Atribui a data e hora do último boot do sistema à variável 'lb'
lb=$(who -b | awk '$1 == "system" {print $3 " " $4}')

# Informa se estou utilizando LVM nas partições
lvmu=$(if [ $(lsblk | grep "lvm" | wc -l) -eq 0 ]; then echo no; else echo yes; fi)

# Atribui o número de conexões TCP estabelecidas à variável 'ctcp'
ctcp=$(ss -neopt state established | wc -l)

# Informa o número de usuários atualmente logados no sistema
ulog=$(users | wc -w)

# Informa o endereço IP associado ao hostname da máquina
ip=$(hostname -I)

# Informa a interface de rede do sistema
mac=$(ip link show | grep "ether" | awk '{print $2}')

# Informa o relatório de comandos SUDO dados no sistema
cmds=$(journalctl _COMM=sudo | grep COMMAND | wc -l)
echo "	#Architecture: $arc
	#CPU physical: $pcpu
	#vCPU: $vcpu
	#Memory Usage: $uram/${fram}MB ($pram%)
	#Disk Usage: $udisk/${fdisk}Gb ($pdisk%)
	#CPU load: $cpul%
	#Last boot: $lb
	#LVM use: $lvmu
	#Connections TCP: $ctcp ESTABLISHED
	#User log: $ulog
	#Network: IP $ip ($mac)
	#Sudo: $cmds cmd"

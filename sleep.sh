#!/bin/bash
#
# Script usada para calcular o atraso da execução do script 'monitoring.sh'

# Obtém os minutos do boot e extrai-os usando o comando 'cut'
MIN_TOTAL=$(who -b | cut -d: -f2)

# Calcula, em segundos, quanto tempo deverá atrasar a execução do script 'monitoring.sh'. Ele funciona em 3 etapas:
#
# 1. Calcula os minutos com o modulo 10, para obter o resto.
# 2. Multiplica o resto por 60, obtendo os segundos totais para atrasar
# 3. Atribui o resultado à variável 'SEC', utilizada para sleepar 
SEC=$[(MIN_TOTAL % 10) *60]


# Atrasa a execução por um determinado número de segundos
sleep $SEC

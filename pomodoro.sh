#!/bin/bash

export DISPLAY=:0

num_regex='^[-]{0,1}[0-9]+$'
trabajo=${1:- 25};
descanso=${2:- 5};

function usage {
	printf "\nUsage:\n./pomodoro.sh [trabajo (min)] [descanso (min)]\n"
}

function validate {
	num=$1
	extra=$2
	if [ -n "$extra" ]; then
		extra="($extra)"
	fi

	if [ "$num" == "--help" ]; then
		less BASICS.txt
		exit 0
	elif ! [[ $num =~ $num_regex ]]; then
		echo "El parámetro '$num' debe ser numérico. $extra"
		exit 1
	elif [ $num -lt 1 ]; then
		echo "El tiempo ingresado debe ser mayor a cero. $extra"
		exit 1
	elif [ $num -gt 1440 ]; then
		echo "El tiempo ingresado debe ser menor a 24 hs. $extra"
		exit 1
	fi
}

function work {
	notify-send "Concéntrate en tu tarea" -i play.png
}

function relax {
	notify-send "Toma un descanso" -i pause.png
}

function monitor {
	tiempo=$1
	tini=$(date +%s)
	tfin=$tini
	while [ $((tfin - tini)) -le $tiempo ]
	do
		actual=$((tiempo - tfin + tini))
		sleep 1
		hora=$((actual / 3600))
		minutos=$(((actual / 60) % 60))
		segundos=$((actual % 60))
		printf "Tiempo restante: $hora:$minutos:$segundos\r"
		tfin=$(date +%s)
	done
}

### MAIN ###
validate $trabajo "tiempo de trabajo"
validate $descanso "tiempo de descanso"

while [ 1 == 1 ]
do
	work
	monitor $((trabajo * 60))
	relax
	monitor $((descanso * 60))
done

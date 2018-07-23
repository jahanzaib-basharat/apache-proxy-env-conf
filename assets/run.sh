#!/bin/bash

FILE="/conf/proxy.conf"

echo "ProxyPreserveHost On" >> $FILE

declare -A SOURCES
declare -A TARGETS
declare -A MATCHSOURCES
declare -A MATCHTARGETS

#ProxyPass
ITER=0
for i in $(printenv | grep "PROXY_PASS_" | sort); do
	IFS='=' read -a splitted <<< "$i"
	KEY=${splitted[0]}
	VALUE=${splitted[1]}
	if [[ $KEY =~ ^PROXY_PASS_[1-9]+_SOURCE$ ]]; then
		SOURCES[$ITER]=$VALUE
		ITER=$((ITER+1))
	fi
done

ITER=0
for i in $(printenv | grep "PROXY_PASS_" | sort); do
	IFS='=' read -a splitted <<< "$i"
	KEY=${splitted[0]}
	VALUE=${splitted[1]}
	if [[ $KEY =~ ^PROXY_PASS_[1-9]+_TARGET$ ]]; then
		TARGETS[$ITER]=$VALUE
		ITER=$((ITER+1))
	fi
done


# ProxyPassMatch
ITER=0
for i in $(printenv | grep "PROXY_MATCH_" | sort); do
	IFS='=' read -a splitted <<< "$i"
	KEY=${splitted[0]}
	VALUE=${splitted[1]}
	if [[ $KEY =~ ^PROXY_MATCH_[1-9]+_SOURCE$ ]]; then
		MATCHSOURCES[$ITER]=$VALUE
		ITER=$((ITER+1))
	fi
done

ITER=0
for i in $(printenv | grep "PROXY_MATCH_" | sort); do
	IFS='=' read -a splitted <<< "$i"
	KEY=${splitted[0]}
	VALUE=${splitted[1]}
	if [[ $KEY =~ ^PROXY_MATCH_[1-9]+_TARGET$ ]]; then
		MATCHTARGETS[$ITER]=$VALUE
		ITER=$((ITER+1))
	fi
done

if [ "${#SOURCES[@]}" -eq "${#TARGETS[@]}" ]; then
	for ((s=0; s <${#SOURCES[@]}; s++)); do
		echo "ProxyPass ${SOURCES[$s]} ${TARGETS[$s]}" >> $FILE
		echo "ProxyPassReverse ${SOURCES[$s]} ${TARGETS[$s]}" >> $FILE
	done
fi

if [ "${#MATCHSOURCES[@]}" -eq "${#MATCHTARGETS[@]}" ]; then
	for ((s=0; s <${#MATCHSOURCES[@]}; s++)); do
		echo "ProxyPassMatch ${MATCHSOURCES[$s]} ${MATCHTARGETS[$s]}" >> $FILE
	done
fi

chown www-data:www-data /app -R
source /etc/apache2/envvars
tail -F /var/log/apache2/* &
exec apache2 -D FOREGROUND
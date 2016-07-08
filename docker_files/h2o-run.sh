#!/bin/bash
CONFIG_FILE=/etc/h2o/h2o-env.sh
FLAT_FILE=/etc/h2o/flatfile

mask2cidr() {
    nbits=0
    IFS=.
    for dec in $1 ; do
        case $dec in
            255) let nbits+=8;;
            254) let nbits+=7;;
            252) let nbits+=6;;
            248) let nbits+=5;;
            240) let nbits+=4;;
            224) let nbits+=3;;
            192) let nbits+=2;;
            128) let nbits+=1;;
            0);;
            *) echo "Error: $dec is not recognised"; exit 1
        esac
    done
    echo "$nbits"
}


# -- Load the configuration file if it exists
[ -e "$CONFIG_FILE" ] && . ${CONFIG_FILE}

ITF=${H2O_ITF:-wlp2s0}

IP=$(ifconfig ${ITF} | grep "inet addr" | cut -d ':' -f2 | cut -d ' ' -f1)
MASK=$(ifconfig ${ITF} | grep "Mask" | cut -d ':' -f4)
CIDR=$(mask2cidr $MASK)

java -Xmx${JAVA_HEAP:-4g} -jar /opt/h2o.jar \
	-name ${H2O_CLOUD_NAME} \
	-flatfile ${FLAT_FILE} \
	-network ${IP}/${CIDR}


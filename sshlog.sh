#! /bin/bash
# Programming and idea by : E2MA3N [Iman Homayouni]
# Gitbub : https://github.com/e2ma3n
# Email : e2ma3n@Gmail.com
# Website : http://blog.homayouni.info
# License : GPL v2.0
# sshlog v1.0 - core
#--------------------------------------------------------#

[ "$UID" != "0" ] && echo "[!] You need to use sudo or root user" && exit 1

function usage {
    echo "Usage:"
    echo "   Create CSV logs: $0"
    echo "   View CSV logs: $0 print [csv log address]"
    echo "   Example: $0 print /var/log/sshlog/login/root.csv"
}

function main {
    rm -rf /var/log/sshlog &> /dev/null
    rm -rf /var/log/sshlog/* &> /dev/null
    [ ! -d /var/log/sshlog/ ] && mkdir -p /var/log/sshlog/attack && mkdir -p /var/log/sshlog/login
}

function dependencies {
    apt list python-pandas 2> /dev/null | grep -o installed &> /dev/null
    [ "$?" != "0" ] && echo "[#] apt install python-pandas" && exit 1

    apt list python-tabulate 2> /dev/null | grep -o installed &> /dev/null
    [ "$?" != "0" ] && echo "[#] apt install python-tabulate" && exit 1

    apt list tree 2> /dev/null | grep -o installed &> /dev/null
    [ "$?" != "0" ] && echo "[#] apt install tree" && exit 1
}

function logs {
    logs=$(ls -1 /var/log/auth.log* | grep -v gz)
}

function root_attack {
    cat $logs | grep 'Failed password for root' > /tmp/sshlog

    cat /tmp/sshlog | tr -s ' ' | cut -d ' ' -f '1,2,3' | tr ' ' '_' > /tmp/sshlog1
    cat /tmp/sshlog | tr -s ' ' | cut -d ' ' -f '11,14' | tr ' ' ',' > /tmp/sshlog2

    echo "Time and Date,Attacker IP,Protocol" > /var/log/sshlog/attack/root.csv
    paste /tmp/sshlog1 /tmp/sshlog2 | tr '\t' ',' >> /var/log/sshlog/attack/root.csv

    rm /tmp/sshlog1 /tmp/sshlog2 /tmp/sshlog &> /dev/null
}

function root_login {
    cat $logs | grep 'Accepted password for root' > /tmp/sshlog

    cat /tmp/sshlog | tr -s ' '  | cut -d ' ' -f '1,2,3' | tr ' ' '_' > /tmp/sshlog1
    cat /tmp/sshlog | tr -s ' ' | cut -d ' ' -f '11,14' | tr ' ' ',' > /tmp/sshlog2

    echo "Time and Date,From,Protocol" > /var/log/sshlog/login/root.csv
    paste /tmp/sshlog1 /tmp/sshlog2 | tr '\t' ',' >> /var/log/sshlog/login/root.csv

    rm /tmp/sshlog1 /tmp/sshlog2 /tmp/sshlog &> /dev/null
}

function invalid_user_attack {
    cat $logs | grep 'Failed password for invalid user' > /tmp/sshlog

    cat /tmp/sshlog | tr -s ' ' | cut -d ' ' -f '1,2,3' | tr ' ' '_' > /tmp/sshlog1
    cat /tmp/sshlog | tr -s ' ' | cut -d ' ' -f '13,16' | tr ' ' ',' > /tmp/sshlog2

    echo "Time and Date,Attacker IP,Protocol" > /var/log/sshlog/attack/invalid_users.csv
    paste /tmp/sshlog1 /tmp/sshlog2 | tr '\t' ',' >> /var/log/sshlog/attack/invalid_users.csv

    rm /tmp/sshlog1 /tmp/sshlog2 /tmp/sshlog &> /dev/null
}

function other_user_login {
    cat $logs | grep 'Accepted password for' | grep -v root > /tmp/sshlog

    cat /tmp/sshlog | tr -s ' ' | cut -d ' ' -f '1,2,3' | tr ' ' '_' > /tmp/sshlog1
    cat /tmp/sshlog | tr -s ' ' | cut -d ' ' -f '9,11,14' | tr ' ' ',' > /tmp/sshlog2

    echo "Time and Date,User,From,Protocol" > /var/log/sshlog/login/other_user_login.csv
    paste /tmp/sshlog1 /tmp/sshlog2 | tr '\t' ',' >> /var/log/sshlog/login/other_user_login.csv

    rm /tmp/sshlog1 /tmp/sshlog2 /tmp/sshlog &> /dev/null
}

function c_python {
    echo "import pandas" > /tmp/sshlog.py
    echo "import sys" >> /tmp/sshlog.py
    echo "from tabulate import tabulate" >> /tmp/sshlog.py
    echo "data = pandas.read_csv(sys.argv[1], encoding = 'utf-8' ). fillna('NULL')" >> /tmp/sshlog.py
    echo "print(tabulate(data, headers=data.columns, tablefmt=\"grid\"))" >> /tmp/sshlog.py
}

reset ; dependencies
if [ -z "$1" ] ; then
    main
    logs
    root_attack
    root_login
    invalid_user_attack
    other_user_login
    tree /var/log/sshlog/
else
    if [ "$1" = "print" ] ; then
        if [ -f "$2" ] ; then
            dependencies
            c_python
            python /tmp/sshlog.py $2
            rm /tmp/sshlog.py &> /dev/null
        else
            usage ; exit 1
        fi
    else
        usage ; exit 1
    fi
fi

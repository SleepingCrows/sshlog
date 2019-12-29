#! /bin/bash
# Programming and idea by : E2MA3N [Iman Homayouni]
# Gitbub : https://github.com/e2ma3n
# Email : e2ma3n@Gmail.com
# Website : http://www.homayouni.info
# License : GPL v2.0
# Last update : 29-December-2019_15:08:35
# sshlog v2.0 - core
#--------------------------------------------------------#

[ "$UID" != "0" ] && echo "[!] You need to use sudo or root user" && exit 1

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
    # ---------------------------------------------------------------- #
    # create and compute /var/log/sshlog/attack/root.csv               #
    # ---------------------------------------------------------------- #
    cat $logs | grep 'Failed password for root' > /tmp/sshlog

    cat /tmp/sshlog | tr -s ' ' | cut -d ' ' -f '1,2,3' | tr ' ' '_' > /tmp/sshlog1
    cat /tmp/sshlog | tr -s ' ' | cut -d ' ' -f '11,14' | tr ' ' ',' > /tmp/sshlog2

    echo "Time and Date,Attacker IP,Protocol" > /var/log/sshlog/attack/root.csv
    paste /tmp/sshlog1 /tmp/sshlog2 | tr '\t' ',' >> /var/log/sshlog/attack/root.csv

    rm /tmp/sshlog1 /tmp/sshlog2 /tmp/sshlog &> /dev/null
}

function root_login {
    # ---------------------------------------------------------------- #
    # create and compute /var/log/sshlog/login/root.csv                #
    # ---------------------------------------------------------------- #
    cat $logs | grep 'Accepted password for root' > /tmp/sshlog

    cat /tmp/sshlog | tr -s ' '  | cut -d ' ' -f '1,2,3' | tr ' ' '_' > /tmp/sshlog1
    cat /tmp/sshlog | tr -s ' ' | cut -d ' ' -f '11,14' | tr ' ' ',' > /tmp/sshlog2

    echo "Time and Date,From,Protocol" > /var/log/sshlog/login/root.csv
    paste /tmp/sshlog1 /tmp/sshlog2 | tr '\t' ',' >> /var/log/sshlog/login/root.csv

    rm /tmp/sshlog1 /tmp/sshlog2 /tmp/sshlog &> /dev/null
}

function invalid_user_attack {
    # ---------------------------------------------------------------- #
    # create and compute /var/log/sshlog/attack/invalid_users.csv      #
    # ---------------------------------------------------------------- #
    cat $logs | grep 'Failed password for invalid user' > /tmp/sshlog

    cat /tmp/sshlog | tr -s ' ' | cut -d ' ' -f '1,2,3' | tr ' ' '_' > /tmp/sshlog1
    cat /tmp/sshlog | tr -s ' ' | cut -d ' ' -f '13,16' | tr ' ' ',' > /tmp/sshlog2

    echo "Time and Date,Attacker IP,Protocol" > /var/log/sshlog/attack/invalid_users.csv
    paste /tmp/sshlog1 /tmp/sshlog2 | tr '\t' ',' >> /var/log/sshlog/attack/invalid_users.csv

    rm /tmp/sshlog1 /tmp/sshlog2 /tmp/sshlog &> /dev/null
}

function other_user_login {
    # ---------------------------------------------------------------- #
    # create and compute /var/log/sshlog/login/other_user_login.csv    #
    # ---------------------------------------------------------------- #
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

function view {
    for (( ;; )) ; do
        # check root.csv file is exist or not
        [ ! -f /var/log/sshlog/attack/root.csv ] && \
        # check root.csv file is exist or not
        [ ! -f /var/log/sshlog/login/root.csv ] && \
        # check invalid_users.csv file is exist or not
        [ ! -f /var/log/sshlog/attack/invalid_users.csv ] && \
        # check other_user_login.csv file is exist or not
        [ ! -f /var/log/sshlog/login/other_user_login.csv ] && \
        echo "[!] No result" && exit 1

        # clean up terminal
        reset
        echo "[+] -------------------------------------------------------------------------- [+]"
        echo "[+] sshlog v2.0 - Professional log viewer for ssh protocol"
        echo "[+] Programming and idea by : E2MA3N [Iman Homayouni]"
        echo "[+] Gitbub : https://github.com/e2ma3n"
        echo "[+]"

        [ -f /var/log/sshlog/attack/root.csv ] && echo -e "[1] View \e[43mattack\e[0m on root user [in ssh protocol]"
        [ -f /var/log/sshlog/login/root.csv ] && echo -e "[2] View \e[101mlogin\e[0m on root user [in ssh protocol]"
        [ -f /var/log/sshlog/attack/invalid_users.csv ] && echo -e "[3] View \e[43mattack\e[0m on invalid user [in ssh protocol]"
        [ -f /var/log/sshlog/login/other_user_login.csv ] && echo -e "[4] View \e[101mlogin\e[0m on other users [in ssh protocol]"

        echo "[5] Exit"
        echo -en "[>] Select: " ; read q
        echo "[+]"

        #  View attack on root user [in ssh protocol]
        if [ "$q" = "1" ] ; then
        echo -e "[1] View \e[43mattack\e[0m on root user [in ssh protocol]"
        python /tmp/sshlog.py /var/log/sshlog/attack/root.csv 2> /dev/null | less
        echo "[>] File: /var/log/sshlog/attack/root.csv"
        echo -en "[>] Press enter for back to menu" ; read null


        # View login on root user [in ssh protocol]
        elif [ "$q" = "2" ] ; then
        echo -e "[2] View \e[101mlogin\e[0m on root user [in ssh protocol]"
        python /tmp/sshlog.py /var/log/sshlog/login/root.csv 2> /dev/null | less
        echo "[>] File: /var/log/sshlog/login/root.csv"
        echo -en "[>] Press enter for back to menu" ; read null


        # View attack on invalid user [in ssh protocol]
        elif [ "$q" = "3" ] ; then
        python /tmp/sshlog.py /var/log/sshlog/attack/invalid_users.csv 2> /dev/null | less
        echo -e "[3] View \e[43mattack\e[0m on invalid user [in ssh protocol]"
        echo "[>] File: /var/log/sshlog/attack/invalid_users.csv"
        echo -en "[>] Press enter for back to menu" ; read null


        # View login on other users [in ssh protocol]
        elif [ "$q" = "4" ] ; then
        echo -e "[4] View \e[101mlogin\e[0m on other users [in ssh protocol]"
        python /tmp/sshlog.py /var/log/sshlog/login/other_user_login.csv 2> /dev/null | less
        echo "[>] File: /var/log/sshlog/login/other_user_login.csv"
        echo -en "[>] Press enter for back to menu" ; read null


        # exit from program
        elif [ "$q" = "5" ] ; then
            echo "[+] -------------------------------------------------------------------------- [+]"
            exit 0
        else
            echo "[!] Bad input"
            echo "[>] Try again"
            sleep 3
        fi
    done
}

# run functions
dependencies
c_python
main
logs
root_attack
root_login
invalid_user_attack
other_user_login
view

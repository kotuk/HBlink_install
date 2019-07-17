#! /bin/bash

HBLINK_DIR="/srv/hblink3"
 
i=0
while IFS=: read tg ts tgp tsp;do
tabtg["$i"]=$tg
tabts["$i"]=$ts
tabtgp["$i"]=$tgp
tabtsp["$i"]=$tsp
i=$(($i+1))
done < tg.txt
 
i=0
while IFS=: read openbridge;do
tabopenbridge["$i"]=$openbridge
i=$(($i+1))
done < openbridge.txt
 
i=0
while IFS=: read master stat1 stat2 stat3 stat4 stat5;do
tabmaster["$i"]=$master
tabstat1["$i"]=$stat1
tabstat2["$i"]=$stat2
tabstat3["$i"]=$stat3
tabstat4["$i"]=$stat4
tabstat5["$i"]=$stat5
i=$(($i+1))
done < masters.txt
 
cp rules.py rules.py.sav
rm -f rules.py
echo "BRIDGES = {" >> rules.py
 
for i in `seq 0 $((${#tabtg[*]}-1))`; do
echo "'TG${tabtg[$i]}': [" >> rules.py
 
        for j in `seq 0 $((${#tabmaster[*]}-1))`; do
        printf "{'SYSTEM': '${tabmaster[$j]}','TS': ${tabts[$i]}, 'TGID': ${tabtg[$i]}, 'ACTIVE':"  >> rules.py
 
                if [ "${tabstat1[$j]}" == ${tabtg[$i]} ] || [ "${tabstat2[$j]}" == ${tabtg[$i]} ] || [ "${tabstat3[$j]}" == ${tabtg[$i]} ] || [ "${tabstat4[$j]}" == ${tabtg[$i]} ] || [ "${tabstat5[$j]}" == ${tabtg[$i]} ]
                then
                printf "True, 'TIMEOUT': 3, 'TO_TYPE': 'OFF', 'ON': [${tabtg[$i]}], 'OFF': [7," >> rules.py
                else
                printf "False, 'TIMEOUT': 3, 'TO_TYPE': 'NONE', 'ON': [${tabtg[$i]}], 'OFF': [7," >> rules.py
                fi
 
                while IFS=: read tgoff tsoff tgp tsp;do
                if [ "$tgoff" != ${tabtg[$i]} ]
                then
                if [ "$tsoff" == ${tabts[$i]} ]
                then
                printf "$tgoff," >> rules.py
                fi
                fi
                done < tg.txt
 
        echo "], 'RESET': []}," >> rules.py
 
        done
 
        if [ ${tabtgp[$i]} ]
        then
        echo "{'SYSTEM': '${tabtgp[$i]}','TS': ${tabtsp[$i]}, 'TGID': ${tabtg[$i]}, 'ACTIVE': True, 'TIMEOUT': 3, 'TO_TYPE' : 'NONE',  'ON': [], 'OFF': [],   'RESET': []},"  >> rules.py
        fi
 
 
        for j in `seq 0 $((${#tabopenbridge[*]}-1))`; do
        echo "{'SYSTEM': '${tabopenbridge[$j]}','TS': 1, 'TGID': ${tabtg[$i]}, 'ACTIVE': True, 'TIMEOUT': 3, 'TO_TYPE': 'NONE',  'ON': [], 'OFF': [],   'RESET': []},"  >> rules.py
        done
echo "]," >> rules.py
done
 
 
echo "" >> rules.py
echo "}" >> rules.py
echo >> rules.py
echo "if __name__ == '__main__':" >> rules.py
echo "    from pprint import pprint" >> rules.py
echo "    pprint(BRIDGES)" >> rules.py
 
read -r -p "Do you want to copy the file in the destination directory ? [y/N] " reponse
reponse=${reponse,,}
if [[ "$reponse" =~ ^(yes|y)$ ]]
then
    cp $HBLINK_DIR/rules.py $HBLINK_DIR/rules.py.sav
    cp rules.py $HBLINK_DIR/rules.py
   /bin/systemctl restart hblink
   /bin/systemctl restart hbmonitor
else
    exit 0
fi
 
 
exit 0

#!/bin/bash
export ns=newoes
export ns=$ns
echo newoes.yml >files.txt
while read file;do
echo $file
grep "encrypted:" $file > file.yml
while read line;do
echo $line
secret=$(echo $line | sed "s/encrypted:/ /g" | awk '{print $2}' | sed 's/:/ /g' |awk '{print $1}')
key=$(echo $line |   sed "s/encrypted:/ /g" | awk '{print $2}' | sed 's/:/ /g' |awk '{print $2}')
value=$(kubectl -n $ns  get secret $secret -o jsonpath="{.data.$key}" | base64 -d)
sed -i "s/encrypted:$secret:$key/$value/g" $file
done <file.yml
kubectl -n $ns apply -f $file
done <files.txt

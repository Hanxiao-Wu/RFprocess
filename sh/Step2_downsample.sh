ls SS.*.SAC | awk -F '.' '{print $2}' | sort -u > h # generate a list that stores all the 'station name'
n=`wc -l h | awk '{print $1}'`
for i in `seq 1 1 $n`
do
st=`awk 'NR=='$i'{print $1}' h`
echo $st
sac<<EOF
r SS.${st}.*.SAC
decimate 5;decimate 4
w over
quit
EOF
done

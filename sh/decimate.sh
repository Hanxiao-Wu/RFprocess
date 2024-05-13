for i in `seq $1 1 $2`
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

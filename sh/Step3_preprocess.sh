loc=1
n=`wc -l h | awk '{print $1}'`
for i in `seq 1 1 $n`
do
st=`awk 'NR=='$i'{print $1}' h`
echo $st GP${loc}
sac<<EOF
r SS.${st}.*.GP${loc}.*.SAC
rmean;rtr;taper;
trans from polezero subtype SS.PZ to none freq 0.005 0.01 20 24
#trans from polezero subtype SS.PZ to none freq 0.02 0.05 5 7
w append .removed
quit
EOF
done

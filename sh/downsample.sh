loc=$1
for i in `ls *GP${loc}*.SAC`
do
sac<<EOF
r $i
decimate 5;decimate 4
w over
quit
EOF
done

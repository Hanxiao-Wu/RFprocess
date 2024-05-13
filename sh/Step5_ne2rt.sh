dir='./EQ'
for ev in `ls -d 2023*`
do
echo $ev
cd ${dir}/$ev
ls *.Z.SAC.P | awk -F '.' '{print $1}' | sort -u > sta.list
for st in `awk '{print $1}' sta.list`
do
sac<<EOF
r ${st}.[NE].SAC.Pcut_high
rotate to gcp
w ${st}.R.SAC.Pcut ${st}.T.SAC.Pcut
quit
EOF
done
cd $dir
echo $ev
done

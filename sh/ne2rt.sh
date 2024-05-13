dir=/NAS1/Antarctica/Season2023/SOLODATA/SAC/NE_SW/EQ
for ev in `ls -d *T*Z`
do
echo $ev
cd ${dir}/$ev
ls *.Z.SAC.Pcut_high | awk -F '.' '{print $1}' | sort -u > sta.list
for st in `awk '{print $1}' sta.list`
do
sac<<EOF
r ${st}.[NE].SAC.Pcut_high
rotate to gcp
w ${st}.R.SAC.Pcut_high ${st}.T.SAC.Pcut_high
quit
EOF
done
cd $dir
echo $ev
done

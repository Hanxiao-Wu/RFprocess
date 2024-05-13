loc=$3
for i in `seq $1 1 $2`
do
st=`awk 'NR=='$i'{print $1}' List`
lat=`awk 'NR=='$i'{print $4}' List`
lon=`awk 'NR=='$i'{print $5}' List`
for j in `ls /NAS1/Antarctica/Season2023/SOLODATA/Antarctica2023-2024/NE-SWLine/23-24.??/${st}.*.${loc}.miniseed`
do
~/mseed2sac-main/mseed2sac $j -k $lat/$lon
done
echo m2sac: $i
done

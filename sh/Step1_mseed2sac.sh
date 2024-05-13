loc=$3   # N , E, or Z
dir=../example/ # where the miniseed data are stored
f=../example/List #store station information
for i in `seq $1 1 $2`
do
st=`awk 'NR=='$i'{print $1}' $f`
lat=`awk 'NR=='$i'{print $4}' $f`
lon=`awk 'NR=='$i'{print $5}' $f`
for j in `ls ${dir}/${st}.*.${loc}.miniseed`
do
mseed2sac $j -k $lat/$lon
done
echo m2sac: $i
done

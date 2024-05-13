for i in `seq $1 1 $2`
do
  year=`awk 'NR=='$i'{print $1}' day`
  day=`awk 'NR=='$i'{print $2}' day`
  for j in `seq 1 1 109`
  do
    sta=`awk 'NR=='$j'{print $1}' list`
    nm=`awk -F ',' '$6=="'$sta'"{print $1}' station_location.info`
    python preprocess.py $sta $year $day $nm
  done
done

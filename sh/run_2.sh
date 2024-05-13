for i in `seq $1 1 $2`
do
  year=`awk 'NR=='$i'{print $1}' day`
  day=`awk 'NR=='$i'{print $2}' day`
  k=1
  sta1=`awk 'NR=='$k'{print $1}' sta_nm.list`
  for j in `seq 1 1 109`
  do
    sta2=`awk 'NR=='$j'{print $1}' sta_nm.list`
    python corr.py $sta1 $sta2 $year $day
  done
done

for i in `seq 1 1 77`
do
eq_time=`awk 'NR=='$i'{print $1}' eq_rf.info`
evla=`awk 'NR=='$i'{print $2}' eq_rf.info`
evlo=`awk 'NR=='$i'{print $3}' eq_rf.info`
evdp=`awk 'NR=='$i'{print $4}' eq_rf.info`
python cut_ev.py $eq_time $evla $evlo $evdp
done

f=eq_rf.info
n=`wc -l $f|awk '{print $1}'`
for i in `seq 1 1 $n`
do
eq_time=`awk 'NR=='$i'{print $1}' $f`
evla=`awk 'NR=='$i'{print $2}' $f`
evlo=`awk 'NR=='$i'{print $3}' $f`
evdp=`awk 'NR=='$i'{print $4}' $f`
python cut_ev.py $eq_time $evla $evlo $evdp
done

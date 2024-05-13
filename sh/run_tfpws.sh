for i in `seq $1 1 $2`
do
list=`ls CORR_ramn/NNE01_*.list | awk 'NR=='$i'{print $1}'`
python tf_PWS.py $list
done

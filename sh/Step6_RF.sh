for ev in `ls -d 20*`
do
python rf.py $ev
echo "done:", $ev
done

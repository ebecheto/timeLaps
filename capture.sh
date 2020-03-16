#!/bin/bash

# if [ -z "$NOMOVE" ]; then NOMOVE=0; echo "NOMOVE set to" $NOMOVE; fi

echo "$#-argument"
FR=0
while [ $# -gt 0 ]; do  case $1 in
	-f)   FR=1 ;;
	*)    echo " -f force picture";;
esac; shift; done

dir=$HOME/timeLaps
mkdir -p $dir
cpdir=/media/USB\ DISK/timeLaps
mkdir -p $cpdir
cd $dir
echo "Using dir:$dir"

NOMOVE=$dir/nomove.txt
if [[ ! -f $NOMOVE ]]; then echo "0" > $NOMOVE; echo "NOMOVE :$NOMOVE set to $(cat $NOMOVE)"; fi
W=640
H=480

# prise de la photo
raspistill -n -o $dir/pic-1.jpg -q 5 -w $W -h $H
python $dir/led_2_on.py

# on envoie la photo que si elle est un peu differente de la precedente
compare -metric RMSE $dir/pic-1.jpg $dir/pic.jpg null: 2>&1 | cut -d ' ' -f 1  > $dir/comp.txt


FLOAT=$(cat $dir/comp.txt)
INT=${FLOAT/\.*}
comp=$INT
VALUE=2000
# if [[ "$comp" -ge "$VALUE" && "$dark" -gt 1000 ]]
if [[ ( "$comp" -ge "$VALUE" ) || ( $FR -eq 1 )]]
then # picures are different
echo "DIFF:$comp > $VALUE && DARK:$dark > 1000 [`date`] || force $FR"
# take a better pic
raspistill -n -o HD_pic.jpg
python $dir/light.py
cp pic-1.jpg $cpdir/P$(date +"_%F_%Hh%Mm%S").jpg
cp HD_pic.jpg $cpdir/HD$(date +"_%F_%Hh%Mm%S").jpg
cp pic.jpg pic-old.jpg; cp pic-1.jpg pic.jpg

# c juste pour pour faire un sond : t'est pris, je t'ai vu!
if [[ $(cat $NOMOVE) -ge 10 ]]; then 
# echo "tictic"; python ~/bin/tictic.py ; 
echo "0"> $NOMOVE ;fi
else
echo $(($(cat $NOMOVE)+1)) > $NOMOVE
echo "$(cat $NOMOVE)___ $comp < $VALUE ! $dark [`date`] ___"
fi


python $dir/led_2_off.py

#!bin/bash
set -e

RUN_FOLDER=$1

for re in $RUN_FOLDER/g*_B/Report.html;
do
echo $re
	sed -i 's/Zheng Wei and Wei Zhang/Admera Health/g' $re 
echo $re done!
done


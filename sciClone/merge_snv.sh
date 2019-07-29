# author: Yifei
# Merge SNV files of samples

set -e

awk -F"\t" '{total[$2] = $1}{ 
    if(NR == FNR){
        a[$2] = $3"\t"$4"\t"$5
        }
    else{
        b[$2] = $3"\t"$4"\t"$5
        }
            }
    END{
        for(pos in total){
            if(pos in a && pos in b){
                print total[pos]"\t"pos"\t"a[pos]"\t"b[pos]
                    }
            else if(pos in a && !(pos in b)){
                print total[pos]"\t"pos"\t"a[pos]"\t"100"\t"0"\t"0
                    }
            else{
                print total[pos]"\t"pos"\t"100"\t"0"\t"0"\t"b[pos]
                    }
                        }
                            }' $1 $2

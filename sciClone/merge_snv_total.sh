# author: Yifei.wan
# Merge SNV files of multiple samples

set -e

# $1: the merged two samples file
# $2: single sample

awk -F"\t" '{
    total[$2] = $1
        if(NR==FNR){
            a[$2] = $0 
            }
        else{
            b[$2] = $3"\t"$4"\t"$5
            }
    }
    END{
        for(p in total){
            if(p in a && p in b){
                print a[p]"\t"b[p]
                }
            else if(p in a && !(p in b)){
                print a[p]"\t"100"\t"0"\t"0
                }
            else{
                print total[p]"\t"p"\t"100"\t"0"\t"0"\t"100"\t"0"\t"0"\t"b[p]
                }
            }
        }
    ' $1 $2

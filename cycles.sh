pushd $(pwd) > /dev/null
cd ~/ETH/ComputerArchitecture/lab3
schedulers=([1]="FCFS" [2]="FRFCFS" [3]="FRFCFS_Cap" [4]="ATLAS" [5]="BLISS")
if [ -f cycles_final.stats ]
then
    rm -f cycles_final.stats
fi
for i in {1..5}
do
    scheduler=${schedulers[$i]}
    ## first workload
    high=$(cat $scheduler'_1.stats' | grep "record_cycs_core_0" | sed "s/\s*[a-z0-7._]*\s*\([0-9]*\)\s*#.*/\1/g")
    low=$(cat $scheduler"_1.stats" | grep "record_cycs_core_1" | sed "s/\s*[a-z0-7._]*\s*\([0-9]*\)\s*#.*/\1/g")
    for j in {2..3}
    do
        cur_low=$(cat $scheduler"_1.stats" | grep "record_cycs_core_$j" | sed "s/\s*[a-z0-7._]*\s*\([0-9]*\)\s*#.*/\1/g")
        if [ $low -lt $cur_low ]
        then
            low=$cur_low
        fi
    done
    high_alone=$(cat baseline_cycles.stats | awk "NR==$i" | sed "s/\([0-9]*\),[0-9]*/\1/g")
    low_alone=$(cat baseline_cycles.stats | awk "NR==$i" | sed "s/[0-9]*,\([0-9]*\)/\1/g")
    high_slowdown=$(echo "$high / $high_alone" | bc -l)
    low_slowdown=$(echo "$low / $low_alone" | bc -l)
    if (( $(echo "$high_slowdown > $low_slowdown" | bc -l) ))
    then
        printf "$high_slowdown," >> cycles_final.stats
    else
        printf "$low_slowdown," >> cycles_final.stats
    fi

    ## second workload
    high_0=$(cat $scheduler'_2.stats' | grep "record_cycs_core_0" | sed "s/\s*[a-z0-7._]*\s*\([0-9]*\)\s*#.*/\1/g")
    high_1=$(cat $scheduler'_2.stats' | grep "record_cycs_core_1" | sed "s/\s*[a-z0-7._]*\s*\([0-9]*\)\s*#.*/\1/g")
    low_0=$(cat $scheduler"_2.stats" | grep "record_cycs_core_2" | sed "s/\s*[a-z0-7._]*\s*\([0-9]*\)\s*#.*/\1/g")
    low_1=$(cat $scheduler"_2.stats" | grep "record_cycs_core_3" | sed "s/\s*[a-z0-7._]*\s*\([0-9]*\)\s*#.*/\1/g")
    if (( $(echo "$high_0 > $high_1" | bc -l) ))
    then
        high=$high_0 
    else 
        high=$high_1
    fi
    if (( $(echo "$low_0 > $low_1" | bc -l) ))
    then
        low=$low_0 
    else 
        low=$low_1
    fi
    high_alone=$(cat baseline_cycles.stats | awk "NR==$i" | sed "s/\([0-9]*\),[0-9]*/\1/g")
    low_alone=$(cat baseline_cycles.stats | awk "NR==$i" | sed "s/[0-9]*,\([0-9]*\)/\1/g")
    high_slowdown=$(echo "$high / $high_alone" | bc -l)
    low_slowdown=$(echo "$low / $low_alone" | bc -l)
    if (( $(echo "$high_slowdown > $low_slowdown" | bc -l) ))
    then
        printf "$high_slowdown," >> cycles_final.stats
    else
        printf "$low_slowdown," >> cycles_final.stats
    fi

    ## third workload
    high=$(cat $scheduler'_3.stats' | grep "record_cycs_core_0" | sed "s/\s*[a-z0-7._]*\s*\([0-9]*\)\s*#.*/\1/g")
    for j in {1..3}
    do
        cur_high=$(cat $scheduler"_3.stats" | grep "record_cycs_core_$j" | sed "s/\s*[a-z0-7._]*\s*\([0-9]*\)\s*#.*/\1/g")
        if [ $high -lt $cur_high ]
        then
            high=$cur_high
        fi
    done
    high_alone=$(cat baseline_cycles.stats | awk "NR==$i" | sed "s/\([0-9]*\),[0-9]*/\1/g")
    high_slowdown=$(echo "$high / $high_alone" | bc -l)
    printf "$high_slowdown," >> cycles_final.stats

    ## fourth workload
    high=$(cat $scheduler'_4.stats' | grep "record_cycs_core_0" | sed "s/\s*[a-z0-7._]*\s*\([0-9]*\)\s*#.*/\1/g")
    for j in {1..7}
    do
        cur_high=$(cat $scheduler"_4.stats" | grep "record_cycs_core_$j" | sed "s/\s*[a-z0-7._]*\s*\([0-9]*\)\s*#.*/\1/g")
        if [ $high -lt $cur_high ]
        then
            high=$cur_high
        fi
    done
    high_alone=$(cat baseline_cycles.stats | awk "NR==$i" | sed "s/\([0-9]*\),[0-9]*/\1/g")
    high_slowdown=$(echo "$high / $high_alone" | bc -l)
    printf "$high_slowdown\n" >> cycles_final.stats

done
popd > /dev/null

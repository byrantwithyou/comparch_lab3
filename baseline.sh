workloads=([1]="traces/""high-mem-intensity.trace" [2]="traces/""low-mem-intensity.trace")
pushd $(pwd) > /dev/null
cd ~/ETH/ComputerArchitecture/lab3
if [ -f baseline_cycles.stats ]
then
    rm -f baseline_cycles.stats
fi
schedulers=([1]="FCFS" [2]="FRFCFS" [3]="FRFCFS_Cap" [4]="ATLAS" [5]="BLISS")
for i in {1..5}
do
    scheduler=${schedulers[$i]}
    for j in {1..2}
    do
        workload=${workloads[$j]}
        if [ -f $scheduler"_b"$j".stats" ]
            then rm -f $scheduler"_b"$j".stats"
        fi
        ./ramulator_"$scheduler" configs/DDR4-config.cfg --mode=cpu --stats $scheduler"_b"$j".stats" $workload >/dev/null
        cycles=$(cat $scheduler'_b'$j'.stats' | grep "cpu_cycles" | sed "s/\s*[a-z._]*\s*\([0-9.]*\)\s*#.*/\1/g")
        printf $cycles >> baseline_cycles.stats
        if [ $j -ne 2 ]
            then printf "," >> baseline_cycles.stats
            else printf "\n" >> baseline_cycles.stats
        fi
    done
done
popd > /dev/null

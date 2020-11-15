get_workload()
{
    traces=([1]="traces/""high-mem-intensity.trace" [2]="traces/""low-mem-intensity.trace")
    workload=""
    for ((i=1;i<=(($1+$2));++i))
    do
        if [ $i -le $1 ]
            then
                workload="$workload ${traces[1]}"
            else
                workload="$workload ${traces[2]}"
        fi
    done
    workloads[$3]="${workload:1}"
}

set_workloads() {
    get_workload 1 3 1
    get_workload 2 2 2
    get_workload 4 0 3
    get_workload 8 0 4
}

pushd $(pwd) > /dev/null
cd ~/ETH/ComputerArchitecture/lab3
if [ -f inst_throughput.stats ]
then
    rm -f inst_throughput.stats
fi
if [ -f cycles.stats ]
then
    rm -f cycles.stats
fi
schedulers=([1]="FCFS" [2]="FRFCFS" [3]="FRFCFS_Cap" [4]="ATLAS" [5]="BLISS")
set_workloads
for i in {1..5}
do
    scheduler=${schedulers[$i]}
    for j in {1..4}
    do
        workload=${workloads[$j]}
        if [ -f $scheduler"_"$j".stats" ]
            then rm -f $scheduler"_"$j".stats"
        fi
        ./ramulator_"$scheduler" configs/DDR4-config.cfg --mode=cpu --stats $scheduler"_"$j".stats" $workload >/dev/null
        inst_th=$(cat $scheduler'_'$j'.stats' | grep "instruction_" | sed "s/\s*[a-z._]*\s*\([0-9.]*\)\s*#.*/\1/g")
        cycles=$(cat $scheduler'_'$j'.stats' | grep "cpu_cycles" | sed "s/\s*[a-z._]*\s*\([0-9.]*\)\s*#.*/\1/g")
        printf $inst_th >> inst_throughput.stats
        printf $cycles >> cycles.stats
        if [ $j -ne 4 ]
            then printf "," >> inst_throughput.stats
                 printf "," >> cycles.stats
            else printf "\n" >> inst_throughput.stats
                 printf "\n" >> cycles.stats
        fi
    done
done
popd > /dev/null

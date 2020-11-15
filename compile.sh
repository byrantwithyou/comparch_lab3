schedulers=([1]="FCFS" [2]="FRFCFS" [3]="FRFCFS_Cap" [4]="ATLAS" [5]="BLISS")
for i in {1..5}
do
    scheduler=${schedulers[$i]}
    sed -i "88s/\(.*::\).*;/\1$scheduler;/g" src/Scheduler.h
    make clean
    make -j > /dev/null
    if [ -f ramulator_"$scheduler" ]
    then rm -f ramulator_"$scheduler"
    fi
    mv ./ramulator ./ramulator_"$scheduler"
done

#! /usr/bin/python3
import numpy as np
import matplotlib.pyplot as plt

inst_throughput = np.loadtxt('inst_throughput.stats', delimiter=',')
 
# set width of bar
barWidth = 0.18
fig, ax = plt.subplots()
rects = [{}, {}, {}, {}, {}]
schedulers = ['FCFS', 'FRFCFS', 'FRFCFS_CAP', 'ATLAS', 'BLISS']
# Make the plot
for i in range(5):
    rects[i] = ax.bar(np.arange(4) + barWidth * i, inst_throughput[i:i + 1][0], width=barWidth, edgecolor='white', label=schedulers[i])

# Add xticks on the middle of the group bars
plt.ylabel("Instruction Throughput")
plt.xticks([r + barWidth * 2 for r in range(4)], ['HLLL', 'HHLL', 'HHHH', 'HHHHHHHH'])
 
# Create legend & Show graphic
plt.legend()
plt.show()

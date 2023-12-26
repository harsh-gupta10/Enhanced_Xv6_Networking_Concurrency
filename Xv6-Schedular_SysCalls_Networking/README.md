[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-24ddc0f5d75046c5622901739e7c5dd533143b0c8e959d652212380cedb1ea36.svg)](https://classroom.github.com/a/DLipn7os)
# Intro to Xv6
OSN Monsoon 2023 mini project 2

## Some pointers
- main xv6 source code is present inside `initial_xv6/src` directory. This is where you will be making all the additions/modifications necessary for the first 3 specifications. 
- work inside the `networks/` directory for the Specification 4 as mentioned in the assignment.
- Instructions to test the xv6 implementations are given in the `initial_xv6/README.md` file. 

- You are free to delete these instructions and add your report before submitting. 

# How i implemented various scheduling methods
## 1. FCFS (First Come First Serve)
### Introduction:
FCFS ensures that the process which arrives first gets executed first.

### Implementation Details:


For every scheduling decision (context switch), iterate over the proc[] array.
Check the ctime (creation time) of each process. Select the process with the earliest ctime that's also in the RUNNABLE state.
Switch context to the selected process.
## 2. RR (Round Robin)
### Introduction:
Round Robin scheduling operates in a cyclic manner, granting each process a fixed time slice or quantum.

#### Implementation Details:


On every timer interrupt, decrement the currently running process's time slice.
If the time slice of a process reaches 0 or if the process finishes its execution before its time slice expires, perform a context switch.
Move to the next process in the proc[] array that is in the RUNNABLE state.
Reset the time slice for the newly scheduled process.
## 3. MLFQ (Multi-Level Feedback Queue)
### Introduction:
MLFQ dynamically adjusts the priority of a process based on its behavior and estimation of its CPU bursts.

### Implementation Details:
Data Structure Update:

An integer, termed priority, is added to the proc structure to represent the priority level or the queue number of the process.
 wtime variable is maintained to track the waiting time of the process.


### Initialization: When a process is created, assign it a default priority (typically the highest priority).
### Scheduling Decision:
Loop through priority levels starting from the highest. For the first priority level with processes in the RUNNABLE state, pick the one with the earliest ctime or the lowest index in the proc[] array.
If no process is found, proceed to the next priority level.
### Time Management:
After each clock tick, increment wtime for processes that didn't get the CPU.
Decide on promoting/demoting processes between priority levels based on wtime or other criteria. For instance, if a process has been waiting too long, increase its priority.
### Feedback Mechanism:
If a process consumes its entire time slice without yielding (like for I/O operations), decrease its priority.
Conversely, if a process yields the CPU before its time slice is exhausted (because it blocks), increase its priority.
### Integration:

Incorporate the logic into trap.c to manage timer interrupts and waiting time updates, and proc.c to manage process states and priority adjustments.

## TIME COMPARISION IN FCFS and MLFQ
### FCFS
Avg run time-16 tics
Avg wait time-132 tics
### MLFQ
Avg run time-16 tics
Avg wait time-163 tics
### RR
Avg run time-16 tics
Avg wait time-164 tics
Generally MLFQ is better but since here are very less processes here FCFS seems better although it depends on when the processes arrived. If we take a sample consisting of hundreds of processes then the MLFQ should perform better. The time slice for priority boost also plays an important role in performance of the MLFQ. Generally, that is very difficult to obtain and hence is referred as voo-doo constant



# Modified Priority-Based Scheduler in xv-6

## Effectiveness of Static Priority (SP):

### Observation:

The Static Priority (SP) represents the inherent priority of a process, ranging from 0 to 100. A lower SP indicates a higher scheduling priority, with a default value of 50 for each process.

### Analysis:

Decreasing the SP of a process increases its priority, facilitating faster scheduling. Conversely, increasing the SP lowers the priority, potentially delaying the process's execution.

### Outcome:

The SP parameter can be manipulated using the `set_priority` system call to expedite or delay the scheduling of a process.

## Effectiveness of Recent Behavior Index (RBI):

### Observation:

The Recent Behavior Index (RBI) is a weighted sum of Running Time (RTime), Sleeping Time (STime), and Waiting Time (WTime), with a default value of 25 for each process. RTime and STime indicate when the process was last scheduled, not their usual meanings.

### Analysis:

1. **Running Time (RTime):**
   The total time the process has been running since its last scheduling. A higher RTime might increase the RBI, suggesting a potential increase in dynamic priority, thus reducing the chances of immediate rescheduling.

2. **Sleeping Time (STime):**
   The total time the process has spent sleeping, i.e., blocked and not using CPU time, since its last scheduling. A higher STime decreases the RBI, potentially lowering dynamic priority and increasing the chances of immediate rescheduling.

3. **Waiting Time (WTime):**
   The total time the process has spent in the ready queue waiting to be scheduled. A process waiting for an extended period may have a lower RBI, decreasing the dynamic Priority and potentially increasing the chances of being scheduled.

### Dynamic Priority (DP):

#### Observation:

Dynamic Priority (DP) is the minimum of the sum of SP and RBI and 100, determining the order of process execution.

#### Analysis:

Processes with lower DP values are scheduled first, and SP and RBI interact to dynamically adjust the priority. Frequent adjustments ensure responsiveness to changing behavior using the `set_priority` syscall.

# Cafe Sim:

## Implementation:

1. Required structs, variables, and locks were created.

2. Using two semaphores: `semBuyer` initialized to 1 and doing a `sempost` when a customer arrives, and another `semMaker` initialized by the number of makers.

3. Customer Thread function `void *Buyer(void *args)` sleeps for arrival time, prints arrival statement, then waits for the barista. It then waits for the remaining tolerance time and checks if the order is ready.

4. `void *CoffeeMaker(void *args)` for the barista thread function obtains a customer struct as an argument. It waits for the arrival of that customer, starts making the order, sleeps for preparation time, then prints that it is made. It updates necessary shared variables.

5. In the main function, input is taken, semaphores are initialized, and threads for all customers and baristas are created.

## Questions:

Both questions are implemented in the code:

1. A global variable `TotalWaitTime` is created and updated in each customer thread. It is increased by the time the customer arrived, and then the barista took the order.

2. A variable `NoOfCoffeeWasted` is also a global variable, and the customer function, when a customer leaves without taking coffee, is increased by 1 based on whether the barista has received the order or not.

# ICE CREAM PARLOR:

## Implementation:

1. Made two structs: one for the machine and one for the customer, containing all information and numerous flags to make this run.

2. In the main function, first, take input as the number of customers is not told and also the number of toppings. Take input via `fgets` line by line, then tokenize that and store corresponding values in the struct.

3. Make a function `CheckCustomer` that prints when a customer arrives and when it leaves after all orders are made.

4. Made a function `CheckMachine` that makes the parlor close when all machines stop. It handles when a machine arrives and when it goes off.

5. There is a function `MachineFn` where every thread (every order/ice cream has a thread) runs. It prints start making, then sleeps for the required time to make, then prints it is made.

6. There is a function `HandleTheCust` from where I will call this `MachineFn` via threads. Firstly, I am checking here whether it can be made or not (sufficient material or not). If yes, then send this order to `MachineFn`. Else, not.

## Questions:

1. _Minimizing Incomplete Orders:_
   To minimize incomplete orders, the approach involves checking ingredient availability for all orders of the customer. If ingredients are available, a complete order can be fulfilled in the future, and only then the order is accepted.

2. _Ingredient Replenishment:_
   Since ingredients can be replenished by the nearest supplier at any time, the focus is on ensuring machine availability for order preparation. If some ingredients are unavailable, then make a flag of that corresponding ingredient to 1 so it can be replenished, and don't reject the order, and do the rest of the stuff normally.

3. _Unserviced Orders:_
  We can give priority to orders based on their total time. If all orders come at the same time, the lesser the time, the more the priority. Then schedule the order in this way and also.


## resources
### Cafe sim
```
https://chat.openai.com/c/ff32f693-dcef-4dd8-9bdf-af20903f5154
https://chat.openai.com/share/ba0ab396-ba29-4f0d-9bec-e6c74cb39990
https://chat.openai.com/share/0b282946-dc30-421d-af59-960fb0ad14ad
https://chat.openai.com/share/03546ef8-9eb2-4849-b82d-5514c59dc56d
```


### cow
```
https://github.com/Mitanshk01/xv6_OperatingSystem   
https://www.youtube.com/watch?v=T098peEfDNc
https://xiayingp.gitbook.io/build_a_os/labs/lab-5-copy-on-write-fork-for-xv6
https://pdos.csail.mit.edu/6.S081/2020/labs/cow.html
https://www.youtube.com/watch?v=T098peEfDNc
```


### Ice cream paurlour
https://chat.openai.com/share/f16de7d6-187d-4212-88e2-2f76ca061748


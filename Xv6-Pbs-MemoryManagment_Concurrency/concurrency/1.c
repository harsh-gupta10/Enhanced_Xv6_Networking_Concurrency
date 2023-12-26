#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <semaphore.h>
#include <unistd.h>
#include <string.h>
#include <sys/time.h>
#include <time.h>
//! timer array ko int karna
// ! ye maker fn to keval b baar hi rn ho rha h
#define MAX_COFFEE_TYPE 20
#define MAX_CUST_POSSIBLE 1000

pthread_mutex_t MutexLock;

sem_t semMaker;
sem_t semBuyer;
int b, k, n;
char coffeeType[MAX_COFFEE_TYPE][100];
int preprationTime[MAX_COFFEE_TYPE];
int CustServed = 0;
// struct timeval start_time;
// struct timeval TimeArr[MAX_CUST_POSSIBLE];
int TimeArr[MAX_CUST_POSSIBLE];
int ConditionVAr[MAX_CUST_POSSIBLE];
time_t start_time=0;
int ExtraTime;

int NoOfCoffeWasted=0;
int NoOfCustTreated=0;
float TotalWaitTime=0;
typedef struct custumer
{
    int id;
    char coffeType[30];
    int arivalTime;
    int tollrence_Time;
} custumer;
custumer custArr[MAX_CUST_POSSIBLE];

int tellPrepTime(char *C_Type)
{
    int i;
    for (i = 0; i < MAX_COFFEE_TYPE; i++)
    {
        if (strcmp(C_Type, coffeeType[i]) == 0)
        {
            break;
        }
    }
    return preprationTime[i];
}

void PrintCUSTINFo()
{
    for (int i = 0; i < n; i++)
    {
        printf("Custumer ID %d\n CoffeType %s\n ArivalTime %d\n TillerenceTime %d\n", custArr[i].id, custArr[i].coffeType, custArr[i].arivalTime, custArr[i].tollrence_Time);
    }
}

void *CoffeeMaker(void *args)
{
    while (CustServed != n)
    {
        int *BaristaID = (int *)args;
        sem_wait(&semBuyer);
        sleep(1); //!!!
        // struct timeval Order_begin_time;
        // gettimeofday(&Order_begin_time, NULL);
        time_t OrderBegian;
        time(&OrderBegian);
        pthread_mutex_lock(&MutexLock);
        if (ConditionVAr[CustServed] == -1)
        {
            printf("\x1b[36mBarista %d begins preparing the order of customer %d at %f second\n", *BaristaID, custArr[CustServed].id,difftime(OrderBegian,start_time)-ExtraTime);
            // printf("Barista %d is sleeping for %d time as making %s\n",*BaristaID,tellPrepTime(custArr[CustServed].coffeType),custArr[CustServed].coffeType);
            sleep(tellPrepTime(custArr[CustServed].coffeType));
            printf("\x1b[34mBarista %d successfully completes the order of customer %d\n", *BaristaID, custArr[CustServed].id);
        }
        else
        {
            // printf("Costumer%d exited order banna bhi shguru nhi hua\n",custArr[CustServed].id);
        }

        // struct timeval Order_finish_time;
        // gettimeofday(&Order_finish_time, NULL);
        time_t orderFimishTime;
        time(&orderFimishTime);
        TimeArr[custArr[CustServed].id] = (int)difftime(orderFimishTime,start_time);
        CustServed++;
        pthread_mutex_unlock(&MutexLock);
        sem_post(&semMaker);
    }
}

void *Buyer(void *args)
{
    custumer *c = (custumer *)args;
    // struct timeval CustThreadStartTime;
    // gettimeofday(&CustThreadStartTime,NULL);
    // printf("Coustumer %d Thread came at  %ld seconds\n ",c->id,CustThreadStartTime.tv_sec-start_time.tv_sec);
    sleep(c->arivalTime);
    // struct timeval CustArrivalTime;
    // gettimeofday(&CustArrivalTime, NULL);

    // pthread_mutex_lock(&MutexLock);
    // printf("Customer %d arrives at %d second\n", c->id, c->arivalTime);
    time_t arrivaltime;
    time(&arrivaltime);
    if (c->id==1)
    {
        ExtraTime=difftime(arrivaltime,start_time);
    }
    printf("\x1b[37mCustomer %d arrives at %f second\n", c->id, difftime(arrivaltime,start_time)-ExtraTime);
    printf("\x1b[33mCustomer %d orders an %s\n", c->id, c->coffeType);
    // pthread_mutex_unlock(&MutexLock);
    sem_wait(&semMaker);
    sem_post(&semBuyer);
    // struct timeval Time_at_which_order_start;
    // gettimeofday(&Time_at_which_order_start, NULL);
    // printf("Time at which Order start %ld of Custumer %d\n",Time_at_which_order_start.tv_sec-start_time.tv_sec,c->id);
    time_t orderStart;
    time(&orderStart);
    int t = c->tollrence_Time - difftime(orderStart,arrivaltime);
    int save_t = t;
    // printf("Save_t=%d for Custumer %d \n",save_t,c->id);
    pthread_mutex_lock(&MutexLock);
    TotalWaitTime=TotalWaitTime+difftime(orderStart,arrivaltime);
    // printf("TimeArr[%d] %d\n",c->id,TimeArr[c->id]);
    if (save_t < 0)
    {
        // printf("Custumer %d sending signal TO leave DONT make coffee\n ",c->id);
        ConditionVAr[c->id] = 1;
    }
    pthread_mutex_unlock(&MutexLock);
    while (t-- && t > 0)
    {
        if (TimeArr[c->id] != -1)
        {
            // printf("Breakin it as someone filled Timer Arr of Custumer %d\n",c->id);
            break;
        }
        // printf("costumer %d Tolrating %d sec and has Tolrating limit %d\n",c->id,save_t-t,c->tollrence_Time);
        sleep(1);
    }
    // struct timeval AfterTolrenceTime;
    // gettimeofday(&AfterTolrenceTime, NULL);
    time_t afterTolrence;
    time(&afterTolrence);
    pthread_mutex_lock(&MutexLock);
    if (TimeArr[c->id] != -1 && save_t > 0)
    {
        printf("\x1b[32mCustomer %d leaves with their order at %f second\n", c->id, difftime(afterTolrence,start_time)-ExtraTime);
    }
    else
    {
        printf("\x1b[31mCustomer %d leaves without their order at %f second\n", c->id, difftime(afterTolrence,start_time)-ExtraTime);
        NoOfCoffeWasted++;
    }
    NoOfCustTreated++;
    if (NoOfCustTreated==n)
    {
        printf("%d coffee wasted\n",NoOfCoffeWasted);
        exit(0);
    }
    
    pthread_mutex_unlock(&MutexLock);
}

int main(int argc, char const *argv[])
{
    // struct timeval start_time;
    // gettimeofday(&start_time, NULL);
    // printf("Start Time %ld\n",start_time.tv_sec);
    time(&start_time);
    for (int i = 0; i < MAX_CUST_POSSIBLE; i++)
    {
        TimeArr[i] = -1;
        ConditionVAr[i] = -1;
    }
    scanf("%d", &b);
    scanf("%d", &k);
    scanf("%d", &n);
    pthread_t tb[b];
    pthread_t tc[n];
    for (int i = 0; i < k; i++)
    {
        scanf("%s", coffeeType[i]);
        scanf("%d", &preprationTime[i]);
    }

    for (int i = 0; i < n; i++)
    {
        scanf("%d", &custArr[i].id);
        scanf("%s", custArr[i].coffeType);
        scanf("%d", &custArr[i].arivalTime);
        scanf("%d", &custArr[i].tollrence_Time);
    }
    pthread_mutex_init(&MutexLock, NULL);
    sem_init(&semMaker, 0, b);
    sem_init(&semBuyer, 0, 0);

    // PrintCUSTINFo();
    for (int i = 0; i < b; i++)
    {
        int *a = malloc(sizeof(int));
        *a = i + 1;
        pthread_create(&tb[i], NULL, &CoffeeMaker, a);
    }
    for (int i = 0; i < n; i++)
    {
        custumer *a = malloc(sizeof(custumer));
        *a = custArr[i];
        pthread_create(&tc[i], NULL, &Buyer, a);
    }
    for (int i = 0; i < n; i++)
    {
        pthread_join(tc[i], NULL);
    }
    for (int i = 0; i < b; i++)
    {
        pthread_join(tb[i], NULL);
    }
    sem_destroy(&semBuyer);
    sem_destroy(&semMaker);
    pthread_mutex_destroy(&MutexLock);
    return 0;
}

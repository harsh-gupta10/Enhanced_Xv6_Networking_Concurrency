#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <semaphore.h>
#include <unistd.h>
#include <string.h>
//! reduce quantity
//!  print cust info in checkcustumer fn
#define MAX_MACHINEFn_POSSIBLE 100
#define MAX_FLAVOUR_POSSIBLE 100
#define MAX_TOPPINGS_POSSIBLE 100
#define MAX_CUSTUMER_POSSIBLE 1000
#define MAX_ICECREAM_CUSTUMER_CAN_ORDER 100

#define CYAN "\x1b[36m"
#define RED "\x1b[31m"
#define ORANGE "\x1b[33m"
#define BLUE "\x1b[34m"
#define WHITE "\x1b[37m"
#define GREEN "\x1b[32m"
#define YELLOW "\x1b[33;1m"
#define RESET "\x1b[0m"

typedef struct Custumer
{
    int id;
    int arrival_time;
    int no_icecream;
    char IceCreamFlavour[MAX_ICECREAM_CUSTUMER_CAN_ORDER][100];
    char Toppings[MAX_ICECREAM_CUSTUMER_CAN_ORDER][MAX_TOPPINGS_POSSIBLE][100];
    int no_toppings[MAX_ICECREAM_CUSTUMER_CAN_ORDER];
    int SareBanGya;
    int currentOrderCount;
    int IsHeLeft;
    int IsInfoPrinted;
    int IsLeftDueToShortage;
} Custumer;

typedef struct Machine
{
    int id;
    int tm_start;
    int tm_stop;
    int isAvalible;
    int IsCurrentlyOccupied; // semwait ki tarah act kar rha h
    int IsOn;                // 0 not started --> 1 band ho gyi  ---> 2 ---> band ka print bhi ho gya
} Machine;

typedef struct toSendToMAchineFn
{
    int IceCreamNo;
    int custNO; // 0 index
    int timeToSleep;
    // int ToppingToDecreaseQuantiy[MAX_TOPPINGS_POSSIBLE];// int array 0 based index
    // int NoOFToppingToDecrease;
} toSendToMAchineFn;

int N, K, F, T;
// int tm_start[MAX_MACHINEFn_POSSIBLE];
// int tm_stop[MAX_MACHINEFn_POSSIBLE];
Machine MachineArr[MAX_MACHINEFn_POSSIBLE];
int t_f[MAX_FLAVOUR_POSSIBLE];
int q_t[MAX_TOPPINGS_POSSIBLE];
char flavour[MAX_FLAVOUR_POSSIBLE][100];
char ToppingsArr[MAX_TOPPINGS_POSSIBLE][100];
int NoOfCustumer = 0;
Custumer CustArr[MAX_CUSTUMER_POSSIBLE];

pthread_mutex_t MutexL;
pthread_mutex_t parlor_lock;

sem_t semMachine;
// sem_t semBuyer;

int CurrTime = 0;
int CurrentNoOfCust = 0;
int NoOfMAchineWorking = 0;
int isPaurlourOpen = 1;
int NoOfMachineOver = 0;
int CurrentNoCustinPaurlor=0;
void printCustInfo(Custumer *c)
{
    printf(YELLOW "Customer %d orders %d icecreams\n", c->id, c->no_icecream);
    for (int i = 0; i < c->no_icecream; i++)
    {
        // printf("Icecream Flavour %s\n", c->IceCreamFlavour[i]);
        // printf("No Of toppings %d\n",c->no_toppings[i]);
        printf(YELLOW "Ice cream %d:%s ", i + 1, c->IceCreamFlavour[i]);
        for (int j = 0; j < c->no_toppings[i]; j++)
        {
            printf(YELLOW "%s ", c->Toppings[i][j]);
        }
        printf("\n");
    }
    printf("\n");
}
void *TimerFn(void *Args)
{
    while (isPaurlourOpen != 0)
    {
        sleep(1);
        CurrTime++;
    }
}

void *CheckCustumer(void *)
{
    // take custumer aary is argument
    // itrate over it till paurlour not closed
    // check ki kisi ka order ban gya to print kar do
    int i = 0;
    while (isPaurlourOpen != 0)
    {
        if (CustArr[i].arrival_time == CurrTime && CustArr[i].IsInfoPrinted == 0 && CurrentNoCustinPaurlor<K)
        {
            printf(WHITE "Customer %d enters at %d second(s)\n", i + 1, CurrTime);
            CurrentNoCustinPaurlor++;
            printCustInfo(&CustArr[i]);
            CustArr[i].IsInfoPrinted = 1;
        }
        if (CustArr[i].currentOrderCount == CustArr[i].no_icecream)
        {
            CustArr[i].SareBanGya = 1;
        }
        if (CustArr[i].SareBanGya == 1 && CustArr[i].IsHeLeft == 0)
        {
            printf(GREEN "Customer %d has collected their order(s) and left at %d second(s)\n", i + 1, CurrTime);
            CustArr[i].IsHeLeft = 1;
            CurrentNoCustinPaurlor--;
        }

        i = (i + 1) % NoOfCustumer;
    }
}

void *CheckMachine()
{
    // machine ko band karni h kya stop time.then print also . mark it unavalible
    // exit tis fn when all machine has soped
    // aur jab avalible h to mark it abalible
    int i = 0;
    while (NoOfMachineOver != N)
    {
        if (MachineArr[i].tm_stop < CurrTime && MachineArr[i].IsOn == 1)
        {
            printf(ORANGE "Machine %d has stopped working at %d second(s)\n", i + 1, CurrTime);
            MachineArr[i].isAvalible = 0;
            NoOfMAchineWorking--;
            NoOfMachineOver++;
            MachineArr[i].IsOn = 2;
        }
        else if ((MachineArr[i].tm_start <= CurrTime) && (CurrTime <= MachineArr[i].tm_stop) && MachineArr[i].IsOn == 0)
        {
            MachineArr[i].isAvalible = 1;
            printf(ORANGE "Machine %d has started working at %d second(s)\n", i + 1, CurrTime);
            NoOfMAchineWorking++;
            MachineArr[i].IsOn = 1;
        }
        i = (i + 1) % N;
    }
    isPaurlourOpen = 0;
}

void *MachineFn(void *Args)
{
    // itrate on all machine and jaise hhi mile to brak it and take machine no
    // agar machine kisi ne li nhi (via semaphore) and uska start time > curr time then and it is avalible .
    // arg me rak order le lo
    // time nikal machine ke sleep ka
    // print kar do ki ban rhi h
    // fir sleep
    // agar machine abhi bhi avalible h to bana diya
    // orderCount bhada diya
    // agar sare ban gye to Sarebangya ko 1 kar do
    // int icecreamNo = 0;
    // int custNo = 0;
    // int timeToSleep = 0;
    toSendToMAchineFn *GotMA = (toSendToMAchineFn *)Args;
    int i = 0;
    sem_wait(&semMachine);
    while (1)
    {
        if ((MachineArr[i].IsCurrentlyOccupied == 0) && (MachineArr[i].isAvalible == 1))
        {
            MachineArr[i].IsCurrentlyOccupied = 1;
            break;
        }
        i = (i + 1) % N;
    }

    printf(CYAN "Machine %d starts preparing ice cream %d of customer %d at %d seconds(s)\n", i + 1, GotMA->IceCreamNo + 1, GotMA->custNO + 1, CurrTime);
    sleep(GotMA->timeToSleep);
    for (int i = 0; i < F; i++)
    {
        if (strcmp(flavour[i], CustArr[GotMA->custNO].IceCreamFlavour[GotMA->custNO]) == 0)
        {
            t_f[i]--;
        }
    }
    if (MachineArr[i].isAvalible == 1)
    {
        printf(BLUE "Machine %d completes preparing ice cream %d of customer %d at %d seconds(s)\n", i + 1, GotMA->IceCreamNo + 1, GotMA->custNO + 1, CurrTime);
        CustArr[GotMA->custNO].currentOrderCount++;
        sem_post(&semMachine);
    }
}

void *CustFn(void *Args)
{
    Custumer *c = (Custumer *)Args;
    sleep(c->arrival_time);
    pthread_mutex_lock(&parlor_lock);
    if (CurrentNoOfCust < K)
    {
        CurrentNoOfCust++;
        printf("Custumer %d come in paurler\n", c->id);
        pthread_mutex_unlock(&parlor_lock);
    }
    else
    {
        printf("Custumer %d leaving :NO SPACE\n", c->id);
        pthread_mutex_unlock(&parlor_lock);
        return NULL;
    }
}

void HandleTheCust()
{
    pthread_t ThreadOrder[NoOfCustumer * MAX_ICECREAM_CUSTUMER_CAN_ORDER];
    int threadOrderIndex = 0;
    pthread_t CustCheckThread;
    pthread_t machineCheckThread;
    int PrevIndex = 0;
    // chalu karo
    // itrate on all cust
    // check ki order complete ho sakta h ki nhi
    // NO OF CUSTUMER
    for (int i = 0; i < NoOfCustumer;)
    {
        int Flag1 = 1;
        if (CustArr[i].arrival_time != CurrTime)
        {
            continue;
        }
        // NO OF ICECREAM
        for (int j = 0; j < CustArr[i].no_icecream; j++)
        {
            // NO OF TOPPINGS
            for (int r = 0; r < CustArr[i].no_toppings[j]; r++)
            {

                for (int s = 0; s < T; s++)
                {
                    if (strcmp(ToppingsArr[s], CustArr[i].Toppings[j][r]) == 0)
                    {
                        /* code */
                        if (q_t[s] == -1)
                        {
                            continue;
                        }
                        else
                        {
                            if (q_t[s] <= 0)
                            {
                                Flag1 = 0;
                                break;
                            }
                        }
                    }
                }
            }
        }
        if (Flag1 == 0  && CustArr[i].IsInfoPrinted==1)
        {
            printf(RED "Customer %d left at %d second(s) with an unfulfilled order\n", i + 1, CurrTime);
            CustArr[i].IsLeftDueToShortage = 1;
            continue;
        }
        for (int j = 0; j < CustArr[i].no_icecream; j++)
        {
            // ! !! abhi arg bhejna h
            toSendToMAchineFn *ma = malloc(sizeof(toSendToMAchineFn));
            ma->custNO = i;
            ma->IceCreamNo = j;
            for (int r = 0; r < F; r++)
            {
                if (strcmp(flavour[r], CustArr[i].IceCreamFlavour[i]) == 0)
                {
                    ma->timeToSleep = t_f[r];
                }
            }
            if ((i + 1) != PrevIndex)
            {
                sleep(1);
            }
            PrevIndex = i + 1;

            pthread_create(&ThreadOrder[i], NULL, &MachineFn, ma);
            threadOrderIndex++;
        }
        i++;
    }
}

int main(int argc, char const *argv[])
{
    scanf("%d", &N);
    scanf("%d", &K);
    scanf("%d", &F);
    scanf("%d", &T);
    for (int i = 0; i < N; i++)
    {
        scanf("%d", &MachineArr[i].tm_start);
        scanf("%d", &MachineArr[i].tm_stop);
        MachineArr[i].id = 0;
        MachineArr[i].isAvalible = 0;
        MachineArr[i].IsCurrentlyOccupied = 0;
        MachineArr[i].IsOn = 0;
    }
    for (int i = 0; i < F; i++)
    {
        scanf("%s", flavour[i]);
        scanf("%d", &t_f[i]);
    }
    for (int i = 0; i < T; i++)
    {
        scanf("%s", ToppingsArr[i]);
        scanf("%d", &q_t[i]);
    }
    char input[4096];
    fgets(input, 4096, stdin);

    // !input galat h abhi
    for (int i = 0; i < MAX_CUSTUMER_POSSIBLE; i++)
    {
        // scanf("%d", &CustArr[i].id);
        char input[4096];
        fgets(input, 4096, stdin);

        if (strcmp(input, "\n") == 0)
        {
            break;
        }
        NoOfCustumer++;
        char *token;
        token = strtok(input, " ");
        CustArr[i].id = atoi(token);
        token = strtok(NULL, " ");
        CustArr[i].arrival_time = atoi(token);
        token = strtok(NULL, " ");
        CustArr[i].no_icecream = atoi(token);

        // scanf("%d", &CustArr[i].arrival_time);
        // scanf("%d", &CustArr[i].no_icecream);
        for (int j = 0; j < CustArr[i].no_icecream; j++)
        {
            char input2[4096];
            fgets(input2, 4096, stdin);
            char *token2;
            token2 = strtok(input2, " ");
            strcpy(CustArr[i].IceCreamFlavour[j], token2);

            // scanf("%s", CustArr[i].IceCreamFlavour);
            CustArr[i].no_toppings[j] = 0;
            for (int k = 0; k < MAX_TOPPINGS_POSSIBLE; k++)
            {
                token2 = strtok(NULL, " ");
                CustArr[i].no_toppings[j]++;
                if (token2[strlen(token2) - 1] == '\n')
                {
                    // isme se \n hatana h
                    char NewToken[100];
                    for (int i = 0; i < strlen(token2) - 1; i++)
                    {
                        NewToken[i] = token2[i];
                    }
                    NewToken[strlen(NewToken)] = '\0';
                    strcpy(CustArr[i].Toppings[j][k], NewToken);
                    break;
                }
                else
                {
                    // token = strtok(input, " ");
                    strcpy(CustArr[i].Toppings[j][k], token2);
                }
            }
        }
    }

    for (int i = 0; i < NoOfCustumer; i++)
    {
        CustArr[i].SareBanGya = 0;
        CustArr[i].currentOrderCount = 0;
        CustArr[i].IsHeLeft = 0;
        CustArr[i].IsInfoPrinted = 0;
        CustArr[i].IsLeftDueToShortage = 0;
    }
    pthread_t timeThread;
    pthread_t tc;
    pthread_t tm;

    // pthread_mutex_init(&MutexL, NULL);
    // pthread_mutex_init(&parlor_lock, NULL);
    sem_init(&semMachine, 0, N);
    // sem_init(&semBuyer, 0, 0);
    pthread_create(&timeThread, NULL, &TimerFn, NULL);
    pthread_create(&tm, NULL, &CheckMachine, NULL);
    pthread_create(&tc, NULL, &CheckCustumer, NULL);
    // for (int i = 0; i < N; i++)
    // {
    //     int *a = malloc(sizeof(int));
    //     *a = i;
    // }
    // for (int i = 0; i < NoOfCustumer; i++)
    // {
    //     Custumer *a = malloc(sizeof(Custumer));
    //     *a = CustArr[i];
    // }
    HandleTheCust();
    pthread_join(tm, NULL);
    pthread_join(tc, NULL);
    // for (int i = 0; i < N; i++)
    // {
    // }
    // for (int i = 0; i < NoOfCustumer; i++)
    // {
    // }
    pthread_join(timeThread, NULL);
    for (int i = 0; i < NoOfCustumer; i++)
    {
        if (CustArr[i].SareBanGya == 0 && CustArr[i].IsLeftDueToShortage == 0 && CustArr[i].IsInfoPrinted==1)
        {
            printf(RED "Customer %d was not serviced due to unavailability of machines\n", i + 1);
        }
    }

    printf(WHITE "Parlour Closed\n");
    // sem_destroy(&semBuyer);
    sem_destroy(&semMachine);
    // pthread_mutex_destroy(&MutexL);
    // pthread_mutex_destroy(&parlor_lock);
    return 0;
}

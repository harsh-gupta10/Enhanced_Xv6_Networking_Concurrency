#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>

int judge(int choiceA, int choiceB)
{
    // printf("In This fn \n");
    if (choiceA == 0 && choiceB == 1)
    {
        // printf("1\n");
        return 2;
    }
    if (choiceA == 0 && choiceB == 2)
    {
        // printf("2\n");
        return 1;
    }
    if (choiceA == 1 && choiceB == 0)
    {
        // printf("3\n");
        return 1;
    }
    // printf("hhhh\n");
    if (choiceA == 1 && choiceB == 2)
    {
        // printf("4\n");
        return 2;
    }
    // printf("ghhuss\n");
    if (choiceA == 2 && choiceB == 1)
    {
        // printf("5\n");
        return 1;
    }
    if (choiceA == 2 && choiceB == 0)
    {
        // printf("6\n");
        return 2;
    }
    if (choiceA==choiceB)
    {
        return 3;
        // Draw
    }
    
}
int main()
{

    char *ip = "127.0.0.1";
    int port = 5050;

    int server_sock, client_sock, clientA, clientB;
    struct sockaddr_in server_addr, client_addr;
    socklen_t addr_size;
    char buffer[1024];
    char choiceA_buf[1024], choiceB_buf[1024], continiue_A[100], continiue_B[100], result_continue[100], result_B[100];
    int n;
    server_sock = socket(AF_INET, SOCK_STREAM, 0);
    if (server_sock < 0)
    {
        perror("[-]Socket error");
        exit(1);
    }
    printf("[+]TCP server socket created.\n");

    memset(&server_addr, '\0', sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = port;
    server_addr.sin_addr.s_addr = inet_addr(ip);

    n = bind(server_sock, (struct sockaddr *)&server_addr, sizeof(server_addr));
    if (n < 0)
    {
        perror("[-]Bind error");
        exit(1);
    }
    printf("[+]Bind to the port number: %d\n", port);

    listen(server_sock, 5);
    printf("Listening...\n");

    // while (1)
    // {
        addr_size = sizeof(client_addr);
        clientA = accept(server_sock, (struct sockaddr *)&client_addr, &addr_size);
        clientB = accept(server_sock, (struct sockaddr *)&client_addr, &addr_size);
        printf("[+]Clients connected.\n");

        while (1)
        {
            // Read choices from clients and judge
            read(clientA, choiceA_buf, sizeof(choiceA_buf));
            printf("one client replied \n");
            read(clientB, choiceB_buf, sizeof(choiceB_buf));
            printf("both client replied \n");

            int result = judge(atoi(choiceA_buf), atoi(choiceB_buf));
            char Ans[200] = "Player Won is:- ";
            Ans[strlen(Ans)] = '0' + result;
            Ans[strlen(Ans)] = '\0';
            // Send result to both clients
            write(clientA, &Ans, sizeof(Ans));
            write(clientB, &Ans, sizeof(Ans));
            read(clientA, continiue_A, sizeof(continiue_A));
            printf("one client replied \n");
            read(clientB, continiue_B, sizeof(continiue_B));
            printf("both client replied \n");
            printf("%s      %s",continiue_A,continiue_B);
            if ((strcmp(continiue_A, continiue_B) == 0) && strcmp(continiue_A, "yes\n")==0)
            {
                strcpy(result_continue, "yes\n");
                write(clientA, &result_continue, sizeof(result_continue));
                write(clientB, &result_continue, sizeof(result_continue));

                continue;
            }
            else
            {
                strcpy(result_continue, "no\n");
                write(clientA, &result_continue, sizeof(result_continue));
                write(clientB, &result_continue, sizeof(result_continue));
                break;
            }
        }

        close(clientA);
        close(clientB);
        printf("[+]Clients disconnected.\n\n");
    // }

    return 0;
}
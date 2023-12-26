
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>
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

int main(int argc, char **argv)
{

    if (argc != 2)
    {
        printf("Usage: %s <port>\n", argv[0]);
        exit(0);
    }

    char *ip = "127.0.0.1";
    int port = atoi(argv[1]);

    int sockfd;
    struct sockaddr_in server_addr, client_addr, clientA_addr, clientB_addr;
    // char buffer[1024];
    char choiceA_buf[1024], choiceB_buf[1024], continiue_A[100], continiue_B[100], result_continue[100], result_B[100];
    socklen_t addr_len = sizeof(clientA_addr);
    socklen_t addr_size;
    int n;

    sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sockfd < 0)
    {
        perror("[-]socket error");
        exit(1);
    }

    memset(&server_addr, '\0', sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(port);
    server_addr.sin_addr.s_addr = inet_addr(ip);

    n = bind(sockfd, (struct sockaddr *)&server_addr, sizeof(server_addr));
    if (n < 0)
    {
        perror("[-]bind error");
        exit(1);
    }

    while (1)
    {
        // Receive from clients
        recvfrom(sockfd, choiceA_buf, sizeof(choiceA_buf), 0, (struct sockaddr *)&clientA_addr, &addr_len);
        recvfrom(sockfd, choiceB_buf, sizeof(choiceB_buf), 0, (struct sockaddr *)&clientB_addr, &addr_len);

        int result = judge(atoi(choiceA_buf), atoi(choiceB_buf));

        char Ans[200] = "Player Won is:- ";
        Ans[strlen(Ans)] = '0' + result;
        Ans[strlen(Ans)] = '\0';
        // printf("**%s**\n",Ans);
        // Send result to both clients
        sendto(sockfd, &Ans, sizeof(Ans), 0, (struct sockaddr *)&clientA_addr, addr_len);
        sendto(sockfd, &Ans, sizeof(Ans), 0, (struct sockaddr *)&clientB_addr, addr_len);

        // read(clientA_addr, continiue_A, sizeof(continiue_A));
        recvfrom(sockfd, continiue_A, sizeof(continiue_A), 0, (struct sockaddr *)&clientA_addr, &addr_len);
        printf("one client replied \n");
        // read(clientB_addr, continiue_B, sizeof(continiue_B));
        recvfrom(sockfd, continiue_B, sizeof(continiue_B), 0, (struct sockaddr *)&clientB_addr, &addr_len);
        printf("both client replied \n");
        printf("%s      %s", continiue_A, continiue_B);
        if ((strcmp(continiue_A, continiue_B) == 0) && strcmp(continiue_A, "yes\n") == 0)
        {
            strcpy(result_continue, "yes\n");
            // write(clientA_addr, &result_continue, sizeof(result_continue));
            sendto(sockfd, &result_continue, sizeof(result_continue), 0, (struct sockaddr *)&clientA_addr, addr_len);
            // write(clientB_addr, &result_continue, sizeof(result_continue));
            sendto(sockfd, &result_continue, sizeof(result_continue), 0, (struct sockaddr *)&clientB_addr, addr_len);

            continue;
        }
        else
        {
            strcpy(result_continue, "no\n");
            // write(clientA_addr, &result_continue, sizeof(result_continue));
            // write(clientB_addr, &result_continue, sizeof(result_continue));
            sendto(sockfd, &result_continue, sizeof(result_continue), 0, (struct sockaddr *)&clientA_addr, addr_len);
            sendto(sockfd, &result_continue, sizeof(result_continue), 0, (struct sockaddr *)&clientB_addr, addr_len);

            break;
        }
    }

    return 0;
}
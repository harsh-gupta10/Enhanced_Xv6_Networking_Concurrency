#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>

int main(int argc, char **argv)
{
    if (argc != 2)
    {
        printf("Usage: %s <port>\n", argv[0]);
        exit(0);
    }

    char *ip = "127.0.0.1";
    int port = atoi(argv[1]);
    if (port == 0)
    {
        fprintf(stderr, "Invalid port number.\n");
        exit(1);
    }

    int sockfd;
    struct sockaddr_in server_addr, client_addr, clientA_addr, clientB_addr;
    char choiceA_buf[1024], choiceB_buf[1024];
    socklen_t addr_len = sizeof(clientA_addr);

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
    if (server_addr.sin_addr.s_addr == INADDR_NONE)
    {
        perror("[-]Invalid IP address");
        close(sockfd);
        exit(1);
    }

    if (bind(sockfd, (struct sockaddr *)&server_addr, sizeof(server_addr)) < 0)
    {
        perror("[-]bind error");
        close(sockfd);
        exit(1);
    }

    ssize_t recvABytes = recvfrom(sockfd, choiceA_buf, sizeof(choiceA_buf), 0, (struct sockaddr *)&clientA_addr, &addr_len);
    if (recvABytes < 0)
    {
        perror("[-]recvfrom clientA error");
        // continue; // Move to the next iteration
    }
    printf("Message From Client is %s\n",choiceA_buf);
    char Ans[200] = "Hi this is server ";

    ssize_t sentABytes = sendto(sockfd, &Ans, sizeof(Ans), 0, (struct sockaddr *)&clientA_addr, addr_len);
    if (sentABytes < 0)
    {
        perror("[-]sendto clientA error");
    }

    return 0;
}

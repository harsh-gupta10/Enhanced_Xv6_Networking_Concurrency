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
    struct sockaddr_in addr;
    char choice_buf[1024], result_buf[1024];
    socklen_t addr_size;

    sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sockfd < 0)
    {
        perror("[-]Socket error");
        exit(1);
    }

    memset(&addr, '\0', sizeof(addr));
    addr.sin_family = AF_INET;
    addr.sin_port = htons(port);
    addr.sin_addr.s_addr = inet_addr(ip);
    if (addr.sin_addr.s_addr == INADDR_NONE)
    {
        perror("[-]Invalid IP address");
        close(sockfd);
        exit(1);
    }

    // printf("Enter choice (0 for Rock, 1 for Paper , 2 for Scissors): ");
    // if (fgets(choice_buf, sizeof(choice_buf), stdin) == NULL)
    // {
    //     perror("[-]Read from stdin error");
    //     close(sockfd);
    //     exit(1);
    // }

    strcpy(choice_buf,"Hi this is clint");


    ssize_t sentBytes = sendto(sockfd, choice_buf, sizeof(choice_buf), 0, (struct sockaddr *)&addr, sizeof(addr));
    if (sentBytes < 0)
    {
        perror("[-]sendto error");
        close(sockfd);
        exit(1);
    }

    ssize_t receivedBytes = recvfrom(sockfd, result_buf, sizeof(result_buf), 0, NULL, NULL);
    if (receivedBytes < 0)
    {
        perror("[-]recvfrom error");
        close(sockfd);
        exit(1);
    }

    printf(" Message From Server%s\n", result_buf);

    return 0;
}

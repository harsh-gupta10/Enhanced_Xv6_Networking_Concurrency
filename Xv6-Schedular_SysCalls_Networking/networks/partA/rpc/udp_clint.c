
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <arpa/inet.h>

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
    struct sockaddr_in addr;
    // char buffer[1024];
    char choice_buf[1024], result_buf[1024],continiue_play[100],result_2[100];
    socklen_t addr_size;

    sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    memset(&addr, '\0', sizeof(addr));
    addr.sin_family = AF_INET;
    addr.sin_port = htons(port);
    addr.sin_addr.s_addr = inet_addr(ip);

    while (1)
    {
        printf("Enter choice (0 for Rock, 1 for Paper , 2 for Seciors): ");
        fgets(choice_buf, sizeof(choice_buf), stdin);
        sendto(sockfd, choice_buf, sizeof(choice_buf), 0, (struct sockaddr *)&addr, sizeof(addr));
        recvfrom(sockfd, result_buf, sizeof(result_buf), 0, NULL, NULL);
        // printf("Result: Player No:-%s won\n", result_buf);
        // printf("%s\n",result_buf);
        // printf("hhhhhsssss  %s",result_buf);
        if (strcmp("Player Won is:- 3", result_buf) == 0)
        {
            printf("Match Draw\n");
        }
        else
        {
            printf("%s\n", result_buf);
        }

        printf("Want to play another game ? Press  yes or no\n");
        fgets(continiue_play, sizeof(continiue_play), stdin);
        // write(sockfd, continiue_play, sizeof(continiue_play));
        sendto(sockfd, continiue_play, sizeof(continiue_play), 0, (struct sockaddr *)&addr, sizeof(addr));

        // read(sockfd, result_2, sizeof(result_2));
        recvfrom(sockfd, result_2, sizeof(result_2), 0, NULL, NULL);
        printf("%s\n",result_2);
        if (strcmp("no\n",result_2)==0)
        {
            break;
        }
        else
        {
            continue;
        }
    }
    return 0;
}
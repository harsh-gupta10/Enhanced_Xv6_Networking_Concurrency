#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>

int main()
{

    char *ip = "127.0.0.1";
    int port = 5050;

    int sock;
    struct sockaddr_in addr;
    socklen_t addr_size;
    char buffer[1024];
    char choice_buf[1024], result_buf[1024], continiue_play[100], result_2[100];
    int n;

    sock = socket(AF_INET, SOCK_STREAM, 0);
    if (sock < 0)
    {
        perror("[-]Socket error");
        exit(1);
    }
    printf("[+]TCP server socket created.\n");

    memset(&addr, '\0', sizeof(addr));
    addr.sin_family = AF_INET;
    addr.sin_port = port;
    addr.sin_addr.s_addr = inet_addr(ip);

    connect(sock, (struct sockaddr *)&addr, sizeof(addr));
    printf("Connected to the server.\n");

    while (1)
    {
        printf("Enter choice (0 for Rock, 1 for Paper , 2 for Seciors):");
        fgets(choice_buf, sizeof(choice_buf), stdin);
        write(sock, choice_buf, sizeof(choice_buf));

        read(sock, result_buf, sizeof(result_buf));
        // printf("hhhhhsssss  %s",result_buf);
        // if (strcmp("3", result_buf) == 0)
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
        write(sock, continiue_play, sizeof(continiue_play));

        read(sock, result_2, sizeof(result_2));
        printf("%s\n", result_2);
        if (strcmp("no\n", result_2) == 0)
        {
            break;
        }
        else
        {
            continue;
        }

        // printf("%s\n", result_buf);
    }

    close(sock);
    printf("Disconnected from the server.\n");

    return 0;
}
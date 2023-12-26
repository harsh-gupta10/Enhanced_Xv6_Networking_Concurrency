#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>

int main()
{
    char *ip = "127.0.0.1";
    int port = 4455;

    int sock;
    struct sockaddr_in addr;
    socklen_t addr_size;
    char buffer[1024];
    char choice_buf[1024], result_buf[1024];
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

    if (addr.sin_addr.s_addr == INADDR_NONE)
    {
        perror("[-]Invalid IP address");
        close(sock);
        exit(1);
    }

    if (connect(sock, (struct sockaddr *)&addr, sizeof(addr)) < 0)
    {
        perror("[-]Connection error");
        close(sock);
        exit(1);
    }

    printf("Connected to the server.\n");
    // printf("Enter choice (0 for Rock, 1 for Paper , 2 for Scissors):");

    // if (fgets(choice_buf, sizeof(choice_buf), stdin) == NULL)
    // {
    //     perror("[-]Read from stdin error");
    //     close(sock);
    //     exit(1);
    // }
    strcpy(choice_buf,"Hi this is clint");

    if (write(sock, choice_buf, sizeof(choice_buf)) < 0)
    {
        perror("[-]Write error");
        close(sock);
        exit(1);
    }

    if (read(sock, result_buf, sizeof(result_buf)) < 0)
    {
        perror("[-]Read error");
        close(sock);
        exit(1);
    }

    printf("Message from Server is %s\n", result_buf);

    if (close(sock) < 0)
    {
        perror("[-]Close socket error");
        exit(1);
    }

    printf("Disconnected from the server.\n");

    return 0;
}

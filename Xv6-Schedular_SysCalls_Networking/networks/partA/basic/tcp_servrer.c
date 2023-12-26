#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>

int main()
{
    char *ip = "127.0.0.1";
    int port = 4455;

    int server_sock, client_sock, clientA, clientB;
    struct sockaddr_in server_addr, client_addr;
    socklen_t addr_size;
    char buffer[1024];
    char choiceA_buf[1024], choiceB_buf[1024];
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

    if (server_addr.sin_addr.s_addr == INADDR_NONE)
    {
        perror("[-]Invalid IP address");
        close(server_sock);
        exit(1);
    }

    n = bind(server_sock, (struct sockaddr *)&server_addr, sizeof(server_addr));
    if (n < 0)
    {
        perror("[-]Bind error");
        close(server_sock);
        exit(1);
    }
    printf("[+]Bind to the port number: %d\n", port);

    if (listen(server_sock, 5) < 0)
    {
        perror("[-]Listen error");
        close(server_sock);
        exit(1);
    }
    printf("Listening...\n");

    addr_size = sizeof(client_addr);
    clientA = accept(server_sock, (struct sockaddr *)&client_addr, &addr_size);
    if (clientA < 0)
    {
        perror("[-]ClientA connection error");
        // continue; // Move to the next iteration to keep listening
    }

    printf("[+]Clients connected.\n");

    if (read(clientA, choiceA_buf, sizeof(choiceA_buf)) < 0)
    {
        perror("[-]Read error from clientA");
        close(clientA);
        // continue; // Move to the next iteration to keep listening
    }
    printf("Message from clint is  %s\n", choiceA_buf);

    char Ans[200] = "Hi this is server";
    if (write(clientA, &Ans, sizeof(Ans)) < 0)
    {
        perror("[-]Write error to clientA");
    }

    if (close(clientA) < 0)
    {
        perror("[-]ClientA close error");
    }

    printf("[+]Clients disconnected.\n\n");

    return 0;
}

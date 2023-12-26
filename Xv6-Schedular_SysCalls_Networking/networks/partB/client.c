
#include "common.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <arpa/inet.h>

int main(int argc, char **argv)
{

    char *ip = "127.0.0.1";
    int port = 5050;

    int sockfd;
    struct sockaddr_in addr;
    fcntl(sockfd, F_SETFL, O_NONBLOCK); // set socket to non-blocking mode
    // char buffer[1024];
    char choice_buf[1024], result_buf[1024];
    socklen_t addr_size;

    sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    memset(&addr, '\0', sizeof(addr));
    addr.sin_family = AF_INET;
    addr.sin_port = htons(port);
    addr.sin_addr.s_addr = inet_addr(ip);

    // printf("Enter choice (0 for Rock, 1 for Paper , 2 for Seciors): ");
    printf("\n\n\n\n MESSAGE FROM CLIENT TO SERVER \n\n\n\n ");

    // fgets(choice_buf, sizeof(choice_buf), stdin);
    // scanf("%s",choice_buf);
    // sendto(sockfd, choice_buf, sizeof(choice_buf), 0, (struct sockaddr *)&addr, sizeof(addr));
    strcpy(choice_buf, "abcdefghijklmnopqrstuvwxyz11abcdefghijklmnopqrstuvwxyz22abcdefghijklmnopqrstuvwxyz33abcdefghijklmnopqrstuvwxyz44abcdefghijklmnopqrstuvwxyz");
    int num_chunks = (strlen(choice_buf) + CHUNK_SIZE - 1) / CHUNK_SIZE;
    printf("\nNO OF CHUNKS BEING SEND %d\n", num_chunks);
    int current_time;
    // printf("2\n");
    // Initially send all chunks
    for (int i = 0; i < num_chunks; i++)
    {
        // printf("i %d\n", i);
        Packet pkt;
        pkt.type = DATA;
        pkt.sequence_num = i;
        pkt.total_chunks = num_chunks;
        memcpy(pkt.data, choice_buf + i * CHUNK_SIZE, CHUNK_SIZE);
        // sendto(sockfd, &pkt, sizeof(pkt), 0, (struct sockaddr *)&remote_addr, sizeof(struct sockaddr_in));
        if (i % 3 != 0)
        {
            sendto(sockfd, &pkt, sizeof(pkt), 0, (struct sockaddr *)&addr, sizeof(addr));
        }
        // last_sent_time[i] = get_current_time();
    }

    // it will be 1 when we recive ack
    int SucessfullSended[num_chunks];
    int NoOFAck = 0;
    // printf("3\n");
    for (int i = 0; i < num_chunks; i++)
    {
        SucessfullSended[i] = 0;
    }
    while (NoOFAck != num_chunks)
    {
        printf("NO OF ACK Recived %d\n", NoOFAck);
        sleep(0.1);
        for (int i = 0; i < num_chunks; i++)
        {
            printf("Check ACK od Seq no  %d\n", i);
            Packet packetTemp;
            recvfrom(sockfd, &packetTemp, sizeof(packetTemp), 0, NULL, NULL);
            // recvfrom(sockfd, result_buf, sizeof(result_buf), 0, NULL, NULL);
            if (packetTemp.type == ACK)
            {
                printf("Recived ACK of Seq no %d\n", packetTemp.sequence_num);
                NoOFAck++;
                SucessfullSended[packetTemp.sequence_num] = 1;
            }
            // printf("SucessfullSended[%d]=%d\n", i, SucessfullSended[i]);
            // else if (packetTemp.type = REQ)
            if (SucessfullSended[i] != 1)
            {
                printf(" SERVER NOT RECIVED || NOT SENDED ACK of No %d\n", i);
                // int DataIndex = packetTemp.sequence_num;
                Packet pkt;
                pkt.type = DATA;
                pkt.sequence_num = i;
                pkt.total_chunks = num_chunks;
                memcpy(pkt.data, choice_buf + i * CHUNK_SIZE, CHUNK_SIZE);
                // sendto(sockfd, &pkt, sizeof(pkt), 0, (struct sockaddr *)&remote_addr, sizeof(struct sockaddr_in));
                sendto(sockfd, &pkt, sizeof(pkt), 0, (struct sockaddr *)&addr, sizeof(addr));
            }
        }
    }



    printf("\n\n\n\n MESSAGE FROM SERVER TO CLIENT \n\n\n\n ");
    // ! MESSAGE FROM SERVER TO CLIENT
    char received_message[2048] = "";
    char temp[CHUNK_SIZE];
    // Packet packetTemp;
    // printf("1\n");
    int isAllrecived;
    int noOfRecived = 0;

    Packet packet1, packetTemp;
    // printf("2\n");
    // recvfrom(sockfd, &packet1, sizeof(packet1), 0, NULL, NULL);
    printf("Sending ACk 0\n");
    // recvfrom(sockfd, &packet1, sizeof(packet1), 0, (struct sockaddr *)&clientA_addr, &addr_len);
    recvfrom(sockfd, &packet1, sizeof(packet1), 0, NULL, NULL);
    // printf("3\n");
    int Recived[packet1.total_chunks];
    Packet ArrayOfPacket[packet1.total_chunks];
    for (int i = 0; i < packet1.total_chunks; i++)
    {
        Recived[i] = 0;
    }
    Recived[packet1.sequence_num] = 1;
    ArrayOfPacket[packet1.sequence_num].sequence_num = packet1.sequence_num;
    ArrayOfPacket[packet1.sequence_num].total_chunks = packet1.total_chunks;
    ArrayOfPacket[packet1.sequence_num].type = packet1.type;
    strcpy(ArrayOfPacket[packet1.sequence_num].data, packet1.data);
    // printf("4\n");
    // ACK
    Packet pkt;
    pkt.type = ACK;
    pkt.sequence_num = packet1.sequence_num;
    // sendto(sockfd, &pkt, sizeof(pkt), 0, (struct sockaddr *)&remote_addr, sizeof(struct sockaddr_in));
    // sendto(sockfd, &pkt, sizeof(pkt), 0, (struct sockaddr *)&clientA_addr, addr_len);
    sendto(sockfd, &pkt, sizeof(pkt), 0, (struct sockaddr *)&addr, sizeof(addr));
    printf("Sended and recived corresponding packet ACk %d\n", pkt.sequence_num);

    // ACK
    // printf("5\n");
    noOfRecived++;
    strncpy(temp, packet1.data, CHUNK_SIZE);
    temp[CHUNK_SIZE] = '\0';
    strcat(received_message, temp);
    printf("Temp: %s\n", temp);
    // printf("Recived massage: %s\n", received_message);
    while (isAllrecived != 1)
    {
        // for (int i = 1; i < packet1.total_chunks-2; i=packetTemp.sequence_num)
        // {
        // printf("Value OF i %d\n",i);
        // recvfrom(sockfd, &packetTemp, sizeof(packetTemp), 0, NULL, NULL);
        // recvfrom(sockfd, &packetTemp, sizeof(packetTemp), 0, (struct sockaddr *)&clientA_addr, &addr_len);
        recvfrom(sockfd, &packetTemp, sizeof(packetTemp), 0, NULL, NULL);
        printf("Sending ACk of Packet %d\n", packetTemp.sequence_num);

        Recived[packetTemp.sequence_num] = 1;
        ArrayOfPacket[packetTemp.sequence_num].sequence_num = packetTemp.sequence_num;
        ArrayOfPacket[packetTemp.sequence_num].total_chunks = packetTemp.total_chunks;
        ArrayOfPacket[packetTemp.sequence_num].type = packetTemp.type;
        strcpy(ArrayOfPacket[packetTemp.sequence_num].data, packetTemp.data);
        // ACK
        Packet pkt;
        pkt.type = ACK;
        pkt.sequence_num = packetTemp.sequence_num;
        // sendto(sockfd, &pkt, sizeof(pkt), 0, (struct sockaddr *)&remote_addr, sizeof(struct sockaddr_in));
        // sendto(sockfd, &pkt, sizeof(pkt), 0, (struct sockaddr *)&clientA_addr, addr_len);
        sendto(sockfd, &pkt, sizeof(pkt), 0, (struct sockaddr *)&addr, sizeof(addr));
        // ACK
        noOfRecived++;
        //! message ka order kharab ho sakta h
        strncpy(temp, packetTemp.data, CHUNK_SIZE);
        temp[CHUNK_SIZE] = '\0';
        strcat(received_message, temp);
        printf("Temp: %s\n", temp);
        // printf("Recived massage: %s\n", received_message);
        // printf("Sended and recived corresponding packet ACk %d\n", packetTemp.sequence_num);
        // }
        // printf("BeforeBreak\n");
        printf("NO OF RECIVED %d\n", noOfRecived);
        if (noOfRecived == packet1.total_chunks)
        {
            break;
        }
        // printf("AfterBreak\n");
        // wait for 0.1sec
        // for (int i = 0; i < packet1.total_chunks; i++)
        // {
        //     printf("checking  Ack of %d\n", i);
        //     if (Recived[i] == 0)
        //     {
        //         printf("Reciver[%d]==0\n", i);
        //         Packet pkt;
        //         pkt.type = REQ;
        //         pkt.sequence_num = i;
        //         // sendto(sockfd, &pkt, sizeof(pkt), 0, (struct sockaddr *)&remote_addr, sizeof(struct sockaddr_in));
        //         sendto(sockfd, &pkt, sizeof(pkt), 0, (struct sockaddr *)&clientA_addr, addr_len);
        //     }
        // }
    }

    // Make Message;
    printf("Finally Making String\n");
    printf("%s\n", ArrayOfPacket[0].data);
    char MesaageRecived[MAX_CHUNKS * CHUNK_SIZE];
    strcpy(MesaageRecived, ArrayOfPacket[0].data);
    for (int i = 1; i < packet1.total_chunks; i++)
    {
        // printf("%s\n", ArrayOfPacket[i].data);
        strcat(MesaageRecived, ArrayOfPacket[i].data);
    }
    printf("Received by Server : %s\n", MesaageRecived);

    // printf("Result: Player No:-%s won\n", result_buf);
    // printf("%s\n", result_buf);

    // ! MESSAGE FROM SERVER TO CLIENT

    return 0;
}

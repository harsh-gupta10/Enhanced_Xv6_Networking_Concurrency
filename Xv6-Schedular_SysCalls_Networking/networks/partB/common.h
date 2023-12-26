#ifndef COMMON_H
#define COMMON_H

#include <sys/time.h>
#include<stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <fcntl.h>

#define CHUNK_SIZE 10
#define MAX_CHUNKS 100
#define WAIT_TIME 1000
// #define MAX_RETRASNMISSION 10

typedef enum {
    DATA,
    ACK,
    REQ,
} PacketType;

typedef struct {
    PacketType type;
    int sequence_num;
    int total_chunks;
    char data[CHUNK_SIZE];
} Packet;

int get_current_time() {
    struct timeval te; 
    gettimeofday(&te, NULL);
    return te.tv_sec*1000 + te.tv_usec/1000; // return current time in milliseconds
}


// // int udp_socket;
// struct sockaddr_in remote_addr;
// Packet received_chunks[MAX_CHUNKS];
// int acknowledged_chunks[MAX_CHUNKS] = {0};
// int last_sent_time[MAX_CHUNKS] = {0};

#endif

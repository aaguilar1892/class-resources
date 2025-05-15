//minor4svr.c

/**
 * UDP Ping Server
 * Listens for PING messages and responds with PONG messages
 * Simulates 30% packet loss
 * 
 * Usage: ./minor4svr <port>
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <time.h>

#define BUFFER_SIZE 1024
#define LOSS_PERCENTAGE 30

int main(int argc, char *argv[]) {
    // Check command line arguments
    if (argc != 2) {
        printf("usage: %s <port>\n", argv[0]);
        exit(1);
    }

    // Variables for server setup
    int sockfd;
    struct sockaddr_in server_addr, client_addr;
    socklen_t client_len = sizeof(client_addr);
    char buffer[BUFFER_SIZE];
    int port = atoi(argv[1]);

    // Create UDP socket
    if ((sockfd = socket(AF_INET, SOCK_DGRAM, 0)) < 0) {
        perror("Error creating socket");
        exit(1);
    }

    // Initialize server address structure
    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = htonl(INADDR_ANY);
    server_addr.sin_port = htons(port);

    // Bind socket to server address
    if (bind(sockfd, (struct sockaddr *)&server_addr, sizeof(server_addr)) < 0) {
        perror("Error binding socket");
        close(sockfd);
        exit(1);
    }

    // Initialize random seed
    srand(time(NULL));

    printf("[server]: ready to accept data...\n");

    // Main server loop
    while (1) {
        // Receive message from client
        ssize_t recv_len = recvfrom(sockfd, buffer, BUFFER_SIZE - 1, 0,
                                  (struct sockaddr *)&client_addr, &client_len);
        
        if (recv_len < 0) {
            perror("Error receiving data");
            continue;
        }

        buffer[recv_len] = '\0';

        // Simulate packet loss
        if (rand() % 100 < LOSS_PERCENTAGE) {
            printf("[server]: dropped packet\n");
            continue;
        }

        // Print received message
        printf("[client]: %s\n", buffer);

        // Send PONG response back to client
        const char *response = "PONG";
        if (sendto(sockfd, response, strlen(response), 0,
                  (struct sockaddr *)&client_addr, client_len) < 0) {
            perror("Error sending response");
        }
    }

    close(sockfd);
    return 0;
}
//minor4cli.c

/**
 * UDP Ping Client
 * Sends PING messages to server and measures RTT
 * Handles both IPv4 and IPv6 connections
 * 
 * Usage: ./minor4cli <hostname> <port>
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>
#include <sys/time.h>
#include <errno.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <sys/select.h>

#define NUM_PINGS 10
#define TIMEOUT_SEC 1
#define BUFFER_SIZE 1024

// Structure to store RTT statistics
struct rtt_stats {
    double min;
    double max;
    double total;
    int received;
};

// Function to calculate RTT in milliseconds
double calculate_rtt(struct timeval *start, struct timeval *end) {
    return (end->tv_sec - start->tv_sec) * 1000.0 +
           (end->tv_usec - start->tv_usec) / 1000.0;
}

int main(int argc, char *argv[]) {
    // Check command line arguments
    if (argc != 3) {
        printf("usage: %s <hostname> <port>\n", argv[0]);
        exit(1);
    }

    // Variables for setup
    int sockfd;
    struct addrinfo hints, *servinfo, *p;
    char buffer[BUFFER_SIZE];
    struct timeval start, end, timeout;
    struct rtt_stats stats = {999999.0, 0.0, 0.0, 0};

    // Set timeout for recvfrom
    timeout.tv_sec = TIMEOUT_SEC;
    timeout.tv_usec = 0;

    // Configure hints for getaddrinfo
    memset(&hints, 0, sizeof hints);
    hints.ai_family = AF_UNSPEC;    // Allow IPv4 or IPv6
    hints.ai_socktype = SOCK_DGRAM; // UDP socket

    // Get address information
    int rv = getaddrinfo(argv[1], argv[2], &hints, &servinfo);
    if (rv != 0) {
        fprintf(stderr, "getaddrinfo: %s\n", gai_strerror(rv));
        exit(1);
    }

    // Loop through all the results and try to connect
    for (p = servinfo; p != NULL; p = p->ai_next) {
        if ((sockfd = socket(p->ai_family, p->ai_socktype, p->ai_protocol)) < 0) {
            continue;
        }
        break;
    }

    if (p == NULL) {
        fprintf(stderr, "failed to create socket\n");
        exit(1);
    }

    // Set socket timeout
    if (setsockopt(sockfd, SOL_SOCKET, SO_RCVTIMEO, &timeout, sizeof(timeout)) < 0) {
        perror("setsockopt failed");
        exit(1);
    }

    // Send PING messages
    const char *ping_msg = "PING";
    for (int i = 1; i <= NUM_PINGS; i++) {
        printf("%d: Sent... ", i);
        
        // Get start time
        gettimeofday(&start, NULL);

        // Send PING
        if (sendto(sockfd, ping_msg, strlen(ping_msg), 0,
                  p->ai_addr, p->ai_addrlen) < 0) {
            perror("sendto failed");
            continue;
        }

        // Receive PONG
        ssize_t recv_len = recvfrom(sockfd, buffer, BUFFER_SIZE - 1, 0, NULL, NULL);
        
        // Get end time
        gettimeofday(&end, NULL);

        if (recv_len < 0) {
            if (errno == EAGAIN || errno == EWOULDBLOCK) {
                printf("Timed Out\n");
            } else {
                perror("recvfrom failed");
            }
            continue;
        }

        // Calculate RTT
        double rtt = calculate_rtt(&start, &end);
        printf("RTT=%.6f ms\n", rtt);

        // Update statistics
        stats.received++;
        stats.total += rtt;
        if (rtt < stats.min) stats.min = rtt;
        if (rtt > stats.max) stats.max = rtt;
    }

    // Print final statistics
    double loss_rate = ((NUM_PINGS - stats.received) * 100.0) / NUM_PINGS;
    double avg_rtt = stats.received > 0 ? stats.total / stats.received : 0;

    printf("%d pkts xmited, %d pkts rcvd, %.0f%% pkt loss\n",
           NUM_PINGS, stats.received, loss_rate);
    if (stats.received > 0) {
        printf("min: %.6f ms, max: %.6f ms, avg: %.6f ms\n",
               stats.min, stats.max, avg_rtt);
    }

    freeaddrinfo(servinfo);
    close(sockfd);
    return 0;
}
// Client program to demonstrate buffer overflow
//
// communicate with the server using either textual commands:
//  
//  echo -n "version" | ./client 127.0.0.1 6000
//
//  or by feeding it binary shellcode blob:
//
//  cat q1-cs.bin | ./client 127.0.0.1 6000
//
// For the sake of exploitation simplicity, the example server uses 
// proprietary binary communication protocol, in which client commands
// are sequences of bytes. When sending a command, the client 
// prefixes it with the 4-byte length of the command in little-endian 
// format. E.g. <len><command>
//

#include <stdio.h>
#include <sys/socket.h>
#include <unistd.h>
#include <stdlib.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <string.h>

int main(int argc, char const *argv[])
{

   int sock, port;
   int32_t len;
   struct sockaddr_in server;
   char message[4004], server_reply[4000];
	
   printf("COMP30080 2020/2021 Assignment 4 EXAMPLE Client\n"); 
   
   // getting port number from argv[1]
   if (argc < 2) 
   {
      printf("\nUsage: client server-addr port\n\n");
      return 0;
   }

   port = atoi(argv[2]);

   if (port == 0) 
   {
      printf("\nPlease specify a valid port number!\n\n");
      return 0;
   }

   //Create socket
   sock = socket(AF_INET , SOCK_STREAM , 0);
   if (sock == -1)
   {
     printf("Could not create socket");
   }
   puts("Socket created");

   server.sin_addr.s_addr = inet_addr(argv[1]);
   server.sin_family = AF_INET;
   server.sin_port = htons( port );

   //Connect to remote server
   if (connect(sock , (struct sockaddr *)&server , sizeof(server)) < 0)
   {
      perror("connect failed. Error");
      return 1;
   }
	
   puts("Connected\n");
	
   //Communicating with server
   
   len = read(STDIN_FILENO, message+4,4000); 
   *(int32_t *)message = len; 		

   //Send some data
   if( send(sock , message , len+4 , 0) < 0)
   {
     puts("Send failed");
     return 1;
   }
   else
   {
     puts("Message sent");
   }
		
   close(sock);
   return 0;
}
    

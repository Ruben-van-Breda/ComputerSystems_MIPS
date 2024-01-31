// Sample server program to demonstrate buffer overflow
//
// For the sake of exploitation simplicity, this server uses 
// a binary communication protocol, in which client commands
// are sequences of bytes. When sending a command, the client 
// prefixes it with the 4-byte length of the command in little-endian 
// format. E.g. <len><command>
//
// "\x07\0x00\0x00\0x00version"
//
// The response is a JSON string.

#include <stdio.h>
#include <sys/socket.h>
#include <unistd.h>
#include <stdlib.h>
#include <netinet/in.h>
#include <string.h>

void process(char *buffer)
{
   char command[2000]="";
   int  len = *((unsigned int *)buffer);
   //printf("command = %x\n",(unsigned int)command);
   memcpy(command,buffer+4,len);
   command[len]='\0';
   if (strcmp(command,"version")==0)
   {
      printf("received command 'version'\n");
   }
   else
   {
      printf("received unsupported command!\n");
   }
   return;
}

int main(int argc, char const *argv[])
{
   int server_fd, new_socket; long valread;
   struct sockaddr_in address;
   int addrlen = sizeof(address);
   int port;

   printf("COMP30080 2020/2021 Assignment 4 EXAMPLE Server\n"); 
   
   // getting port number from argv[1]
   if (argc < 2) 
   {
      printf("\nUsage: server port\n\n");
      return 0;
   }
    
   port = atoi(argv[1]);

   if (port == 0) 
   {
      printf("\nPlease specify a valid port number!\n\n");
      return 0;
   }


   // Creating socket file descriptor
   if ((server_fd = socket(AF_INET, SOCK_STREAM, 0)) == 0)
   {
       perror("In socket");
       exit(EXIT_FAILURE);
   }

    
   address.sin_family = AF_INET;
   address.sin_addr.s_addr = INADDR_ANY;
   address.sin_port = htons( port );
    
   memset(address.sin_zero, '\0', sizeof address.sin_zero);
   
   if (bind(server_fd, (struct sockaddr *)&address, sizeof(address))<0)
   {
       perror("In bind");
       exit(EXIT_FAILURE);
   }
   if (listen(server_fd, 10) < 0)
   {
       perror("In listen");
       exit(EXIT_FAILURE);
   }
   while(1)
   {
       printf("\n+++++++ Waiting for new connection ++++++++\n\n");
       if ((new_socket = accept(server_fd, (struct sockaddr *)&address, (socklen_t*)&addrlen))<0)
       {
           perror("In accept");
           exit(EXIT_FAILURE);
       }
       
       char buffer[30000] = {0};
       valread = read( new_socket , buffer, 30000);
       process(buffer);
       printf("------------------request processed -------------------");
       close(new_socket);
   }
   return 0;
}

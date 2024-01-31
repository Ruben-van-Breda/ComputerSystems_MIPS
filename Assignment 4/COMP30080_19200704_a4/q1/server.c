// COMP 30080 Assignment 4, Q1.
//
// New server program to adapt the buffer overflow attack to
//
// This program is different from the provided example in that
// commands are NULL-terminated strings rather than binary blobs.
// It means that the shellcode MUST NOT contain any zero bytes.
//
// Your task for Q1 is to modify shellcode progam in such a way that
// once assembled it does not contain any 0x00 bytes.
//
// You can achieve it by using MIPS instructions in innovative ways!
//
// Here is the list of *hints* to consider:
//
// 1) Although the default NOP instruction has code 0x00000000, you 
// can use any other instruction that does not affect program behaviour
// in place of NOP.
//
// 2) .data and .text section sizes must be a multiple of 16 bytes, 
// if your section is not a multiply of 16 bytes is size, assembler 
// and linker will automatically pad it with 0x00000000
//
// 3) strings cmd, amd_arg1, cmd_arg2 and the exec_args[] array must be 
// terminated with 0x00 and 0x000000 respectivewly. Since you cannot
// insert 0x00 into the shell code, you need to find a way to generate them
// at runtime
//
// 4) address of exec_args must begin at a multiply of 4. Assembler may 
// prepend it with some 0x00 if it is not.
//
// 5) if your immediate offsets in addiu and sw instructions contain 0x00s, 
// find a way to use negative offsets !!!
//
// 6) readup about the obscure parameter of MIPS syscall command (e.g. syscall 0x1). 
// Find out a way to use it!
//
// 7) Assemble this program using provided 'assemble' bash script
//   THEN EXAMINE GENERATED BINARY CODE using provided 'disassemble' bash script!
//
// Enjoy!
//
// Pavel Gladyshev

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
   printf("buffer = %x\n",(unsigned int)buffer);
   printf("command = %x\n",(unsigned int)command);
   strcpy(command,buffer);
   
 
   (sizeof(buffer) == sizeof(command)) ? printf("Buffer copied over fully:\n") : printf("Buffer NOT copied over fully:\n") ;
  
 //  memcpy(command,buffer+4,len);
  // command[len]='\0';

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

   printf("COMP30080 2020/2021 Assignment 4 Q1 Server\n"); 
   
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
       printf("------------------request processed-------------------");
       close(new_socket);
   }
   return 0;
}

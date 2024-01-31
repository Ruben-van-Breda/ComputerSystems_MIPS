// Simple HTTP server program to demonstrate buffer overflow
#include <stdio.h>
#include <sys/socket.h>
#include <unistd.h>
#include <stdlib.h>
#include <netinet/in.h>
#include <string.h>

#define PORT 8080

void process(char *buffer)
{
    char parameter[200]="";
    sscanf(buffer,"GET /%[^ ]%*s",parameter);
    if (strlen(parameter)==0)
    {
        sprintf(buffer,"HTTP/1.1 200 OK\nContent-Type: text/html\nContent-Length: 258\n\n\
<!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n\
<html>\n\
<head>\n\
   <title>Welcome</title>\n\
</head>\n\
<body>\n\
   <h1>Welcome</h1>\n\
   <p>This is a vulnerable web server, which you are requested to exploit as part of UCD's COMP 30080 module.</p>\n\
</body>\n\
</html>\n");

    } else if (strcmp(parameter,"version")==0)
    {
        sprintf(buffer,"HTTP/1.1 200 OK\nContent-Type: application/json\nContent-Length: 15\n\n{\"version\":1.0}");
    }
    else
    {
        sprintf(buffer,"HTTP/1.1 404 Not Found\nContent-Type: text/html\nContent-Length: 199\n\n\
<!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n\
<html>\n\
<head>\n\
   <title>404 Not Found</title>\n\
</head>\n\
<body>\n\
   <h1>Not Found</h1>\n\
   <p>The requested parameter was not found.</p>\n\
</body>\n\
</html>");
    }
    return;
}

int main(int argc, char const *argv[])
{
    int server_fd, new_socket; long valread;
    struct sockaddr_in address;
    int addrlen = sizeof(address);
    
    // Creating socket file descriptor
    if ((server_fd = socket(AF_INET, SOCK_STREAM, 0)) == 0)
    {
        perror("In socket");
        exit(EXIT_FAILURE);
    }
    
    address.sin_family = AF_INET;
    address.sin_addr.s_addr = INADDR_ANY;
    address.sin_port = htons( PORT );
    
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
        write(new_socket , buffer , strlen(buffer));
        printf("------------------response sent-------------------");
        close(new_socket);
    }
    return 0;
}

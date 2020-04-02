#include <stdio.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[])
{
    int i = 0;
    int arg_num = argc;
    int src_fd, dest_fd;
    char buf[1024];
    int read_len = 0;

    printf("argc: %d\n", argc);
    for(i; i<argc; i++)
    {
        printf("argv[%d]:%s\n", i, argv[i]);        
    }
    
    if (argc < 3)
    {
        printf("./mycp src dest.\n");
        exit(1);
    }

    // 终端敲umask默认是0002, 会限制程序新建文件的权限
    umask(0);
    src_fd  = open(argv[1], O_RDONLY);
    dest_fd = open(argv[2], O_CREAT | O_WRONLY | O_TRUNC, 0644);
    if ((src_fd == -1)||(dest_fd == -1))
    {
        printf("open fail: src_fd(%s): %d , dest_fd(%s): %d !\n", argv[1], src_fd, argv[2], dest_fd);
        exit(1);        
    }

    printf("src_fd:%d, dest_fs:%d\n", src_fd, dest_fd);

    while((read_len = read(src_fd, buf, sizeof(buf))) > 0)
    {
        write(dest_fd, buf, read_len);
    }

    close(src_fd);
    close(dest_fd);


    return 0;    
}
#include <sys/time.h>
#include <sys/resource.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <unistd.h>
#include <linux/stat.h>
#define ESTRUCTURA_FILE "archivo"

int getrusage(int who, struct rusage *usage);


int main(void)
{


 struct rusage usage;
 int i=0;
 FILE *fp;

 char readbuf[1000];
 /* Crea el FIFO si no existe */
 umask(0);
 mknod(ESTRUCTURA_FILE, S_IFIFO|0666, 0);

 while(i<1000)
 {

 fp = fopen(ESTRUCTURA_FILE, "r");//si se abre el "archivo" para lectura, el proceso estará
                                  //"bloqueado" hasta que cualquier otro proceso lo abra para escritura. Esta acción funciona al revés también.

 fgets(readbuf, 1000, fp);
 fclose(fp);
 printf("Cadena recibida en el proceso 1: %s %d\n", readbuf,i);

 readbuf[0]=i;
 fp = fopen(ESTRUCTURA_FILE, "w");
 fputs(readbuf, fp);
 fclose(fp);

 i++;
 }

  getrusage(RUSAGE_SELF,&usage);

 printf ("Tiempo de CPU del proceso B: %ld.%06ld segs usuario, %ld.%06ld segs sistema\n",
          usage.ru_utime.tv_sec, usage.ru_utime.tv_usec,
          usage.ru_stime.tv_sec, usage.ru_stime.tv_usec);
 //getrusage(getpid(),&usage);
 return(0);
}

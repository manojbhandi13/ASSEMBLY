#include <LPC214x.h>

int main(void)
{
	unsigned int delay,delay1,num,val;
	 
        IO1DIR 	= 0x00FF0000; 					              	// set all ports to output
        num=0x00;
        IO1CLR=0x00FF0000;
    while(1)
	{
          IO1CLR=val;
          val=(num<<16);
          IO1SET=val;
          num++;
          if(num > 0x0f)
          {
            num=0x00;
          }
        for(delay = 0;delay<0x700;delay++)        //simple delay loop
        {
        for(delay1 = 0;delay1<0x70;delay1++);
        }
	}
}
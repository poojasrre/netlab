#include<stdio.h>
#include<conio.h>
#include<math.h>
void ksa(int state[],int key[],int len)
{
	int i,j=0;
	int t[6];
	int temp;
	for (i=0;i<=5;i++)
	state[i]=i;
	printf("\n the t matrix is\t");
	for (i=0;i<=5;i++)
	{
		t[i]=key[i%len];
		printf("%d",t[i]);
		j=(j+state[i]+t[i])%6;
		temp=state[i];
		state[i]=state[j];
		state[j]=temp;
	}
	printf("\nthe state after swapping");
	for(i=0;i<=5;i++)
	printf("\t%d",state[i]);
	}
	void prga(int state[],int out[], int len)
	{
		int i=0,j=0,x,t;
		for (x=0;x<len;++x)
		{
			i=(i+1)%6;
			j=(j+state[i])%6;
			t=state[i];
			state[i]=state[j];
			state[j]=t;
			out[x]=state[(state[i]+state[j])%6];
		}
	}
	int main()
	{
		int state[256],stream[1024],c[100];
		int key[]={1,2,3};
		int ptext[]={1,2,2};
		int len=3,i;
		ksa(state,key,len);
		prga(state,stream,len);
		for (i=0;i<3;i++)
		{
			c[i]=ptext[i]^stream[i];
			printf("%d",stream[i]);
		}
	printf("\nthe code is:");
	for(i=0;i<3;i++)
	printf("%d",c[i]);
	getch();
	return 0;
	}
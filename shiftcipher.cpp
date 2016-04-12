#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#define  MAXCHARS  255
#define  MAXS    4
int convertChar(char *a);
void encrypt();
void decrypt();
int main()
{
    char response[MAXS],plaintext[MAXCHARS];
    printf("Shift Cipher Program\n\nWould you like to (E)ncrypt or (D)ecrypt a message or (Q)uit.  ");
    scanf("%s",response);    
    while (response[0] != 'q' && response[0] != 'Q') {
          switch (response[0]) {
                 case 'e':
                 case 'E':
                      encrypt();
                      break;
                 case 'd':
                 case 'D':
                      decrypt();
                      break;
                 default:
                         printf("error: invalid command\n");
                         break;
          }//end of switch
    printf("Would you like to (E)ncrypt or (D)ecrypt a message or (Q)uit.  ");
    scanf("%s",response);
    }//end of while
    return 0;
}//end of main
void encrypt()
{
     int i=0,k;
     char msg[MAXCHARS],*letter;
    printf("Please enter the plain text to encrypt in all CAPS and press enter\n");
     scanf ("%s",msg);
     printf("Please enter the alpha key(k) you would like to use  ");
     scanf ("%s",letter);
     k = convertChar(letter);
     while (msg[i]!= '\0') 
	 {
           if ((msg[i]+k) > 'Z')
           {
		   msg[i] = ((((msg[i]+k) - 'Z')-1) + 'A');
		   } //wrap to the beginning}             
           else
           {
		   msg[i] = (msg[i]+k);
		   }
		   i++;
		   
     }          
     printf("\n%s", msg);
     }
void decrypt()
{
     int i=0,k;
     char msg[MAXCHARS],*letter;
     printf("Please enter the cipher text to decrypt in all CAPS and press enter\n");
     scanf ("%s",msg);
     printf("Please enter the alpha key(k) you would like to use  "); 
       scanf ("%s",letter);
     k = convertChar(letter);
           while (msg[i]!= '\0') {
          if ((msg[i]-k) < 'A'){          
              msg[i] = ('Z' - (('A' - (msg[i]-k))-1)); } //wrap to the end.
           else {           
               msg[i] = (msg[i]-k); }    
          i++;
     }
     printf ("%s\n",msg);
}                      
int convertChar(char *a)
{
    static char *letters[26] = {"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"};    int i=0;
        while(i<26){
        if (strcmp(letters[i],a))
		{
            printf("%d",i);
            return (i+1); }
        else
            i++;
    }
    return 0;
}

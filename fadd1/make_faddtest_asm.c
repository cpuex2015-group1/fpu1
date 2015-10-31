#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include "fadd.c"

uint32_t fadd(uint32_t a,uint32_t b);

char bit_to_hex(uint32_t n){
	if((n ^ 0x00000000) == 0) return '0';
	if((n ^ 0x00000001) == 0) return '1';
	if((n ^ 0x00000002) == 0) return '2';
	if((n ^ 0x00000003) == 0) return '3';
	if((n ^ 0x00000004) == 0) return '4';
	if((n ^ 0x00000005) == 0) return '5';
	if((n ^ 0x00000006) == 0) return '6';
	if((n ^ 0x00000007) == 0) return '7';
	if((n ^ 0x00000008) == 0) return '8';
	if((n ^ 0x00000009) == 0) return '9';
	if((n ^ 0x0000000A) == 0) return 'a';
	if((n ^ 0x0000000B) == 0) return 'b';
	if((n ^ 0x0000000C) == 0) return 'c';
	if((n ^ 0x0000000D) == 0) return 'd';
	if((n ^ 0x0000000E) == 0) return 'e';
	if((n ^ 0x0000000F) == 0) return 'f';
	return 0;
}

void writetest(int fd, uint32_t a, uint32_t b, uint32_t c){

	char a_16_1[6] = {'0','x'};
	a_16_1[2] = bit_to_hex((a>>28) & 0x0000000F);
	a_16_1[3] = bit_to_hex((a>>24) & 0x0000000F);
	a_16_1[4] = bit_to_hex((a>>20) & 0x0000000F);
	a_16_1[5] = bit_to_hex((a>>16) & 0x0000000F);
	char a_16_2[6] = {'0','x'};
	a_16_2[2] = bit_to_hex((a>>12) & 0x0000000F);
	a_16_2[3] = bit_to_hex((a>>8) & 0x0000000F);
	a_16_2[4] = bit_to_hex((a>>4) & 0x0000000F);
	a_16_2[5] = bit_to_hex((a>>0) & 0x0000000F);
	char b_16_1[6] = {'0','x'};
	b_16_1[2] = bit_to_hex((b>>28) & 0x0000000F);
	b_16_1[3] = bit_to_hex((b>>24) & 0x0000000F);
	b_16_1[4] = bit_to_hex((b>>20) & 0x0000000F);
	b_16_1[5] = bit_to_hex((b>>16) & 0x0000000F);
	char b_16_2[6] = {'0','x'};
	b_16_2[2] = bit_to_hex((b>>12) & 0x0000000F);
	b_16_2[3] = bit_to_hex((b>>8) & 0x0000000F);
	b_16_2[4] = bit_to_hex((b>>4) & 0x0000000F);
	b_16_2[5] = bit_to_hex((b>>0) & 0x0000000F);
	char c_16_1[6] = {'0','x'};
	c_16_1[2] = bit_to_hex((c>>28) & 0x0000000F);
	c_16_1[3] = bit_to_hex((c>>24) & 0x0000000F);
	c_16_1[4] = bit_to_hex((c>>20) & 0x0000000F);
	c_16_1[5] = bit_to_hex((c>>16) & 0x0000000F);
	char c_16_2[6] = {'0','x'};
	c_16_2[2] = bit_to_hex((c>>12) & 0x0000000F);
	c_16_2[3] = bit_to_hex((c>>8) & 0x0000000F);
	c_16_2[4] = bit_to_hex((c>>4) & 0x0000000F);
	c_16_2[5] = bit_to_hex((c>>0) & 0x0000000F);

	char addiu[5] = {'a','d','d','i','u'};
	char subi[4] = {'s','u','b','i'};
	char sll[3] = {'s','l','l'};
	char st[3] = {'s','t'};
	char fld[3] = {'f','l','d'};
	char fadd[4] = {'f','a','d','d'};
	char fseq[4] = {'f','s','e','q'};
	char bclf[4] = {'b','c','l','f'};
	char r0[2] = {'r','0'};
	char r1[2] = {'r','1'};
	char r2[2] = {'r','2'};
	char r3[2] = {'r','3'};
	char r4[2] = {'r','4'};
	char r5[2] = {'r','5'};
	char r9[2] = {'r','9'};
	char r16[3] = {'r','1','6'};
	char f1[2] = {'f','1'};
	char f2[2] = {'f','2'};
	char f3[2] = {'f','3'};
	char f4[2] = {'f','4'};
	char zero[1] = {'0'};
	char one[1] = {'1'};
	char end[3] = {'e','n','d'};
	char LF[1];
	LF[0] = 10;
	char SP[1];
	SP[0] = 32;

	write(fd,addiu,5);
	write(fd,SP,1);
	write(fd,r1,2);
	write(fd,SP,1);
	write(fd,r0,2);
	write(fd,SP,1);
	write(fd,a_16_1,6);
	write(fd,LF,1);

	write(fd,sll,3);
	write(fd,SP,1);
	write(fd,r1,2);
	write(fd,SP,1);
	write(fd,r1,2);
	write(fd,SP,1);
	write(fd,r16,3);
	write(fd,LF,1);

	write(fd,addiu,5);
	write(fd,SP,1);
	write(fd,r1,2);
	write(fd,SP,1);
	write(fd,r1,2);
	write(fd,SP,1);
	write(fd,a_16_2,6);
	write(fd,LF,1);


	write(fd,addiu,5);
	write(fd,SP,1);
	write(fd,r2,2);
	write(fd,SP,1);
	write(fd,r0,2);
	write(fd,SP,1);
	write(fd,b_16_1,6);
	write(fd,LF,1);

	write(fd,sll,3);
	write(fd,SP,1);
	write(fd,r2,2);
	write(fd,SP,1);
	write(fd,r2,2);
	write(fd,SP,1);
	write(fd,r16,3);
	write(fd,LF,1);

	write(fd,addiu,5);
	write(fd,SP,1);
	write(fd,r2,2);
	write(fd,SP,1);
	write(fd,r2,2);
	write(fd,SP,1);
	write(fd,b_16_2,6);
	write(fd,LF,1);


	write(fd,addiu,5);
	write(fd,SP,1);
	write(fd,r3,2);
	write(fd,SP,1);
	write(fd,r0,2);
	write(fd,SP,1);
	write(fd,c_16_1,6);
	write(fd,LF,1);

	write(fd,sll,3);
	write(fd,SP,1);
	write(fd,r3,2);
	write(fd,SP,1);
	write(fd,r3,2);
	write(fd,SP,1);
	write(fd,r16,3);
	write(fd,LF,1);

	write(fd,addiu,5);
	write(fd,SP,1);
	write(fd,r3,2);
	write(fd,SP,1);
	write(fd,r3,2);
	write(fd,SP,1);
	write(fd,c_16_2,6);
	write(fd,LF,1);


	write(fd,st,2);
	write(fd,SP,1);
	write(fd,r4,2);
	write(fd,SP,1);
	write(fd,r1,2);
	write(fd,SP,1);
	write(fd,zero,1);
	write(fd,LF,1);

	write(fd,addiu,5);
	write(fd,SP,1);
	write(fd,r4,2);
	write(fd,SP,1);
	write(fd,r4,2);
	write(fd,SP,1);
	write(fd,one,1);
	write(fd,LF,1);

	write(fd,st,2);
	write(fd,SP,1);
	write(fd,r4,2);
	write(fd,SP,1);
	write(fd,r2,2);
	write(fd,SP,1);
	write(fd,zero,1);
	write(fd,LF,1);

	write(fd,addiu,5);
	write(fd,SP,1);
	write(fd,r4,2);
	write(fd,SP,1);
	write(fd,r4,2);
	write(fd,SP,1);
	write(fd,one,1);
	write(fd,LF,1);

	write(fd,st,2);
	write(fd,SP,1);
	write(fd,r4,2);
	write(fd,SP,1);
	write(fd,r3,2);
	write(fd,SP,1);
	write(fd,zero,1);
	write(fd,LF,1);


	write(fd,fld,3);
	write(fd,SP,1);
	write(fd,r4,2);
	write(fd,SP,1);
	write(fd,f3,2);
	write(fd,SP,1);
	write(fd,zero,1);
	write(fd,LF,1);

	write(fd,subi,4);
	write(fd,SP,1);
	write(fd,r4,2);
	write(fd,SP,1);
	write(fd,r4,2);
	write(fd,SP,1);
	write(fd,one,1);
	write(fd,LF,1);

	write(fd,fld,3);
	write(fd,SP,1);
	write(fd,r4,2);
	write(fd,SP,1);
	write(fd,f2,2);
	write(fd,SP,1);
	write(fd,zero,1);
	write(fd,LF,1);

	write(fd,subi,4);
	write(fd,SP,1);
	write(fd,r4,2);
	write(fd,SP,1);
	write(fd,r4,2);
	write(fd,SP,1);
	write(fd,one,1);
	write(fd,LF,1);

	write(fd,fld,3);
	write(fd,SP,1);
	write(fd,r4,2);
	write(fd,SP,1);
	write(fd,f1,2);
	write(fd,SP,1);
	write(fd,zero,1);
	write(fd,LF,1);


	write(fd,fadd,4);
	write(fd,SP,1);
	write(fd,f4,2);
	write(fd,SP,1);
	write(fd,f1,2);
	write(fd,SP,1);
	write(fd,f2,2);
	write(fd,LF,1);


	write(fd,fseq,4);
	write(fd,SP,1);
	write(fd,f4,2);
	write(fd,SP,1);
	write(fd,f3,2);
	write(fd,LF,1);


	write(fd,addiu,5);
	write(fd,SP,1);
	write(fd,r5,2);
	write(fd,SP,1);
	write(fd,r5,2);
	write(fd,SP,1);
	write(fd,one,1);
	write(fd,LF,1);


	write(fd,bclf,4);
	write(fd,SP,1);
	write(fd,end,3);
	write(fd,LF,1);
}
	
int main(){

	uint32_t a,b,c;
	int i,j;
	unsigned char randbyte[8];
	int fd;

	char addiu[5] = {'a','d','d','i','u'};
	char r0[2] = {'r','0'};
	char r4[2] = {'r','4'};
	char r5[2] = {'r','5'};
	char r16[3] = {'r','1','6'};
	char halt[4] = {'h','a','l','t'};
	char send[4] = {'s','e','n','d'};
	char zero[1] = {'0'};
	char nine[1] = {'9'};
	char sixteen[2] = {'1','6'};
	char end[3] = {'e','n','d'};
	char colon[1] = {':'};
	char LF[1];
	LF[0] = 10;
	char SP[1];
	SP[0] = 32;

	fd = open("test-fadd.asm", O_WRONLY | O_CREAT, S_IRWXU);

	write(fd,addiu,5);
	write(fd,SP,1);
	write(fd,r16,3);
	write(fd,SP,1);
	write(fd,r0,2);
	write(fd,SP,1);
	write(fd,sixteen,2);
	write(fd,LF,1);

	write(fd,addiu,5);
	write(fd,SP,1);
	write(fd,r4,2);
	write(fd,SP,1);
	write(fd,r0,2);
	write(fd,SP,1);
	write(fd,nine,1);
	write(fd,LF,1);

	write(fd,addiu,5);
	write(fd,SP,1);
	write(fd,r5,2);
	write(fd,SP,1);
	write(fd,r0,2);
	write(fd,SP,1);
	write(fd,zero,1);
	write(fd,LF,1);

	for(i=0; i<100; i++){
		a = 0;
		b = 0;
		for(j=0; j<8; j++){
			randbyte[j] = rand()%256;		
			if(j%2==0){
				a = a << 8;
				a = (a | randbyte[j]);
			}
			else{
				b = b << 8;
				b = (b | randbyte[j]);
			}
		}
		c = fadd(a,b);
		writetest(fd, a,b,c);
	}

	write(fd,end,3);
	write(fd,colon,1);
	write(fd,LF,1);
	write(fd,send,4);
	write(fd,SP,1);
	write(fd,r5,2);
	write(fd,LF,1);
	write(fd,halt,4);
	write(fd,LF,1);

	close(fd);

	return 0;
}


#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include "finv.c"

uint32_t finv(uint32_t a, uint32_t table1, uint32_t table2);

uint32_t read_nbit(FILE *fp, int n){
	uint32_t data = 0;
	int i;
	int bit[32];
	char LF;
	for(i=0; i<n; i++) bit[i] = getc(fp);
    LF = getc(fp);
	for(i=0; i<n; i++){
		data = data * 2;
		if(bit[i]==49) data = data + 1;
	}
	return data;
}

int main(){

	uint32_t input,output;
	FILE *fp1,*fp2;
	uint32_t table1[1024];
	uint32_t table2[1024];
	int i,addr;

	fp1 = fopen("finv_table1.txt","r");
	fp2 = fopen("finv_table2.txt","r");

	for(i=0;i<1024;i++){
		table1[i]=read_nbit(fp1,23);
		table2[i]=read_nbit(fp2,13);
	}

	input = 0x12345678;
	addr = (input & 0x7FE000)>>13; //fsqrtの場合、 addr = (input.int32 & 0xFFC000)>>14;
	output = finv(input,table1[addr], table2[addr]);

	fclose(fp1);
	fclose(fp2);

	return 0;
}

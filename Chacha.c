#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <memory.h>
#include <time.h>

int add(int a, int b){
	unsigned long s = (a+b);
	int sum = s%(1UL<<32);//To ensure that the resulting value remains within 32 bits, since addition must be modulo 2^32
	return sum;
	}
int xor(int a, int b){
	int x = a^b;
	return x;
	}
int shift(int a, int sa){
	unsigned long r = (a<<sa);
	int res = r%(1UL<<32);//To ensure that the result remains within 32 bits
	return res;
	}
int main(){
	int numChar = 16;//The number of characters to be encrypted
	char *kname = "Key.txt";//The name of the file which stores the key words
	int keys[8];
	int i = 0, j = 0;
	FILE *kptr = fopen(kname, "r");
	if(kptr == NULL){
		printf("Cannot open key file. \n");
		exit(0);
		}
	while(i < 8){
		fscanf(kptr, "%d\n", &keys[i]);
		i = i+1;
	}
	fclose(kptr);

	char * nname = "Nonce.txt";//The name of the file which stores the Nonce words
	int nonce[2];
	i = 0;
	FILE *nptr = fopen(nname, "r");
	if(nptr==NULL){
		printf("Cannot open nonce file. \n");
		exit(0);
	}
	while(i < 2){
		fscanf(nptr, "%d\n", &nonce[i]);
		i = i+1;
	}
	fclose(nptr);

	int numblocks = numChar/4;//The number of 32-bit blocks that the input stream comprises of; 1 4-byte block contains 4 characters
	if(numChar%4!=0 && numChar>4){
		numblocks = numblocks+1;
	}
	char *mname = "Plaintext.txt";//The name of the file which stores the plaintext
	int plain;
	int msg[numblocks];
	char m[numblocks];
	i = 0;
	FILE *mptr = fopen(mname, "r");
	if(mptr == NULL){
		printf("Cannot open plaintext file. \n");
		exit(0);
	}
	while(i<numblocks){
		fscanf(mptr, "%d", &msg[i]);
		i = i+1;
	}
	fclose(mptr);

	int matrix[4][4] = {{1634760805, 857760878, 2036477234, 1797285236},{keys[0], keys[1], keys[2], keys[3]},{keys[4], keys[5], keys[6], keys[7]},{1, 0, nonce[0], nonce[1]}};
	int kstream[4][4] = {{1634760805, 857760878, 2036477234, 1797285236},{keys[0], keys[1], keys[2], keys[3]},{keys[4], keys[5], keys[6], keys[7]},{1, 0, nonce[0], nonce[1]}};
	printf("Original matrix is:\n");
	int row, col;
	for(row = 0; row<4; row++){
		for(col = 0; col<4; col++){
			printf("0x%x\t", matrix[row][col]);
		}
		printf("\n");
	}
	clock_t start, end;
 	start = clock();
	int round = 1;
	for(round=1; round<=20; round++){
		int b0, b1, b2, b3;
		int z0, z1, z2, z3;
		int x0, x1, x2, x3;
		int index1, index2, index3, index0;
		for(col=0; col<4; col++){
			if(round%2==1){//For odd-numbered rounds, the operations are column-wise
				index1 = col;
				index0 = col;
				index2 = col;
				index3 = col;
			}
			else{//for even-numbered rounds, the operations are diagonal-wise, going from top to bottom, left to right
				index0 = col;
				index1 = (col+1)%4;
				index2 = (col+2)%4;
				index3 = (col+3)%4;
			}
			x0 = matrix[0][index0]; //get the required elements
			x1 = matrix[1][index1];
			x2 = matrix[2][index2];
			x3 = matrix[3][index3];
			b0 = add(x0, x1); //begin quarter round operations
			b3 = shift(xor(x3, b0), 16);
			b2 = add(x2, b3);
			b1 = shift(xor(x1, b2), 12);
			z0 = add(b0, b1);
			z3 = shift(xor(b3, z0), 8);
			z2 = add(b2, z3);
			z1 = shift(xor(b1, z2), 7);
			matrix[0][index0] = z0;
			matrix[1][index1] = z1;
			matrix[2][index2] = z2;
			matrix[3][index3] = z3;
		}
		printf("After round %d the matrix is:\n", round);
		for(row = 0; row<4; row++){
			for(col = 0; col<4; col++){
				printf("0x%x\t", matrix[row][col]);
			}
			printf("\n");
		}
	}
 	end = clock();
 	float elapsed_time = (float) (end - start); //get the number of clock cycles between start and end
 	printf("Number of clock cycles taken is %f\n", elapsed_time);
	int stream[16];
	int ctr = 0;
	for(i=0; i<4; i++){
		for(j=0; j<4; j++){
			kstream[i][j] = add(kstream[i][j],matrix[i][j]);//Adding the result to the original matrix
			stream[ctr] = kstream[i][j];
			ctr = ctr+1;
		}
	}
	printf("Keystream is:\n");
	for(i=0; i<16; i++){
		printf("0x%x\t", stream[i]);
	}
	printf("\n");
	
	int ciphertext[16];
	printf("Ciphertext is:\n");
	for(i=0; i<16; i++){
		ciphertext[i] = xor(msg[i], stream[i]);//Obtaining the ciphertext
		printf("0x%x\t", ciphertext[i]);
	}
	printf("\n");
	
	exit(EXIT_SUCCESS);
	return 1;
}

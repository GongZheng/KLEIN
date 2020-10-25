#include <stdio.h>
#include <time.h>
//#include "klein.h"
#include "bs_klein64.h"
#include "bs_klein80.h"
#include "bs_klein96.h"
//#include "speedklein64.h"
//#include "speedklein80.h"
//#include "speedklein96.h"

#define EXPERIMENT_TIMES 10000

void klein_testvectors()
{

	uint8_t i;

	//test values
	const uint8_t key8_1[8] = {0};

	const uint8_t key8_2[8] = {
	0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
	};

	const uint8_t key8_3[8] = {
	0x12, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF,
	};


	const uint8_t key10_1[10] = {0};

	const uint8_t key10_2[10] = {
	0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
	};

	const uint8_t key10_3[10] = {
	0x12, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF, 0x12, 0x34,
	};


	const uint8_t key12_1[12] = {0};

	const uint8_t key12_2[12] = {
	0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
	};

	const uint8_t key12_3[12] = {
	0x12, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF, 0x12, 0x34, 0x56, 0x78,
	};

	uint8_t message1[8] = {0};

	uint8_t message2[8] = {
	0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
	};

	uint8_t message3[8] = {
	0x12, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF,
	};

	uint8_t cipher[8];

	printf("============klein-64 test vector===========\n");
	klein64_encrypt(message2, key8_1, cipher);
	for (i = 0; i < 8; i++) {
	    printf("%02X ", cipher[i]);
	}
	printf("\n");

	klein64_encrypt(message1, key8_2, cipher);
	for (i = 0; i < 8; i++) {
	    printf("%02X ", cipher[i]);
	}
	printf("\n");

	klein64_encrypt(message2, key8_3, cipher);
	for (i = 0; i < 8; i++) {
	    printf("%02X ", cipher[i]);
	}
	printf("\n");

	klein64_encrypt(message3, key8_1, cipher);
	for (i = 0; i < 8; i++) {
	    printf("%02X ", cipher[i]);
	}
	printf("\n");

	printf("============klein-80 test vector===========\n");
	klein80_encrypt(message2, key10_1, cipher);
	for (i = 0; i < 8; i++) {
	    printf("%02X ", cipher[i]);
	}
	printf("\n");

	klein80_encrypt(message1, key10_2, cipher);
	for (i = 0; i < 8; i++) {
	    printf("%02X ", cipher[i]);
	}
	printf("\n");

	klein80_encrypt(message2, key10_3, cipher);
	for (i = 0; i < 8; i++) {
	    printf("%02X ", cipher[i]);
	}
	printf("\n");

	klein80_encrypt(message3, key10_1, cipher);
	for (i = 0; i < 8; i++) {
	    printf("%02X ", cipher[i]);
	}
	printf("\n");

	printf("============klein-96 test vector===========\n");
	klein96_encrypt(message2, key12_1, cipher);
	for (i = 0; i < 8; i++) {
	    printf("%02X ", cipher[i]);
	}
	printf("\n");

	klein96_encrypt(message1, key12_2, cipher);
	for (i = 0; i < 8; i++) {
	    printf("%02X ", cipher[i]);
	}
	printf("\n");

	klein96_encrypt(message2, key12_3, cipher);
	for (i = 0; i < 8; i++) {
	    printf("%02X ", cipher[i]);
	}
	printf("\n");

	klein96_encrypt(message3, key12_1, cipher);
	for (i = 0; i < 8; i++) {
	    printf("%02X ", cipher[i]);
	}
	printf("\n");

}

int main(int argc, char **argv)
{

	//klein_testvectors();

	/*
	const uint8_t message[8] = {
	0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
	0x12, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF,
	};
	*/


	//uint8_t cipher[8] = {0};

	//test values
	uint8_t key8[8] = {
	0
    //0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
	//0x12, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF,
	};


	const uint8_t key10[10] = {
	0
	//0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
	//0x12, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF, 0x12, 0x34,
	};


	const uint8_t key12[12] = {
	0
	//0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
	//0x12, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF, 0x12, 0x34, 0x56, 0x78,
	};

	uint8_t message[8] = {
	//0
	//0xFE, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
	0x12, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF,
	};

	//uint8_t message[8] = {0x12, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF,};

    uint8_t cipher[8];

	int i;
	clock_t program_start, program_end = 0;
	program_start = clock();

    //uint8_t ekey[12][8];
    //uint8_t ekey[16][10]; //subkeys for klein_80
    //uint8_t ekey[20][12]; //subkeys for klein_96

    //klein64_expandKey(key8, ekey);
    //klein80_expandKey(key10, ekey);
    //klein96_expandKey(key12, ekey);

	for(i = 0; i < EXPERIMENT_TIMES; i++)
	{
        //klein64_encrypt(message, key8, cipher);
	    //klein80_encrypt(message, key10, cipher);
	    klein96_encrypt(message, key12, cipher);

    }


	program_end = clock();

	printf("The %d times encryptions spend %ld ms\n", i, program_end - program_start);

	for (i = 0; i < 8; i++) {
	    printf("%02X ", cipher[i]);
	}
	printf("\n");

	program_start = clock();

	for(i = 0; i < EXPERIMENT_TIMES; i++)
	{
		//klein64_decrypt(cipher, key8, message);
	    //klein80_decrypt(cipher, key10, message);
		klein96_decrypt(cipher, key12, message);
    }

	program_end = clock();

	printf("The %d times decryptions spend %ld ms\n", i, program_end - program_start);

	for (i = 0; i < 8; i++) {
	    printf("%02X ", message[i]);
		}
	printf("\n");

	return 0;
}

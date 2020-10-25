/*
 * Copyright (c) 2010, University of Twente
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in
 *   the documentation and/or other materials provided with the
 *   distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 * COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
 * ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

/*
 *  speedklein96.h
 *  Description: An 8-bit platform optimized implementation of klein-96
 *  Created on: 2010-4-7
 *  Last modified: 2010-8-18
 *  Author: Zheng Gong
 *
 */
#include "kleinSbox.h"
#ifndef SPEEDKLEIN96_H_
#define SPEEDKLEIN96_H_

//Rounds of klein-96, a final "half" round will be appended after the rounds;
#define ROUNDS_96 20

//the algorithms for the encryption and decryption of klein-96
#define klein96_encrypt(plain, key, cipher) klein96_encrypt_rounds((plain), (key), ROUNDS_96, (cipher))
#define klein96_decrypt(cipher, key, plain) klein96_decrypt_rounds((cipher), (key), ROUNDS_96, (plain))

void klein96_expandKey(const uint8_t *key, uint8_t (*ekey)[12])
{
	uint8_t i;
	uint8_t temp_state[7];

	ekey[0][0] = key[0];
	ekey[0][1] = key[1];
	ekey[0][2] = key[2];
	ekey[0][3] = key[3];
	ekey[0][4] = key[4];
	ekey[0][5] = key[5];
	ekey[0][6] = key[6];
	ekey[0][7] = key[7];
	ekey[0][8] = key[8];
	ekey[0][9] = key[9];
	ekey[0][10] = key[10];
	ekey[0][11] = key[11];


	for(i = 0; i < ROUNDS_96 - 1; i++)
	{
        temp_state[0] = ekey[i][0];
        temp_state[1] = ekey[i][1];
        temp_state[2] = ekey[i][2];
        temp_state[3] = ekey[i][3];
        temp_state[4] = ekey[i][4];
        temp_state[5] = ekey[i][5];
        temp_state[6] = ekey[i][6];

        ekey[i+1][0] = ekey[i][7];
        ekey[i+1][1] = ekey[i][8];
        ekey[i+1][2] = ekey[i][9] ^ (i+1);
        ekey[i+1][3] = ekey[i][10];
        ekey[i+1][4] = ekey[i][11];
        ekey[i+1][5] = ekey[i][6];

        ekey[i+1][6] = temp_state[1] ^ ekey[i][7];
        ekey[i+1][7] = sbox8[temp_state[2] ^ ekey[i][8]];
        ekey[i+1][8] = sbox8[temp_state[3] ^ ekey[i][9]];
        ekey[i+1][9] = temp_state[4] ^ ekey[i][10];
        ekey[i+1][10] = temp_state[5] ^ ekey[i][11];
        ekey[i+1][11] = temp_state[0] ^ temp_state[6];

	}
}

void klein96_encrypt_rounds(const uint8_t *plain, const uint8_t (*ekey)[12], const uint8_t rounds, uint8_t *cipher)
{

		uint8_t state[8];
		uint8_t temp_state[8];
		uint8_t u,v = 0;
		uint8_t i;

		state[0] = plain[0];
		state[1] = plain[1];
		state[2] = plain[2];
		state[3] = plain[3];
		state[4] = plain[4];
		state[5] = plain[5];
		state[6] = plain[6];
		state[7] = plain[7];


		for(i = 0; i < rounds; i++)
		{
			//add round key;
			state[0] = state[0] ^ ekey[i][0];
			state[1] = state[1] ^ ekey[i][1];
			state[2] = state[2] ^ ekey[i][2];
			state[3] = state[3] ^ ekey[i][3];
			state[4] = state[4] ^ ekey[i][4];
			state[5] = state[5] ^ ekey[i][5];
			state[6] = state[6] ^ ekey[i][6];
			state[7] = state[7] ^ ekey[i][7];


			//substitute nibbles with the byte-oriented S-box;
			state[0] = sbox8[state[0]];
			state[1] = sbox8[state[1]];
			state[2] = sbox8[state[2]];
			state[3] = sbox8[state[3]];
			state[4] = sbox8[state[4]];
			state[5] = sbox8[state[5]];
			state[6] = sbox8[state[6]];
			state[7] = sbox8[state[7]];

			//the RotateNibbles step, left shift two bytes;
	        temp_state[0] = state[2];
	        temp_state[1] = state[3];
	        temp_state[2] = state[4];
	        temp_state[3] = state[5];
	        temp_state[4] = state[6];
	        temp_state[5] = state[7];
	        temp_state[6] = state[0];
	        temp_state[7] = state[1];

	        //an efficient MixNibbles implementation for AES, Book Page 54;
            u = temp_state[0] ^ temp_state[1] ^ temp_state[2] ^ temp_state[3];
            v = temp_state[0] ^ temp_state[1];
            v = multiply2[v];
            state[0] = temp_state[0] ^ v ^ u;

            v = temp_state[1] ^ temp_state[2];
            v = multiply2[v];
            state[1] = temp_state[1] ^ v ^ u;

            v = temp_state[2] ^ temp_state[3];
            v = multiply2[v];
            state[2] = temp_state[2] ^ v ^ u;

            v = temp_state[3] ^ temp_state[0];
            v = multiply2[v];
            state[3] = temp_state[3] ^ v ^ u;

            u = temp_state[4] ^ temp_state[5] ^ temp_state[6] ^ temp_state[7];
            v = temp_state[4] ^ temp_state[5];
            v = multiply2[v];
            state[4] = temp_state[4] ^ v ^ u;

            v = temp_state[5] ^ temp_state[6];
            v = multiply2[v];
            state[5] = temp_state[5] ^ v ^ u;

            v = temp_state[6] ^ temp_state[7];
            v = multiply2[v];
            state[6] = temp_state[6] ^ v ^ u;

            v = temp_state[7] ^ temp_state[4];
            v = multiply2[v];
            state[7] = temp_state[7] ^ v ^ u;

	    }

		//output the ciphertext;
		cipher[0] = state[0];
		cipher[1] = state[1];
		cipher[2] = state[2];
		cipher[3] = state[3];
		cipher[4] = state[4];
		cipher[5] = state[5];
		cipher[6] = state[6];
		cipher[7] = state[7];


}

void klein96_decrypt_rounds(const uint8_t *cipher, const uint8_t (*ekey)[12], const uint8_t rounds, uint8_t *plain)
{
	uint8_t state[8];
    uint8_t temp_state[8];
    uint8_t u,v = 0;
	uint8_t i;

	//initialize the state;
	state[0] = cipher[0];
    state[1] = cipher[1];
	state[2] = cipher[2];
	state[3] = cipher[3];
	state[4] = cipher[4];
	state[5] = cipher[5];
	state[6] = cipher[6];
	state[7] = cipher[7];

	//inverse the subsequent rounds
	for(i = 1; i <= rounds; i++)
	{
		//an efficient invMixNibbles implementation for AES, Book Page 55;
		temp_state[0] = state[0];
		temp_state[1] = state[1];
		temp_state[2] = state[2];
		temp_state[3] = state[3];
		temp_state[4] = state[4];
		temp_state[5] = state[5];
		temp_state[6] = state[6];
		temp_state[7] = state[7];

		u = multiply2[multiply2[temp_state[0] ^ temp_state[2]]];
		v = multiply2[multiply2[temp_state[1] ^ temp_state[3]]];

		temp_state[0] = temp_state[0] ^ u;
		temp_state[1] = temp_state[1] ^ v;
		temp_state[2] = temp_state[2] ^ u;
		temp_state[3] = temp_state[3] ^ v;

		u = multiply2[multiply2[temp_state[4] ^ temp_state[6]]];
		v = multiply2[multiply2[temp_state[5] ^ temp_state[7]]];

		temp_state[4] = temp_state[4] ^ u;
		temp_state[5] = temp_state[5] ^ v;
		temp_state[6] = temp_state[6] ^ u;
		temp_state[7] = temp_state[7] ^ v;

        u = temp_state[0] ^ temp_state[1] ^ temp_state[2] ^ temp_state[3];
        v = temp_state[0] ^ temp_state[1];
        v = multiply2[v];
        state[0] = temp_state[0] ^ v ^ u;

        v = temp_state[1] ^ temp_state[2];
        v = multiply2[v];
        state[1] = temp_state[1] ^ v ^ u;

        v = temp_state[2] ^ temp_state[3];
        v = multiply2[v];
        state[2] = temp_state[2] ^ v ^ u;

        v = temp_state[3] ^ temp_state[0];
        v = multiply2[v];
        state[3] = temp_state[3] ^ v ^ u;

        u = temp_state[4] ^ temp_state[5] ^ temp_state[6] ^ temp_state[7];
        v = temp_state[4] ^ temp_state[5];
        v = multiply2[v];
        state[4] = temp_state[4] ^ v ^ u;

        v = temp_state[5] ^ temp_state[6];
        v = multiply2[v];
        state[5] = temp_state[5] ^ v ^ u;

        v = temp_state[6] ^ temp_state[7];
        v = multiply2[v];
        state[6] = temp_state[6] ^ v ^ u;

        v = temp_state[7] ^ temp_state[4];
        v = multiply2[v];
        state[7] = temp_state[7] ^ v ^ u;

		//inverse rotate nibbles
		temp_state[0] = state[6];
		temp_state[1] = state[7];
		state[7] = state[5];
		state[6] = state[4];
		state[5] = state[3];
		state[4] = state[2];
		state[3] = state[1];
		state[2] = state[0];
		state[1] = temp_state[1];
		state[0] = temp_state[0];

        //inverse substitute nibbles;
		state[0] = sbox8[state[0]];
		state[1] = sbox8[state[1]];
		state[2] = sbox8[state[2]];
		state[3] = sbox8[state[3]];
		state[4] = sbox8[state[4]];
		state[5] = sbox8[state[5]];
		state[6] = sbox8[state[6]];
		state[7] = sbox8[state[7]];

		//xor the round key;
		state[0] = state[0] ^ ekey[rounds-i][0];
		state[1] = state[1] ^ ekey[rounds-i][1];
		state[2] = state[2] ^ ekey[rounds-i][2];
		state[3] = state[3] ^ ekey[rounds-i][3];
		state[4] = state[4] ^ ekey[rounds-i][4];
		state[5] = state[5] ^ ekey[rounds-i][5];
		state[6] = state[6] ^ ekey[rounds-i][6];
		state[7] = state[7] ^ ekey[rounds-i][7];


	}

	//output the plaintext;
	plain[0] = state[0];
	plain[1] = state[1];
	plain[2] = state[2];
	plain[3] = state[3];
	plain[4] = state[4];
	plain[5] = state[5];
	plain[6] = state[6];
	plain[7] = state[7];

}
#endif /* SPEEDKLEIN96_H_ */

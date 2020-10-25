/*
 * Copyright (c) 2013, South China Normal University
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
 * kleinSbox.h
 *
 *  Created on: 2013-2-2
 *  Last modified: 2013-2-2
 *  Author: Zheng Gong
 *
 */

#ifndef KLEINSBOX_H_
#define KLEINSBOX_H_

//comment this out if this is used on PC
//#define __UINT_T__
#ifndef __UINT_T__
#define __UINT_T__
typedef unsigned char uint8_t;
typedef short int int8_t;
typedef unsigned short uint16_t;
typedef unsigned long uint32_t;
typedef unsigned long long uint64_t;
#endif /*__UINT_T__*/

/*
 * optimize the 4-bit S-box to a byte-oriented permutation,
 * costs more storage but faster than use the 4-bit S-box.
 *
 */

//substitution box for KLEIN, we note that the sbox is involutive.
/*static const uint8_t hsbox[16] = {
	0x70, 0x40, 0xA0, 0x90, 0x10, 0xF0, 0xB0, 0x00, 0xC0, 0x30, 0x20, 0x60, 0x80, 0xE0, 0xD0, 0x50,
};

//use two S-boxes to save the shift operations during the permutation.
static const uint8_t lsbox[16] = {
	0x07, 0x04, 0x0A, 0x09, 0x01, 0x0F, 0x0B, 0x00, 0x0C, 0x03, 0x02, 0x06, 0x08, 0x0E, 0x0D, 0x05,
};*/

uint8_t sbox(uint8_t input) {
    uint8_t output = 0;
	uint8_t x[4],y[4];
	int i;
	
	for(i = 0; i <=3; i++)
	{
	    //x[i] = (input & (0x01 << i)) >> i;
	    x[i] = (input >> i) & 0x01;
	}
	
	//y0 = 1 + x0 + x1 + x0x2 + x1x2 + x0x1x2 + x3 + x1x3 + x0x1x3
	y[0] = 0x1 ^ x[0] ^ x[1] ^ (x[0] & x[2]) ^ (x[1] & x[2]) ^ (x[0] & x[1] & x[2]) ^ x[3] ^ (x[1] & x[3]) ^ (x[0] & x[1] & x[3]);
	
	//y1 = 1 + x0 + x2 + x1x2 + x3 + x1x3 + x0x1x3 + x2x3
	y[1] = 0x1 ^ x[0] ^ x[2] ^ (x[1] & x[2]) ^ x[3] ^ (x[1] & x[3]) ^ (x[0] & x[1] & x[3]) ^ (x[2] & x[3]);
	
	//y2 = 1 + x1 + x2 + x0x2 + x1x2 + x0x1x2 + x0x3 + x0x2x3 + x1x2x3  
	y[2] = 0x1 ^ x[1] ^ x[2] ^ (x[0] & x[2]) ^ (x[1] & x[2]) ^ (x[0] & x[1] & x[2]) ^ (x[0] & x[3]) ^ (x[0] & x[2] & x[3]) ^ (x[1] & x[2] & x[3]);
	
	 //y3 = x1 + x0x2 + x3 + x0x3 + x0x1x3 + x1x2x3
	y[3] = x[1] ^ (x[0] & x[2]) ^ x[3] ^ (x[0] & x[3]) ^ (x[0] & x[1] & x[3]) ^ (x[1] & x[2] & x[3]);
	
	
	for(i = 0; i <=3; i++)
	{
	    output = output ^ (y[i] << i);
	}
	
    return output;
}

uint8_t sbox8(uint8_t input) {
    uint8_t output = 0;
	uint8_t x[8],y[8];
	int i;
	
	for(i = 0; i <=7; i++)
	{
	    //x[i] = (input & (0x01 << i)) >> i;
	    x[i] = (input >> i) & 0x01;
	}
	
	//y0 = 1 + x0 + x1 + x0x2 + x1x2 + x0x1x2 + x3 + x1x3 + x0x1x3
	y[0] = 0x1 ^ x[0] ^ x[1] ^ (x[0] & x[2]) ^ (x[1] & x[2]) ^ (x[0] & x[1] & x[2]) ^ x[3] ^ (x[1] & x[3]) ^ (x[0] & x[1] & x[3]);
	
	//y1 = 1 + x0 + x2 + x1x2 + x3 + x1x3 + x0x1x3 + x2x3
	y[1] = 0x1 ^ x[0] ^ x[2] ^ (x[1] & x[2]) ^ x[3] ^ (x[1] & x[3]) ^ (x[0] & x[1] & x[3]) ^ (x[2] & x[3]);
	
	//y2 = 1 + x1 + x2 + x0x2 + x1x2 + x0x1x2 + x0x3 + x0x2x3 + x1x2x3  
	y[2] = 0x1 ^ x[1] ^ x[2] ^ (x[0] & x[2]) ^ (x[1] & x[2]) ^ (x[0] & x[1] & x[2]) ^ (x[0] & x[3]) ^ (x[0] & x[2] & x[3]) ^ (x[1] & x[2] & x[3]);
	
    //y3 = x1 + x0x2 + x3 + x0x3 + x0x1x3 + x1x2x3
	y[3] = x[1] ^ (x[0] & x[2]) ^ x[3] ^ (x[0] & x[3]) ^ (x[0] & x[1] & x[3]) ^ (x[1] & x[2] & x[3]);
	
	//y4 = 1 + x4 + x5 + x4x6 + x5x6 + x4x5x6 + x7 + x5x7 + x4x5x7
	y[4] = 0x1 ^ x[4] ^ x[5] ^ (x[4] & x[6]) ^ (x[5] & x[6]) ^ (x[4] & x[5] & x[6]) ^ x[7] ^ (x[5] & x[7]) ^ (x[4] & x[5] & x[7]);
	
	//y5 = 1 + x4 + x6 + x5x6 + x7 + x5x7 + x4x5x7 + x6x7
	y[5] = 0x1 ^ x[4] ^ x[6] ^ (x[5] & x[6]) ^ x[7] ^ (x[5] & x[7]) ^ (x[4] & x[5] & x[7]) ^ (x[6] & x[7]);
	
	//y6 = 1 + x5 + x6 + x4x6 + x5x6 + x4x5x6 + x4x7 + x4x6x7 + x5x6x7
	y[6] = 0x1 ^ x[5] ^ x[6] ^ (x[4] & x[6]) ^ (x[5] & x[6]) ^ (x[4] & x[5] & x[6]) ^ (x[4] & x[7]) ^ (x[4] & x[6] & x[7]) ^ (x[5] & x[6] & x[7]);
	
	//y7 = x5 + x4x6 + x7 + x4x7 + x4x5x7 + x5x6x7
	y[7] = x[5] ^ (x[4] & x[6]) ^ x[7] ^ (x[4] & x[7]) ^ (x[4] & x[5] & x[7]) ^ (x[5] & x[6] & x[7]);
	
	for(i = 0; i <=7; i++)
	{
	    output = output ^ (y[i] << i);
	}
	
    return output;
}

/*static const uint8_t sbox8[256] = {
		0x77, 0x74, 0x7A, 0x79, 0x71, 0x7F, 0x7B, 0x70, 0x7C, 0x73, 0x72, 0x76, 0x78, 0x7E, 0x7D, 0x75,
		0x47, 0x44, 0x4A, 0x49, 0x41, 0x4F, 0x4B, 0x40, 0x4C, 0x43, 0x42, 0x46, 0x48, 0x4E, 0x4D, 0x45,
		0xA7, 0xA4, 0xAA, 0xA9, 0xA1, 0xAF, 0xAB, 0xA0, 0xAC, 0xA3, 0xA2, 0xA6, 0xA8, 0xAE, 0xAD, 0xA5,
		0x97, 0x94, 0x9A, 0x99, 0x91, 0x9F, 0x9B, 0x90, 0x9C, 0x93, 0x92, 0x96, 0x98, 0x9E, 0x9D, 0x95,
		0x17, 0x14, 0x1A, 0x19, 0x11, 0x1F, 0x1B, 0x10, 0x1C, 0x13, 0x12, 0x16, 0x18, 0x1E, 0x1D, 0x15,
		0xF7, 0xF4, 0xFA, 0xF9, 0xF1, 0xFF, 0xFB, 0xF0, 0xFC, 0xF3, 0xF2, 0xF6, 0xF8, 0xFE, 0xFD, 0xF5,
		0xB7, 0xB4, 0xBA, 0xB9, 0xB1, 0xBF, 0xBB, 0xB0, 0xBC, 0xB3, 0xB2, 0xB6, 0xB8, 0xBE, 0xBD, 0xB5,
		0x07, 0x04, 0x0A, 0x09, 0x01, 0x0F, 0x0B, 0x00, 0x0C, 0x03, 0x02, 0x06, 0x08, 0x0E, 0x0D, 0x05,
		0xC7, 0xC4, 0xCA, 0xC9, 0xC1, 0xCF, 0xCB, 0xC0, 0xCC, 0xC3, 0xC2, 0xC6, 0xC8, 0xCE, 0xCD, 0xC5,
		0x37, 0x34, 0x3A, 0x39, 0x31, 0x3F, 0x3B, 0x30, 0x3C, 0x33, 0x32, 0x36, 0x38, 0x3E, 0x3D, 0x35,
		0x27, 0x24, 0x2A, 0x29, 0x21, 0x2F, 0x2B, 0x20, 0x2C, 0x23, 0x22, 0x26, 0x28, 0x2E, 0x2D, 0x25,
		0x67, 0x64, 0x6A, 0x69, 0x61, 0x6F, 0x6B, 0x60, 0x6C, 0x63, 0x62, 0x66, 0x68, 0x6E, 0x6D, 0x65,
		0x87, 0x84, 0x8A, 0x89, 0x81, 0x8F, 0x8B, 0x80, 0x8C, 0x83, 0x82, 0x86, 0x88, 0x8E, 0x8D, 0x85,
		0xE7, 0xE4, 0xEA, 0xE9, 0xE1, 0xEF, 0xEB, 0xE0, 0xEC, 0xE3, 0xE2, 0xE6, 0xE8, 0xEE, 0xED, 0xE5,
		0xD7, 0xD4, 0xDA, 0xD9, 0xD1, 0xDF, 0xDB, 0xD0, 0xDC, 0xD3, 0xD2, 0xD6, 0xD8, 0xDE, 0xDD, 0xD5,
		0x57, 0x54, 0x5A, 0x59, 0x51, 0x5F, 0x5B, 0x50, 0x5C, 0x53, 0x52, 0x56, 0x58, 0x5E, 0x5D, 0x55,
};*/

//Tables for the MixNibbles step
//Look-up table for 2 * x
/*static const uint8_t multiply2[256] = {
		0x00, 0x02, 0x04, 0x06, 0x08, 0x0a, 0x0c, 0x0e, 0x10, 0x12, 0x14, 0x16, 0x18, 0x1a, 0x1c, 0x1e,
		0x20, 0x22, 0x24, 0x26, 0x28, 0x2a, 0x2c, 0x2e, 0x30, 0x32, 0x34, 0x36, 0x38, 0x3a, 0x3c, 0x3e,
		0x40, 0x42, 0x44, 0x46, 0x48, 0x4a, 0x4c, 0x4e, 0x50, 0x52, 0x54, 0x56, 0x58, 0x5a, 0x5c, 0x5e,
		0x60, 0x62, 0x64, 0x66, 0x68, 0x6a, 0x6c, 0x6e, 0x70, 0x72, 0x74, 0x76, 0x78, 0x7a, 0x7c, 0x7e,
		0x80, 0x82, 0x84, 0x86, 0x88, 0x8a, 0x8c, 0x8e, 0x90, 0x92, 0x94, 0x96, 0x98, 0x9a, 0x9c, 0x9e,
		0xa0, 0xa2, 0xa4, 0xa6, 0xa8, 0xaa, 0xac, 0xae, 0xb0, 0xb2, 0xb4, 0xb6, 0xb8, 0xba, 0xbc, 0xbe,
		0xc0, 0xc2, 0xc4, 0xc6, 0xc8, 0xca, 0xcc, 0xce, 0xd0, 0xd2, 0xd4, 0xd6, 0xd8, 0xda, 0xdc, 0xde,
		0xe0, 0xe2, 0xe4, 0xe6, 0xe8, 0xea, 0xec, 0xee, 0xf0, 0xf2, 0xf4, 0xf6, 0xf8, 0xfa, 0xfc, 0xfe,
		0x1b, 0x19, 0x1f, 0x1d, 0x13, 0x11, 0x17, 0x15, 0x0b, 0x09, 0x0f, 0x0d, 0x03, 0x01, 0x07, 0x05,
		0x3b, 0x39, 0x3f, 0x3d, 0x33, 0x31, 0x37, 0x35, 0x2b, 0x29, 0x2f, 0x2d, 0x23, 0x21, 0x27, 0x25,
		0x5b, 0x59, 0x5f, 0x5d, 0x53, 0x51, 0x57, 0x55, 0x4b, 0x49, 0x4f, 0x4d, 0x43, 0x41, 0x47, 0x45,
		0x7b, 0x79, 0x7f, 0x7d, 0x73, 0x71, 0x77, 0x75, 0x6b, 0x69, 0x6f, 0x6d, 0x63, 0x61, 0x67, 0x65,
		0x9b, 0x99, 0x9f, 0x9d, 0x93, 0x91, 0x97, 0x95, 0x8b, 0x89, 0x8f, 0x8d, 0x83, 0x81, 0x87, 0x85,
		0xbb, 0xb9, 0xbf, 0xbd, 0xb3, 0xb1, 0xb7, 0xb5, 0xab, 0xa9, 0xaf, 0xad, 0xa3, 0xa1, 0xa7, 0xa5,
		0xdb, 0xd9, 0xdf, 0xdd, 0xd3, 0xd1, 0xd7, 0xd5, 0xcb, 0xc9, 0xcf, 0xcd, 0xc3, 0xc1, 0xc7, 0xc5,
		0xfb, 0xf9, 0xff, 0xfd, 0xf3, 0xf1, 0xf7, 0xf5, 0xeb, 0xe9, 0xef, 0xed, 0xe3, 0xe1, 0xe7, 0xe5,
};*/

uint8_t xtime(uint8_t input)
{
    return (input<<1) ^ (((input>>7) & 1) * 0x1b);
	
	//if((input & 0x80) == 0)
	//   return (input << 1) ^ 0x00;
	//else
	//   return (input << 1) ^ 0x1B;
}

//bitsliced MixNibbles for two 4-bytes vectors, like KLEIN;
void bt_MixNibbles(uint8_t *state)
{
	uint8_t bt_state[64], temp[64];
	int i,j;
	
	for(i = 0; i < 8; i++)
	{
		for(j = 0; j < 8; j++)
		{
		    bt_state[j + (i * 8)] = (state[i] >> j) & 0x01;
		}
	}
	

	//bij|0 = a(i)4j |7 ¨’a(i+1)4j |0 ¨’ a(i+1)4j|7 ¨’a(i+2)4j|0 ¨’a(i+3)4j |0
    //bij|1 = a(i)4j |0 ¨’ a(i)4j|7 ¨’a(i+1)4j |0 ¨’ a(i+1)4j|1 ¨’ a(i+1)4j |7 ¨’a(i+2)4j|1 ¨’a(i+3)4j |1
    //bij|2 = a(i)4j |1 ¨’a(i+1)4j |1 ¨’ a(i+1)4j|2 ¨’a(i+2)4j|2 ¨’a(i+3)4j |2
    //bij|3 = a(i)4j |2 ¨’ a(i)4j|7 ¨’a(i+1)4j |2 ¨’ a(i+1)4j|3 ¨’ a(i+1)4j |7 ¨’a(i+2)4j|3 ¨’a(i+3)4j |3
    //bij|4 = a(i)4j |3 ¨’ a(i)4j|7 ¨’a(i+1)4j |3 ¨’ a(i+1)4j|4 ¨’ a(i+1)4j |7 ¨’a(i+2)4j|4 ¨’a(i+3)4j |4
    //bij|5 = a(i)4j |4 ¨’a(i+1)4j |4 ¨’ a(i+1)4j|5 ¨’a(i+2)4j|5 ¨’a(i+3)4j |5
    //bij|6 = a(i)4j |5 ¨’a(i+1)4j |5 ¨’ a(i+1)4j|6 ¨’a(i+2)4j|6 ¨’a(i+3)4j |6
    //bij|7 = a(i)4j |6 ¨’a(i+1)4j |6 ¨’ a(i+1)4j|7 ¨’a(i+2)4j|7 ¨’a(i+3)4j |7
    
    for(j = 0; j < 2; j++)
    {
    	for(i = 0; i < 4; i++)
    	{
    		temp[i * 8 + j * 32] = bt_state[(i * 8 + j * 32) + 7] ^ bt_state[((i+1)%4) * 8 + j*32] 
	                  ^ bt_state[((i+1)%4) * 8 + j*32 + 7] ^ bt_state[((i+2)%4) * 8 + j*32] ^ bt_state[((i+3)%4) * 8 + j*32];
    		
    		temp[1 + (i * 8 + j * 32)] = bt_state[(i * 8 + j * 32)] ^ bt_state[(i * 8 + j * 32) + 7] ^ bt_state[((i+1)%4) * 8 + j*32] ^ bt_state[((i+1)%4) * 8 + j*32 + 1]
	                  ^ bt_state[((i+1)%4) * 8 + j*32 + 7] ^ bt_state[((i+2)%4) * 8 + j*32 + 1] ^ bt_state[((i+3)%4) * 8 + j*32 + 1];
    		
    		temp[2 + (i * 8 + j * 32)] = bt_state[(i * 8 + j * 32) + 1] ^ bt_state[((i+1)%4) * 8 + j*32 + 1] 
	                  ^ bt_state[((i+1)%4) * 8 + j*32 + 2] ^ bt_state[((i+2)%4) * 8 + j*32 + 2] ^ bt_state[((i+3)%4) * 8 + j*32 + 2];
    		
    		temp[3 + (i * 8 + j * 32)] = bt_state[(i * 8 + j * 32) + 2] ^ bt_state[(i * 8 + j * 32) + 7] ^ bt_state[((i+1)%4) * 8 + j*32 + 2] 
	                  ^ bt_state[((i+1)%4) * 8 + j*32 + 3] ^ bt_state[((i+1)%4) * 8 + j*32 + 7] ^ bt_state[((i+2)%4) * 8 + j*32 + 3] ^ bt_state[((i+3)%4) * 8 + j*32 + 3];
    		
    		temp[4 + (i * 8 + j * 32)] =  bt_state[(i * 8 + j * 32) + 3] ^ bt_state[(i * 8 + j * 32) + 7] ^ bt_state[((i+1)%4) * 8 + j*32 + 3] 
	                  ^ bt_state[((i+1)%4) * 8 + j*32 + 4] ^ bt_state[((i+1)%4) * 8 + j*32 + 7] ^ bt_state[((i+2)%4) * 8 + j*32 + 4] ^ bt_state[((i+3)%4) * 8 + j*32 + 4];
    		
    		temp[5 + (i * 8 + j * 32)] = bt_state[(i * 8 + j * 32) + 4] ^ bt_state[((i+1)%4) * 8 + j*32 + 4] 
	                  ^ bt_state[((i+1)%4) * 8 + j*32 + 5] ^ bt_state[((i+2)%4) * 8 + j*32 + 5] ^ bt_state[((i+3)%4) * 8 + j*32 + 5];
    		
    		temp[6 + (i * 8 + j * 32)] = bt_state[(i * 8 + j * 32) + 5] ^ bt_state[((i+1)%4) * 8 + j*32 + 5] 
	                  ^ bt_state[((i+1)%4) * 8 + j*32 + 6] ^ bt_state[((i+2)%4) * 8 + j*32 + 6] ^ bt_state[((i+3)%4) * 8 + j*32 + 6];
    		
    		temp[7 + (i * 8 + j * 32)] = bt_state[(i * 8 + j * 32) + 6] ^ bt_state[((i+1)%4) * 8 + j*32 + 6] 
	                  ^ bt_state[((i+1)%4) * 8 + j*32 + 7] ^ bt_state[((i+2)%4) * 8 + j*32 + 7] ^ bt_state[((i+3)%4) * 8 + j*32 + 7];
    	}
    }
	
	
/*	for(i = 0; i < 8; i++)
	{
	    temp[i * 8] = bt_state[(i * 8) + 7] ^ bt_state[(((i + 1) % 8) * 8)] 
	                  ^ bt_state[(((i + 1) % 8) * 8) + 7] ^ bt_state[(((i + 2) % 8) * 8)] ^ bt_state[(((i + 3) % 8) * 8)];
     
        temp[1 + i * 8] = bt_state[(i * 8)] ^ bt_state[(i * 8) + 7] ^ bt_state[(((i + 1) % 8) * 8)] ^ bt_state[(((i + 1) % 8) * 8) + 1]
	                  ^ bt_state[(((i + 1) % 8) * 8) + 7] ^ bt_state[(((i + 2) % 8) * 8) + 1] ^ bt_state[(((i + 3) % 8) * 8) + 1];
	                  
        temp[2 + i * 8] = bt_state[(i * 8) + 1] ^ bt_state[(((i + 1) % 8) * 8) + 1] 
	                  ^ bt_state[(((i + 1) % 8) * 8) + 2] ^ bt_state[(((i + 2) % 8) * 8) + 2] ^ bt_state[(((i + 3) % 8) * 8) + 2];
	                  
        temp[3 + i * 8] = bt_state[(i * 8) + 2] ^ bt_state[(i * 8) + 7] ^ bt_state[(((i + 1) % 8) * 8) + 2] 
	                  ^ bt_state[(((i + 1) % 8) * 8) + 3] ^ bt_state[(((i + 1) % 8) * 8) + 7] ^ bt_state[(((i + 2) % 8) * 8) + 3] ^ bt_state[(((i + 3) % 8) * 8) + 3];
	                  
        temp[4 + i * 8] = bt_state[(i * 8) + 3] ^ bt_state[(i * 8) + 7] ^ bt_state[(((i + 1) % 8) * 8) + 3] 
	                  ^ bt_state[(((i + 1) % 8) * 8) + 4] ^ bt_state[(((i + 1) % 8) * 8) + 7] ^ bt_state[(((i + 2) % 8) * 8) + 4] ^ bt_state[(((i + 3) % 8) * 8) + 4];
	                  
        temp[5 + i * 8] = bt_state[(i * 8) + 4] ^ bt_state[(((i + 1) % 8) * 8) + 4] 
	                  ^ bt_state[(((i + 1) % 8) * 8) + 5] ^ bt_state[(((i + 2) % 8) * 8) + 5] ^ bt_state[(((i + 3) % 8) * 8) + 5];
	                  
        temp[6 + i * 8] = bt_state[(i * 8) + 5] ^ bt_state[(((i + 1) % 8) * 8) + 5] 
	                  ^ bt_state[(((i + 1) % 8) * 8) + 6] ^ bt_state[(((i + 2) % 8) * 8) + 6] ^ bt_state[(((i + 3) % 8) * 8) + 6];
     
        temp[7 + i * 8] = bt_state[(i * 8) + 6] ^ bt_state[(((i + 1) % 8) * 8) + 6] 
	                  ^ bt_state[(((i + 1) % 8) * 8) + 7] ^ bt_state[(((i + 2) % 8) * 8) + 7] ^ bt_state[(((i + 3) % 8) * 8) + 7];
	                  
	                  
	}
*/	
	
	
	for(i = 0; i < 8; i++)
	{
		state[i] = 0;
		
		for(j = 0; j < 8; j++)
		{
			if(temp[i * 8 + j])
			{
		    	state[i] = state[i] ^ (temp[i * 8 + j] << j);
			}
		}
	}
}

//bitsliced MixNibbles for 4-bytes vector
/*void bt_MixNibbles(uint8_t *state)
{
	uint8_t bt_state[32], temp[32];
	int i,j;
	
	for(i = 0; i < 4; i++)
	{
		for(j = 0; j < 8; j++)
		{
		    bt_state[j + (i * 8)] = (state[i] >> j) & 0x01;
		}
	}
	
	//bij|0 = a(i)4j |7 ¨’a(i+1)4j |0 ¨’ a(i+1)4j|7 ¨’a(i+2)4j|0 ¨’a(i+3)4j |0
    //bij|1 = a(i)4j |0 ¨’ a(i)4j|7 ¨’a(i+1)4j |0 ¨’ a(i+1)4j|1 ¨’ a(i+1)4j |7 ¨’a(i+2)4j|1 ¨’a(i+3)4j |1
    //bij|2 = a(i)4j |1 ¨’a(i+1)4j |1 ¨’ a(i+1)4j|2 ¨’a(i+2)4j|2 ¨’a(i+3)4j |2
    //bij|3 = a(i)4j |2 ¨’ a(i)4j|7 ¨’a(i+1)4j |2 ¨’ a(i+1)4j|3 ¨’ a(i+1)4j |7 ¨’a(i+2)4j|3 ¨’a(i+3)4j |3
    //bij|4 = a(i)4j |3 ¨’ a(i)4j|7 ¨’a(i+1)4j |3 ¨’ a(i+1)4j|4 ¨’ a(i+1)4j |7 ¨’a(i+2)4j|4 ¨’a(i+3)4j |4
    //bij|5 = a(i)4j |4 ¨’a(i+1)4j |4 ¨’ a(i+1)4j|5 ¨’a(i+2)4j|5 ¨’a(i+3)4j |5
    //bij|6 = a(i)4j |5 ¨’a(i+1)4j |5 ¨’ a(i+1)4j|6 ¨’a(i+2)4j|6 ¨’a(i+3)4j |6
    //bij|7 = a(i)4j |6 ¨’a(i+1)4j |6 ¨’ a(i+1)4j|7 ¨’a(i+2)4j|7 ¨’a(i+3)4j |7
	
	
	for(i = 0; i < 4; i++)
	{
	    temp[i * 8] = bt_state[(i * 8) + 7] ^ bt_state[(((i + 1) % 4) * 8)] 
	                  ^ bt_state[(((i + 1) % 4) * 8) + 7] ^ bt_state[(((i + 2) % 4) * 8)] ^ bt_state[(((i + 3) % 4) * 8)];
     
        temp[1 + i * 8] = bt_state[(i * 8)] ^ bt_state[(i * 8) + 7] ^ bt_state[(((i + 1) % 4) * 8)] ^ bt_state[(((i + 1) % 4) * 8) + 1]
	                  ^ bt_state[(((i + 1) % 4) * 8) + 7] ^ bt_state[(((i + 2) % 4) * 8) + 1] ^ bt_state[(((i + 3) % 4) * 8) + 1];
	                  
        temp[2 + i * 8] = bt_state[(i * 8) + 1] ^ bt_state[(((i + 1) % 4) * 8) + 1] 
	                  ^ bt_state[(((i + 1) % 4) * 8) + 2] ^ bt_state[(((i + 2) % 4) * 8) + 2] ^ bt_state[(((i + 3) % 4) * 8) + 2];
	                  
        temp[3 + i * 8] = bt_state[(i * 8) + 2] ^ bt_state[(i * 8) + 7] ^ bt_state[(((i + 1) % 4) * 8) + 2] 
	                  ^ bt_state[(((i + 1) % 4) * 8) + 3] ^ bt_state[(((i + 1) % 4) * 8) + 7] ^ bt_state[(((i + 2) % 4) * 8) + 3] ^ bt_state[(((i + 3) % 4) * 8) + 3];
	                  
        temp[4 + i * 8] = bt_state[(i * 8) + 3] ^ bt_state[(i * 8) + 7] ^ bt_state[(((i + 1) % 4) * 8) + 3] 
	                  ^ bt_state[(((i + 1) % 4) * 8) + 4] ^ bt_state[(((i + 1) % 4) * 8) + 7] ^ bt_state[(((i + 2) % 4) * 8) + 4] ^ bt_state[(((i + 3) % 4) * 8) + 4];
	                  
        temp[5 + i * 8] = bt_state[(i * 8) + 4] ^ bt_state[(((i + 1) % 4) * 8) + 4] 
	                  ^ bt_state[(((i + 1) % 4) * 8) + 5] ^ bt_state[(((i + 2) % 4) * 8) + 5] ^ bt_state[(((i + 3) % 4) * 8) + 5];
	                  
        temp[6 + i * 8] = bt_state[(i * 8) + 5] ^ bt_state[(((i + 1) % 4) * 8) + 5] 
	                  ^ bt_state[(((i + 1) % 4) * 8) + 6] ^ bt_state[(((i + 2) % 4) * 8) + 6] ^ bt_state[(((i + 3) % 4) * 8) + 6];
     
        temp[7 + i * 8] = bt_state[(i * 8) + 6] ^ bt_state[(((i + 1) % 4) * 8) + 6] 
	                  ^ bt_state[(((i + 1) % 4) * 8) + 7] ^ bt_state[(((i + 2) % 4) * 8) + 7] ^ bt_state[(((i + 3) % 4) * 8) + 7];
	                  
	                  
	}
	
	
	
	for(i = 0; i < 4; i++)
	{
		state[i] = 0;
		
		for(j = 0; j < 8; j++)
		{
			if(temp[i * 8 + j])
			{
		    	state[i] = state[i] ^ (temp[i * 8 + j] << j);
			}
		}
	}
}
*/
#endif /* KLEINSBOX_H_ */

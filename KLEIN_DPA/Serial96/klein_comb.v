//////////////////////////////////////////////////
// KLEIN combinational module
//
module  klein_comb  ( inp, key, round0, round1, round, sels, selk, out, ck ) ;


input   [0:7]   inp ;  // state input from state register
input   [0:7]   key ;
input   [0:3]   sels;
input   [0:4]   selk;
input           round0;
input           round1;
input   [0:4]   round;
input   ck;

output  [0:7]   out;

reg     [0:12*8-1]   state ;
reg     [0:13*8-1]    keys;
wire    [0:12*8-1]   nstate ;
wire    [0:13*8-1]    nkeys;
wire    [0:3]        sbin1;
wire    [0:3]        sbin2;
wire    [0:3]        sbin3;
wire    [0:3]        sbin4;
wire    [0:3]        sbout3;
wire    [0:3]        sbout4;
wire    [0:7]        r9in;
wire    [0:7]        r9out;
wire    [0:7]        r10in;
wire    [0:7]        r11in;
wire    [0:7]        r0temp;
wire    [0:7]        k0temp;


///State 
assign sbin1= sels[0] ? state[56:59]  : state[0:3];
assign sbin2= sels[0] ? state[60:63]  : state[4:7];

sbox  sb1( .a(sbin1) , .y(nstate[8:11]));
sbox  sb2( .a(sbin2) , .y(nstate[12:15]));

assign r0temp = round0 ? inp : state[88:95];
assign nstate[0:7]  = r0temp ^ nkeys[0:7];
assign nstate[16:47]= state[8:39]; 

assign nstate[48:55]= sels[0] ? state[0:7] : state[56:63];
assign nstate[56:63] = state[48:55];

assign nstate[64:71]  =  { state[9:15] , 1'b0 }  ^  { 3'b000 , state[8] , state[8] , 1'b0 , state[8] , state[8] } ; 

assign r9in=sels[1] ? state[40:47] : state[8:15];

assign r9out  =  r9in  ^  { r9in[1:7] , 1'b0 }  ^  { 3'b000 , r9in[0] , r9in[0] , 1'b0 , r9in[0] , r9in[0] } ; 
assign nstate[72:79]= r9out ^ state[64:71];

assign r10in= sels[2] ? state[40:47] : state[8:15];
assign nstate[80:87]=state[72:79]^r10in;

assign r11in= sels[3] ? state[40:47] : state[8:15];
assign nstate[88:95]= state[80:87]^r11in;

always  @ ( posedge ck )  state  <=  nstate ;
  
//Key  
assign sbin3= keys[72:75];
assign sbin4= keys[76:79];

sbox sb3(.a(sbin3), .y(sbout3));
sbox sb4(.a(sbin4), .y(sbout4));

assign k0temp =  round0 ? key : (selk[0] ? keys[48:55] : (selk[1] ? keys[96:103]: keys[0:7]));
assign nkeys[0:7] = selk[4] ? (k0temp^{3'b000 , round}) : k0temp ;
assign nkeys[8:47] = keys[0:39];
assign nkeys[48:55] = round0 ? (key^keys[40:47]) : (selk[2] ? (selk[3] ? (keys[40:47]^keys[96:103]) : keys[40:47]) : (selk[3] ? (round1 ? (key^keys[40:47]) : (keys[88:95]^keys[40:47])) : (round1 ? (key^keys[40:47]) : (keys[40:47]^keys[96:103]))));
assign nkeys[56:63]= selk[0] ? keys[96:103] : keys[48:55];
assign nkeys[64:71] = keys[56:63];
assign nkeys[72:79] = (selk[0:1]==2'b00) ? keys[72:79] : keys[64:71];
assign nkeys[80:87] = (selk[0:1]==2'b00) ? keys[80:87] : ((selk[2:3]==2'b10) ? {sbout3, sbout4} : keys[72:79]);
assign nkeys[88:95] = (selk[0:1]==2'b00) ? keys[88:95] : keys[80:87];
assign nkeys[96:103] = selk[2] ? keys[88:95] : (selk[3] ? (round1 ? key : keys[88:95]) : (round1 ? key : keys[96:103]));

always  @ ( posedge ck )  keys  <=  nkeys ;
  
assign out=nstate[0:7];  

endmodule

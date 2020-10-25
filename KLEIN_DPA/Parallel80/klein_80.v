//////////////////////////////////////////////////
// Top level module for KLEIN-80
//
module  klein_80  ( start , inp , key , ck , ready , out ) ;


input   start ;
input   [0:63]  inp ;  // Data input
input   [0:79]  key ;  // Key input
input   ck ; // Rising edge clock

output  ready ;
output  [0:63]  out ;  // Data output

reg     [0:4]   round ;
reg     [0:63]  state ;
reg     [0:79]  kstate ;
wire    [0:63]  nstate  ;
wire    [0:79]  nkstate ;
wire    [0:63]  ssum , ssubs , srot ;
wire    [0:7]   sa  [0:7] ;
wire    [0:7]   sb  [0:7] ;
wire    [0:79]  krot , kfei ;


// Control
//
always  @ ( posedge ck )
  if  ( start )  round  <=  0 ;
  else           round  <=  round  +  1 ;
//
assign  ready  =  ( round == 15 ) ;


// State register
//
always  @ ( posedge ck )
  if  ( start )  state  <=  inp ;
  else           state  <=  nstate ;


// Key register
//
always  @ ( posedge ck )
  if  ( start )  kstate  <=  key;
  else           kstate  <=  nkstate ;


// AddKeys
//
assign  ssum  =  state  ^  kstate[0:63] ;

//Sboxes
//
sbox  s1  ( .a( ssum[0:3] ) , .y( ssubs[0:3] )  ) ;
sbox  s2  ( .a( ssum[4:7] ) , .y( ssubs[4:7] )  ) ;
sbox  s3  ( .a( ssum[8:11] ) , .y( ssubs[8:11] )  ) ;
sbox  s4  ( .a( ssum[12:15] ) , .y( ssubs[12:15] )  ) ;
sbox  s5  ( .a( ssum[16:19] ) , .y( ssubs[16:19] )  ) ;
sbox  s6  ( .a( ssum[20:23] ) , .y( ssubs[20:23] )  ) ;
sbox  s7  ( .a( ssum[24:27] ) , .y( ssubs[24:27] )  ) ;
sbox  s8  ( .a( ssum[28:31] ) , .y( ssubs[28:31] )  ) ;
sbox  s9  ( .a( ssum[32:35] ) , .y( ssubs[32:35] )  ) ;
sbox  s10  ( .a( ssum[36:39] ) , .y( ssubs[36:39] )  ) ;
sbox  s11  ( .a( ssum[40:43] ) , .y( ssubs[40:43] )  ) ;
sbox  s12  ( .a( ssum[44:47] ) , .y( ssubs[44:47] )  ) ;
sbox  s13  ( .a( ssum[48:51] ) , .y( ssubs[48:51] )  ) ;
sbox  s14  ( .a( ssum[52:55] ) , .y( ssubs[52:55] )  ) ;
sbox  s15  ( .a( ssum[56:59] ) , .y( ssubs[56:59] )  ) ;
sbox  s16  ( .a( ssum[60:63] ) , .y( ssubs[60:63] )  ) ;

// RotateNibbles
//
assign  srot  =  { ssubs[16:63] , ssubs[0:15] } ;


// MixNibbles
//
assign  sa[0]  =  srot[00:07] ;
assign  sa[1]  =  srot[08:15] ;
assign  sa[2]  =  srot[16:23] ;
assign  sa[3]  =  srot[24:31] ;
assign  sa[4]  =  srot[32:39] ;
assign  sa[5]  =  srot[40:47] ;
assign  sa[6]  =  srot[48:55] ;
assign  sa[7]  =  srot[56:63] ;
//
assign  sb[0]  =  {sa[0][1:7], 1'b0}  ^  { 3'b000 , sa[0][0] , sa[0][0] , 1'b0 , sa[0][0] , sa[0][0] }
               ^  {sa[1][1:7], 1'b0}  ^  { 3'b000 , sa[1][0] , sa[1][0] , 1'b0 , sa[1][0] , sa[1][0] }
               ^  sa[1]  ^  sa[2]  ^  sa[3] ;
assign  sb[1]  =  {sa[1][1:7], 1'b0}  ^  { 3'b000 , sa[1][0] , sa[1][0] , 1'b0 , sa[1][0] , sa[1][0] }
               ^  {sa[2][1:7], 1'b0}  ^  { 3'b000 , sa[2][0] , sa[2][0] , 1'b0 , sa[2][0] , sa[2][0] }
               ^  sa[2]  ^  sa[3]  ^  sa[0] ;
assign  sb[2]  =  {sa[2][1:7], 1'b0}  ^  { 3'b000 , sa[2][0] , sa[2][0] , 1'b0 , sa[2][0] , sa[2][0] }
               ^  {sa[3][1:7], 1'b0}  ^  { 3'b000 , sa[3][0] , sa[3][0] , 1'b0 , sa[3][0] , sa[3][0] }
               ^  sa[3]  ^  sa[0]  ^  sa[1] ;
assign  sb[3]  =  {sa[3][1:7], 1'b0}  ^  { 3'b000 , sa[3][0] , sa[3][0] , 1'b0 , sa[3][0] , sa[3][0] }
               ^  {sa[0][1:7], 1'b0}  ^  { 3'b000 , sa[0][0] , sa[0][0] , 1'b0 , sa[0][0] , sa[0][0] }
               ^  sa[0]  ^  sa[1]  ^  sa[2] ;
//
assign  sb[4]  =  {sa[4][1:7], 1'b0}  ^  { 3'b000 , sa[4][0] , sa[4][0] , 1'b0 , sa[4][0] , sa[4][0] }
               ^  {sa[5][1:7], 1'b0}  ^  { 3'b000 , sa[5][0] , sa[5][0] , 1'b0 , sa[5][0] , sa[5][0] }
               ^  sa[5]  ^  sa[6]  ^  sa[7] ;
assign  sb[5]  =  {sa[5][1:7], 1'b0}  ^  { 3'b000 , sa[5][0] , sa[5][0] , 1'b0 , sa[5][0] , sa[5][0] }
               ^  {sa[6][1:7], 1'b0}  ^  { 3'b000 , sa[6][0] , sa[6][0] , 1'b0 , sa[6][0] , sa[6][0] }
               ^  sa[6]  ^  sa[7]  ^  sa[4] ;
assign  sb[6]  =  {sa[6][1:7], 1'b0}  ^  { 3'b000 , sa[6][0] , sa[6][0] , 1'b0 , sa[6][0] , sa[6][0] }
               ^  {sa[7][1:7], 1'b0}  ^  { 3'b000 , sa[7][0] , sa[7][0] , 1'b0 , sa[7][0] , sa[7][0] }
               ^  sa[7]  ^  sa[4]  ^  sa[5] ;
assign  sb[7]  =  {sa[7][1:7], 1'b0}  ^  { 3'b000 , sa[7][0] , sa[7][0] , 1'b0 , sa[7][0] , sa[7][0] }
               ^  {sa[4][1:7], 1'b0}  ^  { 3'b000 , sa[4][0] , sa[4][0] , 1'b0 , sa[4][0] , sa[4][0] }
               ^  sa[4]  ^  sa[5]  ^  sa[6] ;
//
assign  nstate  =  { sb[0] , sb[1] , sb[2] , sb[3] , sb[4] , sb[5] , sb[6] , sb[7] } ;


// Rotate keys
//
assign  krot  =  { kstate[8:39] , kstate[0:7] , kstate[48:79] , kstate[40:47] } ;


// Feistel
//
assign  kfei[00:39]  =  krot[40:79] ;
assign  kfei[40:79]  =  krot[00:39]  ^  krot[40:79] ;


// Next keys
//
assign  nkstate[00:15]  =  kfei[00:15] ;
assign  nkstate[16:23]  =  kfei[16:23]  ^  { 3'd0 , round+1 } ;
assign  nkstate[24:47]  =  kfei[24:47] ;
sbox  sk0  ( .a( kfei[48:51] ) , .y( nkstate[48:51] )  ) ;
sbox  sk1  ( .a( kfei[52:55] ) , .y( nkstate[52:55] )  ) ;
sbox  sk2  ( .a( kfei[56:59] ) , .y( nkstate[56:59] )  ) ;
sbox  sk3  ( .a( kfei[60:63] ) , .y( nkstate[60:63] )  ) ;
assign  nkstate[64:79]  =  kfei[64:79] ;


// Output
//
assign  out  =  nstate ^ nkstate[0:63];

endmodule

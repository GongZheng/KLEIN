//////////////////////////////////////////////////
// Control module for KLEIN
//
module  klein_control  ( start , ck , round0 , round1, round , ready, sels, selk ) ;

input   start ;
input   ck ; // Rising edge clock

output  round0 ;  // Round-0 flag
output  round1;
output  [0:4] round;
output  ready ;
output   [0:3]   sels;
output   [0:4]   selk;

reg     [0:4]  round_ps;
wire    [0:4]  round_ns;
reg     [2:0]  cnt_ps ;  // PS of counter
wire    [2:0]  cnt_ns ;  // NS of counter
reg            ready ;   // Ready is DFF output
wire 		   round16;
reg     [0:8] intsel;

// Define counter
//
assign  cnt_ns  =  start  ?  0  :  cnt_ps + 1 ;
always  @ ( posedge ck )  cnt_ps  <=  cnt_ns ;
//
assign  round_ns    =  start ? 0 : ( (cnt_ps==7) ? round_ps+1 : round_ps) ;
always  @ ( posedge ck  )  round_ps  <=  round_ns ;
assign  round0   =  ( round_ps == 0 ) ;
assign  round1   =  ( round_ps == 1 ) ;
assign  round16  =  ( round_ps == 16 ) ;
assign  round  =  round_ps;

// Delay round12 flag to get ready output
//
always  @ ( posedge ck )  ready  <=  round16 ;

always  @ ( * )
  case  ( cnt_ps )
    4'h0  :  intsel  =  { 4'b0111 , 5'b00000 } ; 
    4'h1  :  intsel  =  { 4'b1011 , 5'b01000 } ; 
    4'h2  :  intsel  =  { 4'b1001 , 5'b10011 } ; 
    4'h3  :  intsel  =  { 4'b0000 , 5'b10010 } ; 
    4'h4  :  intsel  =  { 4'b0111 , 5'b11100 } ;
    4'h5  :  intsel  =  { 4'b0011 , 5'b10110 } ; 
    4'h6  :  intsel  =  { 4'b0001 , 5'b10110 } ; 
    4'h7  :  intsel  =  { 4'b0000 , 5'b10110 } ; 
  endcase  
  
assign sels= intsel[0:3]; 
assign selk= intsel[4:8]; 

endmodule

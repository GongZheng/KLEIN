//////////////////////////////////////////////////
// Control module for KLEIN
//
module  klein_control  ( start , ck , round0 ,  round , ready, sels, selk ) ;

input   start ;
input   ck ; // Rising edge clock

output  round0 ;  // Round-0 flag
output  [0:3] round;
output  ready ;
output   [0:3]   sels;
output   [0:3]   selk;

reg     [0:3]  round_ps;
wire    [0:3]  round_ns;
reg     [2:0]  cnt_ps ;  // PS of counter
wire    [2:0]  cnt_ns ;  // NS of counter
reg            ready ;   // Ready is DFF output
wire 		   round12;
reg     [0:7] intsel;

// Define counter
//
assign  cnt_ns  =  start  ?  0  :  cnt_ps + 1 ;
always  @ ( posedge ck )  cnt_ps  <=  cnt_ns ;
//
assign  round_ns    =  start ? 0 : ( (cnt_ps==7) ? round_ps+1 : round_ps) ;
always  @ ( posedge ck  )  round_ps  <=  round_ns ;
assign  round0   =  ( round_ps == 0 ) ;
assign  round12  =  ( round_ps == 12 ) ;
assign  round  =  round_ps;

// Delay round12 flag to get ready output
//
always  @ ( posedge ck )  ready  <=  round12 ;

always  @ ( * )
  case  ( cnt_ps )
    4'h0  :  intsel  =  { 4'b0111 , 4'b0000 } ; 
    4'h1  :  intsel  =  { 4'b1011 , 4'b0000 } ; 
    4'h2  :  intsel  =  { 4'b1001 , 4'b0010 } ; 
    4'h3  :  intsel  =  { 4'b0000 , 4'b0101 } ; 
    4'h4  :  intsel  =  { 4'b0111 , 4'b1001 } ;
    4'h5  :  intsel  =  { 4'b0011 , 4'b1000 } ; 
    4'h6  :  intsel  =  { 4'b0001 , 4'b1000 } ; 
    4'h7  :  intsel  =  { 4'b0000 , 4'b1100 } ; 
  endcase  
  
assign sels= intsel[0:3]; 
assign selk= intsel[4:7]; 

endmodule

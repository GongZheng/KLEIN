//////////////////////////////////////////////////
// Top level module for KLEIN-96
//
module  klein_96  ( start , inp , key , ck , ready , out ) ;


input   start ;
input   [0:7]  inp ;  // Data input
input   [0:7]  key ;  // Key input
input   ck ; // Rising edge clock

output  ready ;
output  [0:7]  out ;  // Data output

wire    round0 ,round1 ;
wire    [0:4]  round ;
wire    [0:7]  rout;
wire    [0:3]  sels;
wire    [0:4]  selk;


//( start , ck , rn , round0 ,  round, active , ready, sels, selk )
klein_control  u_control  (
  .start   ( start   ) ,
  .ck      ( ck      ) ,
  .round0  ( round0  ) ,
  .round1  ( round1  ) ,
  .round   ( round   ) ,
  .ready   ( ready   ) ,
  .sels    ( sels    ) ,
  .selk    ( selk    ) 
) ;

//( inp, key, round0, round, sels, selk, out, clk, rst) 
klein_comb  u_comb  (
  .inp     ( inp    ), 
  .key     ( key    ), 
  .round0  ( round0 ), 
  .round1  ( round1 ),  
  .ck      ( ck     ) ,
  .round   ( round  ),
  .sels    ( sels   ),
  .selk    ( selk   ), 
  .out     ( rout   )
) ;

assign  out  =  rout ;


endmodule

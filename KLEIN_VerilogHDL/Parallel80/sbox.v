///KLEIN S-box, used as y=S(x)

module  sbox  ( a , y ) ;


input   [0:3]  a ;  // 4-bit input

output  [0:3]  y ;  // 4-bit yput

reg     [0:3]  y ;  // 4-bit yput

function [0:3] S;
input [0:3] x;
  
case ( x )
  4'h0  :  S  =  4'h7 ; 
  4'h1  :  S  =  4'h4 ; 
  4'h2  :  S  =  4'hA ; 
  4'h3  :  S  =  4'h9 ; 
  4'h4  :  S  =  4'h1 ;
  4'h5  :  S  =  4'hF ; 
  4'h6  :  S  =  4'hB ; 
  4'h7  :  S  =  4'h0 ; 
  4'h8  :  S  =  4'hC ; 
  4'h9  :  S  =  4'h3 ; 
  4'hA  :  S  =  4'h2 ; 
  4'hB  :  S  =  4'h6 ; 
  4'hC  :  S  =  4'h8 ; 
  4'hD  :  S  =  4'hE ; 
  4'hE  :  S  =  4'hD ; 
  4'hF  :  S  =  4'h5 ;
endcase
    
endfunction
  

// output
always  @ ( * )
  y = S(a);
  
endmodule

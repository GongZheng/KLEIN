///KLEIN Shared S-box, used as sbox(a) = f(g(h(a)))

module  sbox  ( a , y ) ;


input   [0:3]  a ;  // 4-bit input

output  [0:3]  y ;  // 4-bit yput

reg     [0:3]  y ;  // 4-bit yput

function [0:3] F;
input [0:3] x;
  
case ( x )
  4'h0  :  F  =  4'h3 ; 
  4'h1  :  F  =  4'hD ; 
  4'h2  :  F  =  4'h7 ; 
  4'h3  :  F  =  4'h8 ; 
  4'h4  :  F  =  4'hB ;
  4'h5  :  F  =  4'h5 ; 
  4'h6  :  F  =  4'hF ; 
  4'h7  :  F  =  4'h0 ; 
  4'h8  :  F  =  4'hA ; 
  4'h9  :  F  =  4'h4 ; 
  4'hA  :  F  =  4'h6 ; 
  4'hB  :  F  =  4'h9 ; 
  4'hC  :  F  =  4'h2 ; 
  4'hD  :  F  =  4'hC ; 
  4'hE  :  F  =  4'hE ; 
  4'hF  :  F  =  4'h1 ;
endcase
    
endfunction
  
function [0:3] G;
input [0:3] x;
  
case ( x )
  4'h0  :  G  =  4'h0 ; 
  4'h1  :  G  =  4'hA ; 
  4'h2  :  G  =  4'h4 ; 
  4'h3  :  G  =  4'hF ; 
  4'h4  :  G  =  4'hC ;
  4'h5  :  G  =  4'h7 ; 
  4'h6  :  G  =  4'h9 ; 
  4'h7  :  G  =  4'h3 ; 
  4'h8  :  G  =  4'h8 ; 
  4'h9  :  G  =  4'h2 ; 
  4'hA  :  G  =  4'hE ; 
  4'hB  :  G  =  4'h5 ; 
  4'hC  :  G  =  4'h6 ; 
  4'hD  :  G  =  4'hD ; 
  4'hE  :  G  =  4'h1 ; 
  4'hF  :  G  =  4'hB ;
endcase
    
endfunction
  
function [0:3] H;
input [0:3] x;
  
case ( x )
  4'h0  :  H  =  4'h9 ; 
  4'h1  :  H  =  4'h6 ; 
  4'h2  :  H  =  4'h8 ; 
  4'h3  :  H  =  4'hF ; 
  4'h4  :  H  =  4'h3 ;
  4'h5  :  H  =  4'hC ; 
  4'h6  :  H  =  4'h2 ; 
  4'h7  :  H  =  4'h5 ; 
  4'h8  :  H  =  4'hD ; 
  4'h9  :  H  =  4'h0 ; 
  4'hA  :  H  =  4'h4 ; 
  4'hB  :  H  =  4'h1 ; 
  4'hC  :  H  =  4'h7 ; 
  4'hD  :  H  =  4'hA ; 
  4'hE  :  H  =  4'hE ; 
  4'hF  :  H  =  4'hB ;
endcase
    
endfunction

// output
always  @ ( * )
  y = F(G(H(a)));
  
endmodule

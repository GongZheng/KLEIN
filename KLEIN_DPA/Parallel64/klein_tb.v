//////////////////////////////////////////////////
`timescale  1 ns / 1 ns
//////////////////////////////////////////////////
// Testbench for AES-128 module
//
module  klein_tb ;

parameter  per  =  10 ;  // Clock period for 100 MHz

// Inputs declared as "registers"
reg   start ;
reg   [0:63]  inp ;  // Data input
reg   [0:63]  key ;  // Key input
reg   ck ; // Rising edge clock

// Outputs declared as "nets"
wire  ready ;
wire  [0:63]  out ;  // Data output


// Instantiate device under test (DUT)
klein_64  dut  (
  .start ( start ) ,
  .inp   ( inp   ) ,
  .key   ( key   ) ,
  .ck    ( ck    ) ,
  .ready ( ready ) ,
  .out   ( out   )
) ;

// Define clock
initial  ck  <=  1'b1 ;  // Initially clock is "1"
always  #(per/2)  // Every (per/2) ns, clock is toggled,
  ck  <=  ~ ck ;  // resulting in a periodic square wave

// Other stimulus
//
initial  // Use "initial" to define waveforms
  begin  // starting at zero time.
    // Initialize everything first
    start  <= #1  1'b0 ;
    inp    <= #1  64'd0 ;
    key    <= #1  64'd0 ;
    //Wait a few periods. Change inputs and send start
    #(3*per) ;  // Wait for 3 periods of time
    key    <= #1  64'hffffffffffffffff ;
    inp    <= #1  64'h0000000000000000 ;
    start  <= #1  1'b1 ;  // Start pulled up
    #(per) ;           // After one period of time
    start  <= #1  1'b0 ;  // start is pulled down -> a single pulse
    //Wait until ready becomes "1"
    wait ( ready ) ;
    #(3*per) ;  // Check to see if output is correct
    // Wait a few periods. Change inputs and send start
    #(3*per) ;  // Wait for 3 periods of time
    key    <= #1  64'h0000000000000000 ;
    inp    <= #1  64'h1234567890abcdef ;
    start  <= #1  1'b1 ;  // Start pulled up
    #(per) ;           // After one period of time
    start  <= #1  1'b0 ;  // start is pulled down -> a single pulse
   // Wait until ready becomes "1"
    wait ( ready ) ;
    #(3*per) ;  // Check to see if output is correct
     $stop ;
  end


endmodule

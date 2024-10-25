module fsm (clk, reset, start, not_64, en, init, write_result);

   input logic  clk;
   input logic  reset;
   input logic 	start;
   input logic  not_64;    
   
   output logic en;
   output logic init; 
   output logic write_result;  
   
   typedef enum logic [1:0] {S0, S1, S2, S3} statetype;
   statetype state, nextstate;
   
   // state register
   always_ff @(posedge clk, posedge reset)
     if (reset) state <= S0;
     else       state <= nextstate;
   
   // next state logic
   always_comb
     case (state)
       S0: begin // initial state
	  en <= 1'b0;
	  init <= 1'b0;
	  write_result <= 1'b0;	  
	  if (start) nextstate <= S1;
	  else   nextstate <= S0;
       end
       S1: begin // init state
	  en <= 1'b1;
	  init <= 1'b1;
	  write_result <= 1'b0;
	  nextstate <= S2;
       end
       S2: begin // main comp state
	  en <= 1'b1;
	  init <= 1'b0;
	  write_result <= 1'b0;	  	  
	  if (not_64) nextstate <= S2;
	  else   nextstate <= S3;
       end       
       S3: begin // write result state
	  en <= 1'b0;
	  init <= 1'b0;
	  write_result <= 1'b1;	  	  
	  if (start) nextstate <= S3;
	  else   nextstate <= S0;
       end
       default: begin
	  en <= 1'b0;
	  init <= 1'b0;
	  write_result <= 1'b0;	  	  
	  nextstate <= S0;
       end
     endcase
   
endmodule
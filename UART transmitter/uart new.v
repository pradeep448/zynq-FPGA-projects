`timescale 1ns / 1ps

module uart_tx(
clkin, tx
    );
    input clkin;
    output reg tx; // output pin
    
    integer cst, st_no;
    integer i=7;
    reg [0:7]data; // LSB goes first, index=7 is LSB here
    reg done;
    
    initial begin
    tx=1;
    data=8'b1001_1001;
    done=0;
    end
    
    
    always@(posedge clkin) begin
        
        case(cst)
        0: begin st_no=0; tx=1; // stop bit =1 OR IDLE state
            if(done==0) cst=1; 
            end
        1: begin st_no=1; tx=0; cst=2; end // start bit = 0
        2: begin st_no=2;  // 8 bit data
            tx=data[i]; 
            i=i-1;
            if(i==-1) begin cst=0; done=1; end // if 8 bit data sent, send stop bit
			else begin cst=2; end
            end
        
        default: begin   st_no=99; cst=0; end
        endcase
    end
    
    
endmodule
`timescale 1ns / 1ps

module m(
clk100M, clk100K, mosi, ss
    );
    input clk100M;
    output reg  clk100K, mosi, ss;
    integer st_no, cst,i=15, cnt=0;
    reg [15:0]setup;
    reg done=0;
    initial begin
        ss=1;
        setup=16'b1000000110000001;

    end
    //CPOL CPHA 11
    always@(posedge clk100M) begin
            cnt=cnt+1;
            
            if(cnt<=500) clk100K=1;
            else if (cnt>500 && cnt<=1000) clk100K=0;
            if(cnt==1000) cnt=0;
        end
        
     always@(negedge clk100K) begin
            case(cst)
            0: begin st_no=0; // idle state OR no data transfer
                ss=1;
                if(done==0) begin cst=1; end
                
                end
            1: begin st_no=1; // data transfer as ss=0
             ss=0;
             mosi=setup[i];
             i=i-1;
             if(i==-1) begin cst=0; done=1; end else cst=1;
                end
         
               
            default: begin st_no=99; cst=0;end
            endcase
         end
    
endmodule


`timescale 1ns / 1ps


module spi_test;

    reg clk100M;
    wire  clk100K, mosi, ss;
    
    m dut (.clk100M(clk100M),.clk100K(clk100K), .mosi(mosi), .ss(ss));
    
    initial clk100M=0;
    always #5 clk100M=~clk100M;
    
endmodule



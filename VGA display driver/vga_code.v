
`timescale 1ns / 1ps  

module top(			// top module
    input clk_25M, //int,
    input [11:0] dataIn,
    output hsynq,
    output vsynq,
    output [11:0] outData 
    );
    
    wire enable_v_counter;
    wire [15:0] h_count_value;
    wire [15:0] v_count_value;
    horizontal_counter vga_horiz (clk_25M, enable_v_counter, h_count_value);
    vertical_counter vga_verti (clk_25M, enable_v_counter, v_count_value);
  
    assign hsynq=(h_count_value<96) ? 1:0; 
    assign vsynq=(v_count_value<2) ? 1:0; 

    assign outData=(h_count_value <784 && h_count_value > 143 && v_count_value < 515 && v_count_value>34) ? dataIn:12'h0;
    
endmodule


`timescale 1ns / 1ps

module horizontal_counter( 	// to count horizontal pulses
    input clk_25M,
    output reg enable_v_counter=0,
    output reg [15:0] h_count_value=0
    );
    
    always@(posedge clk_25M) begin
        if (h_count_value <=799) begin 
            h_count_value <= h_count_value+1; 
                      enable_v_counter=0;

        end
        else begin
            h_count_value=0;
            enable_v_counter=1;
        end
    end
    
endmodule

`timescale 1ns / 1ps

module vertical_counter( 	// to count vertical pulses
    input clk_25M,
    input    enable_v_counter,
    output reg [15:0] v_count_value=0
    );
    
    always@(posedge clk_25M) begin
            if (enable_v_counter == 1) begin 
            if (v_count_value <= 524) begin
                v_count_value = v_count_value+1; 
            end
            
            else begin
                v_count_value=0;
            end
        end
    end
endmodule


`timescale 1ns / 1ps

module basic_clk_div( // clock divider for 100MHz to 25MHz
input clk2,
output reg out25M
    );
    
    integer cnt3=0;
    integer div=4;
    
    always@(posedge clk2)
    begin 
        cnt3=cnt3+1;
        if(cnt3>=1 && cnt3 <=div/2) begin out25M=1; end
        if(cnt3>=div/2+1 && cnt3 <=div) begin out25M=0; end
        if(cnt3==div) begin cnt3=0; end
    end
    
    
endmodule



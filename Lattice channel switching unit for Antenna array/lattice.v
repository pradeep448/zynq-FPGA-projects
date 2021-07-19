`timescale 1ns / 1ps

module main(
output reg [20:0] out, // 7 relays * 3 pins each = 21 output pins
input clk_in, // 100MHz, 10ns
output reg clk_5_6_5_10 // width in ms
    );
   
    integer cnt=0;
    integer cst_cnt=0;

    always@(posedge clk_in) // create clk_5_6_5_10
    begin
        cnt=cnt+1;
        if(cnt>=1 && cnt <=500000) begin clk_5_6_5_10=1; end //  width= 5 ms
        if(cnt>=500000+1 && cnt <=500000+600000) begin clk_5_6_5_10=0; end // width= 6 ms
        if(cnt>=500000+600000+1 && cnt <=500000+600000+500000) begin clk_5_6_5_10=1; end // width=5ms
        if(cnt>=500000+600000+500000+1 && cnt <=500000+600000+500000+1000000) begin clk_5_6_5_10=0; end // width = 10ms       
        if(cnt==500000+600000+500000+1000000) begin cnt=0; end
    end
    
    always@( posedge clk_5_6_5_10)
    begin
        case (cst_cnt)
			// to handle 7 antenna switches (Teledyne relays) named below
            //             Rx1 Rx2 Rx3 Rx4 Tx1 Tx2 Tx3
			// no of antennas connected as following:
			//              6	6	6	6	6	6	1
         0: begin out<=21'b000_000_111_111_000_111_111; cst_cnt=cst_cnt+1; end // for 5ms
         1: begin out<=21'b000_000_111_111_111_111_111; cst_cnt=cst_cnt+1; end // for 6ms
         2: begin out<=21'b000_000_000_000_100_111_111; cst_cnt=cst_cnt+1; end // for 5ms
         3: begin out<=21'b111_111_000_000_111_111_111; cst_cnt=cst_cnt+1; end // for 10ms
         4: begin out<=21'b100_100_000_000_010_111_111; cst_cnt=cst_cnt+1; end // for 5ms
         5: begin out<=21'b100_100_111_111_111_111_111; cst_cnt=cst_cnt+1; end // for 6ms
         6: begin out<=21'b100_100_100_100_110_111_111; cst_cnt=cst_cnt+1; end // for 5ms
         7: begin out<=21'b111_111_100_100_111_111_111; cst_cnt=cst_cnt+1; end // for 10ms
         8: begin out<=21'b010_010_100_100_001_111_111; cst_cnt=cst_cnt+1; end // ...
         9: begin out<=21'b010_010_111_111_111_111_111; cst_cnt=cst_cnt+1; end // ...
							
        10: begin out<=21'b010_010_010_010_101_111_111; cst_cnt=cst_cnt+1; end
        11: begin out<=21'b111_111_010_010_111_111_111; cst_cnt=cst_cnt+1; end
        12: begin out<=21'b110_110_010_010_111_000_111; cst_cnt=cst_cnt+1; end
        13: begin out<=21'b110_110_111_111_111_111_111; cst_cnt=cst_cnt+1; end
        14: begin out<=21'b110_110_110_110_111_111_000; cst_cnt=cst_cnt+1; end
        15: begin out<=21'b111_111_110_110_111_111_111; cst_cnt=cst_cnt+1; end
        16: begin out<=21'b001_001_110_110_111_111_100; cst_cnt=cst_cnt+1; end
        17: begin out<=21'b001_001_111_111_111_111_111; cst_cnt=cst_cnt+1; end
        18: begin out<=21'b001_001_001_001_111_111_010; cst_cnt=cst_cnt+1; end
        19: begin out<=21'b111_111_001_001_111_111_111; cst_cnt=cst_cnt+1; end
									
        20: begin out<=21'b101_101_001_001_111_111_110; cst_cnt=cst_cnt+1; end
        21: begin out<=21'b101_101_111_111_111_111_111; cst_cnt=cst_cnt+1; end
        22: begin out<=21'b101_101_101_101_111_111_001; cst_cnt=cst_cnt+1; end
        23: begin out<=21'b111_111_101_101_111_111_111; cst_cnt=cst_cnt+1; end
        24: begin out<=21'b111_111_101_101_111_111_101; cst_cnt=cst_cnt+1; end
        25: begin out<=21'b111_111_111_111_111_111_111; cst_cnt=0; end // All pins are off
        
        default: out<=21'b111_111_111_111_111_111_111; // All pins are off
        endcase
    end
    
endmodule
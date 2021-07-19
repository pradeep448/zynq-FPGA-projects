// Time domain Radar Synchronizer
`timescale 1ns / 1ps

module m(
clk_in, // 500 MHz, 2ns period => to get 100KHz PRT
rx_out, // PW = 200ns,198ns,...,2ns -> 100 pts in single Ascan
tx_out, // PW = 60ns
mcu_out // PW = 400ns
);
input clk_in; // 500MHz => clk period 2 ns

integer div=5000; // 100KHz out

//---mcu-------
output reg mcu_out;
integer cnt_mcu=0;
integer mcu_high=200; // 1 => 2ns, 2 => 4ns,...


////---TX------
output reg tx_out;
integer cnt_tx=0;
integer tx_high=30; // 1 => 2ns, 2 => 4ns,...

//---RX------
output reg rx_out;
integer cnt_rx=0;

integer temp=80;//var*2ns = 160ns --> STARTING OFFSET
integer temp_2=180;//var*2ns = 160ns + 200ns = 360ns --> ENDING OFFSET

//180-80 = 100 points in single Ascan



//---mcu_out---
always@(posedge clk_in) begin
    cnt_mcu=cnt_mcu+1;
    
    if(cnt_mcu<= mcu_high) begin   
            mcu_out=1;
    end
    else if(cnt_mcu>= (mcu_high+1) && cnt_mcu<=div) begin
        mcu_out=0;
    end
    
    if(cnt_mcu==div) begin
        cnt_mcu=0;
    end
end


////---TX PULSE---
always@(posedge clk_in) begin
    cnt_tx=cnt_tx+1;
    
    if(cnt_tx<= tx_high) begin   
            tx_out=1;
    end
    else if(cnt_tx>= (tx_high+1) && cnt_tx<=div) begin
        tx_out=0;
    end
    
    if(cnt_tx==div) begin
        cnt_tx=0;
    end
end

//--RX PULSE---
always@(posedge clk_in) begin
    cnt_rx=cnt_rx+1;
    
    if(cnt_rx<=temp || cnt_rx>temp_2) begin rx_out=0;   end
    if(cnt_rx>temp && cnt_rx<=temp_2) begin rx_out=1;   end
    
    if(cnt_rx==div) begin
       cnt_rx=0; temp=temp+1; // increment starting offset by 2ns
        if(temp==temp_2) temp=80; // reset to starting offset
    end
end

endmodule

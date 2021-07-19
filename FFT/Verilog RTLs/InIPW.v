`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.05.2021 11:52:09
// Design Name: 
// Module Name: InIPW
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module InIPW(
input [31:0] in1_Tdata,
input in1_Tvalid,
input in1_Tlast,
output in1_Tready,

input [31:0] in2_Tdata,
input in2_Tvalid,
input in2_Tlast,
output in2_Tready,

output [63:0] out3_Tdata,
output out3_Tvalid,
output out3_Tlast,
input out3_Tready);

assign out3_Tdata={in2_Tdata,in1_Tdata};
assign out3_Tvalid=in2_Tvalid || in1_Tvalid;
assign out3_Tlast=in2_Tlast || in1_Tlast;
assign in1_Tready=out3_Tready;
assign in2_Tready=out3_Tready;

endmodule

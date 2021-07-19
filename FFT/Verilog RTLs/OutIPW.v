`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.05.2021 13:29:31
// Design Name: 
// Module Name: OutIPW
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


module OutIPW(
input [63:0] in1_Tdata,
input in1_Tvalid,
input in1_Tlast,
output in1_Tready,

output [31:0] out1_Tdata,
output out1_Tvalid,
output out1_Tlast,
input out1_Tready,

output [31:0] out2_Tdata,
output out2_Tvalid,
output out2_Tlast,
input out2_Tready);

assign out1_Tdata=in1_Tdata[31:0];
assign out2_Tdata=in1_Tdata[63:32];

assign out1_Tvalid= in1_Tvalid;
assign out2_Tvalid= in1_Tvalid;

assign out1_Tlast=in1_Tlast;
assign out2_Tlast=in1_Tlast;

assign in1_Tready =out2_Tready || out1_Tready;

endmodule

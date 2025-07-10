
module first_A(
  input clk, rst,
  input [7:0] data,
  output reg signed [10:0] A
);
  always @(posedge clk) begin
    if (rst)
      A <= {data, 3'b000};
  end
endmodule


module regfile_32x3_dual (
  input wire clk,
  input wire rst,
  input wire en,
  input signed  [4:0] addr,
  output reg [2:0] dout1,
  output reg [2:0] dout2
);
  reg [2:0] mem1 [0:31];
  reg [2:0] mem2 [0:31];

  always @(posedge clk) begin
    if (rst) begin
      mem1[0] <= 3'b000; mem1[1] <= 3'b010; mem1[2] <= 3'b001; mem1[3] <= 3'b010;
      mem1[4] <= 3'b000; mem1[5] <= 3'b001; mem1[6] <= 3'b001; mem1[7] <= 3'b000;
      mem1[8] <= 3'b000; mem1[9] <= 3'b010; mem1[10] <= 3'b001; mem1[11] <= 3'b010;
      mem1[12] <= 3'b000; mem1[13] <= 3'b001; mem1[14] <= 3'b001; mem1[15] <= 3'b000;
      mem1[16] <= 3'b101; mem1[17] <= 3'b100; mem1[18] <= 3'b101; mem1[19] <= 3'b101;
      mem1[20] <= 3'b100; mem1[21] <= 3'b110; mem1[22] <= 3'b101; mem1[23] <= 3'b110;
      mem1[24] <= 3'b101; mem1[25] <= 3'b100; mem1[26] <= 3'b101; mem1[27] <= 3'b101;
      mem1[28] <= 3'b100; mem1[29] <= 3'b110; mem1[30] <= 3'b101; mem1[31] <= 3'b110;

      mem2[0] <= 3'b100; mem2[1] <= 3'b111; mem2[2] <= 3'b110; mem2[3] <= 3'b011;
      mem2[4] <= 3'b101; mem2[5] <= 3'b011; mem2[6] <= 3'b010; mem2[7] <= 3'b111;
      mem2[8] <= 3'b100; mem2[9] <= 3'b111; mem2[10] <= 3'b110; mem2[11] <= 3'b011;
      mem2[12] <= 3'b101; mem2[13] <= 3'b011; mem2[14] <= 3'b010; mem2[15] <= 3'b111;
      mem2[16] <= 3'b101; mem2[17] <= 3'b011; mem2[18] <= 3'b110; mem2[19] <= 3'b111;
      mem2[20] <= 3'b001; mem2[21] <= 3'b111; mem2[22] <= 3'b010; mem2[23] <= 3'b011;
      mem2[24] <= 3'b101; mem2[25] <= 3'b011; mem2[26] <= 3'b110; mem2[27] <= 3'b111;
      mem2[28] <= 3'b001; mem2[29] <= 3'b111; mem2[30] <= 3'b010; mem2[31] <= 3'b011;
    end
  end

  always @(*) begin
    if (en) begin
    dout1 = mem1[addr[4:0]];  
    dout2 = mem2[addr[4:0]];
    end else begin
      dout1 = 3'b000;
      dout2 = 3'b000;
    end
  end
endmodule


module mux8_1 (
  input [10:0] A,
  input [2:0] dout1,
  output reg [10:0] out
);
  always @(*) begin
    case (dout1)
      3'd0: out = A;
      3'd1: out = A >> 1;
      3'd2: out = A >> 2;
      3'd3: out = A >> 3;
      3'd4: out = ~A + 1;
      3'd5: out = (~A + 1) >> 1;
      3'd6: out = (~A + 1) >> 2;
      3'd7: out = (~A + 1) >> 3;
      default: out = 11'b0;
    endcase
  end
endmodule

module mux4_1 (
  input [10:0] A,
  input [1:0] sel,  
  output reg [11:0] mux_out
);
  always @(*) begin
    case (sel)
      2'b00: mux_out = 12'b0;
      2'b01: mux_out = {1'b0, A};  
      2'b10: mux_out = {1'b0, (~A + 11'b00000000001)};  
      2'b11: mux_out = 12'b0;
      default: mux_out = 12'b0;
    endcase
  end
endmodule




module top_module(
  input clk, rst, en,
  input signed [7:0] data,
  input signed [4:0] addr,
  output signed [10:0] out1,
  output signed [10:0] out2,
  output signed [11:0] sum_out,
  output signed [12:0] final_sum
);
  wire signed [10:0] A_wire;
  wire [2:0] dout1, dout2;
  wire signed [11:0] temp_output3;


  first_A u1 (
    .clk(clk),
    .rst(rst),
    .data(data),
    .A(A_wire)
  );

  
  regfile_32x3_dual u2 (
    .clk(clk),
    .rst(rst),
    .en(en),
    .addr(addr),
    .dout1(dout1),
    .dout2(dout2)
  );

  mux8_1 u3 (
    .A(A_wire),
    .dout1(dout1),
    .out(out1)
  );

  mux8_1 u4 (
    .A(A_wire),
    .dout1(dout2), 
    .out(out2)
  );

  
  mux4_1 u5 (
    .A(A_wire),
    .sel(addr[4:3]),
    .mux_out(temp_output3)
  );

  
  assign sum_out = out1 + out2;
  assign final_sum = sum_out + temp_output3;

endmodule

module sub_module(
  input clk, rst, en,
  input signed [7:0] data1,data2,
  input signed [4:0] addr1,addr2,
  output signed [10:0] out1,out1_2,
  output signed [10:0] out2,out2_2,
  output signed [11:0] sum_out1,sum_out2,
  output signed [12:0] final_sum1,final_sum2,
  output signed [13:0] partial_sum14
);
 
  
  top_module t1 (
    .clk(clk),
    .rst(rst),
    .en(en),
    .data(data1),
    .addr(addr1),
    .out1(out1),
    .out2(out2),
    .sum_out(sum_out1),
    .final_sum(final_sum1)
  );
  
   top_module t2 (
    .clk(clk),
    .rst(rst),
    .en(en),
     .data(data2),
     .addr(addr2),
     .out1(out1_2),
     .out2(out2_2),
     .sum_out(sum_out2),
     .final_sum(final_sum2)
  );
  
  assign partial_sum14 = final_sum1 + final_sum2;
endmodule
  
module sub_module15(
  input clk,rst,en,
  input signed [7:0] data1,data2,data3,data4,
  input signed [4:0] addr1,addr2,addr3,addr4,
  output signed [10:0] out1,out1_2,out1_3,out1_4,
  output signed [10:0] out2,out2_2,out2_3,out2_4,
  output signed [11:0] sum_out1,sum_out2,sum_out3,sum_out4,
  output signed [12:0] final_sum1,final_sum2,final_sum3,final_sum4,
  output signed [13:0] partial_sum14,partial_sum14_1,
  output signed [14:0] partial_sum15
);
  
  sub_module s1 (
    .clk(clk),
    .rst(rst),
    .en(en),
    .data1(data1),
    .data2(data2),
    .addr1(addr1),
    .addr2(addr2),
    .out1(out1),
    .out1_2(out1_2),
    .out2(out2),
    .out2_2(out2_2),
    .sum_out1(sum_out1),
    .sum_out2(sum_out2),
    .final_sum1(final_sum1),
    .final_sum2(final_sum2),
    .partial_sum14(partial_sum14)
  );
  
    sub_module s2 (
    .clk(clk),
    .rst(rst),
    .en(en),
    .data1(data3),
    .data2(data4),
    .addr1(addr3),
    .addr2(addr4),
    .out1(out1_3),
    .out1_2(out1_4),
      .out2(out2_3),
      .out2_2(out2_4),
      .sum_out1(sum_out3),
      .sum_out2(sum_out4),
      .final_sum1(final_sum3),
      .final_sum2(final_sum4),
      .partial_sum14(partial_sum14_1)
  );
  
  assign partial_sum15 = partial_sum14 + partial_sum14_1;
  
endmodule

module sub_module16(
  input clk,rst,en,
  input signed [7:0] data1,data2,data3,data4,data5,data6,data7,data8,
  input signed [4:0] addr1,addr2,addr3,addr4,addr5,addr6,addr7,addr8,
  output signed [10:0] out1,out1_2,out1_3,out1_4,out1_5,out1_6,out1_7,out1_8,
  output signed [10:0] out2,out2_2,out2_3,out2_4,out2_5,out2_6,out2_7,out2_8,
  output signed [11:0] sum_out1,sum_out2,sum_out3,sum_out4,sum_out5,sum_out6,sum_out7,sum_out8,
  output signed [12:0] final_sum1,final_sum2,final_sum3,final_sum4,final_sum5,final_sum6,final_sum7,final_sum8,
  output signed [13:0] partial_sum14,partial_sum14_1,partial_sum14_2,partial_sum14_3,
  output signed [14:0] partial_sum15,partial_sum15_1,
  output signed [15:0] partial_sum16
);
  
   sub_module15 sm1 (
    .clk(clk),
    .rst(rst),
    .en(en),
    .data1(data1),
    .data2(data2),
    .data3(data3),
    .data4(data4),
    .addr1(addr1),
    .addr2(addr2),
    .addr3(addr3),
    .addr4(addr4),
    .out1(out1),
    .out1_2(out1_2),
    .out1_3(out1_3),
    .out1_4(out1_4),
    .out2(out2),
    .out2_2(out2_2),
    .out2_3(out2_3),
    .out2_4(out2_4),
    .sum_out1(sum_out1),
    .sum_out2(sum_out2),
    .sum_out3(sum_out3),
    .sum_out4(sum_out4), 
    .final_sum1(final_sum1),
    .final_sum2(final_sum2),
    .final_sum3(final_sum3),
    .final_sum4(final_sum4),
    .partial_sum14(partial_sum14),
    .partial_sum14_1(partial_sum14_1),
    .partial_sum15(partial_sum15)
   );
  
  sub_module15 sm2 (
    .clk(clk),
    .rst(rst),
    .en(en),
    .data1(data5),
    .data2(data6),
    .data3(data7),
    .data4(data8),
    .addr1(addr5),
    .addr2(addr6),
    .addr3(addr7),
    .addr4(addr8),
    .out1(out1_5),
    .out1_2(out1_6),
    .out1_3(out1_7),
    .out1_4(out1_8),
    .out2(out2_5),
    .out2_2(out2_6),
    .out2_3(out2_7),
    .out2_4(out2_8),
    .sum_out1(sum_out5),
    .sum_out2(sum_out6),
    .sum_out3(sum_out7),
    .sum_out4(sum_out8), 
    .final_sum1(final_sum5),
    .final_sum2(final_sum6),
    .final_sum3(final_sum7),
    .final_sum4(final_sum8),
    .partial_sum14(partial_sum14_2),
    .partial_sum14_1(partial_sum14_3),
    .partial_sum15(partial_sum15_1)
   );
  
  assign partial_sum16 = partial_sum15 + partial_sum15_1;
endmodule

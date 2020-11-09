`timescale 1ns / 1ps

module alu(
  input [31:0] data1,
  input [31:0] read2,
  input [31:0] instru, // used for sign-extension
  input ALUSrc,
  input [3:0] ALUcontrol,
  output reg zero,
  output reg [31:0] ALUresult
);

  reg [31:0] data2;
  
  always @(ALUSrc, read2, instru) begin
    if (ALUSrc == 0) begin
      data2 = read2;
    end else begin
      // SignExt[Instru[15:0]]
      if (instru[15] == 1'b0) begin
        data2 = {16'b0,instru[15:0]};
      end else begin
        data2 = {16'b1,instru[15:0]};
      end
    end
  end

  always @(data1, data2, ALUcontrol) begin
    case (ALUcontrol)
      4'b0000: // AND
        ALUresult = data1 & data2;
      4'b0001: // OR
        ALUresult = data1 | data2;
      4'b0010: // ADD
        ALUresult = data1 + data2;
      4'b0110: // SUB
        ALUresult = data1 - data2;
      4'b0111: // SLT
        ALUresult = (data1 < data2) ? 1 : 0;
      default:
        ;
    endcase
    if (ALUresult == 0) begin
      zero = 1;
    end else begin
      zero = 0;
    end
  end

endmodule
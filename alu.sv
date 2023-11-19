/*
Arithmetic Logic Unit

00      Ain + Bin
01      Ain - Bin
10      Ain & Bin
11      ~Bin

If the result is 0 the 1 bit output Z should be 1 (and otherwise 0).
*/

module ALU(Ain, Bin, ALUop, out, Z);
    input [15:0] Ain, Bin;
    input [1:0] ALUop;
    output reg [15:0] out;
    output reg Z;

    always @* begin
        case (ALUop)
            2'b00: out = Ain + Bin;
            2'b01: out = Ain - Bin;
            2'b10: out = Ain & Bin;
            2'b11: out = ~Bin;
            default: out = 16'b0;
        endcase

        Z = (out == 16'b0) ? 1'b1 : 1'b0;
    end
endmodule: ALU
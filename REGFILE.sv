module Decoder (in, out);
    input [2:0] in;
    output reg [7:0] out;
    always @(in) begin
        out = 8'b00000000;  // Initialize output to 0
        case (in)
            3'b000: out[0] = 1'b1;
            3'b001: out[1] = 1'b1;
            3'b010: out[2] = 1'b1;
            3'b011: out[3] = 1'b1;
            3'b100: out[4] = 1'b1;
            3'b101: out[5] = 1'b1;
            3'b110: out[6] = 1'b1;
            3'b111: out[7] = 1'b1;
            default: out = 8'b00000000;
        endcase
    end
endmodule

module regfile(data_in,writenum,write,readnum,clk,data_out);
    input [15:0] data_in;
    input [2:0] writenum;
    input [2:0] readnum;
    input write;
    input clk;
    output reg [15:0] data_out;
    wire [7:0]oneHotWriting;
    wire [7:0] oneHotReading;
    reg [15:0] R0_;
    reg [15:0] R1_;
    reg [15:0] R2_;
    reg [15:0] R3_;
    reg [15:0] R4_;
    reg [15:0] R5_;
    reg [15:0] R6_;
    reg [15:0] R7_;
    reg [15:0] outdata;
    wire [15:0] R0;
    wire [15:0] R1;
    wire [15:0] R2;
    wire [15:0] R3;
    wire [15:0] R4;
    wire [15:0] R5;
    wire [15:0] R6;
    wire [15:0] R7;

    //Need 2 3:8 decoders for reading and writing
    Decoder writing (writenum,oneHotWriting);
    Decoder reading (readnum,oneHotReading);

    always@(*) begin
        case (oneHotReading)
            8'b00000001: outdata = R0_;
            8'b00000010: outdata = R1_;
            8'b00000100: outdata = R2_;
            8'b00001000: outdata = R3_;
            8'b00010000: outdata = R4_;
            8'b00100000: outdata = R5_;
            8'b01000000: outdata = R6_;
            8'b10000000: outdata = R7_;
            default: outdata = 16'bxxxxxxxxxxxxxxxx;
        endcase
        data_out = outdata;
    end

    always_ff @(posedge clk) begin
        case ({oneHotWriting,write})
            9'b000000011: R0_ <= data_in;
            9'b000000101: R1_ <= data_in;
            9'b000001001: R2_ <= data_in;
            9'b000010001: R3_ <= data_in;
            9'b000100001: R4_ <= data_in;
            9'b001000001: R5_ <= data_in;
            9'b010100001: R6_ <= data_in;
            9'b100000001: R7_ <= data_in;
            default: begin
                R0_ <= R0;
                R1_ <= R1;
                R2_ <= R2;
                R3_ <= R3;
                R4_ <= R4;
                R5_ <= R5;
                R6_ <= R6;
                R7_ <= R7;
            end
        endcase
    end

    assign  R0 = R0_;
    assign  R1 = R1_;
    assign  R2 = R2_;
    assign  R3 = R3_;
    assign  R4 = R4_;
    assign  R5 = R5_;
    assign  R6 = R6_;
    assign  R7 = R7_;
endmodule
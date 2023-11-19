module datapath (datapath_in, datapath_out, writenum, readnum, write, loada, loadb, asel, bsel,vsel, loadc, loads, shift, ALUop, Z_out, clk);
    input [15:0] datapath_in;
    output [15:0] datapath_out;
    input [2:0] writenum, readnum;
    input write, loada, loadb, asel, bsel, vsel, loadc, loads, clk;
    input [1:0] shift, ALUop;
    output Z_out;
    wire [15:0] data_in;
    wire [15:0] data_out;
    wire [15:0] fromA ;
    wire [15:0] fromB;
    wire [15:0] fromShift;
    wire [15:0] Ain;
    wire [15:0] Bin;
    wire [15:0] toC;
    wire Z;

    assign data_in = vsel ? datapath_in : datapath_out;

    regfile REGFILE (data_in,writenum,write,readnum,clk,data_out);
    //left branch
    vDFFE #(16) registerA (clk,loada,data_out,fromA);
    assign Ain = asel ? 16'b0 : fromA;
    //right branch
    vDFFE #(16) registerB (clk,loadb,data_out,fromB);
    shifter Shift (fromB, shift, fromShift);
    assign Bin = bsel ? {11'b0,datapath_in[4:0]}:fromShift ;

    //all into the same ALU
    ALU Arithmetic(Ain, Bin, ALUop, toC, Z);
    vDFFE #(16) registerC (clk,loadc,toC,datapath_out);

    //status 
    vDFFE status (clk,loads,Z,Z_out);

endmodule: datapath

module vDFFE(clk, en, in, out) ;
  parameter n = 1;  // width
  input clk, en ;
  input  [n-1:0] in ;
  output [n-1:0] out ;
  reg    [n-1:0] out ;
  wire   [n-1:0] next_out ;

  assign next_out = en ? in : out;

  always @(posedge clk)
    out = next_out;
endmodule


module RegC (in,load,clk,out);
    input in;
    input load, clk;
    output  out;
    reg  present_register;

    always_ff @( posedge clk ) begin 
        case (load)
            1'b0 : present_register = present_register;
            1'b1 : present_register <= in;
        endcase
    end

    assign out = present_register; 

endmodule

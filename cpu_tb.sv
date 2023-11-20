module cpu_tb ();
    reg [15:0] in;
    reg clk, load;
    wire [15:0] out;
    wire N, V, Z, w, reset, s;

    reg [15:0] current_instruction;
    reg [2:0] nsel;
    reg [2:0] opcode;
    reg [2:0] ALUop;
    reg [1:0] op;
    reg [7:0] imm8;
    reg [7:0] imm5;
    reg [15:0] sximm5;
    reg [15:0] sximm8;
    reg [1:0] shift;
    reg [2:0] Rd;
    reg [2:0] Rm;
    reg [2:0] Rn;
    reg [2:0] expected_opcode;
    reg [2:0] expected_ALUop;
    reg [1:0] expected_op;
    reg [7:0] expected_imm8;
    reg [7:0] expected_imm5;
    reg [15:0] expected_sximm5;
    reg [15:0] expected_sximm8;
    reg [1:0] expected_shift;
    reg [2:0] expected_Rd;
    reg [2:0] expected_Rm;
    reg [2:0] expected_Rn;
    reg err;
    reg [15:0] expected_in;

    cpu dut (clk, reset, s, load, in, out, N, V, Z, w);

    initial begin
        clk = 1'b0; #5; //rising edge of clock every 5 time units
        forever begin
            clk = 1'b1; #5;
            clk = 1'b0; #5;
        end
    end

    initial begin
        //instruction register
        err = 1'b0;
        load = 1'b1;
        in = 16'b1101000100000010;
        expected = 16'b1101000100000010;

        #10;

         if (current_instruction != expected_in)
            err = 1'b1;

        #5;

        //instruction decoder
        nsel = 010;
        expected_opcode = 3'b110;
        expected_op = 2'b10;
        expected_Rn = 3'b001;
        expected_Rd = 3'b000;
        expected_Rm = 3'b010;
        expected_shift = 2'b00;
        expected_imm8 = 0000010;
        expected_sximm8 = 000000000000010;

        #10;

        if (opcode != expected_opcode)
            err = 1'b1;

        if (op != expected_op)
            err = 1'b1;

        if (Rn != expected_Rn)
            err = 1'b1;

        if (Rd != expected_Rd)
            err = 1'b1;

        if (Rm != expected_Rm)
            err = 1'b1;

        if (shift != expected_shift)
            err = 1'b1;

        if (imm8 != expected_imm8)
            err = 1'b1;

        if (sximm8 != expected_sximm8)
            err = 1'b1;

        #5;

    end

endmodule
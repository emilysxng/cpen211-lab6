`define WAIT 5'b00000
`define DECODE 5'b00001
`define GET_A 5'b00010
`define GET_B 5'b00011
`define ADD 5'b00100
`define WRITE_REG 5'b00101
`define CMP 5'b00110
`define AND 5'b00111
`define MVN 5'b01000
`define Rd 3'b010
`define Rm 3'b001
`define Rn 3'b100

module cpu_tb ();
    reg [15:0] in;
    reg clk, load;
    wire [15:0] out;
    reg N, V, Z, reset, s;

    reg [2:0] nsel, opcode, Rn, Rd, Rm, expected_opcode, expected_Rd, expected_Rm, expected_Rn;
    reg [1:0] op, shift, expected_op, expected_shift, expected_ALUop, ALUop, vsel;
    reg [7:0] expected_imm8, imm8;
    reg [15:0] expected_sximm8, sximm8, expected_in, current_instruction;
    reg err;
    reg asel,bsel,loada,loadb,loadc,write;

    cpu dut (clk, reset, s, load, in, out, N, V, Z, w);
    FSM_controller put(clk, reset, s, opcode,  op, nsel, asel, bsel, w, loada,loadb,loadc, loads, ALUop, vsel, write);

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
        expected_in = 16'b1101000100000010;

        #10;

         if (current_instruction != expected_in)
            err = 1'b1;

        #100;

        //instruction decoder
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
        #100;
    end

    //FSM tests 

    initial begin
        //MOV 8 TO R0 ------------------------------------------------------------------------------

        err = 0;
        reset = 1; s = 0; load = 0; in = 16'b0;
        #10;

        reset = 0; 
        #10;

        in = 16'b1101000000001000;
        load = 1;
        #10;

        load = 0;
        s = 1;
        #10

        s = 0;
        @(posedge w); // wait for w to go high again
        #10;

        if (dut.DP.REGFILE.R0 !== 16'h8) begin
            err = 1;
        end

        // MOV 5 TO R1  ------------------------------------------------------------------------------

        @(negedge clk); // wait for falling edge of clock before changing inputs
        in = 16'b1101000100000101;
        load = 1;
        #10;

        load = 0;
        s = 1;
        #10

        s = 0;
        @(posedge w); // wait for w to go high again
        #10;

        if (dut.DP.REGFILE.R1 !== 16'h5) begin
         err = 1;
        end

        // R2 has (8*2) + 5 = 21?  ------------------------------------------------------------------------------

        @(negedge clk); // wait for falling edge of clock before changing inputs
        in = 16'b1010000101001000;
        load = 1;
        #10;

        load = 0;
        s = 1;
        #10

        s = 0;
        @(posedge w); // wait for w to go high again
        #10;

        $display("ADD R2, R1, R0 * 2");
        $display("R0 (8): %b", dut.DP.REGFILE.R0);
        $display("R1 (5): %b", dut.DP.REGFILE.R1);
        $display("R2 (8*2 + 5 = 21): %b", dut.DP.REGFILE.R2);

        if (dut.DP.REGFILE.R2 !== 16'h15) begin //21 is 15 in hex
            err = 1;
        end

        // CMP R1, R0 TEST ------------------------------------------------------------------------------

        @(negedge clk); // wait for falling edge of clock before changing inputs
        in = 16'b101_01_001_000_00_000;
        load = 1;
        #10;

        load = 0;
        s = 1;
        #10

        s = 0;
        @(posedge w); // wait for w to go high again
        #10;

        $display("CMP between R1, R0 status results:");
        $display("Z of the compare: %b", dut.Z); //exp: 0 //actual: 1
        $display("N of the compare: %b", dut.N); //exp: 1 //actual: 0
        $display("V of the compare: %b", dut.V); //exp: 0 //actual: 0

        if (dut.Z !== 1'b0) begin //not equal
            err = 1;
        end
        if (dut.N !== 1'b1) begin // negative (R1 - R0 = 5 - 8 = negative)
            err = 1;
        end
        if (dut.V !== 1'b0) begin //not overflow
            err = 1;
        end

        //  AND R3, R1, R0  ------------------------------------------------------------------------------

        @(negedge clk); // wait for falling edge of clock before changing inputs
        in = 16'b101_10_001_011_00_000;
        load = 1;
        #10;

        load = 0;
        s = 1;
        #10;

        s = 0;
        @(posedge w); // wait for w to go high again
        #10;

        $display("AND R3, R1, R0");
        $display("R0: %b", dut.DP.REGFILE.R0);
        $display("R1: %b", dut.DP.REGFILE.R1);
        $display("R3: %b", dut.DP.REGFILE.R3);

        if (dut.DP.REGFILE.R3 !== 16'b0000000000000000) begin //no matches so should be all 0
            err = 1;
        end

        // MVN R4, R0  ------------------------------------------------------------------------------

        @(negedge clk); // wait for falling edge of clock before changing inputs
        in = 16'b101_11_000_100_00_000;
        load = 1;
        #10;

        load = 0;
        s = 1;
        #10;

        s = 0;
        @(posedge w); // wait for w to go high again
        #10;

        $display("MVN R4, R0");
        $display("R0: %b", dut.DP.REGFILE.R0);
        $display("R4: %b", dut.DP.REGFILE.R4);

        if (dut.DP.REGFILE.R4 !== 16'b1111111111110111) begin //Move and negate contents of R0 (8) to R4 (-8)
            err = 1;
        end

        // MOV R5, R1 (shifted by 1 bit)  ------------------------------------------------------------------------------

        @(negedge clk); // wait for falling edge of clock before changing inputs
        in = 16'b110_00_000_101_01_001;
        load = 1;
        #10;

        load = 0;
        s = 1;
        #10;

        s = 0;
        @(posedge w); // wait for w to go high again
        #10;

        $display("MOV R5, R1*2");
        $display("R1 (5): %b", dut.DP.REGFILE.R1);
        $display("R5 (10): %b", dut.DP.REGFILE.R5);

        if (dut.DP.REGFILE.R5 !== 16'b0000000000001010) begin //contents of R1 shifted by 1 bit (5*2) is moved to R5 (10)
            err = 1;
        end

        $stop;
    end
endmodule
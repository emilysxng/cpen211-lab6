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
    reg N, V, Z, w, reset, s;

    reg [15:0] current_instruction;
    reg [2:0] nsel;
    reg [2:0] opcode;
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
    reg asel,bsel,loada,loadb,loadc,vsel,write;

    cpu dut (clk, reset, s, load, in, out, N, V, Z, w);
    FSM_controller dup(clk, reset, s, opcode,  op, nsel, asel, bsel, w, loada,loadb,loadc, loads, ALUop, vsel, write);

    initial begin
        clk = 1'b0; #5; //rising edge of clock every 5 time units
        forever begin
            clk = 1'b1; #5;
            clk = 1'b0; #5;
        end
    end

/*
    initial begin
        s = 1'b0;
        #5;
        s = 1'b1;
        #5;
        opcode = 16'b110_10_000_00000010; //MOV r0, 2
        op = 2'b01;
        #100;
        opcode = 16'b110_10_001_00000111; //MOV r1, 7
        op = 2'b01;
        #100;
        opcode = 16'b110_10_000_000_00_010; //ADD R2, R1, R0
        op = 2'b01;
        #100;
        opcode = 16'b101_01_000_000_00_001; //CMP R1, R0
        op = 2'b01;
        #100;
    end
*/

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

        #100;

        //FSM tests  
        reset = 1'b1;#10;
        reset = 1'b0;#5;
        err = 1'b0;

        // ADD test ----------------------------------------------------------------------------------------------------------------------

        s = 1'b0;
        $display("Check to see if we are in waiting state: %b", dut.present_state);
        if (w == s) begin
            err = 1'b1; 
        end

        #5;

        s = 1'b1;
        opcode = 3'b101;
        op = 2'b00;
        $display("Check to see if we are in GET_A): %b", dut.present_state);
        if (dut.present_state != `GET_A) begin
            err = 1'b1; 
        end

        #5;

        $display("Check to see if we are in GET_B: %b", dut.present_state);
        if (dut.present_state != `GET_B) begin
            err = 1'b1; 
        end

        #5;

        $display("Check to see if we are in ADD: %b", dut.present_state);
        if (dut.present_state != `ADD) begin
            err = 1'b1; 
        end

        #5;


        $display("Check to see if we are in WRITE_REG: %b",dut.present_state );
        if (dut.present_state != `WRITE_REG) begin
            err = 1'b1; 
        end

        #5;

        //CHECK CONTENTS OF ADD

        // CMP Test ----------------------------------------------------------------------------------------------------------------------

        s = 1'b0;
        $display("Check to see if we are in waiting state: %b", dut.present_state);
        if (w == s) begin
            err = 1'b1; 
        end

        #5;

        s = 1'b1;
        opcode = 3'b101;
        op = 2'b01;
        $display("Check to see if we are in GET_A): %b", dut.present_state);
        if (dut.present_state != `GET_A) begin
            err = 1'b1; 
        end

        #5;

        $display("Check to see if we are in GET_B: %b", dut.present_state);
        if (dut.present_state != `GET_B) begin
            err = 1'b1; 
        end

        #5;

        $display("Check to see if we are in CMP: %b", dut.present_state);
        if (dut.present_state != `CMP) begin
            err = 1'b1; 
        end

        //SUPPOSED TO CHECK STATUS HERE

        #5;
 
        // AND Test ----------------------------------------------------------------------------------------------------------------------

        s = 1'b0;
        $display("Check to see if we are in waiting state: %b", dut.present_state);
        if (w == s) begin
            err = 1'b1; 
        end

        #5;

        s = 1'b1;
        opcode = 3'b101;
        op = 2'b10;
        $display("Check to see if we are in GET_A): %b", dut.present_state);
        if (dut.present_state != `GET_A) begin
            err = 1'b1; 
        end

        #5;

        $display("Check to see if we are in GET_B: %b", dut.present_state);
        if (dut.present_state != `GET_B) begin
            err = 1'b1; 
        end

        #5;

        $display("Check to see if we are in AND: %b", dut.present_state);
        if (dut.present_state != `AND) begin
            err = 1'b1; 
        end

        //SUPPOSED TO WRITE THE RESULT OF AND TO RD HERE

        #5;

        // MVN Test ----------------------------------------------------------------------------------------------------------------------

        $display("Check to see if we are in waiting state: %b", dut.present_state);
        if (dut.present_state != `WRITE_REG) begin
            err = 1'b1; 
        end

        #5;

        s = 1'b1;
        opcode = 3'b101;
        op = 2'b11;
        $display("Check to see if we are in GET_A): %b", dut.present_state);
        if (dut.present_state != `GET_A) begin
            err = 1'b1; 
        end

        #5;

        $display("Check to see if we are in GET_B: %b", dut.present_state);
        if (dut.present_state != `GET_B) begin
            err = 1'b1; 
        end

        #5;

        $display("Check to see if we are in MVN: %b", dut.present_state);
        if (dut.present_state != `MVN) begin
            err = 1'b1; 
        end

        #5;

        $display("Check to see if we are in WRITE_REG: %b",dut.present_state );
        if (dut.present_state != `WRITE_REG) begin
            err = 1'b1; 
        end

        #5;

        //CHECK CONTENTS OF RD

        // MOV sximm8 Test ----------------------------------------------------------------------------------------------------------------------
        

        // MOV reg -> reg Test ----------------------------------------------------------------------------------------------------------------------

        $stop;  
    end

endmodule
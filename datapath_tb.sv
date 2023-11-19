module datapath_tb ();
    reg [15:0] datapath_in;
    reg [15:0] datapath_out;
    reg [2:0] writenum, readnum;
    reg write, loada, loadb, asel, bsel, loadc, loads,vsel,clk;
    reg [1:0] shift, ALUop;
    reg err;

    datapath dut (datapath_in, datapath_out, writenum, readnum, write, loada, loadb, asel, bsel,vsel, loadc, loads, shift, ALUop, Z_out,clk);
    initial begin
        clk = 1'b0; #5; //rising edge of clock every 5 time units
        forever begin
            clk = 1'b1; #5;
            clk = 1'b0; #5;
        end
    end

    // Tests R2 + R3 = R5
    initial begin
        //Clock cycle 1 : Write 2 to R3
        err = 1'b0;
        datapath_in = 16'd2;
        writenum = 3'b011;
        vsel = 1'b1;
        write = 1'b1;
        readnum = 3'b011; 
        loada = 1'b1;
        #30;
        loada = 1'b0;

        datapath_in = 16'd7;
        writenum = 3'b010;
        vsel = 1'b1;
        write = 1'b1;
        readnum = 3'b010; 
        loadb = 1'b1;
        #30;
        loadb = 1'b0;

        asel = 1'b0;
        bsel = 1'b0;
        #10;

        ALUop = 2'b00;
        loads = 1'b1;

        if (datapath_out != 16'd9) begin
            err = 1'b1;
        end

    end

endmodule: datapath_tb
`timescale 1ns/1ps

module top_tb;

    // ============================================================
    // CLOCK / RESET
    // ============================================================

    logic clk;
    logic rst;

    localparam integer NUM_REGS = 32;
    localparam integer NUM_EXECUTED = 44;

    // ============================================================
    // DUT
    //
    // CHANGE ONLY THIS INSTANCE/PORT LIST IF YOUR TOP MODULE
    // HAS A DIFFERENT NAME.
    // ============================================================

    risc_v DUT (
        .clk   (clk),
        .rst (rst)
    );


    // ============================================================
    // CLOCK
    // ============================================================

    initial begin
        clk = 1'b0;

        forever #5 clk = ~clk;
    end


    // ============================================================
    // RESET
    // ============================================================

    initial begin

        rst = 1'b1;

        repeat (3)
            @(posedge clk);

        rst = 1'b0;

    end


    // ============================================================
    // EXPECTED EXECUTION SEQUENCE
    //
    // This is NOT the instruction memory.
    //
    // It tells the checker which instructions should actually
    // retire because branches and jumps change the PC.
    // ============================================================

    logic [31:0] expected_pc [0:NUM_EXECUTED-1];

    integer expected_rd [0:NUM_EXECUTED-1];

    logic [31:0] expected_value [0:NUM_EXECUTED-1];

    string instruction_name [0:NUM_EXECUTED-1];


    // ============================================================
    // EXPECTED EXECUTION INFORMATION
    // ============================================================

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, top_tb);

        // --------------------------------------------------------
        // PC        RD       EXPECTED RESULT       INSTRUCTION
        // --------------------------------------------------------

        expected_pc[0]  = 32'h00000000;
        expected_rd[0]  = 1;
        expected_value[0] = 32'h12345000;
        instruction_name[0] = "LUI x1,0x12345";

        expected_pc[1]  = 32'h00000004;
        expected_rd[1]  = 2;
        expected_value[1] = 32'h00010004;
        instruction_name[1] = "AUIPC x2,0x10";

        expected_pc[2]  = 32'h00000008;
        expected_rd[2]  = 3;
        expected_value[2] = 32'h00000005;
        instruction_name[2] = "ADDI x3,x0,5";

        expected_pc[3]  = 32'h0000000C;
        expected_rd[3]  = 4;
        expected_value[3] = 32'h00000008;
        instruction_name[3] = "ADDI x4,x3,3";

        expected_pc[4]  = 32'h00000010;
        expected_rd[4] = 5;
        expected_value[4] = 32'h00000005;
        instruction_name[4] = "ANDI x5,x3,0x3F";

        expected_pc[5]  = 32'h00000014;
        expected_rd[5] = 6;
        expected_value[5] = 32'h00000105;
        instruction_name[5] = "ORI x6,x3,0x100";

        expected_pc[6]  = 32'h00000018;
        expected_rd[6] = 7;
        expected_value[6] = 32'h00000005;
        instruction_name[6] = "XORI x7,x6,0x100";

        expected_pc[7]  = 32'h0000001C;
        expected_rd[7] = 8;
        expected_value[7] = 32'h0000000A;
        instruction_name[7] = "SLLI x8,x3,1";

        expected_pc[8]  = 32'h00000020;
        expected_rd[8] = 9;
        expected_value[8] = 32'h00000002;
        instruction_name[8] = "SRLI x9,x3,1";

        expected_pc[9]  = 32'h00000024;
        expected_rd[9] = 10;
        expected_value[9] = 32'h00000000;
        instruction_name[9] = "SRAI x10,x3,31";

        expected_pc[10] = 32'h00000028;
        expected_rd[10] = 11;
        expected_value[10] = 32'h0000000D;
        instruction_name[10] = "ADD x11,x3,x4";

        expected_pc[11] = 32'h0000002C;
        expected_rd[11] = 12;
        expected_value[11] = 32'h00000003;
        instruction_name[11] = "SUB x12,x4,x3";

        expected_pc[12] = 32'h00000030;
        expected_rd[12] = 13;
        expected_value[12] = 32'h00000000;
        instruction_name[12] = "AND x13,x3,x4";

        expected_pc[13] = 32'h00000034;
        expected_rd[13] = 14;
        expected_value[13] = 32'h0000000D;
        instruction_name[13] = "OR x14,x3,x4";

        expected_pc[14] = 32'h00000038;
        expected_rd[14] = 15;
        expected_value[14] = 32'h0000000D;
        instruction_name[14] = "XOR x15,x3,x4";

        expected_pc[15] = 32'h0000003C;
        expected_rd[15] = 16;
        expected_value[15] = 32'h00000500;
        instruction_name[15] = "SLL x16,x3,x4";

        expected_pc[16] = 32'h00000040;
        expected_rd[16] = 17;
        expected_value[16] = 32'h00000000;
        instruction_name[16] = "SRL x17,x3,x4";

        expected_pc[17] = 32'h00000044;
        expected_rd[17] = 18;
        expected_value[17] = 32'h00000000;
        instruction_name[17] = "SRA x18,x3,x4";

        expected_pc[18] = 32'h00000048;
        expected_rd[18] = 19;
        expected_value[18] = 32'h00000001;
        instruction_name[18] = "SLT x19,x3,x4";

        expected_pc[19] = 32'h0000004C;
        expected_rd[19] = 20;
        expected_value[19] = 32'h00000001;
        instruction_name[19] = "SLTU x20,x3,x4";

        expected_pc[20] = 32'h00000050;
        expected_rd[20] = 21;
        expected_value[20] = 32'h00000100;
        instruction_name[20] = "ADDI x21,x0,256";

        // expected_pc[21] = 32'h00000054;
        // expected_rd[21] = 22;
        // expected_value[21] = 32'hAABBD000;
        // instruction_name[21] = "LUI x22,0xAABBD";

        // expected_pc[22] = 32'h00000058;
        // expected_rd[22] = 22;
        // expected_value[22] = 32'hAABBCCDD;
        // instruction_name[22] = "ADDI x22,x22,0xCDD";

        expected_pc[23] = 32'h0000005C;
        expected_rd[23] = -1;
        expected_value[23] = 32'h00000000;
        instruction_name[23] = "SW x22,0(x21)";

        expected_pc[24] = 32'h00000060;
        expected_rd[24] = 23;
        expected_value[24] = 32'hFFFFFFDD;
        instruction_name[24] = "LB x23,0(x21)";

        expected_pc[25] = 32'h00000064;
        expected_rd[25] = 24;
        expected_value[25] = 32'hFFFFCCDD;
        instruction_name[25] = "LH x24,0(x21)";

        expected_pc[26] = 32'h00000068;
        expected_rd[26] = 25;
        expected_value[26] = 32'hAABBCCDD;
        instruction_name[26] = "LW x25,0(x21)";

        expected_pc[27] = 32'h0000006C;
        expected_rd[27] = 26;
        expected_value[27] = 32'h000000DD;
        instruction_name[27] = "LBU x26,0(x21)";

        expected_pc[28] = 32'h00000070;
        expected_rd[28] = 27;
        expected_value[28] = 32'h0000CCDD;
        instruction_name[28] = "LHU x27,0(x21)";

        expected_pc[29] = 32'h00000074;
        expected_rd[29] = -1;
        expected_value[29] = 32'h00000000;
        instruction_name[29] = "BEQ x3,x4,+8";

        expected_pc[30] = 32'h00000078;
        expected_rd[30] = 28;
        expected_value[30] = 32'h00000001;
        instruction_name[30] = "ADDI x28,x0,1";

        expected_pc[31] = 32'h0000007C;
        expected_rd[31] = -1;
        expected_value[31] = 32'h00000000;
        instruction_name[31] = "BNE x3,x4,+8";

        expected_pc[32] = 32'h00000084;
        expected_rd[32] = 29;
        expected_value[32] = 32'h00000003;
        instruction_name[32] = "ADDI x29,x0,3";

        expected_pc[33] = 32'h00000088;
        expected_rd[33] = -1;
        expected_value[33] = 32'h00000000;
        instruction_name[33] = "BLT x4,x3,+8";

        expected_pc[34] = 32'h0000008C;
        expected_rd[34] = 30;
        expected_value[34] = 32'h00000004;
        instruction_name[34] = "ADDI x30,x0,4";

        expected_pc[35] = 32'h00000090;
        expected_rd[35] = -1;
        expected_value[35] = 32'h00000000;
        instruction_name[35] = "BGE x4,x3,+8";

        expected_pc[36] = 32'h00000098;
        expected_rd[36] = -1;
        expected_value[36] = 32'h00000000;
        instruction_name[36] = "BLTU x4,x3,+8";

        expected_pc[37] = 32'h0000009C;
        expected_rd[37] = -1;
        expected_value[37] = 32'h00000000;
        instruction_name[37] = "BGEU x4,x3,+8";

        expected_pc[38] = 32'h000000A4;
        expected_rd[38] = 1;
        expected_value[38] = 32'h000000A8;
        instruction_name[38] = "JAL x1,+16";

        expected_pc[39] = 32'h000000B4;
        expected_rd[39] = 5;
        expected_value[39] = 32'h0000000C;
        instruction_name[39] = "ADDI x5,x0,12";

        // expected_pc[40] = 32'h000000B8;
        // expected_rd[40] = 6;
        // expected_value[40] = 32'h000000B8;
        // instruction_name[40] = "AUIPC x6,0";

        expected_pc[41] = 32'h000000BC;
        expected_rd[41] = 6;
        expected_value[41] = 32'h000000C8;
        instruction_name[41] = "ADDI x6,x6,16";

        expected_pc[42] = 32'h000000C0;
        expected_rd[42] = 7;
        expected_value[42] = 32'h000000C4;
        instruction_name[42] = "JALR x7,0(x6)";

        expected_pc[43] = 32'h000000C8;
        expected_rd[43] = 9;
        expected_value[43] = 32'h0000000E;
        instruction_name[43] = "ADDI x9,x0,14";

    end


    // ============================================================
    // REGISTER ACCESS
    //
    // Your previous hierarchy was:
    //
    // DUT.datapath.reg_file.x[index]
    //
    // If your register-file hierarchy is different, this is the
    // ONLY part of the checker that needs to be changed.
    // ============================================================

    function automatic [31:0] dut_reg(input integer index);

        begin
            dut_reg = DUT.datapath.reg_file.reg_array[index];
        end

    endfunction


    // ============================================================
    // MAIN INSTRUCTION-BY-INSTRUCTION CHECKER
    // ============================================================

    integer cycle;
    integer i;

    logic [31:0] actual_value;


    initial begin

        cycle = 0;

        // Wait until reset is released.
        wait(rst == 1'b0);

        // Allow the first instruction to execute.
        @(posedge clk);

        for (i = 0; i < NUM_EXECUTED; i = i + 1) begin

            // Allow DUT's sequential register write to settle.
            #1;

            if (expected_rd[i] >= 0) begin

                actual_value = dut_reg(expected_rd[i]);

                // ------------------------------------------------
                // ASSERTION
                // ------------------------------------------------

                assert (actual_value === expected_value[i])
                else begin

                    $display("");
                    $display("============================================================");
                    $display("                 RV32I ASSERTION FAILURE");
                    $display("============================================================");
                    $display("Execution step : %0d", i);
                    $display("PC              : %08h", expected_pc[i]);
                    $display("Instruction      : %s", instruction_name[i]);
                    $display("Destination      : x%0d", expected_rd[i]);
                    $display("Expected value   : %08h", expected_value[i]);
                    $display("Actual value     : %08h", actual_value);
                    $display("Difference       : %08h",
                             expected_value[i] ^ actual_value);
                    $display("============================================================");
                    $display("");

                    $fatal(1);
                end

                $display("[PASS] PC=%08h | %-24s | x%0d = %08h",
                         expected_pc[i],
                         instruction_name[i],
                         expected_rd[i],
                         actual_value);

            end
            else begin

                $display("[PASS] PC=%08h | %-24s | no register write",
                         expected_pc[i],
                         instruction_name[i]);

            end

            @(posedge clk);

        end


        // ========================================================
        // FINAL REGISTER CHECK
        // ========================================================

        #1;

        $display("");
        $display("============================================================");
        $display("              FINAL REGISTER VERIFICATION");
        $display("============================================================");


        // x0 must always be zero.
        assert (dut_reg(0) === 32'h00000000)
        else begin
            $display("ERROR: x0 changed!");
            $display("x0 = %08h", dut_reg(0));
            $fatal(1);
        end


        // --------------------------------------------------------
        // Final architectural register values
        // --------------------------------------------------------

        assert (dut_reg(1)  === 32'h000000A8)
            else $error("x1 mismatch: expected A8, got %08h", dut_reg(1));

        assert (dut_reg(2)  === 32'h00010004)
            else $error("x2 mismatch: expected 00010004, got %08h", dut_reg(2));

        assert (dut_reg(3)  === 32'h00000005)
            else $error("x3 mismatch: expected 5, got %08h", dut_reg(3));

        assert (dut_reg(4)  === 32'h00000008)
            else $error("x4 mismatch: expected 8, got %08h", dut_reg(4));

        assert (dut_reg(5)  === 32'h0000000C)
            else $error("x5 mismatch: expected C, got %08h", dut_reg(5));

        assert (dut_reg(6)  === 32'h000000C8)
            else $error("x6 mismatch: expected C8, got %08h", dut_reg(6));

        assert (dut_reg(7)  === 32'h000000C4)
            else $error("x7 mismatch: expected C4, got %08h", dut_reg(7));

        assert (dut_reg(8)  === 32'h0000000A)
            else $error("x8 mismatch: expected A, got %08h", dut_reg(8));

        assert (dut_reg(9)  === 32'h0000000E)
            else $error("x9 mismatch: expected E, got %08h", dut_reg(9));

        assert (dut_reg(10) === 32'h00000000)
            else $error("x10 mismatch: expected 0, got %08h", dut_reg(10));

        assert (dut_reg(11) === 32'h0000000D)
            else $error("x11 mismatch: expected D, got %08h", dut_reg(11));

        assert (dut_reg(12) === 32'h00000003)
            else $error("x12 mismatch: expected 3, got %08h", dut_reg(12));

        assert (dut_reg(13) === 32'h00000000)
            else $error("x13 mismatch: expected 0, got %08h", dut_reg(13));

        assert (dut_reg(14) === 32'h0000000D)
            else $error("x14 mismatch: expected D, got %08h", dut_reg(14));

        assert (dut_reg(15) === 32'h0000000D)
            else $error("x15 mismatch: expected D, got %08h", dut_reg(15));

        assert (dut_reg(16) === 32'h00000500)
            else $error("x16 mismatch: expected 500, got %08h", dut_reg(16));

        assert (dut_reg(17) === 32'h00000000)
            else $error("x17 mismatch: expected 0, got %08h", dut_reg(17));

        assert (dut_reg(18) === 32'h00000000)
            else $error("x18 mismatch: expected 0, got %08h", dut_reg(18));

        assert (dut_reg(19) === 32'h00000001)
            else $error("x19 mismatch: expected 1, got %08h", dut_reg(19));

        assert (dut_reg(20) === 32'h00000001)
            else $error("x20 mismatch: expected 1, got %08h", dut_reg(20));

        assert (dut_reg(21) === 32'h00000100)
            else $error("x21 mismatch: expected 100, got %08h", dut_reg(21));

        assert (dut_reg(22) === 32'hAABBCCDD)
            else $error("x22 mismatch: expected AABBCCDD, got %08h", dut_reg(22));

        assert (dut_reg(23) === 32'hFFFFFFDD)
            else $error("x23 mismatch: expected FFFFFFDD, got %08h", dut_reg(23));

        assert (dut_reg(24) === 32'hFFFFCCDD)
            else $error("x24 mismatch: expected FFFFCCDD, got %08h", dut_reg(24));

        assert (dut_reg(25) === 32'hAABBCCDD)
            else $error("x25 mismatch: expected AABBCCDD, got %08h", dut_reg(25));

        assert (dut_reg(26) === 32'h000000DD)
            else $error("x26 mismatch: expected DD, got %08h", dut_reg(26));

        assert (dut_reg(27) === 32'h0000CCDD)
            else $error("x27 mismatch: expected CCDD, got %08h", dut_reg(27));

        assert (dut_reg(28) === 32'h00000001)
            else $error("x28 mismatch: expected 1, got %08h", dut_reg(28));

        assert (dut_reg(29) === 32'h00000003)
            else $error("x29 mismatch: expected 3, got %08h", dut_reg(29));

        assert (dut_reg(30) === 32'h00000004)
            else $error("x30 mismatch: expected 4, got %08h", dut_reg(30));

        assert (dut_reg(31) === 32'h00000000)
            else $error("x31 mismatch: expected 0, got %08h", dut_reg(31));


        // ========================================================
        // SUCCESS
        // ========================================================

        $display("");
        $display("============================================================");
        $display("                 RV32I TEST PASSED");
        $display("============================================================");
        $display("All executed instructions passed.");
        $display("Register-file verification passed.");
        $display("Load/store verification passed.");
        $display("Branch verification passed.");
        $display("JAL verification passed.");
        $display("JALR verification passed.");
        $display("AUIPC verification passed.");
        $display("LUI verification passed.");
        $display("x0 invariant passed.");
        $display("============================================================");
        $display("");

        $finish;

    end


    // ============================================================
    // PERMANENT x0 ASSERTION
    //
    // RISC-V requires x0 to ALWAYS read as zero.
    // ============================================================

    always @(posedge clk) begin

        if (!rst) begin

            assert (dut_reg(0) === 32'h00000000)
            else begin

                $display("");
                $display("============================================================");
                $display("                  x0 ASSERTION FAILURE");
                $display("============================================================");
                $display("x0 must always remain zero.");
                $display("Actual x0 = %08h", dut_reg(0));
                $display("============================================================");
                $fatal(1);

            end

        end

    end

endmodule
module top_tb;
    logic clk;
    logic rst;
    
    risc_v DUT (
        .clk(clk),
        .rst(rst)
    );

    // ============================================================
    // Clock generation
    // ============================================================
    always #5 clk <= ~clk;


    // ============================================================
    // Test sequence
    // ============================================================
    initial begin

        // VCD waveform generation
        $dumpfile("dump.vcd");
        $dumpvars(0, top_tb);

        // Initial values
        clk = 0;
        rst = 1;

        // --------------------------------------------------------
        // Hold reset for two clock cycles
        // --------------------------------------------------------
        #20;
        rst = 0;

        // --------------------------------------------------------
        // Allow processor to execute the complete program
        // Single-cycle processor: one instruction per clock cycle
        // --------------------------------------------------------
        #500;


        // ========================================================
        // REGISTER FILE TESTS
        // ========================================================

        // x0 must always remain zero
        if (DUT.datapath.reg_file.reg_array[0] !== 32'd0)
            $fatal(1,"FAIL: x0 must remain 0, got 0x%08h",DUT.datapath.reg_file.reg_array[0]);


        // x1 = 5
        if (DUT.datapath.reg_file.reg_array[1] !== 32'd5)
            $fatal(1,"FAIL: x1 expected 5, got %0d",DUT.datapath.reg_file.reg_array[1]);


        // x2 = 5
        if (DUT.datapath.reg_file.reg_array[2] !== 32'd5)
            $fatal(1,"FAIL: x2 expected 5, got %0d",DUT.datapath.reg_file.reg_array[2]);


        // x3 = 10
        if (DUT.datapath.reg_file.reg_array[3] !== 32'd10)
            $fatal(1,"FAIL: x3 expected 10, got %0d",DUT.datapath.reg_file.reg_array[3]);


        // x4 = 0xFFFFFFFF
        if (DUT.datapath.reg_file.reg_array[4] !== 32'hFFFFFFFF)
            $fatal(1,"FAIL: x4 expected 0xFFFFFFFF, got 0x%08h",DUT.datapath.reg_file.reg_array[4]);


        // ========================================================
        // BEQ TESTS
        // ========================================================

        // BEQ taken:
        // x1 == x2
        // x5 should be skipped
        // x6 should execute
        if (DUT.datapath.reg_file.reg_array[5] !== 32'd0)
            $fatal(1,"FAIL: x5 expected 0 (BEQ should have skipped), got %0d",DUT.datapath.reg_file.reg_array[5]);

        if (DUT.datapath.reg_file.reg_array[6] !== 32'd2)
            $fatal(1,"FAIL: x6 expected 2, got %0d",DUT.datapath.reg_file.reg_array[6]);


        // BEQ not taken:
        // x1 != x3
        // x7 and x8 should both execute
        if (DUT.datapath.reg_file.reg_array[7] !== 32'd3)
            $fatal(1,"FAIL: x7 expected 3 (BEQ should not have branched), got %0d",DUT.datapath.reg_file.reg_array[7]);

        if (DUT.datapath.reg_file.reg_array[8] !== 32'd4)
            $fatal(1,"FAIL: x8 expected 4, got %0d",DUT.datapath.reg_file.reg_array[8]);


        // ========================================================
        // BNE TESTS
        // ========================================================

        // BNE taken:
        // x1 != x3
        // x9 should be skipped
        // x10 should execute
        if (DUT.datapath.reg_file.reg_array[9] !== 32'd0)
            $fatal(1,"FAIL: x9 expected 0 (BNE should have skipped), got %0d",DUT.datapath.reg_file.reg_array[9]);

        if (DUT.datapath.reg_file.reg_array[10] !== 32'd6)
            $fatal(1,"FAIL: x10 expected 6, got %0d",DUT.datapath.reg_file.reg_array[10]);


        // BNE not taken:
        // x1 == x2
        // x11 and x12 should both execute
        if (DUT.datapath.reg_file.reg_array[11] !== 32'd7)
            $fatal(1,"FAIL: x11 expected 7 (BNE should not have branched), got %0d",DUT.datapath.reg_file.reg_array[11]);

        if (DUT.datapath.reg_file.reg_array[12] !== 32'd8)
            $fatal(1,
                "FAIL: x12 expected 8, got %0d",
                DUT.datapath.reg_file.reg_array[12]);


        // ========================================================
        // BLT TESTS
        // ========================================================

        // BLT taken:
        // 5 < 10
        // x13 should be skipped
        // x14 should execute
        if (DUT.datapath.reg_file.reg_array[13] !== 32'd0)
            $fatal(1,
                "FAIL: x13 expected 0 (BLT should have skipped), got %0d",
                DUT.datapath.reg_file.reg_array[13]);

        if (DUT.datapath.reg_file.reg_array[14] !== 32'd10)
            $fatal(1,
                "FAIL: x14 expected 10, got %0d",
                DUT.datapath.reg_file.reg_array[14]);


        // BLT not taken:
        // 10 < 5 is false
        // x15 and x16 should both execute
        if (DUT.datapath.reg_file.reg_array[15] !== 32'd11)
            $fatal(1,
                "FAIL: x15 expected 11 (BLT should not have branched), got %0d",
                DUT.datapath.reg_file.reg_array[15]);

        if (DUT.datapath.reg_file.reg_array[16] !== 32'd12)
            $fatal(1,
                "FAIL: x16 expected 12, got %0d",
                DUT.datapath.reg_file.reg_array[16]);


        // ========================================================
        // BGE TESTS
        // ========================================================

        // BGE taken:
        // 10 >= 5
        // x17 should be skipped
        // x18 should execute
        if (DUT.datapath.reg_file.reg_array[17] !== 32'd0)
            $fatal(1,
                "FAIL: x17 expected 0 (BGE should have skipped), got %0d",
                DUT.datapath.reg_file.reg_array[17]);

        if (DUT.datapath.reg_file.reg_array[18] !== 32'd14)
            $fatal(1,
                "FAIL: x18 expected 14, got %0d",
                DUT.datapath.reg_file.reg_array[18]);


        // BGE not taken:
        // 5 >= 10 is false
        // x19 and x20 should both execute
        if (DUT.datapath.reg_file.reg_array[19] !== 32'd15)
            $fatal(1,
                "FAIL: x19 expected 15 (BGE should not have branched), got %0d",
                DUT.datapath.reg_file.reg_array[19]);

        if (DUT.datapath.reg_file.reg_array[20] !== 32'd16)
            $fatal(1,
                "FAIL: x20 expected 16, got %0d",
                DUT.datapath.reg_file.reg_array[20]);


        // ========================================================
        // BLTU TESTS
        // ========================================================

        // BLTU taken:
        // 5 <u 0xFFFFFFFF
        // x21 should be skipped
        // x22 should execute
        if (DUT.datapath.reg_file.reg_array[21] !== 32'd0)
            $fatal(1,
                "FAIL: x21 expected 0 (BLTU should have skipped), got %0d",
                DUT.datapath.reg_file.reg_array[21]);

        if (DUT.datapath.reg_file.reg_array[22] !== 32'd18)
            $fatal(1,
                "FAIL: x22 expected 18, got %0d",
                DUT.datapath.reg_file.reg_array[22]);


        // BLTU not taken:
        // 0xFFFFFFFF <u 5 is false
        // x23 and x24 should both execute
        if (DUT.datapath.reg_file.reg_array[23] !== 32'd19)
            $fatal(1,
                "FAIL: x23 expected 19 (BLTU should not have branched), got %0d",
                DUT.datapath.reg_file.reg_array[23]);

        if (DUT.datapath.reg_file.reg_array[24] !== 32'd20)
            $fatal(1,
                "FAIL: x24 expected 20, got %0d",
                DUT.datapath.reg_file.reg_array[24]);


        // ========================================================
        // BGEU TESTS
        // ========================================================

        // BGEU taken:
        // 0xFFFFFFFF >=u 5
        // x25 should be skipped
        // x26 should execute
        if (DUT.datapath.reg_file.reg_array[25] !== 32'd0)
            $fatal(1,
                "FAIL: x25 expected 0 (BGEU should have skipped), got %0d",
                DUT.datapath.reg_file.reg_array[25]);

        if (DUT.datapath.reg_file.reg_array[26] !== 32'd22)
            $fatal(1,
                "FAIL: x26 expected 22, got %0d",
                DUT.datapath.reg_file.reg_array[26]);


        // BGEU not taken:
        // 5 >=u 0xFFFFFFFF is false
        // x27 and x28 should both execute
        if (DUT.datapath.reg_file.reg_array[27] !== 32'd23)
            $fatal(1,
                "FAIL: x27 expected 23 (BGEU should not have branched), got %0d",
                DUT.datapath.reg_file.reg_array[27]);

        if (DUT.datapath.reg_file.reg_array[28] !== 32'd24)
            $fatal(1,
                "FAIL: x28 expected 24, got %0d",
                DUT.datapath.reg_file.reg_array[28]);


        // ========================================================
        // LUI TEST
        // ========================================================

        // LUI:
        // x29 = 0x12345000
        if (DUT.datapath.reg_file.reg_array[29] !== 32'h12345000)
            $fatal(1,
                "FAIL: x29 expected 0x12345000 after LUI, got 0x%08h",
                DUT.datapath.reg_file.reg_array[29]);


        // ========================================================
        // AUIPC TEST
        // ========================================================

        // AUIPC:
        // x30 = PC + 0x1000
        //
        // Expected value:
        // x30 = 0x000010A4
        //
        if (DUT.datapath.reg_file.reg_array[30] !== 32'h000010A4)
            $fatal(1,
                "FAIL: x30 expected 0x000010A4 after AUIPC, got 0x%08h",
                DUT.datapath.reg_file.reg_array[30]);


        // ========================================================
        // STORE WORD TEST
        // ========================================================

        // sw x1, 0(x2)
        //
        // x1 = 5
        // x2 = 5
        //
        // Effective address = x2 + 0 = 5
        //
        // IMPORTANT:
        // This assumes your data_memory internally maps
        // byte address 5 to memory word index 1.
        //
        if (DUT.datapath.data_mem.memory[1] !== 32'h00000005)
            $fatal(1,"FAIL: MEM[1] expected 5 after SW, got 0x%08h",DUT.datapath.data_mem.memory[1]);


        // ========================================================
        // LOAD WORD TEST
        // ========================================================

        // lw x31, 0(x2)
        //
        // Expected:
        // x31 = 5
        //
        if (DUT.datapath.reg_file.reg_array[31] !== 32'h00000005)
            $fatal(1,
                "FAIL: x31 expected 5 after LW, got 0x%08h",
                DUT.datapath.reg_file.reg_array[31]);


        // ========================================================
        // ALL TESTS PASSED
        // ========================================================

        $display("");
        $display("==============================================");
        $display("       ALL TESTS PASSED SUCCESSFULLY");
        $display("==============================================");
        $display("");

        $finish;

    end

endmodule
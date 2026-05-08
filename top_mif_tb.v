`timescale 1ns / 1ps

module top_mif_tb;

    // ============================
    // Clock / Reset
    // ============================
    reg clk;
    reg reset;

    // ============================
    // DUT outputs
    // ============================
    wire halted;
    wire [7:0]  pc_debug;
    wire [15:0] instr_debug;
    wire        exec_state_debug;

    integer cycle_count;

    // ============================
    // DUT
    // ============================
    top_mif uut (
        .clk              (clk),
        .reset            (reset),
        .halted           (halted),
        .pc_debug         (pc_debug),
        .instr_debug      (instr_debug),
        .exec_state_debug (exec_state_debug)
    );

    // ============================
    // Clock generation
    // 10ns period = 100MHz
    // ============================
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    // ============================
    // Test sequence
    // ============================
    initial begin
        cycle_count = 0;

        $display("========================================");
        $display(" top_mif ROM-based CPU Test START ");
        $display("========================================");

        // Reset
        reset = 1'b1;
        #30;
        reset = 1'b0;

        // Run until HALT or timeout
        while (halted == 1'b0 && cycle_count < 600) begin
            @(posedge clk);
            #1;

            cycle_count = cycle_count + 1;

            $display(
                "cycle=%0d | state=%b | pc=%0d | instr=%h | halted=%b",
                cycle_count,
                exec_state_debug,
                pc_debug,
                instr_debug,
                halted
            );
        end

        $display("========================================");
        $display(" Final Register Values ");
        $display("========================================");

        $display("R0 = %h", uut.cpu.u_regfile.regs[0]);
        $display("R1 = %h", uut.cpu.u_regfile.regs[1]);
        $display("R2 = %h", uut.cpu.u_regfile.regs[2]);
        $display("R3 = %h", uut.cpu.u_regfile.regs[3]);
        $display("R4 = %h", uut.cpu.u_regfile.regs[4]);
        $display("R5 = %h", uut.cpu.u_regfile.regs[5]);
        $display("R6 = %h", uut.cpu.u_regfile.regs[6]);
        $display("R7 = %h", uut.cpu.u_regfile.regs[7]);

        $display("========================================");
        $display(" Test Result ");
        $display("========================================");

        if (halted == 1'b1) begin
            $display("TEST PASSED");
            $display("CPU halted normally.");
            $display("Final PC = %0d", pc_debug);
        end
        else begin
            $display("TEST FAILED");
            $display("CPU did not halt within timeout.");
            $display("Final PC = %0d", pc_debug);
        end

        $display("Total cycles = %0d", cycle_count);

        $stop;
    end

endmodule
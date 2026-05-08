// ============================================================
// File: pc.v
// Description:
//   Program Counter for SimpleCPU16
//
// Features:
//   - 8-bit PC
//   - Synchronous reset
//   - Enable controlled
//   - Synthesizable
// ============================================================

module pc (
    input  wire       clk,
    input  wire       reset,
    input  wire       enable,
    output reg  [7:0] pc_out
);

    always @(posedge clk) begin
        if (reset) begin
            pc_out <= 8'd0;
        end
        else begin
            if (enable) begin
                pc_out <= pc_out + 8'd1;
            end
            else begin
                pc_out <= pc_out;
            end
        end
    end

endmodule

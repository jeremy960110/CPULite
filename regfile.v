module regfile (
    input  wire        clk,
    input  wire        reset,

    input  wire        we,
    input  wire [2:0]  waddr,
    input  wire [15:0] wdata,

    input  wire [2:0]  raddr1,
    input  wire [2:0]  raddr2,

    output wire [15:0] rdata1,
    output wire [15:0] rdata2
);

    reg [15:0] regs [0:7];

    integer i;

    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < 8; i = i + 1) begin
                regs[i] <= 16'h0000;
            end
        end
        else begin
            if (we) begin
                if (waddr != 3'b000) begin
                    regs[waddr] <= wdata;
                end
            end

            regs[0] <= 16'h0000;
        end
    end

    assign rdata1 = (raddr1 == 3'b000) ? 16'h0000 : regs[raddr1];
    assign rdata2 = (raddr2 == 3'b000) ? 16'h0000 : regs[raddr2];

endmodule
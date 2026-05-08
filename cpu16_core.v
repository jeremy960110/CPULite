module cpu16_core (
    input  wire        clk,
    input  wire        reset,

    output wire [7:0]  instr_addr,
    input  wire [15:0] instr_data,

    output reg         halted,
    output wire        exec_state_debug
);

    // ============================================================
    // Opcode definition
    // ============================================================
    localparam OP_NOP  = 4'b0000;
    localparam OP_ADD  = 4'b0001;
    localparam OP_SUB  = 4'b0010;
    localparam OP_MUL  = 4'b0011;
    localparam OP_SHL  = 4'b0100;
    localparam OP_SHR  = 4'b0101;
    localparam OP_NOT  = 4'b0110;
    localparam OP_AND  = 4'b0111;
    localparam OP_OR   = 4'b1000;
    localparam OP_LDI  = 4'b1001;
    localparam OP_HALT = 4'b1111;

    // ============================================================
    // State definition
    // ============================================================
    localparam STATE_WAIT_ROM = 1'b0;
    localparam STATE_EXEC     = 1'b1;

    reg state;

    assign exec_state_debug = state;

    // ============================================================
    // Program Counter
    // ============================================================
    reg [7:0] pc;

    assign instr_addr = pc;

    // ============================================================
    // Instruction decode
    // ============================================================
    wire [15:0] instr;

    assign instr = instr_data;

    wire [3:0] opcode;
    wire [2:0] rd;
    wire [2:0] rs;
    wire [2:0] rt;
    wire [3:0] shamt;
    wire [8:0] imm9;

    assign opcode = instr[15:12];
    assign rd     = instr[11:9];
    assign rs     = instr[8:6];
    assign rt     = instr[5:3];
    assign shamt  = instr[5:2];
    assign imm9   = instr[8:0];

    // ============================================================
    // Register file wires
    // ============================================================
    wire [15:0] rs_data;
    wire [15:0] rt_data;

    reg reg_we;

    // ============================================================
    // ALU wires
    // ============================================================
    wire [15:0] alu_b;
    wire [15:0] alu_result;
    wire        alu_zero;

    assign alu_b = (opcode == OP_LDI) ? {7'b0000000, imm9} : rt_data;

    // ============================================================
    // Register File
    // ============================================================
    regfile u_regfile (
        .clk    (clk),
        .reset  (reset),

        .we     (reg_we),
        .waddr  (rd),
        .wdata  (alu_result),

        .raddr1 (rs),
        .raddr2 (rt),

        .rdata1 (rs_data),
        .rdata2 (rt_data)
    );

    // ============================================================
    // ALU
    // ============================================================
    alu u_alu (
        .a       (rs_data),
        .b       (alu_b),
        .alu_op  (opcode),
        .shamt   (shamt),

        .result  (alu_result),
        .zero    (alu_zero)
    );

    // ============================================================
    // Register write control
    //
    // Only write register during EXEC state.
    // During WAIT_ROM state, instruction data may not be valid yet.
    // ============================================================
    always @(*) begin
        reg_we = 1'b0;

        if ((state == STATE_EXEC) && (!halted)) begin
            case (opcode)

                OP_ADD,
                OP_SUB,
                OP_MUL,
                OP_SHL,
                OP_SHR,
                OP_NOT,
                OP_AND,
                OP_OR,
                OP_LDI: begin
                    reg_we = 1'b1;
                end

                default: begin
                    reg_we = 1'b0;
                end

            endcase
        end
    end

    // ============================================================
    // PC / State / HALT control
    //
    // STATE_WAIT_ROM:
    //   Wait one clock for synchronous ROM output to become valid.
    //
    // STATE_EXEC:
    //   Execute current instruction.
    //   If HALT, stop.
    //   Otherwise PC = PC + 1.
    // ============================================================
    always @(posedge clk) begin
        if (reset) begin
            pc     <= 8'd0;
            halted <= 1'b0;
            state  <= STATE_WAIT_ROM;
        end
        else begin
            if (!halted) begin

                case (state)

                    STATE_WAIT_ROM: begin
                        state <= STATE_EXEC;
                    end

                    STATE_EXEC: begin
                        if (opcode == OP_HALT) begin
                            halted <= 1'b1;
                        end
                        else begin
                            pc <= pc + 8'd1;
                        end

                        state <= STATE_WAIT_ROM;
                    end

                    default: begin
                        state <= STATE_WAIT_ROM;
                    end

                endcase

            end
        end
    end

endmodule
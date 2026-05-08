module alu (
    input  wire [15:0] a,
    input  wire [15:0] b,
    input  wire [3:0]  alu_op,
    input  wire [3:0]  shamt,

    output reg  [15:0] result,
    output wire        zero
);

    parameter OP_NOP  = 4'b0000;
    parameter OP_ADD  = 4'b0001;
    parameter OP_SUB  = 4'b0010;
    parameter OP_MUL  = 4'b0011;
    parameter OP_SHL  = 4'b0100;
    parameter OP_SHR  = 4'b0101;
    parameter OP_NOT  = 4'b0110;
    parameter OP_AND  = 4'b0111;
    parameter OP_OR   = 4'b1000;
    parameter OP_LDI  = 4'b1001;
    parameter OP_HALT = 4'b1111;

    always @(*) begin
        case (alu_op)

            OP_NOP: begin
                result = 16'h0000;
            end

            OP_ADD: begin
                result = a + b;
            end

            OP_SUB: begin
                result = a - b;
            end

            OP_MUL: begin
                result = a * b;
            end

            OP_SHL: begin
                result = a << shamt;
            end

            OP_SHR: begin
                result = a >> shamt;
            end

            OP_NOT: begin
                result = ~a;
            end

            OP_AND: begin
                result = a & b;
            end

            OP_OR: begin
                result = a | b;
            end

            OP_LDI: begin
                result = b;
            end

            OP_HALT: begin
                result = 16'h0000;
            end

            default: begin
                result = 16'h0000;
            end

        endcase
    end

    assign zero = (result == 16'h0000);

endmodule
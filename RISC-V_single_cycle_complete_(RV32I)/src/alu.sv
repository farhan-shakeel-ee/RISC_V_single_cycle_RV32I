module risc_alu #(
    parameter WIDTH = 32
)(
    input logic[WIDTH-1:0] operand1,
    input logic [WIDTH-1:0] operand2,
    input logic [3:0] alu_operations,
    output logic [WIDTH-1:0] ALU_Result,
    output logic               Zero
);

    always @(*) begin
            case (alu_operations) 
                4'b0000: ALU_Result = operand1 + operand2;
                4'b0001: ALU_Result = operand1 - operand2;
                4'b0010: ALU_Result = operand1 & operand2;
                4'b0011: ALU_Result = operand1 | operand2;
                4'b0100: ALU_Result = operand1 ^ operand2;
                4'b0101: ALU_Result = operand1 << operand2[4:0]; //SLL
                4'b0110: ALU_Result = operand1 >> operand2[4:0]; //SRL
                4'b0111: ALU_Result = $signed(operand1) >>> operand2[4:0]; 
                4'b1000: ALU_Result = ($signed(operand1) < $signed(operand2)) ? 32'd1 : 32'd0;
                4'b1001: ALU_Result = ($unsigned(operand1) < $unsigned(operand2)) ? 32'd1 : 32'd0;
                default: ALU_Result = '0;
            endcase
    end
    assign Zero = (ALU_Result == '0);
    
endmodule
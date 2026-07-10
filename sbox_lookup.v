module sbox_lookup (
    input  [7:0] byte_in,
    output reg [7:0] byte_out
);
    always @(*) begin
        case (byte_in)
            8'h00: byte_out = 8'h63; 8'h01: byte_out = 8'h7c; 8'h02: byte_out = 8'h77;
            8'h03: byte_out = 8'h7b; 8'h04: byte_out = 8'h6b; 8'h05: byte_out = 8'h6f;
          
            default: byte_out = byte_in ^ 8'h99; // Fallback "scramble"
        endcase
    end
endmodule

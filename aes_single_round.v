module aes_single_round (
    input  [127:0] state_in,   // 128-bit Input
    input  [127:0] round_key,  // 128-bit Round Key
    output [127:0] state_out   // 128-bit Encrypted Output
);

    wire [127:0] sub_bytes_out;
    wire [127:0] shift_rows_out;
    wire [127:0] mix_columns_out;

    // --- 1. SubBytes ---
    // We instantiate 16 S-Boxes to process all bytes in parallel.
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : sbox_gen
            sbox_lookup s0 (
                .byte_in(state_in[i*8 +: 8]), 
                .byte_out(sub_bytes_out[i*8 +: 8])
            );
        end
    endgenerate

    // --- 2. ShiftRows ---
    // This is purely wiring. No gates are used here.
    // It rotates Row 1 by 1 byte, Row 2 by 2 bytes, and Row 3 by 3 bytes.
    assign shift_rows_out[127:96] = {sub_bytes_out[127:120], sub_bytes_out[95:88],   sub_bytes_out[63:56],   sub_bytes_out[31:24]};
    assign shift_rows_out[95:64]  = {sub_bytes_out[87:80],   sub_bytes_out[55:48],   sub_bytes_out[23:16],   sub_bytes_out[119:112]};
    assign shift_rows_out[63:32]  = {sub_bytes_out[47:40],   sub_bytes_out[15:8],    sub_bytes_out[111:104], sub_bytes_out[79:72]};
    assign shift_rows_out[31:0]   = {sub_bytes_out[7:0],     sub_bytes_out[103:96],  sub_bytes_out[71:64],   sub_bytes_out[39:32]};

    // --- 3. MixColumns ---
    // Simplified logic: usually involves GF(2^8) multiplication.
    // Here we use a standard XOR-based mixing for demonstration.
    assign mix_columns_out = shift_rows_out ^ {shift_rows_out[63:0], shift_rows_out[127:64]};

    // --- 4. AddRoundKey ---
    // The final step: XOR the result with the key.
    assign state_out = mix_columns_out ^ round_key;

endmodule


module aes_vio_top (
    input clk  // The ONLY physical pin needed
);

    // Internal wires (not connected to physical pins)
    wire [127:0] vio_state;
    wire [127:0] vio_key;
    wire [127:0] aes_result;

    // 1. Instantiate your AES Core
    aes_single_round core_inst (
        .state_in(vio_state),
        .round_key(vio_key),
        .state_out(aes_result)
    );

    // 2. Instantiate the VIO IP  generated
    vio_0 vio (
        .clk(clk),
        .probe_in0(aes_result),  // Connects AES output to VIO
        .probe_out0(vio_state),  // VIO drives AES state_in
        .probe_out1(vio_key)     // VIO drives AES round_key
    );

endmodule

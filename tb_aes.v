module tb_aes;
    reg  [127:0] test_data;
    reg  [127:0] test_key;
    wire [127:0] result;

    // Connect to our AES module
    aes_single_round dut (
        .state_in(test_data),
        .round_key(test_key),
        .state_out(result)
    );

    initial begin
        // Example Hex inputs (16 bytes each)
        test_data = 128'h3243f6a8885a308d313198a2e0370734;
        test_key  = 128'h2b7e151628aed2a6abf7158809cf4f3c;
        
        #10; // Wait for the "combinational logic" to settle
        
        $display("--- AES Single Round Simulation ---");
        $display("Input State: %h", test_data);
        $display("Round Key:   %h", test_key);
        $display("Output:      %h", result);
        $display("-----------------------------------");
        $finish;
    end
endmodule

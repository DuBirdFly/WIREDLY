`timescale 1ns/1ps

module TEST_0;

    //////////////////////////////////////////////////
    `ifdef DUMP_VCD
    initial begin
        $dumpfile("out.vcd");
        $dumpvars(0, TEST_0);
    end
    `endif

    `ifdef DUMP_FSDB
    initial begin
        $fsdbDumpfile("out.fsdb");
        $fsdbDumpvars(0, TEST_0);
    end
    `endif

    //////////////////////////////////////////////////
    localparam CLK_PERIOD = 10;
    localparam WIDTH = 1;

    logic clk = 0;
    logic rst_n = 0;

    always  #(CLK_PERIOD/2) clk = ~clk;
    initial #(CLK_PERIOD*2) rst_n = 1;

    //////////////////////////////////////////////////
    logic mem_start = 0;
    logic [7:0] mem_data = 0;
    IfMEM ifMEM();
    mem_wrapper mem_wrap(ifMEM, mem_start, mem_data, clk, rst_n);

    logic phy_start = 0;
    logic [7:0] phy_data = 0;
    IfPHY ifPHY();
    phy_wrapper phy_wrap(ifPHY, phy_start, phy_data, clk, rst_n);

    pcbdly u_pcbdly(ifPHY, ifMEM);

    //////////////////////////////////////////////////
    task do_phy_start(logic [7:0] data);
        #1;
        phy_start = 1;
        phy_data = data;
        repeat(1) @(posedge clk);
        #1 phy_start = 0;
    endtask

    task do_mem_start(logic [7:0] data);
        #1;
        mem_start = 1;
        mem_data = data;
        repeat(1) @(posedge clk);
        #1 mem_start = 0;
    endtask

    initial begin
        wait(rst_n);
        repeat(2) @(posedge clk);

        do_phy_start(8'hFF);
        repeat(15) @(posedge clk);

        do_mem_start(8'hFF);
        repeat(15) @(posedge clk);

        fork
            do_phy_start(8'hAA);
            do_mem_start(8'hA5);
        join
        repeat(15) @(posedge clk);

        fork
            begin
                do_phy_start(8'h5A);
            end
            begin
                @(posedge clk);
                do_mem_start(8'hA5);
            end
        join
        repeat(15) @(posedge clk);

        $display("=====================================");
        $display("\tSIMULATION FINISHED");
        $display("=====================================");
        $finish;
    end

endmodule

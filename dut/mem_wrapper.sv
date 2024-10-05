module mem_wrapper (
    IfMEM       ifMEM,
    input       start,
    input [7:0] data,

    input       clk,
    input       rst_n
);

    rank u_rank(
        .dqs_p ( ifMEM.dqs_p  ),
        .dqs_n ( ifMEM.dqs_n  ),
        .dq    ( ifMEM.dq     ),

        .start ( start        ),
        .data  ( data         ),

        .clk   ( clk          ),
        .rst_n ( rst_n        )
    );

endmodule
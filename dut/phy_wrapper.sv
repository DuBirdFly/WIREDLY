module phy_wrapper (
    IfPHY       ifPHY,
    input       start,
    input [7:0] data,

    input       clk,
    input       rst_n
);

    comp u_comp(
        .dqs_p ( ifPHY.dqs_p  ),
        .dqs_n ( ifPHY.dqs_n  ),
        .dq    ( ifPHY.dq     ),

        .start ( start        ),
        .data  ( data         ),

        .clk   ( clk          ),
        .rst_n ( rst_n        )
    );

endmodule
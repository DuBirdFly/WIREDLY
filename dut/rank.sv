module rank (
    inout       dqs_p,
    inout       dqs_n,
    inout       dq,

    input       start,
    input [7:0] data,

    input       clk,
    input       rst_n
);

    pullup(dqs_p);
    pulldown(dqs_n);

    comp u_comp(
        .dqs_p  ( dqs_p     ),
        .dqs_n  ( dqs_n     ),
        .dq     ( dq        ),

        .start  ( start     ),
        .data   ( data      ),

        .clk    ( clk       ),
        .rst_n  ( rst_n     )
    );

endmodule

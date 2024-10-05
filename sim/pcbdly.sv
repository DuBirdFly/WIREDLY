module pcbdly(
    IfPHY       ifPHY,
    IfMEM       ifMEM,
    input       rst_n
);

    genvar dqwd;
    generate
        for (dqwd = 0; dqwd < 1; dqwd++) begin: gen_dq
            wiredly #(
                .DELAY_A2B  ( 2                 ),
                .DELAY_B2A  ( 2                 )
            ) u_wiredly(
                .A          ( ifPHY.dq          ),
                .B          ( ifMEM.dq          ),
                .rst_n      ( rst_n             )
            );
        end
    endgenerate

    genvar dqspwd;
    generate
        for (dqspwd = 0; dqspwd < 1; dqspwd++) begin: gen_dqs_p
            wiredly #(
                .DELAY_A2B  ( 2                 ),
                .DELAY_B2A  ( 2                 )
            ) u_wiredly(
                .A          ( ifPHY.dqs_p       ),
                .B          ( ifMEM.dqs_p       ),
                .rst_n      ( rst_n             )
            );
        end
    endgenerate

    genvar dqsnwd;
    generate
        for (dqsnwd = 0; dqsnwd < 1; dqsnwd++) begin: gen_dqs_n
            wiredly #(
                .DELAY_A2B  ( 2                 ),
                .DELAY_B2A  ( 2                 )
            ) u_wiredly(
                .A          ( ifPHY.dqs_n       ),
                .B          ( ifMEM.dqs_n       ),
                .rst_n      ( rst_n             )
            );
        end
    endgenerate

endmodule
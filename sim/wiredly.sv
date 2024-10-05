module wiredly # (
    parameter DELAY_A2B = 0,
    parameter DELAY_B2A = 0
)(
    inout A,
    inout B,
    input rst_n
);

    reg A_r, B_r, line_en;

    assign A = A_r;
    assign B = B_r;

    always @(*) begin
        if (!rst_n) begin
            A_r <= 1'bz;
            B_r <= 1'bz;
        end
        else begin
            if (line_en) begin
                B_r <= 1'bz;
                A_r <= #DELAY_B2A B;
            end
            else begin
                B_r <= #DELAY_A2B A;
                A_r <= 1'bz;
            end
        end
    end

    always @(A or B) begin
        if (!rst_n)         line_en <= 1'b0;
        else if (A !== A_r) line_en <= 1'b0;
        else if (B_r !== B) line_en <= 1'b1;
        else                line_en <= line_en;
    end

endmodule

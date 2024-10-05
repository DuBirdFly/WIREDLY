module comp (
    inout       dqs_p,
    inout       dqs_n,
    inout       dq,

    input       start,
    input [7:0] data,

    input       clk,
    input       rst_n
);

    typedef enum logic [3:0] {IDLE, SEND} state_t;

    state_t state, next_state;

    logic [7:0] cnt;
    logic [7:0] data_r;

    always_ff @(posedge clk or negedge rst_n) begin
        if (~rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    always_comb begin
        case (state)
            IDLE:
                if (start)
                    next_state = SEND;
                else
                    next_state = IDLE;
            SEND:
                if (cnt == 7)
                    next_state = IDLE;
                else
                    next_state = SEND;
        endcase
    end

    always_ff @(posedge clk) begin
        case (state)
            IDLE: begin
                cnt <= 0;
                if (start) data_r <= data;
            end
            SEND: begin
                cnt <= cnt + 1;
            end
        endcase
    end

    io u_dqs_p (
        .E  ( state == SEND ),
        .I  ( ~cnt[0]   ),
        .IO ( dqs_p     )
    );

    io u_dqs_n (
        .E  ( state == SEND ),
        .I  ( cnt[0]    ),
        .IO ( dqs_n     )
    );

    io u_dq (
        .E  ( state == SEND ),
        .I  ( data[cnt] ),
        .IO ( dq        )
    );

endmodule
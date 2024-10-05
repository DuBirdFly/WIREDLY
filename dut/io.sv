module io #(
    parameter WIDTH = 1
)(
    input  wire              E,
    input  wire [WIDTH-1:0]  I,
    inout  wire [WIDTH-1:0]  IO
);

    assign IO = E ? I : 'z;

endmodule
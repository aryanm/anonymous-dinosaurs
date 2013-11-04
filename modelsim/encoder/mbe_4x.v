module mbe_4x
(
input [7:0] x,
output [3:0] single, double, neg
);

mbe_1x mbe3(x[7:5],single[3],double[3],neg[3]);
mbe_1x mbe2(x[5:3],single[2],double[2],neg[2]);
mbe_1x mbe1(x[3:1],single[1],double[1],neg[1]);
mbe_1x mbe0({x[1:0],1'b0},single[0],double[0],neg[0]);

endmodule

module mbe_1x
(
input [2:0] x,
output single, double, neg
);

assign single = (x[1] & ~x[0]) | (~x[1] & x[0]);
assign double = (x[2] & ~x[1] & ~x[0]) | (~x[2] & x[1] & x[0]);
assign neg    = x[2];

endmodule
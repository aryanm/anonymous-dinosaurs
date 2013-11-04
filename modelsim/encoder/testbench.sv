module testbench();
    logic clk;
    logic [2:0] x;
	logic single, double, neg;
    logic [5:0] vectors[8:0], currentvec;
    logic [3:0] vectornum, errors;
    
    // The device under test
	//mbe_1x dut(x, single, double, neg);
    mbe_1x dut(x[0], x[1], x[2], double, neg, single);
    
    // read test vector file and initialize test
    initial begin
       $readmemb("mbe-vectors.txt", vectors);
       vectornum = 0; errors = 0;
    end
    // generate a clock to sequence tests
    always begin
       clk = 1; #10; clk = 0; #10;
    end
    // apply test
    always @(posedge clk) begin
       currentvec = vectors[vectornum];
       x = currentvec[5:3];
       if (currentvec[2] === 1'bx | currentvec[1] === 1'bx | currentvec[0] === 1'bx) begin
         $display("Completed %d tests with %d errors.", 
                  vectornum, errors);
         $stop;
       end
    end
    // check if test was sucessful and apply next one
    always @(negedge clk) begin
       if ((single !== currentvec[2] | double !== currentvec[1] | neg !== currentvec[0])) begin
          $display("Error: inputs were x=%h", x);
          $display("       output mismatches as %h%h%h (%h expected)", 
                   single, double, neg, currentvec[2:0]);
          errors = errors + 1;
       end
       vectornum = vectornum + 1;
    end
endmodule

/*module mbe_1x
(
input [2:0] x,
output single, double, neg
);

assign single = (x[1] & ~x[0]) | (~x[1] & x[0]);
assign double = (x[2] & ~x[1] & ~x[0]) | (~x[2] & x[1] & x[0]);
assign neg    = x[2];

endmodule*/

/* Verilog for cell 'mbe_1x{sch}' from library 'wordlib8' */
/* Created on Mon Oct 28, 2013 21:36:11 */
/* Last revised on Wed Oct 30, 2013 01:39:50 */
/* Written on Mon Nov 04, 2013 11:55:45 by Electric VLSI Design System, version 8.06 */

module muddlib07__buf_1x(a, y);
  input a;
  output y;

  supply1 vdd;
  supply0 gnd;
  wire net_23;

  tranif1 nmos_0(gnd, net_23, a);
  tranif1 nmos_1(gnd, y, net_23);
  tranif0 pmos_0(net_23, vdd, a);
  tranif0 pmos_1(y, vdd, net_23);
endmodule   /* muddlib07__buf_1x */

module muddlib07__inv_1x(a, y);
  input a;
  output y;

  supply1 vdd;
  supply0 gnd;
  tranif1 nmos_0(gnd, y, a);
  tranif0 pmos_0(y, vdd, a);
endmodule   /* muddlib07__inv_1x */

module muddlib07__nor2_1x(a, b, y);
  input a;
  input b;
  output y;

  supply1 vdd;
  supply0 gnd;
  wire net_9;

  tranif1 nmos_0(gnd, y, a);
  tranif1 nmos_1(gnd, y, b);
  tranif0 pmos_0(y, net_9, b);
  tranif0 pmos_1(net_9, vdd, a);
endmodule   /* muddlib07__nor2_1x */

module muddlib07__xor2_1x(a, b, y);
  input a;
  input b;
  output y;

  supply1 vdd;
  supply0 gnd;
  wire ab, bb, net_3, net_4, net_7, net_8;

  tranif1 nmos_0(gnd, net_3, a);
  tranif1 nmos_1(gnd, net_4, ab);
  tranif1 nmos_2(net_3, y, b);
  tranif1 nmos_3(net_4, y, bb);
  tranif1 nmos_4(gnd, bb, b);
  tranif1 nmos_5(gnd, ab, a);
  tranif0 pmos_0(y, net_7, b);
  tranif0 pmos_1(net_7, vdd, ab);
  tranif0 pmos_2(y, net_8, bb);
  tranif0 pmos_3(net_8, vdd, a);
  tranif0 pmos_4(bb, vdd, b);
  tranif0 pmos_5(ab, vdd, a);
endmodule   /* muddlib07__xor2_1x */

module mbe_1x(x0, x1, x2, double, neg, single);
  input x0;
  input x1;
  input x2;
  output double;
  output neg;
  output single;

  supply1 vdd;
  supply0 gnd;
  wire net_0, net_2;

  muddlib07__buf_1x buf_1x_0(.a(x2), .y(neg));
  muddlib07__inv_1x inv_1x_0(.a(net_0), .y(net_2));
  muddlib07__nor2_1x nor2_1x_0(.a(net_2), .b(single), .y(double));
  muddlib07__xor2_1x xor2_1x_0(.a(x2), .b(x0), .y(net_0));
  muddlib07__xor2_1x xor2_1x_1(.a(x0), .b(x1), .y(single));
endmodule   /* mbe_1x */

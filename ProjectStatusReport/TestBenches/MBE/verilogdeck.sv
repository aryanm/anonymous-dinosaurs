module verilogdeck();
    logic clk;
    logic [7:0] x;
	logic [3:0] single, double, neg;
    logic [19:0] vectors[256:0], currentvec;
    logic [8:0] vectornum, errors;
	integer out;
    
    // The device under test
	mbe_4x dut(x, double, neg, single);
    
    // read test vector file and initialize test
    initial begin
       $readmemb("output.txt", vectors);
       vectornum = 0; errors = 0;
    end
    // generate a clock to sequence tests
    always begin
       clk = 1; #10; clk = 0; #10;
    end
    // apply test
    always @(posedge clk) begin
       currentvec = vectors[vectornum];
       x = currentvec[19:12];
       if (currentvec[19] === 1'bx) begin
         $display("Completed %d tests with %d errors.", 
                  vectornum, errors);
         $stop;
       end
    end
    // check if test was sucessful and apply next one
    always @(negedge clk) begin
       if (
	   (single[3] !== currentvec[11] | double[3] !== currentvec[10] | neg[3] !== currentvec[9]) |
	   (single[2] !== currentvec[8] | double[2] !== currentvec[7] | neg[2] !== currentvec[6]) |
	   (single[1] !== currentvec[5] | double[1] !== currentvec[4] | neg[1] !== currentvec[3]) |
	   (single[0] !== currentvec[2] | double[0] !== currentvec[1] | neg[0] !== currentvec[0])) begin
          $display("Error: inputs were x=%h", x);
          $display("       output mismatches as %h%h%h (%h expected)", 
                   single, double, neg, currentvec[11:0]);
          errors = errors + 1;
       end
       vectornum = vectornum + 1;
    end
endmodule

/* Verilog for cell 'mbe_4x{sch}' from library 'wordlib8' */
/* Created on Wed Oct 30, 2013 00:34:43 */
/* Last revised on Wed Oct 30, 2013 01:31:25 */
/* Written on Wed Oct 30, 2013 01:40:31 by Electric VLSI Design System, version 8.06 */

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

module wordlib8__mbe_1x(x0, x1, x2, double, neg, single);
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
endmodule   /* wordlib8__mbe_1x */

module mbe_4x(x, double, neg, single);
  input [7:0] x;
  output [3:0] double;
  output [3:0] neg;
  output [3:0] single;

  supply1 vdd;
  supply0 gnd;
  wordlib8__mbe_1x mbe_1x_4(.x0(x[5]), .x1(x[6]), .x2(x[7]), 
      .double(double[3]), .neg(neg[3]), .single(single[3]));
  wordlib8__mbe_1x mbe_1x_5(.x0(x[3]), .x1(x[4]), .x2(x[5]), 
      .double(double[2]), .neg(neg[2]), .single(single[2]));
  wordlib8__mbe_1x mbe_1x_6(.x0(x[1]), .x1(x[2]), .x2(x[3]), 
      .double(double[1]), .neg(neg[1]), .single(single[1]));
  wordlib8__mbe_1x mbe_1x_7(.x0(gnd), .x1(x[0]), .x2(x[1]), .double(double[0]), 
      .neg(neg[0]), .single(single[0]));
endmodule   /* mbe_4x */

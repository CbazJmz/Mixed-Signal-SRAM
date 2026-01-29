`timescale 1ns/10ps
module inv (out,in);
	input in;	output out;
	wreal in, out;
	real outval;
	parameter real VTH=0.5;

always @(in) begin
	if (in == `wrealXState)
		outval = `wrealXState;
	else if (in == `wrealZstate)
		outval = `wrealZstate;
	else if (in > VTH)
		outval = 0;
	else
		outval = 1.5;
end
assign #0.23 out = outval;
endmodule

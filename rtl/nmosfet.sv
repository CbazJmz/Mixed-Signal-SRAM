module nmosfet(
	input real vd,
	input real vg,
	output real vs
);

//   ________________________________
//  |              VDD   |    VSS    |
//  |--------------------------------|
//  |Typ Voltage|  1.5   |    0.0    |
//  |________________________________|

const real VDD =  1.5;
const real VSS =  0.0;
const real VTH =  0.8; 

always_comb begin
	if(vg<VTH)
		vs = VSS;
	else if(vg>=VTH && vd>=VTH)
		vs = VDD;
	else
		vs = vs;
end

endmodule

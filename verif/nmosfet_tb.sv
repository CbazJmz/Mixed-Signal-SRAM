module nmosfet_tb();
	
	real vg;
	real vs;
	real vd;
	
	const real VDD =  1.5;
	const real VSS =  0.0;
	
	nmosfet nmos1 (
	.vd (vd),
	.vg (vg),
	.vs (vs)
	);
	
	bit vg_rising;
	bit vg_falling;
	bit samp;
	always #1ns samp = !samp;
	
	always_comb begin
		vg_rising = vg > $past(vg,1,,@(posedge samp));
	end

	always_comb begin
		vg_falling = vg < $past(vg,1,,@(posedge samp));
	end

    initial begin
		samp = 1'b0;
		vd = VDD;
		vg = VSS;
		
		while ((VSS<vg<VDD && vg_rising)||(vg == VSS)) begin
			#1ns vg = vg + 0.1;
		end
		
		while ((VSS<vg<VDD && vg_falling)||(vg == VDD)) begin
			#1ns vg = vg - 0.1;
		end

    end

    initial begin
	    $shm_open("shm_db");
	    $shm_probe("ASMTR");
    end

endmodule


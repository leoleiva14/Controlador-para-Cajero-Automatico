tarea: testbench.v controlador.ys
	yosys -s controlador.ys
	iverilog -o resultado testbench.v
	vvp resultado
	gtkwave resultado.vcd

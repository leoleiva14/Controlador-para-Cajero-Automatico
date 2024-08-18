`include "tester.v"
`include "controlador_synth.v"
`include "cmos_cells.v"
// Testbench
module testbench; 

/*AUTOWIRE*/
// Beginning of automatic wires (for undeclared instantiated-module outputs)
wire			ADVERTENCIA;		// From a0 of controlador.v
wire			BALANCE_ACTUALIZADO;	// From a0 of controlador.v
wire			BLOQUEO_CTRL;		// From a0 of controlador.v
wire			CLK;			// From a1 of tester.v
wire [3:0]		DIGITO;			// From a1 of tester.v
wire			DIGITO_STB;		// From a1 of tester.v
wire			ENTREGAR_DINERO;	// From a0 of controlador.v
wire			FONDOS_INSUFICIENTES;	// From a0 of controlador.v
wire [31:0]		MONTO;			// From a1 of tester.v
wire			MONTO_STB;		// From a1 of tester.v
wire [15:0]		PIN;			// From a1 of tester.v
wire			PIN_INCORRECTO;		// From a0 of controlador.v
wire			RESET;			// From a1 of tester.v
wire			TARJETA_RECIBIDA;	// From a1 of tester.v
wire			TIPO_TRANS;		// From a1 of tester.v
// End of automatics


initial begin
    $dumpfile ("resultado.vcd");
    $dumpvars(-1, testbench);
    $monitor("");
     end
 
controlador a0 (/*AUTOINST*/
		// Outputs
		.BALANCE_ACTUALIZADO	(BALANCE_ACTUALIZADO),
		.ENTREGAR_DINERO	(ENTREGAR_DINERO),
		.PIN_INCORRECTO		(PIN_INCORRECTO),
		.ADVERTENCIA		(ADVERTENCIA),
		.BLOQUEO_CTRL		(BLOQUEO_CTRL),
		.FONDOS_INSUFICIENTES	(FONDOS_INSUFICIENTES),
		// Inputs
		.CLK			(CLK),
		.RESET			(RESET),
		.TARJETA_RECIBIDA	(TARJETA_RECIBIDA),
		.TIPO_TRANS		(TIPO_TRANS),
		.DIGITO_STB		(DIGITO_STB),
		.MONTO_STB		(MONTO_STB),
		.DIGITO			(DIGITO[3:0]),
		.PIN			(PIN[15:0]),
		.MONTO			(MONTO[31:0]));
		
tester a1 (/*AUTOINST*/
	   // Outputs
	   .CLK				(CLK),
	   .RESET			(RESET),
	   .TARJETA_RECIBIDA		(TARJETA_RECIBIDA),
	   .TIPO_TRANS			(TIPO_TRANS),
	   .DIGITO_STB			(DIGITO_STB),
	   .MONTO_STB			(MONTO_STB),
	   .DIGITO			(DIGITO[3:0]),
	   .PIN				(PIN[15:0]),
	   .MONTO			(MONTO[31:0]),
	   // Inputs
	   .BALANCE_ACTUALIZADO		(BALANCE_ACTUALIZADO),
	   .ENTREGAR_DINERO		(ENTREGAR_DINERO),
	   .PIN_INCORRECTO		(PIN_INCORRECTO),
	   .ADVERTENCIA			(ADVERTENCIA),
	   .BLOQUEO_CTRL		(BLOQUEO_CTRL),
	   .FONDOS_INSUFICIENTES	(FONDOS_INSUFICIENTES));

 endmodule
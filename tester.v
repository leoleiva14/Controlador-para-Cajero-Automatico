module tester (
    output reg CLK,
    output reg RESET,
    output reg TARJETA_RECIBIDA,
    output reg TIPO_TRANS,
    output reg DIGITO_STB,
    output reg MONTO_STB,
    output reg [3:0] DIGITO,
    output reg [15:0] PIN,
    output reg [31:0] MONTO,
    input BALANCE_ACTUALIZADO, ENTREGAR_DINERO, PIN_INCORRECTO, ADVERTENCIA, BLOQUEO_CTRL, FONDOS_INSUFICIENTES
);

// Inicializaciones
initial begin
    CLK = 0;
    RESET = 1;
    TARJETA_RECIBIDA = 0;
    TIPO_TRANS = 0;
    DIGITO_STB = 0;
    MONTO_STB = 0;
    DIGITO = 4'd0;
    PIN = 16'b0001_0010_0011_0100; //Representa el valor en BCD de 1234
    MONTO = 32'd0;
    
    // Espera inicial
    #20 RESET =0;
    
    // Introduce la tarjeta
    TARJETA_RECIBIDA = 1;
    #20 TARJETA_RECIBIDA = 0;

    // Introduce el PIN correctamente
    DIGITO = 4'd1; DIGITO_STB = 1;
    #10 DIGITO_STB = 0;
    #20 DIGITO = 4'd2; DIGITO_STB = 1;
    #10 DIGITO_STB = 0;
    #20 DIGITO = 4'd3; DIGITO_STB = 1;
    #10 DIGITO_STB = 0;
    #20 DIGITO = 4'd4; DIGITO_STB = 1;
    #10 DIGITO_STB = 0;

    // Selecciona la operación: RETIRO (TIPO_TRANS = 1)
    #20 TIPO_TRANS = 1;

    // Ingresa un monto menor al balance para retirar
    MONTO = 32'd3000; MONTO_STB = 1;
    #20 MONTO_STB = 0;

    // Espera a que el dinero sea entregado
    #40;

    // Selecciona la operación: DEPOSITO (TIPO_TRANS = 0)
    #20 TIPO_TRANS = 0;

    // Ingresa un monto para depositar
    MONTO = 32'd1000; MONTO_STB = 1;
    #20 MONTO_STB = 0;

    // Espera a que el balance sea actualizado
    #40;
    RESET = 1;
    #20 RESET = 0;

       // Introduce la tarjeta
    TARJETA_RECIBIDA = 1;
    #20 TARJETA_RECIBIDA = 0;


    // Introduce el PIN incorrectamente
    DIGITO = 4'd9; DIGITO_STB = 1;
    #10 DIGITO_STB = 0;
    #20 DIGITO = 4'd8; DIGITO_STB = 1;
    #10 DIGITO_STB = 0;
    #20 DIGITO = 4'd7; DIGITO_STB = 1;
    #10 DIGITO_STB = 0;
    #20 DIGITO = 4'd6; DIGITO_STB = 1;
    #10 DIGITO_STB = 0;

    // Se intenta ingresar el PIN de nuevo (segundo intento erróneo)
    #40 DIGITO = 4'd9; DIGITO_STB = 1;
    #10 DIGITO_STB = 0;
    #20 DIGITO = 4'd8; DIGITO_STB = 1;
    #10 DIGITO_STB = 0;
    #20 DIGITO = 4'd7; DIGITO_STB = 1;
    #10 DIGITO_STB = 0;
    #20 DIGITO = 4'd6; DIGITO_STB = 1;
    #10 DIGITO_STB = 0;

    // Introducción incorrecta de PIN (tercer intento y bloqueo)
    #40 DIGITO = 4'd9; DIGITO_STB = 1;
    #10 DIGITO_STB = 0;
    #20 DIGITO = 4'd1; DIGITO_STB = 1;
    #10 DIGITO_STB = 0;
    #20 DIGITO = 4'd2; DIGITO_STB = 1;
    #10 DIGITO_STB = 0;
    #20 DIGITO = 4'd3; DIGITO_STB = 1;
    #10 DIGITO_STB = 0;

    // Proceso de RESET
    #40 RESET = 1; // Activa el RESET.
    #20 RESET = 0; // Desactiva el RESET para reiniciar el sistema.

    // Finalizar la simulación   
    #20 $finish;
end

// Generador de reloj
always begin
    #5 CLK = !CLK; // Invierte el reloj
end

endmodule
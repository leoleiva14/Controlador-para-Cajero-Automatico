module controlador (
    input CLK, RESET, TARJETA_RECIBIDA, TIPO_TRANS, DIGITO_STB, MONTO_STB,
    input [3:0] DIGITO,
    input [15:0] PIN,
    input [31:0] MONTO,
    output reg BALANCE_ACTUALIZADO, ENTREGAR_DINERO, PIN_INCORRECTO, ADVERTENCIA, BLOQUEO_CTRL, FONDOS_INSUFICIENTES
);

localparam ESPERA_TARJETA = 7'b0000001;
localparam INGRESO_PIN = 7'b0000010;
localparam COMPROBAR_PIN = 7'b0000100;
localparam SELECCION_TRANSACCION = 7'b0001000;
localparam BLOQUEO = 7'b0010000;
localparam DEPOSITO = 7'b0100000;
localparam RETIRO = 7'b1000000;

reg [6:0] estado, proximo_estado;
reg [15:0] cuatro_digitos = 16'd0;
reg [3:0] counter = 4'd0;
reg [2:0] intentos = 3'd0;
reg [31:0] BALANCE;
reg [31:0] BALANCEE;
reg [15:0] pin_ingresado;


always @(posedge CLK) begin
    if (RESET) begin
        estado <= ESPERA_TARJETA;
        cuatro_digitos = 0;
        counter = 0; 
    end else begin
        estado <= proximo_estado;
        if (estado == INGRESO_PIN && DIGITO_STB) begin
            counter <= counter + 1'b1;
            cuatro_digitos <= {cuatro_digitos[11:0], DIGITO}; 
        end
    end    
end
always @(*) begin
    BALANCE_ACTUALIZADO = 1'b0;
    ENTREGAR_DINERO = 1'b0;
    PIN_INCORRECTO = 1'b0;
    ADVERTENCIA = 1'b0;
    BLOQUEO_CTRL = 1'b0;
    FONDOS_INSUFICIENTES = 1'b0;
    BALANCE = 32'd5000; // Suponemos que hay $5000 en la cuenta.
    proximo_estado = estado;
    
    case (estado)

        ESPERA_TARJETA: begin
            if (TARJETA_RECIBIDA) begin
                proximo_estado = INGRESO_PIN;
                intentos = 3'd0;  // Reset intentos
            end       
        end

        INGRESO_PIN: begin
            if (counter == 4) begin
                proximo_estado = COMPROBAR_PIN; 
                pin_ingresado = cuatro_digitos;
                counter = 0;
            end
        end
 
        COMPROBAR_PIN: begin
            if (PIN == pin_ingresado) begin
                proximo_estado = SELECCION_TRANSACCION;
            end else begin
                intentos = intentos + 1;
                if (intentos == 1) begin
                    PIN_INCORRECTO = 1'b1;
                    proximo_estado = INGRESO_PIN;
                end else if (intentos == 2) begin
                    ADVERTENCIA = 1'b1;
                    proximo_estado = INGRESO_PIN;
                end else if (intentos >= 3) begin
                    BLOQUEO_CTRL = 1'b1;
                    proximo_estado = BLOQUEO;
                    intentos = 3;
                end   
            end
        end

        SELECCION_TRANSACCION: begin
            if (TIPO_TRANS) begin
                proximo_estado = RETIRO;
            end else begin
                proximo_estado = DEPOSITO;
            end
        end

        RETIRO: begin
            if (MONTO < BALANCE) begin
                BALANCE_ACTUALIZADO = 1'b1;
                ENTREGAR_DINERO = 1'b1;
                BALANCEE = BALANCE - MONTO;
                proximo_estado = ESPERA_TARJETA;
            end else begin
                FONDOS_INSUFICIENTES = 1'b1;
                proximo_estado = ESPERA_TARJETA;
            end
        end

        DEPOSITO: begin
            BALANCEE = BALANCE + MONTO;
            BALANCE_ACTUALIZADO = 1'b1;
            proximo_estado = ESPERA_TARJETA;
        end

        BLOQUEO: begin
            BLOQUEO_CTRL = 1'b1;
            // La máquina permanece bloqueada hasta que se reciba un RESET.
        end

    endcase
end

endmodule

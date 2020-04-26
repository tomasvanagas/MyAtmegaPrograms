LDmicro0.1
MICRO=Microchip PIC16F876 28-PDIP or 28-SOIC
CYCLE=10000
CRYSTAL=4000000
BAUD=2400

IO LIST
    Xin at 2
    Yout at 3
END

PROGRAM
RUNG
    CONTACTS Xin 0
    CTU Cnew 3
    SHORT
    SHORT
    SHORT
    SHORT
    SHORT
    SHORT
    SHORT
    COIL Rcoil 0 0 0
END
RUNG
    CONTACTS Rcoil 0
    COIL Yout 0 0 0
END
RUNG
    CONTACTS Rcoil 0
    SHIFT_REGISTER reg 9
END
RUNG
    UART_SEND inchar
    ADD dest ADD ADD1
END
RUNG
    PLACEHOLDER
END

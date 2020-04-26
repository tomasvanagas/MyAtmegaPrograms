LDmicro0.1
MICRO=Atmel AVR ATmega8 28-PDIP
CYCLE=1000
CRYSTAL=1001000
BAUD=2400
COMPILED=C:\Documents and Settings\HP\Desktop\band.hex

IO LIST
    Y1 at 2
    Y2 at 3
    YA at 4
    YB at 5
END

PROGRAM
RUNG
    PARALLEL
        SERIES
            CONTACTS ROSC 0
            PARALLEL
                SERIES
                    TON TOSC0 500000
                    TOF TOSC1 500000
                    COIL ROSC 1 0 0
                END
                CTC Counter 7
            END
        END
        SERIES
            LEQ Counter 2
            COIL Y1 0 0 0
        END
        SERIES
            GEQ Counter 4
            NEQ Counter 7
            COIL Y2 0 0 0
        END
        SERIES
            EQU Counter 1
            COIL YA 0 0 0
        END
        SERIES
            EQU Counter 5
            COIL YB 0 0 0
        END
    END
END

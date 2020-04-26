LDmicro0.1
MICRO=Atmel AVR ATmega8 28-PDIP
CYCLE=1000
CRYSTAL=1001000
BAUD=2400
COMPILED=C:\Documents and Settings\HP\Desktop\band.hex

IO LIST
    XRAUD at 2
    XZAL at 4
    Y1 at 18
    Y2 at 12
    Y3 at 19
    YA1 at 14
    YA2 at 17
    YB1 at 15
    YB2 at 24
    YC1 at 3
    YC2 at 25
    YD1 at 13
    YD2 at 16
END

PROGRAM
RUNG
    PARALLEL
        SERIES
            CONTACTS XRAUD 0
            CTU C1 0
        END
        MUL C2 C1 5
        SERIES
            NEQ C1 0
            ADD C3 C2 5
        END
        DIV Rsk_1 C3 10
        MUL Rsk_1x10 Rsk_1 10
        SUB Rsk_2 C3 Rsk_1x10
        SERIES
            CONTACTS XRAUD 1
            TON TUZLAKYMAS0 2500000
            PARALLEL
                SERIES
                    TON TUZLAIKYMAS1 50000
                    PARALLEL
                        RES C1
                        RES C3
                    END
                END
                SERIES
                    OSR
                    PARALLEL
                        MOVE r1 Rsk_1
                        MOVE r2 Rsk_2
                    END
                END
            END
        END
        SERIES
            CONTACTS XZAL 0
            CTU C11 0
        END
        DIV Zsk_1 C11 10
        MUL Zsk_1x10 Zsk_1 10
        SUB Zsk_2 C11 Zsk_1x10
        SERIES
            CONTACTS XZAL 1
            TON TUZLAIKYMAS2 2500000
            PARALLEL
                SERIES
                    TON TUZLAIKYMAS3 50000
                    RES C11
                END
                SERIES
                    OSR
                    PARALLEL
                        MOVE z1 Zsk_1
                        MOVE z2 Zsk_2
                    END
                END
            END
        END
    END
END
RUNG
    PARALLEL
        SERIES
            CONTACTS ROSC 0
            PARALLEL
                SERIES
                    OSR
                    OSF
                    COIL ROSC 1 0 0
                END
                CTC Counter 5
            END
        END
        SERIES
            PARALLEL
                EQU OUTLED 1
                EQU OUTLED 3
                EQU OUTLED 5
                EQU OUTLED 7
                EQU OUTLED 9
            END
            COIL YA1 0 0 0
        END
        SERIES
            PARALLEL
                EQU OUTLED 2
                EQU OUTLED 3
                EQU OUTLED 6
                EQU OUTLED 7
            END
            COIL YB1 0 0 0
        END
        SERIES
            GRT OUTLED 3
            LES OUTLED 7
            COIL YC1 0 0 0
        END
        SERIES
            GEQ OUTLED 8
            COIL YD1 0 0 0
        END
        SERIES
            PARALLEL
                EQU OUTLED1 1
                EQU OUTLED1 3
                EQU OUTLED1 5
                EQU OUTLED1 7
                EQU OUTLED1 9
            END
            COIL YA2 0 0 0
        END
        SERIES
            PARALLEL
                EQU OUTLED1 2
                EQU OUTLED1 3
                EQU OUTLED1 6
                EQU OUTLED1 7
            END
            COIL YB2 0 0 0
        END
        SERIES
            GRT OUTLED1 3
            LES OUTLED1 7
            COIL YC2 0 0 0
        END
        SERIES
            GEQ OUTLED1 8
            COIL YD2 0 0 0
        END
        SERIES
            EQU Counter 0
            PARALLEL
                MOVE OUTLED r1
                MOVE OUTLED1 z1
            END
        END
        SERIES
            EQU Counter 2
            PARALLEL
                MOVE OUTLED r2
                MOVE OUTLED1 z2
            END
        END
        SERIES
            EQU Counter 4
            PARALLEL
                MOVE OUTLED 0
                MOVE OUTLED1 0
            END
        END
    END
END
RUNG
    PARALLEL
        SERIES
            EQU Counter 1
            COIL Y1 0 0 0
        END
        SERIES
            EQU Counter 3
            COIL Y2 0 0 0
        END
        SERIES
            EQU Counter 5
            COIL Y3 0 0 0
        END
    END
END

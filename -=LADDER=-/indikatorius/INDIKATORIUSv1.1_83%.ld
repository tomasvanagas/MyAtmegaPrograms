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
    Y4 at 16
    Y5 at 15
    Y6 at 5
    YA at 17
    YB at 25
    YC at 27
    YD at 23
    YE at 14
    YF at 13
    YG at 11
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
                CTC Counter 11
            END
        END
        SERIES
            NEQ OUTLED 1
            NEQ OUTLED 4
            COIL YA 0 0 0
        END
        SERIES
            NEQ OUTLED 5
            NEQ OUTLED 6
            COIL YB 0 0 0
        END
        SERIES
            NEQ OUTLED 2
            COIL YC 0 0 0
        END
        SERIES
            NEQ OUTLED 1
            NEQ OUTLED 4
            NEQ OUTLED 7
            COIL YD 0 0 0
        END
        SERIES
            PARALLEL
                EQU OUTLED 2
                EQU OUTLED 6
                EQU OUTLED 8
                EQU OUTLED 0
            END
            COIL YE 0 0 0
        END
        SERIES
            NEQ OUTLED 1
            NEQ OUTLED 2
            NEQ OUTLED 3
            COIL YF 0 0 0
        END
        SERIES
            GEQ OUTLED 2
            NEQ OUTLED 7
            COIL YG 0 0 0
        END
        SERIES
            EQU Counter 0
            MOVE OUTLED r1
        END
        SERIES
            EQU Counter 2
            MOVE OUTLED r2
        END
        SERIES
            PARALLEL
                EQU Counter 4
                EQU Counter 10
            END
            MOVE OULTED 0
        END
        SERIES
            EQU Counter 6
            MOVE OUTLED z1
        END
        SERIES
            EQU Counter 8
            MOVE OUTLED z2
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
        SERIES
            EQU Counter 7
            COIL Y4 0 0 0
        END
        SERIES
            EQU Counter 9
            COIL Y5 0 0 0
        END
        SERIES
            EQU Counter 11
            COIL Y6 0 0 0
        END
    END
END

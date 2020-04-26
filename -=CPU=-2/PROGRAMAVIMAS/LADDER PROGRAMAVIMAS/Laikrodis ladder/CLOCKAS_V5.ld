LDmicro0.1
MICRO=Microchip PIC16F628 18-PDIP or 18-SOIC
CYCLE=1000
CRYSTAL=4000000
BAUD=2400
COMPILED=C:\Documents and Settings\tomas\Desktop\band.hex

IO LIST
    XDMinMygtukas at 2
    XMinMygtukas at 3
    XValMygtukas at 1
    YBLOCK_0 at 8
    YBLOCK_1 at 9
    YBLOCK_2 at 11
    YBLOCK_3 at 10
    YOUTPUT_0 at 12
    YOUTPUT_1 at 18
    YOUTPUT_2 at 17
    YOUTPUT_3 at 13
END

PROGRAM
RUNG
    PARALLEL
        SERIES
            CONTACTS R1MIN_osc 0
            PARALLEL
                SERIES
                    TOF T1 272642
                    TON T2 272642
                    COIL R1MIN_osc 1 0 0
                END
                CTC C1Minreal 303
            END
        END
        SERIES
            PARALLEL
                EQU C1Minreal 303
                SERIES
                    CONTACTS XMinMygtukas 0
                    OSR
                END
            END
            CTC CMinutes 9
        END
        SERIES
            PARALLEL
                SERIES
                    EQU CMinutes 0
                    OSR
                END
                CONTACTS XDMinMygtukas 0
            END
            CTC CDMinute 5
        END
        SERIES
            PARALLEL
                SERIES
                    EQU CDMinute 0
                    OSR
                END
                SERIES
                    CONTACTS XValMygtukas 0
                    OSR
                END
            END
            CTC CValando 9
        END
        SERIES
            EQU CValando 0
            OSR
            CONTACTS R11 1
            CTC CDValand 2
        END
        SERIES
            EQU CValando 4
            EQU CDValand 2
            PARALLEL
                RES CValando
                RES CDValand
                COIL R11 0 0 0
            END
        END
        SERIES
            EQU CBLselect 6
            MOVE OUTPUTAS CMinutes
        END
        SERIES
            EQU CBLselect 4
            MOVE OUTPUTAS CDMinute
        END
        SERIES
            EQU CBLselect 2
            MOVE OUTPUTAS CValando
        END
        SERIES
            EQU CBLselect 0
            MOVE OUTPUTAS CDValand
        END
        DIV OUTPUTAS1 OUTPUTAS 2
        MUL OUTPUTAS2 OUTPUTAS1 2
    END
END
RUNG
    PARALLEL
        SERIES
            NEQ OUTPUTAS2 OUTPUTAS
            COIL YOUTPUT_0 0 0 0
        END
        SERIES
            PARALLEL
                EQU OUTPUTAS 2
                EQU OUTPUTAS 3
                EQU OUTPUTAS 6
                EQU OUTPUTAS 7
            END
            COIL YOUTPUT_1 0 0 0
        END
        SERIES
            GRT OUTPUTAS 3
            LES OUTPUTAS 8
            COIL YOUTPUT_2 0 0 0
        END
        SERIES
            GEQ OUTPUTAS 8
            COIL YOUTPUT_3 0 0 0
        END
        SERIES
            CONTACTS RVISUAL_osc 0
            PARALLEL
                SERIES
                    OSR
                    OSF
                    COIL RVISUAL_osc 1 0 0
                END
                CTC CBLselect 7
            END
        END
        SERIES
            EQU CBLselect 1
            COIL YBLOCK_0 1 0 0
        END
        SERIES
            EQU CBLselect 3
            COIL YBLOCK_1 1 0 0
        END
        SERIES
            EQU CBLselect 5
            COIL YBLOCK_2 1 0 0
        END
        SERIES
            EQU CBLselect 7
            COIL YBLOCK_3 1 0 0
        END
    END
END

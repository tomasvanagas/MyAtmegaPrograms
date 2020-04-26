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
    CONTACTS R1MIN_osc 0
    TOF T1 272642
    TON T2 272642
    COIL R1MIN_osc 1 0 0
END
RUNG
    CONTACTS R1MIN_osc 0
    CTC C1Minreal 303
END
RUNG
    PARALLEL
        EQU C1Minreal 303
        SERIES
            CONTACTS XMinMygtukas 0
            OSR
        END
    END
    CTC CMinutes 9
END
RUNG
    PARALLEL
        SERIES
            EQU CMinutes 0
            OSR
        END
        CONTACTS XDMinMygtukas 0
    END
    CTC CDMinute 5
END
RUNG
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
RUNG
    EQU CValando 0
    OSR
    CONTACTS R11 1
    CTC CDValand 2
END
RUNG
    EQU CValando 4
    EQU CDValand 2
    PARALLEL
        RES CValando
        RES CDValand
        COIL R11 0 0 0
    END
END
RUNG
    CONTACTS R4 0
    MOVE OUTPUTAS CMinutes
END
RUNG
    CONTACTS R3 0
    MOVE OUTPUTAS CDMinute
END
RUNG
    CONTACTS R2 0
    MOVE OUTPUTAS CValando
END
RUNG
    CONTACTS R1 0
    MOVE OUTPUTAS CDValand
END
RUNG
    DIV OUTPUTA1 OUTPUTAS 2
END
RUNG
    MUL OUTPUTA2 OUTPUTA1 2
END
RUNG
    NEQ OUTPUTA2 OUTPUTAS
    COIL YOUTPUT_0 0 0 0
END
RUNG
    PARALLEL
        EQU OUTPUTAS 2
        EQU OUTPUTAS 3
        EQU OUTPUTAS 6
        EQU OUTPUTAS 7
    END
    COIL YOUTPUT_1 0 0 0
END
RUNG
    GRT OUTPUTAS 3
    LES OUTPUTAS 8
    COIL YOUTPUT_2 0 0 0
END
RUNG
    GEQ OUTPUTAS 8
    COIL YOUTPUT_3 0 0 0
END
RUNG
    CONTACTS RVISUAL_osc 0
    TOF Tvisual1 2000
    TON Tvisual2 2000
    COIL RVISUAL_osc 1 0 0
END
RUNG
    CONTACTS RVISUAL_osc 0
    CTC CBLselect 15
END
RUNG
    EQU CBLselect 0
    PARALLEL
        SERIES
            TON T10 2000
            COIL YBLOCK_0 1 0 0
        END
        COIL R1 0 0 0
    END
END
RUNG
    EQU CBLselect 4
    PARALLEL
        SERIES
            TON T20 2000
            COIL YBLOCK_1 1 0 0
        END
        COIL R2 0 0 0
    END
END
RUNG
    EQU CBLselect 8
    PARALLEL
        SERIES
            TON T30 2000
            COIL YBLOCK_2 1 0 0
        END
        COIL R3 0 0 0
    END
END
RUNG
    EQU CBLselect 12
    PARALLEL
        SERIES
            TON T40 2000
            COIL YBLOCK_3 1 0 0
        END
        COIL R4 0 0 0
    END
END

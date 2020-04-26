LDmicro0.1
MICRO=Microchip PIC16F628 18-PDIP or 18-SOIC
CYCLE=1000
CRYSTAL=4000000
BAUD=2400
COMPILED=C:\Documents and Settings\tomas\Desktop\CLOCKAS_4.hex

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
    PARALLEL
        SERIES
            TOF T1 272642
            TON T2 272642
            COIL R1MIN_osc 1 0 0
        END
        CTC C1Minreal 303
    END
END
RUNG
    PARALLEL
        SERIES
            EQU C1Minreal 303
            OSR
        END
        CONTACTS XMinMygtukas 0
    END
    CTC CMinutes 9
END
RUNG
    PARALLEL
        EQU CMinutes 1
        EQU CMinutes 3
        EQU CMinutes 5
        EQU CMinutes 7
        EQU CMinutes 9
    END
    COIL R4a 0 0 0
END
RUNG
    PARALLEL
        EQU CMinutes 2
        EQU CMinutes 3
        EQU CMinutes 6
        EQU CMinutes 7
    END
    COIL R4b 0 0 0
END
RUNG
    GRT CMinutes 3
    LES CMinutes 8
    COIL R4c 0 0 0
END
RUNG
    GEQ CMinutes 8
    COIL R4d 0 0 0
END
RUNG
    PARALLEL
        SERIES
            EQU CMinutes 0
            OSR
        END
        CONTACTS XDMinMygtukas 0
    END
    CTC CDMinutes 5
END
RUNG
    PARALLEL
        EQU CDMinutes 1
        EQU CDMinutes 3
        EQU CDMinutes 5
    END
    COIL R3a 0 0 0
END
RUNG
    PARALLEL
        EQU CDMinutes 2
        EQU CDMinutes 3
    END
    COIL R3b 0 0 0
END
RUNG
    GEQ CDMinutes 4
    COIL R3c 0 0 0
END
RUNG
    PARALLEL
        SERIES
            EQU CDMinutes 0
            OSR
        END
        CONTACTS XValMygtukas 0
        SERIES
            CONTACTS Rosc 1
            OSR
        END
    END
    CTC CValandos 9
END
RUNG
    EQU CDValandos 2
    GEQ CValandos 4
    CONTACTS Rosc 0
    OSR
    OSF
    COIL Rosc 1 0 0
END
RUNG
    PARALLEL
        EQU CValandos 1
        EQU CValandos 3
        EQU CValandos 5
        EQU CValandos 7
        EQU CValandos 9
    END
    COIL R2a 0 0 0
END
RUNG
    PARALLEL
        EQU CValandos 2
        EQU CValandos 3
        EQU CValandos 6
        EQU CValandos 7
    END
    COIL R2b 0 0 0
END
RUNG
    GRT CValandos 3
    LES CValandos 8
    COIL R2c 0 0 0
END
RUNG
    GEQ CValandos 8
    COIL R2d 0 0 0
END
RUNG
    EQU CValandos 0
    CTC CDValandos 2
END
RUNG
    EQU CDValandos 1
    COIL R1a 0 0 0
END
RUNG
    EQU CDValandos 2
    COIL R1b 0 0 0
END
RUNG
    PARALLEL
        SERIES
            CONTACTS R4a 0
            CONTACTS R4 0
        END
        SERIES
            CONTACTS R3a 0
            CONTACTS R3 0
        END
        SERIES
            CONTACTS R2a 0
            CONTACTS R2 0
        END
        SERIES
            CONTACTS R1a 0
            CONTACTS R1 0
        END
    END
    COIL YOUTPUT_0 0 0 0
END
RUNG
    PARALLEL
        SERIES
            CONTACTS R4b 0
            CONTACTS R4 0
        END
        SERIES
            CONTACTS R3b 0
            CONTACTS R3 0
        END
        SERIES
            CONTACTS R2b 0
            CONTACTS R2 0
        END
        SERIES
            CONTACTS R1b 0
            CONTACTS R1 0
        END
    END
    COIL YOUTPUT_1 0 0 0
END
RUNG
    PARALLEL
        SERIES
            CONTACTS R4c 0
            CONTACTS R4 0
        END
        SERIES
            CONTACTS R3c 0
            CONTACTS R3 0
        END
        SERIES
            CONTACTS R2c 0
            CONTACTS R2 0
        END
    END
    COIL YOUTPUT_2 0 0 0
END
RUNG
    PARALLEL
        SERIES
            CONTACTS R4d 0
            CONTACTS R4 0
        END
        SERIES
            CONTACTS R2d 0
            CONTACTS R2 0
        END
    END
    COIL YOUTPUT_3 0 0 0
END
RUNG
    CONTACTS RVISUAL_osc 0
    PARALLEL
        SERIES
            TOF Tvisual1 2000
            TON Tvisual2 2000
            COIL RVISUAL_osc 1 0 0
        END
        CTC CBLselect 15
    END
END
RUNG
    EQU CBLselect 0
    PARALLEL
        SERIES
            TON T10 4000
            COIL YBLOCK_0 1 0 0
        END
        COIL R1 0 0 0
    END
END
RUNG
    EQU CBLselect 4
    PARALLEL
        SERIES
            TON T20 4000
            COIL YBLOCK_1 1 0 0
        END
        COIL R2 0 0 0
    END
END
RUNG
    EQU CBLselect 8
    PARALLEL
        SERIES
            TON T30 4000
            COIL YBLOCK_2 1 0 0
        END
        COIL R3 0 0 0
    END
END
RUNG
    EQU CBLselect 12
    PARALLEL
        SERIES
            TON T40 4000
            COIL YBLOCK_3 1 0 0
        END
        COIL R4 0 0 0
    END
END

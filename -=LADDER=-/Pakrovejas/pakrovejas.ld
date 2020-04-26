LDmicro0.1
MICRO=Atmel AVR ATmega162 40-PDIP
CYCLE=1000
CRYSTAL=1001000
BAUD=2400
COMPILED=C:\Documents and Settings\tomas\Desktop\band.hex

IO LIST
    XIskrov_praleid at 17
    XRaudonas at 29
    XTime at 16
    XZalias at 31
    YBlock1 at 12
    YBlock2 at 14
    YBlock3 at 13
    YBlock4 at 15
    YIskrovimas at 36
    YKrauti at 39
    YLOAD at 38
    YReset_beep at 37
    Ya at 8
    Yb at 6
    Yc at 3
    Yd at 5
    Ye at 1
    Yf at 7
    Yg at 2
    Yh at 4
END

PROGRAM
RUNG
    COMMENT -==Leidmas krauti==-
END
RUNG
    CONTACTS XRaudonas 0
    OSR
    COIL RKrauti 0 1 0
END
RUNG
    CONTACTS XZalias 0
    OSR
    COIL RKrauti 0 0 1
END
RUNG
    CONTACTS ROST 0
    TOF Tkro_iskrov_int 1000000
    TON Tkrov_iskrov_in 9000000
    COIL ROST 1 0 0
END
RUNG
    CONTACTS RKrauti 0
    CONTACTS ROST 0
    TON TUzlaikymas2 20000
    COIL YKrauti 0 0 0
END
RUNG
    COMMENT -==Iskrovimas_kraunant==-
END
RUNG
    CONTACTS RKrauti 0
    CONTACTS ROST 1
    TON TUzlaikymas3 20000
    COIL YLOAD 0 0 0
END
RUNG
    COMMENT -==Testinis_iskrovimas==-
END
RUNG
    CONTACTS ROST 0
    LEQ CDesimt_val 3610
    CTU CDesimt_val 3600
    CONTACTS XIskrov_praleid 1
    CONTACTS RKrauti 1
    COIL RIskr_tarp_r 0 0 0
END
RUNG
    CONTACTS RIskr_tarp_r 1
    CONTACTS ROST 0
    OSR
    NEQ CDvi_sav2 4
    CTC CDvi_sav 30000
END
RUNG
    EQU CDvi_sav 30000
    CTC CDvi_sav2 4
END
RUNG
    PARALLEL
        CONTACTS RIskr_tarp_r 0
        SERIES
            EQU CDvi_sav2 4
            CONTACTS RKrauti 0
        END
    END
    PARALLEL
        RES CDesimt_val
        RES CDvi_sav
        RES CDvi_sav2
    END
END
RUNG
    PARALLEL
        CONTACTS RIskr_tarp_r 0
        EQU CDvi_sav 4
    END
    COIL YIskrovimas 0 0 0
END
RUNG
    CONTACTS YIskrovimas 0
    TON TUzlaikymas6 5000000
    OSR
    TOF TUzlaikymas7 2000000
    COIL YReset_beep 0 0 0
END
RUNG
    COMMENT -==Testinio iskrovimo laikmatis==-
END
RUNG
    CONTACTS YIskrovimas 0
    CONTACTS ROST 0
    OSR
    CTC CDes_sec 5
END
RUNG
    TON TUzlaikymas12 100000
    COIL RUzlaikymas 0 0 0
END
RUNG
    EQU CDes_sec 5
    OSR
    CONTACTS RUzlaikymas 0
    CTC CMinutes 9
END
RUNG
    EQU CMinutes 0
    OSR
    CONTACTS RUzlaikymas 0
    CTC CDMinute 5
END
RUNG
    EQU CDMinute 0
    OSR
    CONTACTS RUzlaikymas 0
    CTC CValando 9
END
RUNG
    EQU CValando 0
    OSR
    CONTACTS RUzlaikymas 0
    CTC CDValand 9
END
RUNG
    CONTACTS YIskrovimas 0
    TOF TUzlaikymas5 100000
    OSF
    PARALLEL
        RES CDec_sec
        RES CMinutes
        RES CDMinute
        RES CValandos
        RES CDValand
    END
END
RUNG
    CONTACTS YIskrovimas 0
    OSF
    PARALLEL
        MOVE Minutes CMinutes
        MOVE DMinutes CDMinute
        MOVE Valandos CValando
        MOVE DValando CDValand
    END
END
RUNG
    COMMENT -==Abecele==- :::(10.d)(11.c)(12.h)(13.r)(14.A)(15.L)(16.o)\r\n-==Zodziai==-::: (discharge- dchr )(charge- chAr )(load- LoAd )
END
RUNG
    CONTACTS XTime 1
    CONTACTS YIskrovimas 0
    PARALLEL
        SERIES
            CONTACTS R1 0
            COIL R10 0 0 0
        END
        SERIES
            CONTACTS R2 0
            COIL R11 0 0 0
        END
        SERIES
            CONTACTS R3 0
            COIL R12 0 0 0
        END
        SERIES
            CONTACTS R4 0
            COIL R13 0 0 0
        END
    END
END
RUNG
    CONTACTS XTime 1
    CONTACTS YKrauti 0
    PARALLEL
        SERIES
            CONTACTS R1 0
            COIL R11 0 0 0
        END
        SERIES
            CONTACTS R2 0
            COIL R12 0 0 0
        END
        SERIES
            CONTACTS R3 0
            COIL R14 0 0 0
        END
        SERIES
            CONTACTS R4 0
            COIL R13 0 0 0
        END
    END
END
RUNG
    CONTACTS XTime 1
    CONTACTS YLOAD 0
    PARALLEL
        SERIES
            CONTACTS R1 0
            COIL R15 0 0 0
        END
        SERIES
            CONTACTS R2 0
            COIL R16 0 0 0
        END
        SERIES
            CONTACTS R3 0
            COIL R14 0 0 0
        END
        SERIES
            CONTACTS R4 0
            COIL R10 0 0 0
        END
    END
END
RUNG
    COMMENT -==Kodavimas i dvejetaine sistema ir bitu adresavimas i LED ekrana==-
END
RUNG
    CONTACTS ROSC2 0
    TOF TOscilatorius3 2000
    TON TOscilatorius4 2000
    COIL ROSC2 1 0 0
END
RUNG
    CONTACTS ROSC2 0
    CTC CBlock 15
END
RUNG
    EQU CBlock 0
    PARALLEL
        SERIES
            TON TUzlaikymas13 2000
            COIL YBlock1 0 0 0
        END
        COIL R1 0 0 0
    END
END
RUNG
    EQU CBlock 4
    PARALLEL
        SERIES
            TON TUzlaikymas14 2000
            COIL YBlock2 0 0 0
        END
        COIL R2 0 0 0
    END
END
RUNG
    EQU CBlock 8
    PARALLEL
        SERIES
            TON TUzlaikymas15 2000
            COIL YBlock3 0 0 0
        END
        COIL R3 0 0 0
    END
END
RUNG
    EQU CBlock 12
    PARALLEL
        SERIES
            TON TUzlaikymas16 2000
            COIL YBlock4 0 0 0
        END
        COIL R4 0 0 0
    END
END
RUNG
    CONTACTS R4 0
    CONTACTS XTime 0
    MOVE OUT_LED Minutes
END
RUNG
    CONTACTS R3 0
    CONTACTS XTime 0
    MOVE OUT_LED DMinutes
END
RUNG
    CONTACTS R2 0
    CONTACTS XTime 0
    MOVE OUT_LED Valandos
END
RUNG
    CONTACTS R1 0
    CONTACTS XTime 0
    MOVE OUT_LED DValando
END
RUNG
    PARALLEL
        SERIES
            GEQ OUT_LED 5
            LEQ OUT_LED 9
        END
        EQU OUT_LED 0
        EQU OUT_LED 2
        EQU OUT_LED 3
        CONTACTS R14 0
    END
    COIL Ya 1 0 0
END
RUNG
    PARALLEL
        SERIES
            GEQ OUT_LED 0
            LEQ OUT_LED 4
        END
        SERIES
            GEQ OUT_LED 7
            LEQ OUT_LED 9
        END
        CONTACTS R10 0
        CONTACTS R14 0
    END
    COIL Yb 1 0 0
END
RUNG
    PARALLEL
        SERIES
            GEQ OUT_LED 3
            LEQ OUT_LED 9
        END
        EQU OUT_LED 0
        EQU OUT_LED 1
        CONTACTS R10 0
        CONTACTS R12 0
        CONTACTS R14 0
        CONTACTS R16 0
    END
    COIL Yc 1 0 0
END
RUNG
    PARALLEL
        SERIES
            GEQ OUT_LED 0
            LEQ OUT_LED 8
            NEQ OUT_LED 4
            NEQ OUT_LED 7
            NEQ OUT_LED 1
        END
        CONTACTS R10 0
        CONTACTS R11 0
        CONTACTS R15 0
        CONTACTS R16 0
    END
    COIL Yd 1 0 0
END
RUNG
    PARALLEL
        EQU OUT_LED 0
        EQU OUT_LED 2
        EQU OUT_LED 6
        EQU OUT_LED 8
        CONTACTS R10 0
        CONTACTS R11 0
        CONTACTS R12 0
        CONTACTS R13 0
        CONTACTS R14 0
        CONTACTS R15 0
        CONTACTS R16 0
    END
    COIL Ye 1 0 0
END
RUNG
    PARALLEL
        SERIES
            GEQ OUT_LED 4
            LEQ OUT_LED 9
            NEQ OUT_LED 7
        END
        EQU OUT_LED 0
        CONTACTS R12 0
        CONTACTS R14 0
        CONTACTS R15 0
    END
    COIL Yf 1 0 0
END
RUNG
    PARALLEL
        SERIES
            GEQ OUT_LED 2
            LEQ OUT_LED 9
            NEQ OUT_LED 7
        END
        CONTACTS R10 0
        CONTACTS R11 0
        CONTACTS R12 0
        CONTACTS R13 0
        CONTACTS R14 0
        CONTACTS R16 0
    END
    COIL Yg 1 0 0
END
RUNG
    CONTACTS R2 0
    CONTACTS XTime 0
    COIL Yh 1 0 0
END

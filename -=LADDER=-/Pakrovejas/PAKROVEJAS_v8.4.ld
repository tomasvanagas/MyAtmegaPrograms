LDmicro0.1
MICRO=Atmel AVR ATmega162 40-PDIP
CYCLE=1000
CRYSTAL=1001000
BAUD=2400
COMPILED=C:\Documents and Settings\tomas\Desktop\band.hex

IO LIST
    X1MYGTUKAS at 31
    X2MYGTUKAS at 29
    XFoult_reset at 17
    XGELTONAS at 24
    XISK_PRALEID at 30
    XRAUDONAS at 22
    XTIME at 16
    XZALIAS at 23
    Y1BLOCK at 12
    Y2BLOCK at 14
    Y3BLOCK at 13
    Y4BLOCK at 15
    YA at 8
    YB at 6
    YC at 3
    YD at 5
    YE at 1
    YF at 7
    YG at 2
    YH at 4
    YISKROVIMAS at 36
    YKRAUTI at 39
    YLOAD at 38
    YRESET_BEEPER at 37
END

PROGRAM
RUNG
    COMMENT <<<<<<======DAZNIO MODULIS(1sec)======>>>>>>\r\n<<<<<<<=========IKROVIMO,ISKROVIMO MODULIS=========>>>>>>>
END
RUNG
    COMMENT <<<<<<======ISKROVIMAS SIEKIANT AKU ILGAAMZISKUMO======>>>>>>
END
RUNG
    PARALLEL
        SERIES
            PARALLEL
                SERIES
                    CONTACTS XTIME 0
                    CONTACTS XFoult_reset 0
                    TON TIJUNGIMASKRAUT 2000000
                END
                SERIES
                    CONTACTS XISK_PRALEID 0
                    OSR
                END
                OSR
                SERIES
                    CONTACTS XRAUDONAS 0
                    CONTACTS XGELTONAS 1
                END
            END
            COIL Rkrauti0 0 1 0
        END
        SERIES
            PARALLEL
                SERIES
                    CONTACTS XZALIAS 0
                    CONTACTS XGELTONAS 1
                END
                SERIES
                    CONTACTS X2MYGTUKAS 0
                    CONTACTS XTIME 1
                    OSR
                END
            END
            COIL Rkrauti0 0 0 1
        END
        SERIES
            CONTACTS Rkrauti0 0
            GEQ C30secPerio 3
            COIL YKRAUTI 0 0 0
        END
        SERIES
            CONTACTS ROSC 0
            PARALLEL
                SERIES
                    TOF Timer1 1050000
                    COIL ROSC 1 0 0
                END
                CTC C30secPerio 29
                CTC CSekunde 3
                SERIES
                    CONTACTS YISKROVIMAS 0
                    PARALLEL
                        SERIES
                            NEQ CBEEPER_OFF 11
                            CTU CBEEPER_OFF 10
                            EQU CBEEPER_OFF 10
                            COIL YRESET_BEEPER 0 0 0
                        END
                        CTC CISKROV 59
                    END
                END
            END
        END
        SERIES
            CONTACTS YKRAUTI 1
            CONTACTS Rkrauti0 0
            COIL YLOAD 0 0 0
        END
        SERIES
            PARALLEL
                SERIES
                    EQU C5valandos 18000
                    OSR
                END
                SERIES
                    EQU C5dienos 24
                    OSR
                END
                SERIES
                    CONTACTS X2MYGTUKAS 0
                    CONTACTS XTIME 0
                    TON TijungtISKROV 2000000
                END
            END
            COIL YISKROVIMAS 0 1 0
        END
        SERIES
            PARALLEL
                CONTACTS YKRAUTI 0
                SERIES
                    CONTACTS X2MYGTUKAS 0
                    CONTACTS XTIME 1
                END
            END
            COIL YISKROVIMAS 0 0 1
        END
        SERIES
            PARALLEL
                EQU CISKROV 59
                CONTACTS X2MYGTUKAS 0
            END
            CTU CMinutes 10
            PARALLEL
                RES CMinutes
                SERIES
                    CTU CDMinute 7
                    PARALLEL
                        RES CDMinute
                        SERIES
                            CTU CValando 10
                            PARALLEL
                                RES CValando
                                SERIES
                                    CTU CDValand 10
                                    RES CDValand
                                END
                            END
                        END
                    END
                END
            END
        END
        SERIES
            CONTACTS YISKROVIMAS 1
            TON Tuzlaikymas2 50000
            OSR
            PARALLEL
                RES CBEEPER_OFF
                RES CISKROV
                RES CMinutes
                RES CDMinute
                RES CValando
                RES CDValand
            END
        END
    END
END
RUNG
    PARALLEL
        SERIES
            CONTACTS XISK_PRALEID 0
            PARALLEL
                RES C5dienos
                RES C5valandos2
                RES C5valandos
            END
        END
        SERIES
            CONTACTS ROSC 0
            PARALLEL
                SERIES
                    NEQ C5valandos 18000
                    CTC C5valandos 18000
                END
                SERIES
                    EQU C5valandos 18000
                    CTC C5valandos2 18000
                END
            END
        END
        SERIES
            EQU C5valandos2 17999
            CTC C5dienos 24
        END
    END
END
RUNG
    COMMENT -==Zodziai==-::: (discharge- dchr )(charge- chAr )(load- LoAd )
END
RUNG
    COMMENT <<<<<<======DAZNIS LED EKRANUI======>>>>>>
END
RUNG
    PARALLEL
        SERIES
            CONTACTS ROSC2 0
            PARALLEL
                SERIES
                    OSR
                    OSF
                    COIL ROSC2 1 0 0
                END
                CTC Counteris 7
            END
        END
        SERIES
            PARALLEL
                SERIES
                    EQU Minut 0
                    EQU DMinut 0
                    EQU Valand 0
                    CONTACTS YISKROVIMAS 1
                END
                SERIES
                    CONTACTS X2MYGTUKAS 0
                    CONTACTS XTIME 1
                    TON Tfoult_reset 2000000
                END
            END
            COIL RFoult0 0 0 1
        END
        SERIES
            CONTACTS YISKROVIMAS 1
            LES Valand 1
            OSR
            COIL RFoult0 0 1 0
        END
        SERIES
            CONTACTS RFoult0 0
            GEQ CSekunde 2
            CONTACTS YISKROVIMAS 1
            CONTACTS Rkrauti0 1
            COIL RVienas_foult 0 0 0
        END
    END
END
RUNG
    COMMENT <<<<<<======ISEJIMAS I LED======>>>>>>
END
RUNG
    COMMENT <<<===BLOKAS===>>>
END
RUNG
    PARALLEL
        SERIES
            CONTACTS R_Counteris0 0
            COIL Y1BLOCK 0 0 0
        END
        SERIES
            CONTACTS R_Counteris2 0
            COIL Y2BLOCK 0 0 0
        END
        SERIES
            CONTACTS R_Counteris4 0
            COIL Y3BLOCK 0 0 0
        END
        SERIES
            EQU Counteris 6
            COIL Y4BLOCK 0 0 0
        END
        MOVE Minut CMinutes
        MOVE DMinut CDMinute
        MOVE Valand CValando
        MOVE DValand CDValand
        SERIES
            CONTACTS XTIME 0
            PARALLEL
                SERIES
                    EQU Counteris 0
                    MOVE OUTLED DValand
                END
                SERIES
                    EQU Counteris 2
                    MOVE OUTLED Valand
                END
                SERIES
                    EQU Counteris 4
                    MOVE OUTLED DMinut
                END
                SERIES
                    EQU Counteris 6
                    MOVE OUTLED Minut
                END
            END
        END
    END
END
RUNG
    COMMENT <<<===I LED SEGMENTUS===>>>\r\n<<<===KARTU IRASYTI IR ZODZIAI===>>>
END
RUNG
    PARALLEL
        SERIES
            PARALLEL
                SERIES
                    CONTACTS XTIME 0
                    NEQ OUTLED 1
                    NEQ OUTLED 4
                END
                SERIES
                    CONTACTS XTIME 1
                    PARALLEL
                        SERIES
                            CONTACTS RVienas_foult 0
                            CONTACTS R_Counteris0 0
                        END
                        SERIES
                            CONTACTS Rkrauti0 0
                            CONTACTS R_Counteris4 0
                        END
                    END
                END
            END
            COIL YA 1 0 0
        END
        SERIES
            PARALLEL
                SERIES
                    CONTACTS XTIME 0
                    NEQ OUTLED 5
                    NEQ OUTLED 6
                END
                SERIES
                    CONTACTS XTIME 1
                    PARALLEL
                        SERIES
                            CONTACTS YISKROVIMAS 0
                            CONTACTS R_Counteris0 0
                        END
                        SERIES
                            CONTACTS YLOAD 0
                            PARALLEL
                                CONTACTS R_Counteris4 0
                                EQU Counteris 6
                            END
                        END
                        SERIES
                            CONTACTS YKRAUTI 0
                            CONTACTS R_Counteris4 0
                        END
                    END
                END
            END
            COIL YB 1 0 0
        END
        SERIES
            PARALLEL
                SERIES
                    CONTACTS XTIME 0
                    NEQ OUTLED 2
                END
                SERIES
                    CONTACTS XTIME 1
                    PARALLEL
                        SERIES
                            PARALLEL
                                SERIES
                                    CONTACTS YKRAUTI 0
                                    NEQ Counteris 5
                                    NEQ Counteris 6
                                END
                                CONTACTS YLOAD 0
                            END
                            CONTACTS R_Counteris0 1
                            CONTACTS R_Counteris7 1
                        END
                        SERIES
                            CONTACTS YISKROVIMAS 0
                            PARALLEL
                                CONTACTS R_Counteris0 0
                                CONTACTS R_Counteris4 0
                            END
                        END
                        SERIES
                            CONTACTS RVienas_foult 0
                            EQU Counteris 2
                        END
                    END
                END
            END
            COIL YC 1 0 0
        END
        SERIES
            PARALLEL
                SERIES
                    CONTACTS XTIME 0
                    NEQ OUTLED 1
                    NEQ OUTLED 4
                    NEQ OUTLED 7
                    NEQ OUTLED 9
                END
                SERIES
                    CONTACTS XTIME 1
                    PARALLEL
                        SERIES
                            CONTACTS YISKROVIMAS 0
                            PARALLEL
                                CONTACTS R_Counteris0 0
                                CONTACTS R_Counteris2 0
                            END
                        END
                        SERIES
                            PARALLEL
                                SERIES
                                    CONTACTS YLOAD 0
                                    NEQ Counteris 5
                                    NEQ Counteris 4
                                END
                                SERIES
                                    CONTACTS YKRAUTI 0
                                    CONTACTS R_Counteris0 0
                                END
                            END
                            NEQ Counteris 3
                        END
                        SERIES
                            CONTACTS RVienas_foult 0
                            CONTACTS R_Counteris7 1
                            CONTACTS R_Counteris0 1
                        END
                    END
                END
            END
            COIL YD 1 0 0
        END
        SERIES
            PARALLEL
                SERIES
                    CONTACTS XTIME 0
                    PARALLEL
                        EQU OUTLED 0
                        EQU OUTLED 2
                        EQU OUTLED 6
                        EQU OUTLED 8
                    END
                END
                SERIES
                    CONTACTS XTIME 1
                    PARALLEL
                        CONTACTS Rkrauti0 0
                        CONTACTS YISKROVIMAS 0
                        CONTACTS RVienas_foult 0
                    END
                END
            END
            COIL YE 1 0 0
        END
        SERIES
            PARALLEL
                SERIES
                    CONTACTS XTIME 0
                    NEQ OUTLED 1
                    NEQ OUTLED 2
                    NEQ OUTLED 3
                    NEQ OUTLED 7
                END
                SERIES
                    CONTACTS XTIME 1
                    PARALLEL
                        SERIES
                            CONTACTS YISKROVIMAS 0
                            CONTACTS R_Counteris4 0
                        END
                        SERIES
                            CONTACTS YLOAD 0
                            PARALLEL
                                CONTACTS R_Counteris0 0
                                CONTACTS R_Counteris4 0
                            END
                        END
                        SERIES
                            CONTACTS YKRAUTI 0
                            PARALLEL
                                CONTACTS R_Counteris2 0
                                CONTACTS R_Counteris4 0
                            END
                        END
                        SERIES
                            CONTACTS RVienas_foult 0
                            NEQ Counteris 2
                            NEQ Counteris 3
                        END
                    END
                END
            END
            COIL YF 1 0 0
        END
        SERIES
            PARALLEL
                SERIES
                    CONTACTS XTIME 0
                    GRT OUTLED 1
                    NEQ OUTLED 7
                END
                SERIES
                    CONTACTS XTIME 1
                    PARALLEL
                        CONTACTS YKRAUTI 0
                        CONTACTS YISKROVIMAS 0
                        SERIES
                            CONTACTS RVienas_foult 0
                            NEQ Counteris 4
                            NEQ Counteris 5
                        END
                        SERIES
                            CONTACTS YLOAD 0
                            CONTACTS R_Counteris0 1
                            CONTACTS R_Counteris7 1
                        END
                    END
                END
            END
            COIL YG 1 0 0
        END
        SERIES
            EQU Counteris 0
            COIL R_Counteris0 0 0 0
        END
        SERIES
            EQU Counteris 2
            COIL R_Counteris2 0 0 0
        END
        SERIES
            EQU Counteris 4
            COIL R_Counteris4 0 0 0
        END
        SERIES
            EQU Counteris 7
            COIL R_Counteris7 0 0 0
        END
        SERIES
            PARALLEL
                SERIES
                    CONTACTS XTIME 0
                    CONTACTS R_Counteris2 0
                END
                SERIES
                    CONTACTS X1MYGTUKAS 0
                    CONTACTS XTIME 1
                END
            END
            COIL YH 1 0 0
        END
    END
END

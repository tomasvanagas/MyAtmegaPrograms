LDmicro0.1
MICRO=Atmel AVR ATmega162 40-PDIP
CYCLE=1000
CRYSTAL=1001000
BAUD=2400
COMPILED=C:\Documents and Settings\tomas\Desktop\band.hex

IO LIST
    XISK_PRALEID at 17
    XRAUDONAS at 29
    XTIME at 16
    XZALIAS at 31
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
    COMMENT <<<<<<======DAZNIO MODULIS(1sec)======>>>>>>
END
RUNG
    CONTACTS ROSC 0
    TOF Timer1 250000
    TON Timer2 250000
    COIL ROSC 1 0 0
END
RUNG
    COMMENT <<<<<<<=========IKROVIMO,ISKROVIMO MODULIS=========>>>>>>>
END
RUNG
    PARALLEL
        SERIES
            CONTACTS XRAUDONAS 0
            COIL Rkrauti0 0 1 0
        END
        SERIES
            CONTACTS XZALIAS 0
            COIL Rkrauti0 0 0 1
        END
        SERIES
            CONTACTS Rkrauti0 0
            GEQ C10secPerio 2
            COIL YKRAUTI 0 0 0
        END
        SERIES
            CONTACTS YKRAUTI 1
            CONTACTS Rkrauti0 0
            COIL YLOAD 0 0 0
        END
        SERIES
            CONTACTS ROSC 0
            CTC C10secPerio 19
        END
    END
END
RUNG
    COMMENT <<<<<<======ISKROVIMAS SIEKIANT AKU ILGAAMZISKUMO======>>>>>>
END
RUNG
    PARALLEL
        SERIES
            CONTACTS ROSC 0
            NEQ C2savaites 335
            CONTACTS YKRAUTI 1
            CONTACTS YLOAD 1
            CTC C1valanda 3599
        END
        SERIES
            EQU C1valanda 3599
            CTC C2savaites 335
        END
        SERIES
            PARALLEL
                CONTACTS YKRAUTI 0
                CONTACTS XISK_PRALEID 0
            END
            PARALLEL
                RES C1valanda
                RES C2savaites
            END
        END
        SERIES
            EQU C2savaites 355
            CONTACTS YKRAUTI 1
            COIL YISKROVIMAS 0 0 0
        END
        SERIES
            CONTACTS ROSC 0
            CONTACTS YISKROVIMAS 0
            PARALLEL
                SERIES
                    NEQ CBEEPER_OFF 7
                    CTC CBEEPER_OFF 7
                END
                CTC CISKROV 59
            END
        END
        SERIES
            EQU CISKROV 59
            OSR
            CTC CMinutes 9
        END
        SERIES
            EQU CMinutes 0
            OSR
            CONTACTS RUZLAIKYMAS 0
            CTC CDMinute 5
        END
        SERIES
            EQU CDMinute 0
            OSR
            CONTACTS RUZLAIKYMAS 0
            CTC CValando 9
        END
        SERIES
            EQU CValando 0
            OSR
            CONTACTS RUZLAIKYMAS 0
            CTC CDValand 9
        END
        SERIES
            CONTACTS YISKROVIMAS 0
            PARALLEL
                SERIES
                    OSF
                    RES CBEEPER_OFF
                END
                SERIES
                    GEQ CBEEPER_OFF 5
                    NEQ CBEEPER_OFF 7
                    COIL YRESET_BEEPER 0 0 0
                END
                SERIES
                    TON Tuzlaikymas 20000
                    COIL RUZLAIKYMAS 0 0 0
                END
                SERIES
                    OSF
                    TOF Tuzlaikymas2 100000
                    TON Tuzlaikymas3 50000
                    PARALLEL
                        RES CISKROV
                        RES CMinutes
                        RES CDMinute
                        RES CValando
                        RES CDValand
                    END
                END
            END
        END
    END
END
RUNG
    PARALLEL
        SERIES
            CONTACTS YISKROVIMAS 0
            OSF
            PARALLEL
                MOVE Minut CMinutes
                MOVE DMinut CDMinute
                MOVE Valand CValando
                MOVE DValand CDValand
            END
        END
        SERIES
            CONTACTS XTIME 0
            PARALLEL
                MOVE OUTLED CDValand
                MOVE OUTLED Valand
                MOVE OUTLED DMinut
                MOVE OUTLED Minut
            END
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
            CONTACTS ROSC 0
            CTC CSekunde 3
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
            EQU Counteris 0
            COIL Y1BLOCK 0 0 0
        END
        SERIES
            EQU Counteris 2
            COIL Y2BLOCK 0 0 0
        END
        SERIES
            EQU Counteris 4
            COIL Y3BLOCK 0 0 0
        END
        SERIES
            EQU Counteris 6
            COIL Y4BLOCK 0 0 0
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
                        CONTACTS YLOAD 0
                        CONTACTS YKRAUTI 0
                    END
                    EQU Counteris 4
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
                            EQU Counteris 0
                        END
                        SERIES
                            CONTACTS YLOAD 0
                            PARALLEL
                                EQU Counteris 4
                                EQU Counteris 6
                            END
                        END
                        SERIES
                            CONTACTS YKRAUTI 0
                            EQU Counteris 4
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
                            NEQ Counteris 0
                            NEQ Counteris 7
                        END
                        SERIES
                            CONTACTS YISKROVIMAS 0
                            PARALLEL
                                EQU Counteris 0
                                EQU Counteris 4
                            END
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
                                EQU Counteris 0
                                EQU Counteris 2
                            END
                        END
                        SERIES
                            CONTACTS YLOAD 0
                            NEQ Counteris 4
                            NEQ Counteris 3
                        END
                        SERIES
                            CONTACTS YKRAUTI 0
                            EQU Counteris 0
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
                        CONTACTS YKRAUTI 0
                        CONTACTS YISKROVIMAS 0
                        CONTACTS YLOAD 0
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
                            EQU Counteris 4
                        END
                        SERIES
                            CONTACTS YLOAD 0
                            PARALLEL
                                EQU Counteris 0
                                EQU Counteris 4
                            END
                        END
                        SERIES
                            CONTACTS YKRAUTI 0
                            PARALLEL
                                EQU Counteris 2
                                EQU Counteris 4
                            END
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
                    NEQ OUTLED 0
                    NEQ OUTLED 1
                    NEQ OUTLED 7
                END
                SERIES
                    CONTACTS XTIME 1
                    PARALLEL
                        CONTACTS YKRAUTI 0
                        CONTACTS YISKROVIMAS 0
                        SERIES
                            CONTACTS YLOAD 0
                            NEQ Counteris 0
                            NEQ Counteris 7
                        END
                    END
                END
            END
            COIL YG 1 0 0
        END
        SERIES
            PARALLEL
                SERIES
                    EQU CSekunde 0
                    EQU Counteris 0
                    CONTACTS XTIME 1
                END
                SERIES
                    PARALLEL
                        EQU CSekunde 1
                        CONTACTS XTIME 0
                    END
                    EQU Counteris 2
                END
                SERIES
                    EQU CSekunde 2
                    EQU Counteris 4
                    CONTACTS XTIME 1
                END
                SERIES
                    EQU CSekunde 3
                    EQU Counteris 6
                    CONTACTS XTIME 1
                END
            END
            COIL YH 1 0 0
        END
    END
END

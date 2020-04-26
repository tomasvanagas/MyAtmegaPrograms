LDmicro0.1
CYCLE=10000
CRYSTAL=4000000
BAUD=2400

IO LIST
    Yb6 at 0
    Yb7 at 0
    Yb8 at 0
    Yb9 at 0
    Ain at 0
END

PROGRAM
RUNG
    COMMENT This grabs the top 4 bits of a 10-bit integer variable.
END
RUNG
    PARALLEL
        SERIES
            GEQ outv 512
            PARALLEL
                COIL Yb9 0 0 0
                SUB outv outv 512
            END
        END
        SERIES
            GEQ outv 256
            PARALLEL
                COIL Yb8 0 0 0
                SUB outv outv 256
            END
        END
        SERIES
            GEQ outv 128
            PARALLEL
                COIL Yb7 0 0 0
                SUB outv outv 128
            END
        END
        SERIES
            GEQ outv 64
            PARALLEL
                COIL Yb6 0 0 0
                SUB outv outv 64
            END
        END
    END
END
RUNG
    PARALLEL
        READ_ADC Ain
        MOVE outv Ain
    END
END

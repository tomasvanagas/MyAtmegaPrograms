LDmicro0.1
MICRO=Microchip PIC16F877 40-PDIP
CYCLE=10000
CRYSTAL=4000000
BAUD=2400

IO LIST
    Xb0 at 0
    Xb1 at 0
    Xb2 at 0
    Xb3 at 0
END

PROGRAM
RUNG
    PARALLEL
        MOVE v 0
        SERIES
            CONTACTS Xb0 0
            ADD v v 1
        END
        SERIES
            CONTACTS Xb1 0
            ADD v v 2
        END
	SERIES
            CONTACTS Xb2 0
            ADD v v 4
        END
        SERIES
            CONTACTS Xb3 0
            ADD v v 8
        END
    END
END

LDmicro0.1
CYCLE=10000
CRYSTAL=4000000
BAUD=2400

IO LIST
    Xnaujas at 0
END

PROGRAM
RUNG
    CONTACTS Xnaujas 0
    CTC CNaujas 50
END
RUNG
    PARALLEL
        DIV Pirmas CNaujas 10
        MUL CNaujas1 Pirmas 10
        SUB ANTRAS CNaujas CNaujas1
    END
END

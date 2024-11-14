.data
    #listInput:      .string "ADD(1) ~ ADD(a) ~ ADD(a) ~ ADD(B) ~ ADD(;) ~ ADD(9) ~SSX~SORT~PRINT~DEL(b)~DEL(B) ~PRI~SDX~REV~PRINT"
    #listInput:      .string "ADD(1) ~ SSX ~ ADD(a) ~ add(B) ~ ADD(B) ~ ADD ~ ADD(9) ~PRINT~SORT(a)~PRINT~DEL(bb)~DEL(B) ~PRINT~REV~SDX~PRINT"
    listInput:      .string "ADD(a)~ADD(;)~ADD(B)~ADD(1)~ADD(8)~ADD(t)~ADD(t)~ADD(W)~ADD(T)ADD(z)~ADD(!)~SORT~PRINT~ADD(W)~DEL(W)~REV~PRINT"
    #listInput:        .string "ADD(a)~ADD(d)~ADD(a)~ADD(f)~SSX~PRINT"
    #listInput:        .string "ADD(a)~ADD(B)~ADD(c)~ADD(d)~ADD(a)~PRINT~DEL(a)~REV~PRINT"
    
    countComandi:   .word 0
    nMaxComandi:    .word 30
    newline: .string "\n"
    split:          .word 126
    
.text
MAIN:
    la s0, listInput            
    la s1, 0
    la s2, 30
    li s3, 0x00000800   #indirizzo di partenza
    la s4, newline
    li s5, 126          #carattere separatore ~
    li s6, 32           #spazio vuoto
    add s7, zero s3
    add s8, zero s3    #mi tengo memorizzato l'indirizzo della testa
comando:
    addi s1, s1 1
    
    bge s1, s2, end_main                # controllo se il count è uguale o supera il max di comandi
    lbu t0, 0(s0)                          # prendo il byte per volta della listInput
    
    ope_add:
    li t1, 65                              # 65 = "A"
    li t2, 68                              # 68 = "D"
    li t3, 40                              # 40 = "("
    li t4, 41                              # 41 = ")"

    bne t0, s5, go                       #controllo se il carattere corrente è il separatore
    ricontrollo:
    addi s0, s0, 1                        # nel caso aggiorno la stringa             
    lbu t0, 0(s0)
    
    beq t0 s5 ricontrollo
    beq t0, s6 ricontrollo                         #vado avanti finchè non trovo un carattere diverso dallo spazio a dalla tilde
    go:  
    bne t0, t1, ope_del                    # se t0 non è "A" allora faccio un salto a ope_del
    addi s0, s0, 1                         # scorro listInput
    
    lbu t0, 0(s0)
    bne t0, t2, end_comando                  # se t0 non è "D" allora faccio un salto a end_comando
    addi s0, s0, 1
    lbu t0, 0(s0)
    bne t0, t2, end_comando                    # se t0 non è "D" allora faccio un salto a end_comando
    addi s0, s0, 1
    lbu t0, 0(s0)
    bne t0, t3, end_comando                    # se t0 non è "(" allora faccio un salto a end_comando
    addi s0, s0, 2                             # aumento di due perchè salto il carattere all'interno delle parentesi
    
    lbu t0, 0(s0)
    bne t0, t4, end_comando                    # se t0 non è ")" allora faccio un salto a end_comando
    addi s0 s0 -1                              #torno indietro di 1
     lbu t0, 0(s0)                          # salvo il carattere su t0
    addi s0 s0 1
    jal controll
    add s0 zero t2
 
   
    
    jal cerca
    

    sb t0, 0(s3)           #carico t0 nell'indirizzo in memoria puntato da s3
 
  
   sw s8,1(s3)             #faccio puntare il nuovo nodo alla testa
   
   add t1 zero s3          # memorizzo l'indirizzo attuale
   
   
   sw t1, 1(s7)           #faccio puntare il nodo precedente al nuovo nodo
   add s7 zero s3         #salvo l'indirizzo nel caso di una nuova aggiunta
   addi s3, s3 5
  
    j end_comando
    ope_del:
    
    lbu t0, 0(s0)
    beq t0, zero, end_main              # controllo se è finita la stringa
    li t1, 68                              # 68 = "D"
    li t2, 69                              # 68 = "E"
    li t3, 76                              # 68 = "L"
    li t4, 40                              # 40 = "("
    li t5, 41                              # 41 = ")"
    bne t0, t1, ope_PRINT                      # se t0 non è "D" allora faccio un salto a PRINT
    addi s0, s0, 1                         # scorro listInput
    lbu t0, 0(s0)
    bne t0, t2, end_comando                       # se t0 non è "E" allora faccio un salto a end_comando
    addi s0, s0, 1
    lbu t0, 0(s0)
    bne t0, t3, end_comando                      # se t0 non è "L" allora faccio un salto a end_comando
    addi s0, s0, 1
    lbu t0, 0(s0)
    bne t0, t4, end_comando                       # se t0 non è "(" allora faccio un salto a end_comando
    addi s0, s0, 2
    lbu t0, 0(s0)
    bne t0, t5, end_comando                      # se t0 non è ")" allora faccio un salto a end_comando
    sub t5, t5, t3                         # mi serve 1 e lo salvo su t4
    addi s0, s0, -1                         # torno indietro di 1 per prendere il carattere
    lbu t0, 0(s0)                          # salvo il carattere su t0
    addi s0 s0 1
    
    jal controll
    add s0 zero t2
    
    addi s0,s0 1
    add t1, zero s8                        # salvo l'indirizzo della testa in t1
    add t6, zero s8
    add t2, t1 zero                        #uso t2 per scorrere gli elementi
    lb t5 0(s8)                            #carico l'elemento corrispondente alla testa
    beq t5 zero end_comando                #se è zero vuol dire che la lista è ancora vuota e faccio terminare il programma
    lw t5 1(s8)                            #controllo se c'è solo un'elemento nella lista  se si cancello                                   
    bne t5 s8 cancellazione_testa          #direttamente quello e aggiorno la coda con la testa       
    lb t6 0(t5)
    bne t6 t0 end_comando
    sb zero 0(t5)
    sw zero 1(t5)
    add s7 zero s8
    j end_comando
    cancellazione_testa:
   
    lb t3, 0(t2)                           # carico il carattere dentro quella cella su t2
    
    bne t3, t0 cancellazione_elementi_centrali                          # se t2 non è nella testa
    sb zero 0(t2)                          #azzero la cella
    addi t2, t2 1
    lw t6,0(t2)
    lw t4 ,0(t2)                           #carico momentaneamente la nuova testa in t3
    sw zero 0(t1)                         #cancello il puntatore
    add t1 zero t4                        #pongo definitivamente il controllore della testa al prossimo nodo
    add t2 zero t1                        #aggiorno t2 per continuare a scorrere
 
    j cancellazione_testa                                  #torno indietro per controllare se nella nuova testa bisogna eliminare e impostarne una nuova
    cancellazione_elementi_centrali:
    lb t3, 0(t2)                           # carico il carattere dentro quella cella su t2
    bne t3, t0 nessuna_cancellazione
    sb zero 0(t2)                          #azzero la cella
    addi t2, t2 1
    lw t4, 0(t2)                        #salvo il prossimo indirizzo su t4
    addi t2, t2 -1
    sw zero 1(t2)                         #cancello il puntatore
    sw t4, 1(t5)                          #punto l'elemento precedente al prossimo elemento
    add t2 zero t4                        #vado al prossimo elemento
    beq t4, s8 fine_cancellazioni                         #controllo se sono arrivato alla coda
    j cancellazione_elementi_centrali
    nessuna_cancellazione:
    add t5, zero t2                        #salvo l'indirizzo nel caso il prossimo elemento sia cancellato
    addi t5  t5 1
    lw t2 0 (t5)                           #carico l'indirizzo del successivo su t2
    addi t5  t5 -1
   
    
    bne t2, s8 cancellazione_elementi_centrali                        #controllo se sono arrivato alla coda
    fine_cancellazioni:
    sw t6 1(t5)                           #carico la testa nella coda
    add s8 t6 zero                        #ricarico la testa nel caso sia cambiata
    j end_comando
ope_PRINT:
  
    lbu t0, 0(s0)
     li t1, 80                             # 80 = "P"
    li t2, 82                              # 82 = "R"
    li t3, 73                              # 73 = "I" 
    li t4, 78                              # 78 = "N"
    li t5, 84                              # 84 = "T"
   
    bne t0, t1, ope_SORT                       # se t0 non è "P" allora faccio un salto a SORT
    addi s0, s0, 1                         # scorro listInput
    lbu t0, 0(s0)
    bne t0, t2, end_comando                # se t0 non è "R" allora faccio un salto a end_comando
    addi s0, s0, 1
    lbu t0, 0(s0)
    bne t0, t3, end_comando               # se t0 non è "I" allora faccio un salto a end_comando
    addi s0, s0, 1
    lbu t0, 0(s0)
    bne t0, t4, end_comando               # se t0 non è "N" allora faccio un salto a end_comando
    addi s0, s0, 1
    lbu t0, 0(s0)
    bne t0, t5, end_comando               # se t0 non è "T" allora faccio un salto a end_comando
   jal controll
    add s0 zero t2
   lb t5 0(s8)                            #carico l'elemento corrispondente alla testa
    beq t5 zero end_comando                #se è zero vuol dire che la lista è ancora vuota e faccio terminare l'operazione
    
    
    add t0  s8  zero                      #carico la testa su t0
    stampa:
    lb t1 0(t0)                           #carico l'elemento su t1
    add a0 zero t1                        #lo metto su a0 per stamparlo a video
    li a7 11
    ecall
    addi t0 t0 1                               
    lw t0,0(t0)                           #vado all'elemento sucessivo                  
    bne t0 s8 stampa                          #controllo se ho già stampato tutto
    la a0 newline
    li a7 4
    ecall
    j end_comando
    ope_SORT:
 
    lbu t0, 0(s0)
    li t1, 83                              # 83 = "S"
    li t2, 79                              # 79 = "O"
    li t3, 82                              # 73 = "R" 
    li t5, 84                              # 84 = "T"
    bne t0, t1, ope_REV                        # se t0 non è "S" allora faccio un salto a SDX
    addi s0, s0, 1                         # scorro listInput
    lbu t0, 0(s0)
    bne t0, t2, ope_SDX                        # se t0 non è "O" allora faccio un salto a end_comando
    addi s0, s0, 1
    lbu t0, 0(s0)
    bne t0, t3, end_comando                # se t0 non è "R" allora faccio un salto a end_comando
    addi s0, s0, 1
    lbu t0, 0(s0)
    bne t0, t5, end_comando               # se t0 non è "T" allora faccio un salto a end_comando
   
    jal controll
    add s0 zero t2
    lw t5 1(s8)                            #controllo se c'è solo un'elemento nella lista  se si termino                                  
    beq t5 s8 end_comando                  #il comando perchè non c'è bisogno di eseguire questa operazione
    
   jal coda                               #aggiorno la coda che potrebbe essere stata modificata con delle cancellazioni
   add t0  s8  zero                       #carico la testa su t0
   add t4 s8 zero
   add t2 zero t4                         #carico in t2 l'indirizzo di inizo del radunamento
   add t6 zero t4                         #pongo uguali t6 e t4
   jal scor_punt                          #vado a radunare la punteggiatura
   beq t4 t6 raduna_numeri            #controllo se t4 e t6 corrispondono se si vuol dire che non ci sono caratteri di punteggiatura e passo alla prossima sezione
        lw t5 1(t2)
        sw t2 1(t6)              #faccio puntare l'ultimo elemento della sezione al primo
        lb t1 0(t0)              #carico in t1 e t3 gli elementi 1 e 2 della lista
        lw t2 1(t0)
        lb t3 0(t2)
        add t2 zero t6        # se t2 e t6 coincidono vuol dire che c'è solo un elemento in quella sottolista quindi è già ordinata
        beq t2 s8 salta
        jal ordina            #se c'è più di un'elemento la ordino
        salta:
        sw t4 1(t6)                    #faccio puntare di nuovo l'ultimo elemento della sezione al suo sucessore nella lista completa
        beq t4 s8 end_comando          #se t4 e s8 coincidono vuol dire che la lista è finita e  quindi ordinata
        
        
        add t0 zero t4                 #salvo la momentanea testa
        sw t4 1(s7)                 #faccio puntare la testa all'inizio della nuova sezione
        
        add t0 zero t4           #faccio partire lo scorrimento della sottolista dal'indirizzo puntato da t2
        
        raduna_numeri:
        add t0 zero t4           #faccio partire lo scorrimento della sottolista dal'indirizzo puntato da t2
        add t6 zero t4
        li t1 58                  #codice asci da dove partono i numeri
        add t2 zero t4            #salvo t4 per il controllo finale
        jal scor_altri
        
        sw s8 1(s7)               #faccio puntare di nuovo la testa alla coda
        beq t4 t6 raduna_minuscole #se t4 e t6 coincidono vuol dire che non ci sono numeri e vado direttamente alle minuscole
        
        lw s10 1(t6)              #salvo in s10 l'indirizzo a cui punta la fine della sezione 
        sw t2 1(t6)               #faccio puntare la fine della sezione al'inizio
        lw t1 1(t2) 
        beq t2 t1 vai            #se t2 t1 coincidono vuol dire che c'è solo un'elemento e non deve essere ordinato
        lb t1 0(t0)              #carico in t1 e t3 gli elementi 1 e 2 della lista
        lw t2 1(t0)
        lb t3 0(t2)
        jal ordina
        vai:
        sw s10 1(t6)            #faccio puntare di nuovo la fine della sezione al nodo successivo
        
        beq s10 s8 end_comando #se in s10 c'è la testa vuol dire che la lista finisce con i numeri e quindi è ordinata
        
         add t2 zero t4                 #salvo la momentanea testa
        sw t4 1(s7)                 #faccio puntare la testa all'inizio della nuova sezione
        
        add t0 zero t4          #faccio partire lo scorrimento della sottolista dal'indirizzo puntato da t2
        raduna_minuscole:
         li t1 96            #codice ASCII da dove partono le lettere minuscole
         add t6 zero t4
        jal scor_min            #scorro le lettere minuscole
        
        
        beq t4 t6 ordina_maiuscole   #se t4 e t6 coincidono vuol dire che non ci sono lettere minuscole e posso passare alle maiuscole
        ordina_minuscole:
        
        sw s8 1(s7)               #faccio puntare di nuovo la testa alla coda
        #beq t4 t6 ordina_maiuscole
        
        lw s10 1(t6)              #faccio puntare la coda all'inizio della sezione
        sw t2 1(t6)               #faccio puntare la fine della sezione al'inizio
        lw t1 1(t2)
        beq t2 t1 avanza         #se t2 e t1 coincidono vuol dire che la sottolista a un solo elemento e quindi è ordinata
        lb t1 0(t0)              #carico in t1 e t3 gli elementi 1 e 2 della lista
        lw t2 1(t0)
        lb t3 0(t2)   
        jal ordina
        avanza:
        sw s10 1(t6)
        
        beq s10 s8 end_comando    #se t4 e s8 coincidono vuol dire che la lista è finita e  quindi ordinata
        ordina_maiuscole:
        sw t4 1(s7)               #faccio puntare la coda all'inizio della sezione delle maiuscole
        add t2 zero t4 
        add t0 zero t4
        add t6 zero s7
        lw t1 1(t2)
        beq t2 t1 jump           #se t2 e t1 coincidono vuol dire che c'è solo un'elemento e quindi è ordinato
        lb t1 0(t0)              #carico in t1 e t3 gli elementi 1 e 2 della lista
        lw t2 1(t0)
        lb t3 0(t2)  
        jal ordina
        jump:
        sw s8 1(s7)           #faccio puntare di nuovo la coda alla testa
        j end_comando
ope_SDX:
    
    addi s0, s0 -1
    lbu t0, 0(s0)
    li t2, 68                              # 79 = "D"
    li t3, 88                              # 73 = "X"
     bne t0, t1, end_comando                # se t0 non è "S" allora faccio un salto a REV
    addi s0, s0, 1                         # scorro listInput
    lbu t0, 0(s0)
    bne t0, t2, ope_SSX                        # se t0 non è "D" allora faccio un salto a SSX
    addi s0, s0, 1
    lbu t0, 0(s0)
    bne t0, t3, end_comando                # se t0 non è "X" allora faccio un salto a end_comando
    add t0, zero s8                           #carico l'indirizzo della testa
    jal controll
    add s0 zero t2
    lb t5 0(s8)                            #carico l'elemento corrispondente alla testa
    beq t5 zero end_comando                #se è zero vuol dire che la lista è ancora vuota e faccio terminare l'operazione
    lw t5 1(s8)                            #controllo se c'è solo un'elemento nella lista  se si termino                                  
    beq t5 s8 end_comando                  #il comando perchè non c'è bisogno di eseguire questa operazione
    
            
    lb t1, 0(t0)                          #carico il primo elemento
    lw t2 1(t0)                           #carico l'indirizzo sucessivo
    back:                       
    lb t5, 0(t2)                          #salvo l'elemento che deve essere sostituito             
    
    sb t1, 0(t2)                          #carico l'elemento precedente
    lw t2, 1(t2)                          #salvo il prossimo elemento
    add t1 zero t5                        #salvo l'elemento attuale in t1
    bne t2 s8 back                          #controllo se sono arrivato alla testa
    sb t1, 0(t2)                          #modifico l'elemento della testa
    j end_comando
ope_SSX:
    addi s0, s0, -1
    lbu t0, 0(s0) 
     bne t0, t1, end_comando                # se t0 non è "S" allora faccio un salto a end_comando
    addi s0, s0, 1                         # scorro listInput
    lbu t0, 0(s0)
    bne t0, t1, end_comando                # se t0 non è "S" allora faccio un salto a end_comando
    addi s0, s0, 1
    lbu t0, 0(s0)
    bne t0, t3, end_comando                # se t0 non è "X" allora faccio un salto a end_comando
    jal controll
    add s0 zero t2
    
    lb t5 0(s8)                            #carico l'elemento corrispondente alla testa
    beq t5 zero end_comando                #se è zero vuol dire che la lista è ancora vuota e faccio terminare l'operazione
    lw t5 1(s8)                            #controllo se c'è solo un'elemento nella lista  se si termino                                  
    beq t5 s8 end_comando                  #il comando perchè non c'è bisogno di eseguire questa operazione
    
   
   add t1 zero(s8)                         #carico la testa su t1
   lb t0, 0(s8)                            #carico il primo elemento su t0
   loop:
   add t2 zero t1                          #salvo l'indirizzo dove mettere l'elemento a destra
   lw t1 1(t1)                             #avanzo di una casella        
   lb t3 0(t1)                             #salvo l'elemento a destra
   sb t3 0(t2)                             #e lo salvo a sinistra
   bne t1 s8 loop                          #controllo se sono arrivato alla fine
   sb t0 0(t2)                             #salvo il primo elemento in coda
   j end_comando
    
ope_REV:    
    lbu t0, 0(s0)
    li t1, 82                              # 82 = "R"
    li t2, 69                              # 69 = "E"
    li t3, 86                              # 86 = "V" 
    bne t0, t1, end_comando                # se t0 non è "R" allora faccio un salto a end_comando
    addi s0, s0, 1                         # scorro listInput
    lbu t0, 0(s0)
    bne t0, t2, end_comando                # se t0 non è "E" allora faccio un salto a end_comando
    addi s0, s0, 1
    lbu t0, 0(s0)
    bne t0, t3, end_comando                # se t0 non è "V" allora faccio un salto a end_comando
    jal controll
    add s0 zero t2
    lb t5 0(s8)                            #carico l'elemento corrispondente alla testa
    beq t5 zero end_comando                #se è zero vuol dire che la lista è ancora vuota e faccio terminare l'operazione
    lw t5 1(s8)                            #controllo se c'è solo un'elemento nella lista  se si termino                                  
    beq t5 s8 end_comando                  #il comando perchè non c'è bisogno di eseguire questa operazione
    
    add t0 zero s8                         #carico la testa nei primi 4 registri t
    add t1 zero s8
    add t3 zero s8
    add t4 zero s8
    return:
        add t1 zero t3                    #mi tengo memorizzato l'ultimo elemento visualizzato
        lw t3 1(t1)                       #avanzo di una cella
        bne t3 t4 return                      #scorro finchè non raggiungo l'ultima cella invertita                
        lb t5 0(t0)                       #carico l'elemento che viene prima
        lb t6 0(t1)                       #carico l'elemento che viene dopo
        sb t6 0(t0)                       #gli inverto in memoria
        sb t5 0(t1)                       
        lw t0 1(t0)                       #carico in t0 l'indirizzo del prossimo primo elemento
        add t4 zero t1                    #carico in t4 l'indirizzo dove fermarsi scorrendo la lista
        add t1 zero t0                    #carico in t1 il prossimo indirizzo di partenza per scorrere la lista
        add t3 zero t0
        blt t1 t4 return                      #controllo se i puntatori di testa e coda si sono invertiti nel caso si siano invertiti vuol dire che la lista è stata invertita
        j end_comando 
end_comando:
    lbu t0 0(s0)                           #carico il carattere corrente su t0
    beq t0, zero end_main                  # se i comandi sono finiti fa finire il codice
    beq t0, s5,comando                   # se t0 non è "~" va avanti, se è "~" torna all'inizio per eseguire il nuovo comando
    addi s0 s0 1                         #scorro la stringa
    lbu t0 0(s0)
    
    j end_comando 
cerca:
    
     addi s3 s3 1                         #scorro byte per byte finchè non trovo 5 celle consecutive libere
     beq s3, zero cerca                   
     addi s3 s3 1
     beq s3, zero cerca
     addi s3 s3 1
     beq s3, zero cerca
     addi s3 s3 1
     beq s3, zero cerca
     addi s3 s3 1
     addi s3 s3 -5                   #e le utilizzo per  memorizzare il nuovo nodo
     jr ra
 controll:
     add t2 zero s0                  #salvo in che punto della stringa mi trovo
     addi s0 s0 1                    #scorro 
     lbu t6 0(s0)                    #salvo il carattere corrente in t6
     beq t6 s5 nulla                 #se trovo il carattere separatore o
     beq t6 zero nulla               #la fine della stringa è scritto bene e lo eseguo
     ripasso:
     addi s0 s0 1                    #altrimenti scorro  e se trovo
     lbu t6 0(s0)                    #un carattere diverso dallo spazio
     bne t6 s6 fuori                 #controllo se è il carattere separatore            
     j ripasso
     fuori:
         bne t6 s5 finire            #se non è il carattere separatore vado a far finire il comando senza esegurilo
     nulla:
     jr ra
     finire:
         addi s0 s0 1               #scorro  finchè non trovo il carattere separatore o la fine della stringa
         lbu t6 0(s0)
         beq t6 zero end_main
         beq t6 s5 comando
         j finire
  scor_punt:
        li t1 47
       lb t3 0(t0)                       #carico elemento puntato da t0
       bgt t3 t1 prossimo                #guardo se t2 rientra nei caratteri di punteggiatura
       scambio:
       lb t5 0(t0)                       #se si salvo il carattere corrente in t5
       lb t6 0(t4)                       #e lo inverto con il carattere nella cella più in basso
       sb t6 0(t0)
       sb t5 0(t4)
       add t6 zero t4                   #salvo in che cella c'è l'ultimo elemento del radunamento
       lw t4 1(t4)                      #aggiorno t4 con la prossima cella
       j non_scambio
       prossimo:
       li t1 57                         #mano a mano che vado avanti
       ble t3 t1 non_scambio                     #controllo se il carattere
       li t1 64                         #rientra all'interno della
       ble t3 t1 scambio                     #punteggiatura se si trova in
       li t1 90                         #quell'intervallo vado a farlo 
       ble t3 t1 non_scambio                     #andare avanti se no vado al 
       li t1 96                         #prossimo elemento della lista 
       ble t3 t1 scambio
       li t1 123 
       ble t3 t1 non_scambio
       j scambio
       non_scambio:
        lw t0 1(t0)             
        bne t0 s8 scor_punt          #se ho guardato tutta la lista torno all'ordinamento
        jr ra
        scor_min:
           lb t3 0(t0)
        ble t3 t1 pros
        rb:
       lb t5 0(t0)                       #se si salvo il carattere corrente in t5
       lb t6 0(t4)                       #e lo inverto con il carattere nella cella più in basso
       sb t6 0(t0)
       sb t5 0(t4)
       lw t5 1(t4)
       add t6 zero t4                   #salvo in che cella c'è l'ultimo elemento del radunamento
       lw t4 1(t4)                      #aggiorno t4 con la prossima cella
        pros:
            lw t0 1(t0)
        bne t0 t2 scor_min
        lw t5 1(t4)
        jr ra 
scor_altri:
    
        
        lb t3 0(t0)
        bgt t3 t1 prox
        rd:
       lb t5 0(t0)                       #se si salvo il carattere corrente in t5
       lb t6 0(t4)                       #e lo inverto con il carattere nella cella più in basso
       sb t6 0(t0)
       sb t5 0(t4)
       lw t5 1(t4)
       add t6 zero t4                   #salvo in che cella c'è l'ultimo elemento del radunamento
       lw t4 1(t4)                      #aggiorno t4 con la prossima cella
        prox:
            lw t0 1(t0)
        bne t0 t2 scor_altri
        lw t5 1(t4)
        jr ra
ordina:
            
         blt t1 t3 incre          #controllo se sono in ordine, se si vado a scorrere la sottolista
        ritorna:
        sb t3 0(t0)               #altrimenti li scambio e li ordino
        sb t1 0(t2)
        
        incre:
        lw t5 1(t0)              #uso t5 per controllare se sono arrivato alla fine
        lw t0 1(t0)
        lb t1 0(t0)
        lw t2 1(t0)
        lb t3 0(t2)
        bne t5 t6 ordina  #controllo se ho scorso tutta la lista 
        controllo:              #in questa sezione scorro la 
        lw t5 1(t0)             #sottolista e guardo se gli 
        indietro:               #elemnti sono ordinati, se 
        lw t0 1(t0)             #trovo due elementi non 
        lb t1 0(t0)             #ordinati torno ad ordinare
        lw t2 1(t0)             #la sottolista, altrimenti 
                                #controllo e ho fatto un giro
        lb t3 0(t2)             #completo ed eventualmente esco
        beq t3 t1 avanz         #se i due elementi sono uguali avanzo
        blt t1 t3 controllo     
        beq t5 t6 fine           
         j ritorna
         fine:                  
        jr ra   
       avanz:
           lw t5 1(t0)          #incremento t5 e se sono alla fine termino
           beq t5 t6 fine
           j indietro
coda:
    add t0 zero s8            #carico in t0 la testa per scorrere
    rit:
        add t1 zero t0        #mano a mano salvo la cella in t1
        lw t0 1(t0)
        bne t0 s8 rit        #scorro finchè non torno alla testa
        add s7 zero t1      #aggiorno la testa
        jr ra         
end_main:
    li a0 0
    add a0, a0, zero
    li a7, 11
    ecall
    


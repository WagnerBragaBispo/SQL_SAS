PROC SQL;
   CREATE TABLE PDD.PERF_ROSALVO_31_&DT_PERF. AS SELECT DISTINCT 
          A.*,
		  B.VALOR_NET_SMS
          /* SUM_of_VALOR_NET_SMS */
            (SUM(B.VALOR_NET_SMS)) AS SUM_of_VALOR_NET_SMS
      FROM PDD.PAGAMENTOS_NETSMS_4_201607 B
           LEFT JOIN PDD.PERF_ROSALVO_201607 A ON (B.CD_OPERADORA = A.OPERACAO_NETSMS) AND (INPUT(B.NUM_CONTRATO,18.) = 
          INPUT(A.CONTRATO,18.))
      GROUP BY 1;
QUIT;

-------------- @MARCO ----------

Wagner,

Precisamos enviar para as operações as bases da arvore com o score PrePDD. 
Consegue marcar essa pontuação na base, para isso basta cruzar a sua base com a base pré calculado do score (score_rolagem61_90_201606) 
que esta na lib 

/u01/sasdata/cobranca/DADOS_COBRANCA/MODELAGEM/NET/SCORE .



LEFT JOIN COBRANCA.MD_STATUS_CONTR AS C ON (B.idStatusContr = C.idStatusContr);
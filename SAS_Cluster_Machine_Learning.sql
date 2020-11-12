/* Exemplos
 Como exemplo, agruparemos os valores de pixel de dígitos manuscritos extraídos do banco de dados MNIST. Pesquisas anteriores mostraram que os clusters no banco de dados MNIST são sobrepostos e não esféricos. Para criar resultados facilmente interpretáveis ​​para este exemplo, usaremos 500 observações de dígitos {0, 1, 2, 3, 4}. Observe que a padronização não é necessária, pois as variáveis ​​são medidas nas mesmas unidades.

Aqui estão três maneiras de agrupar nossos dados e dois pontos; 
1) usando puramente FASTCLUS, 2) usando puramente HPCLUS e 3) usando uma combinação de ambos.*/

/*1) Usando puramente FASTCLUS.
Se não sabemos o número de clusters esperados de antemão, temos que executar o PROC FASTCLUS várias vezes com diferentes valores de k . 
A macro abaixo mostra k = 3 a 8.*/
%macro doFASTCLUS;

     %do k= 3 %to 8;

          proc fastclus

               data= digits

               out= fcOut

               maxiter= 100

               converge= 0          /* run to complete convergence */

               radius= 100          /* procura por centróides iniciais muito distantes */

               maxclusters= &k

               summary;

          run;

     %end;

%mend;

%doFASTCLUS

/*A saída resumida de cada k inclui quatro estatísticas diferentes para determinar a compactação e a separação dos resultados de agrupamento. 
Os resultados resumidos para k = 5 são mostrados abaixo. 
Procure uma dica futura que discuta como estimar o número de clusters usando estatísticas de saída, como o Critério de Clustering Cúbico e a Estatística do Pseudo F.*/

/*2) Usando puramente o HPCLUS
No HPCLUS, podemos usar a opção NOC = ABC para selecionar automaticamente o melhor valor de k entre 3 e 8.*/

proc hpclus

     data= digits

     maxclusters= 8

     maxiter= 100

     seed= 54321                                 /* definir semente para gerador de números pseudo-aleatórios */

     NOC= ABC(B= 1 minclusters= 3 align= PCA);   /* selecione melhor k entre 3 e 8 usando ABC */

     score out= OutScore;

     input pixel:;                               /* input variables */

     ods output ABCStats= ABC;                  /* salvar valores de critério ABC para plotagem */

run;
/*O HPCLUS relata o melhor número de clusters em sua saída, juntamente com os valores de gap ABC para cada valor k . A interpretação dos valores ABC será discutida em detalhes em uma dica futura também.*/


/*Podemos visualizar um gráfico dos valores ABC para cada k usando o seguinte código:*/

proc sgplot

     data= ABC;

     scatter x= K y= Gap / markerattrs= (color= 'STPK' symbol= 'circleFilled');

     xaxis grid integer values= (3 to 8 by 1);

     yaxis label= 'ABC Value';

run;
/*O pequeno pico em k = 5 indica que a melhor estimativa para o número de clusters é 5, o que é esperado para nosso conjunto de dados de dígitos manuscritos entre 0-4.*/

/*3) Combinando FASTCLUS e HPCLUS.

Como alternativa, podemos combinar os pontos fortes do FASTCLUS e do HPCLUS usando primeiro o HPCLUS para estimar o número de clusters k e , em seguida, usando o FASTCLUS para obter clusters bem separados por meio de sua inicialização não aleatória .*/


/* executa o HPCLUS para selecionar automaticamente o melhor valor k */

proc hpclus

     data= digits

     maxclusters= 8

     maxiter= 100

     seed= 54321  

     NOC= ABC(B= 1 minclusters= 3 align= PCA);   /* selecione melhor k entre 3 e 8 usando ABC*/                                                      

     input pixel:;                             

     ods output ABCResults= k;                   /* salvar o valor k selecionado por ABC */

run;

 

/* é selecionado k em uma macro var */

data _null_;

      set k;

      call symput('k', strip(k));

run;

%put k= &k.;

 

/* agora execute o FASTCLUS para encontrar k nice clusters de sementes não aleatórias */

proc fastclus

      data= digits

      out= fcOut

      maxiter= 100

      converge= 0

      radius= 100          /* procura por centróides iniciais muito distantes */    

      maxclusters= &k    & k /* k encontrado pelo hpclus */

      summary;

run;

/*Resumo

O PROC FASTCLUS é adequado para dados pequenos e médios. Ele fornece inicialização não aleatória, que geralmente leva a clusters mais bem separados, e fornece várias estatísticas que indicam a qualidade dos resultados de clustering. Se você não sabe o que o número de clusters k deve ser antecipadamente, você teria que executar o FASTCLUS com valores diferentes de k para determinar manualmente o melhor k.

 

O HPCLUS destina-se à execução de tarefas de armazenamento em cluster exigentes em computação em sistemas distribuídos. Ele pode selecionar automaticamente o melhor valor k dentro de um intervalo especificado, mas suporta apenas a inicialização aleatória.*/

 

/*Links Úteis

Consulte o SAS / STAT 9.2, Guia do Usuário, Introdução aos Procedimentos de Cluster ( https://support.sas.com/documentation/cdl/en/statugclustering/61759/PDF/default/statugclustering.pdf ) para obter informações sobre os diversos procedimentos de clustering no SAS . Este documento abrange procedimentos do SAS / STAT, incluindo CLUSTER, FASTCLUS, MODECLUS, VARCLUS e TREE.
*/


proc fastclus data = libref.cluster out = out maxc= 3;
var Income Age;
title 'FASTCLUS ANALYSIS';
RUN;
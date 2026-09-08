
/*----------Advanced series-----------*/


/*-------------------------------------*/
/*##07 Analysis of Variance & Mixed*/
/* title 'toxicology data of rat'*/
data rat;
     input   group $   dose  @ ;
     do  r = 1 TO 10 ; /*Store Hb values in y. Store 10 in each dose.*/
       input   y  @ ;
       output ;
     end ;

     cards ;
       A1   0    153  153  152  156  158  141  151  150  148  157
       A2   5    158  152  152  152  151  151  157  147  155  146
       A3  10    153  146  138  152  140  146  156  142  147  153
       A4  20    137  139  141  141  143  133  147  144  151  156
       A5  40    142  126  134  143  139  134  141  139  124  136
       ;
run;

proc print data=rat;
run;



/*1-way ANOVA*/
proc glm data=rat;
   class group;
   model y=group;
   means group;
run;
proc glm data=rat;
   class dose;
   model y=dose;
   means dose;
run;

*  regression;
proc reg data=rat;
   model y=dose;
run;

/*multiple comparison*/
proc glm data=rat;
   class dose;
   model y=dose;
   means dose/dunnett('0');
run;

/*contrast*/
ods pdf file='F:\anova3.pdf';
proc glm data=rat;
   class dose;
   model y=dose;
   contrast 'linear'      dose -2 -1  0    1    2;
   contrast 'quadratic' dose  2  -1 -2  -1   2;
   contrast 'others'     dose  -1  2  0   -2   1;
run;
ods pdf close;


/*****************************/
/* ANOVA repeated measures*/
/* dog data: example of contrast*/

data dog;
     do time=1 to 5; do dog=1 to 6;
     input y@@;  output; end; end;
     cards;
 900  1510  1540  1082  1180  1311
 792  1189  1082   885   885   984
 792  1109  1049   902   754  1000
 768  1028  1148   885   754   984
 873  1277  1310  1311   951  1279
;
proc print data=dog; run;

proc gplot data=dog;
  plot y*time=dog;
  symbol1 i=join v=star c=blue r=6;
  run;

/*----Q1:Compare models ---------------------------------------------------------------------------*/
/* incorrect analysis*/
/*consider only time model:A model in which the measured data are considered 
  independent without identifying the same individuals*/
/*-----------------------------------------------------------------------------------------*/

proc glm data=dog;
  class time dog;
  model y=time;
run;

/*-----------------------------------------------------------------------------------------*/
/* correct analysis*/
/*consider individual differences The same individuals are measured repeatedly*/
/*-----------------------------------------------------------------------------------------*/

proc glm data=dog;
  class time dog;
  model y=time dog;
  lsmeans time/diff cl;
  contrast '1  -  5' time 1  0  0  0 -1;
  contrast '2  -  3' time 0  1 -1  0  0;
  contrast '23 -  4' time 0  1  1 -2  0;
  contrast '15 -234' time 3 -2 -2 -2  3;
run;


/*---Q2 Perform a time series data analysis using GLM and MIXED---------------*/
/* dataset for GLM-repeated analysis*/

proc sort data=dog out=dog;
   by dog; 
   run;

proc transpose data=dog out=dog_2;/*transposing dataset is dog_2*/
   by dog; var y;
      run;
proc print data=dog_2;/*To check the shape of the data set and variables*/
      run;

/* PROC GLM repeated measurement analysis*/
proc glm data=dog_2;
   model col1-col5=/nouni;
   repeated time 5/PRINTE;
   run;



/*---Q3: Verify that the interpretation by LSMEANS is consistent with that by CONTRAST----*/
/* PROC MIXED repeated measurement analysis*/
proc mixed data=dog;
   class dog time;
   model y=time;
   repeated time/sub=dog type=cs;
   lsmeans time/diff cl;
   contrast '1  -  5' time 1  0  0  0 -1;
   contrast '2  -  3' time 0  1 -1  0  0;
   contrast '23 -  4' time 0  1  1 -2  0;
   contrast '15 -234' time 3 -2 -2 -2  3;
run;


/***********************************/
/* blood pressure data*/

data  bp;
       input dose $   id $   t0  t1  t3  @@;
       * t0: baseline;
       output ;
     cards ;
         D1  R1   119  113  114     D2  S1   125  109  113
         D1  R2   110  115  112     D2  S2   108   98  104
         D1  R3   123  126  111     D2  S3   133  118  117
         D1  R4   130  127  100     D2  S4   125  114  110
         D1  R5   121  115  124     D2  S5   113  107  106
         D1  R6   135  125  115     D2  S6   126  118  110
         ;
proc print data=bp;
   run;


/* data for mixed and graph*/
data work2; set bp;
   time=0; y=t0; output;
   time=1; y=t1; output;
   time=3; y=t3; output;
   keep dose id time y t0;
run;

proc sort data=work2 out=work2;
   by dose id;
run;
 
proc print data=work2;
   run;

 /*graph by gplot*/
proc gplot data=work2;
  plot y*time=id;
  symbol1  repeat=6 i=join v=star c=blue;
  symbol2  repeat=6 i=join v=square c=red;
run;

/*graph by sgplot*/
proc sgplot data=work2;
   vline time/
           group=dose 
           response=y
           groupdisplay=cluster
           clusterwidth=0.3 
           stat=mean 
           limitstat=stddev 
           numstd=1.96 
           markers
           markerattrs=(Symbol=circlefilled);   
run;
/*------------------------------------*/
/*Q4  ttest*/
   ods pdf file='F:\mixed1.pdf';
proc sort data=bp;
by dose;
run;
proc ttest data=bp;
paired t0*t1;
by dose;
run;
proc ttest data=bp;
paired t0*t3;
by dose;
run;
ods pdf close;

/*other methods*/
data test2;      /* ??????????????*/
  set bp;
  diff=t0-t1;
run;
proc univariate data=test2; 

  var diff;
run;


/*-------------------------------------*/
/*Q5 PROC GLM & PROC MIXED*/
/*Be careful whether you use the "work2" dataset or the "bp" dataset*/
/*GLM*/
proc glm data=bp;
   class dose id;
   model t0--t3=dose;
   repeated time 3;
   lsmeans dose/diff cl;
   run;

   /*MIXED*/
proc mixed data=work2;
    class dose id time;
    model y=dose time ;
    repeated time/sub=id type=cs;
    lsmeans dose/diff cl;
    run;

/*-------------------------------------*/
/*Q6 covariance analysis with t0*/;

proc glm data=bp;
   class dose id;
   model t1--t3=dose t0;
   repeated time 2;
   lsmeans dose/diff cl;
   run;

proc mixed data=work2;
    where time ne 0;
    class dose id time;
    model y=dose time t0;
    repeated time/sub=id type=cs;
    lsmeans dose/diff cl;
    run;

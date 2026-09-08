/***********************************/
/*Gneral linear model (1) Regression model*/
/**regression analysis on Anscombe's data*/
/***********************************/

title "Anscombe's data";
/*Slide Q16*/
/*ANS1*/
data ans1;
  input x y;
  cards;
10  8.04
8   6.95
13  7.58
9   8.81
11  8.33
14  9.96
6   7.24
4   4.26
12  10.84
7   4.82
5   5.68
;
run;
/*ANS2*/
data ans2;
  input x y;
  cards;
10  9.14
8   8.14
13  8.74
9   8.77
11  9.26
14  8.10
6   6.13
4   3.10
12  9.13
7   7.26
5   4.74
;
run;

/*ANS3*/
data ans3;
  input x y;
  cards;
10  7.46
8   6.77
13  12.74
9   7.11
11  7.81
14  8.84
6   6.08
4   5.39
12  8.15
7   6.42
5   5.73
;
run;

/*ANS4*/
data ans4;
  input x y;
  cards;
8   6.58
8   5.76
8   7.71
8   8.84
8   8.47
8   7.04
8   5.25
19  12.5
8   5.56
8   7.91
8   6.89
;
run;


/*Run the following code for the ANS1 to ANS4 datasets*/
ods pdf file='F:\reg4.pdf';
proc reg data=ans4;
  model y=x;
  run;
ods pdf close;

/*Run the following code for the ANS1 to ANS4 datasets Slide #28 "influence"*/
 ods pdf file='F:\reg5.pdf';
proc reg data=ans1;
  model y=x/r influence;
  run;
ods pdf close;

/*Robust reg Use the ANS3 data and run the following code*/
 ods pdf file='F:\reg6.pdf';
proc robustreg data=ans3 method=m;
 model y=x;
 run;
ods pdf close;


/***********************************/
/******variable selection data=select*****/
/***********************************/

proc corr data=select;
  var x1-x15 y;
  run;

/*all*/
proc reg data=select;
    model y=x1-x15;
run;
/*forward*/
proc reg data=.select;
    model y=x1-x15/selection=forward sle=0.15;
run;
/*backward*/
proc reg data=select;
    model y=x1-x15/selection=backward sls=0.15;
run;
/*stepwise*/
proc reg data=.select;
    model y=x1-x15/selection=stepwise sle=0.15 sls=0.15;
run;
/*rsquare*/
proc reg data=select;
    model y=x1-x15/selection=rsquare best=5 start=1 stop=5;
run;

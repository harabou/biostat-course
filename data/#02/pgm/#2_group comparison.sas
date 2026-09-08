/*#2_group comparison*/

/*Barley Rice and Cholesterol Lowering*/
*libname surv 'D:\';
data barely;
input  group $ d_chol;
cards;
B	-40
B	-5
B	-45
B	5
B	-30
B	-40
B	-10
B	-15
B	0
B	10
C	-20
C	-25
C	-25
C	-20
C	-5
C	-15
C	-5
C	-10
C	35
C	10

;
run;
proc print;
run;
/*boxplot*/
proc boxplot data=barely;
plot d_chol*group/ boxstyle=schematic;
run;
ods pdf file= 'F=p.pdf';
/*t-test*/
proc ttest;
class group;
var d_chol;
run;
ods pdf close;



/*Comparison with height of corn data*/
/*Slide #23-24 Q1: DarwinÅfs Corn (Zea) Data data=darwin*/
data surv.darwin;
input group len;
cards;
1 23.5
1 12
1 21
1 22
1 19.125
1 21.5
1 22.125
1 20.375
1 18.25
1 21.625
1 23.25
1 21
1 22.125
1 23
1 12
2 17.375
2 20.375
2 20
2 20
2 18.375
2 18.625
2 18.625
2 15.25
2 16.5
2 18
2 16.25
2 18
2 12.75
2 15.5
2 18
;
run;
/*Univariate (#1 review work)*/
proc univariate data=darwin plot normal;
var len;
by group; 
run;

/*plot 1-SG plot-*/
proc sgplot data=darwin;
  vbox len/category=group; run;
/*plot 2 boxplot-*/
proc boxplot data=darwin;
    plot len*group/boxstyle=schematic;
run;

/* t-test* slide#25/
ods pdf file='G:\kamogawa\test\test.pdf' ;
proc ttest data=darwin;
   class group;
   var len;
run;
ods pdf close;

/*Wilcoxon test slide#31*/
proc npar1way data=darwin wilcoxon;
   class group;
   var len;
   exact wilcoxon;
run;

/*ttest outlier affect outcome*/
data surv.outl;
input group d;
cards;
1 1
1 2
1 2
1 3
1 4
2 5
2 5
2 6
2 7
2 8
;

/*ttest outlier affect outcome slide#34-36*/
/*change 8->80*/
data outl2;
input group d;
cards;
1 1
1 2
1 2
1 3
1 4
2 5
2 5
2 6
2 7
2 80
;

proc ttest data=outl2; /*t-test*/
class group;
var d;
run;

proc npar1way data=outl2 wilcoxon; /*wilcoxon*/
   class group;
   var d;
   exact wilcoxon;
run;




/*Chi-square test cross table*/;
/* reumatism data*/

data rheu;
    input sex group res num;
	cards;
	1  1  1  7
	1  1  0  7
	1  2  1  1
    1  2  0  10
	2  1  1  21
	2  1  0  6
	2  2  1  13
    2  2  0  19
	;
	run;
proc format ;
	  value se 1='male' 2='female';
	  value gr 1='test'   2='placebo';
	  value re 1='some/marked'  0='none';
	run;

/*chisq-test and Fisher's exact test side #42-45*/;
proc freq data=rheu order=data;
     tables group*res/nocol nopercent chisq riskdiff;
      weight num;
      format sex se. group gr. res re.;
run;



/* Cochran-Mantel-Haenszel test for stratification  slide#46-49*/
ods pdf file='G:\kamogawa\test\test.pdf' ;
proc freq data=rheu order=data;
     tables sex*group*res/relrisk plots(only)=relriskplot(stats) nocol nopercent chisq cmh;
     weight num;
     format sex se. group gr. res re.;
run;
ods pdf close;

/*McNemarÅfs test* Slide#50-53*/
/*lowback pain data*/
data lowback;
input y $ n $ count;
cards;
Y Y 47
Y N 16
N Y 5
N N 32
;
run;

PROC FREQ DATA=lowback;
TABLES y*n;
EXACT MCNEM;
WEIGHT Count;
run;

/*consult with parent data  Q3: slide #52-53*/
data tabledata;/*A-data*/
input y $ n $ count;
datalines;
Y Y 50
Y N 0
N Y 0
N N 50
;
run;
proc freq data=tabledata order=data;
     tables y*n/nocol nopercent chisq;
      weight count;

PROC FREQ DATA=tabledata;
TABLES y*n;
EXACT MCNEM;
WEIGHT Count;
run;

data tabledata2;/*B-data*/
input y $ n $ count;
datalines;
Y Y 32
Y N 48
N Y 8
N N 12
;
run;
proc freq data=tabledata2 order=data;
     tables y*n/nocol nopercent chisq;
      weight count;

PROC FREQ DATA=tabledata2;
TABLES y*n;
EXACT MCNEM;
WEIGHT Count;
run;





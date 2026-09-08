/***************************************/
/*Dietary survey (FFQ) data for college students*/
/***************************************/

/*Dataset:bdhq_1
(1) Specify libname and read from dataset or (2) csv file*/

/*(1) libname case*/
libname diet 'D:\'; /*c:\pass change*/

data diet.bdhq2;/*dataset should be stored in the libname hierarchy*/
  set diet.bdhq1;
  keep id milk_p--yushi_p  idc ;
  run;

/*(2) csv loading case*/
libname diet 'D:\'; /*c:\pass change*/

data diet.bdhq2;
infile 'D:\bdhq_1.csv' delimiter='.' firstobs=2;
input 
ID	MG VC WDF NDF C18M milk_p	meat_p	fish_p egg_p soy_p potato_p pickles_p	
gveg_p	veg_p kinoko_p kaisou_p sweets_p	fruits_p	cyoumi_p bread_p noodle_p rice_p	
tea_p	 coffee_p sbev_p fbev_p sugar_p	misosp_p alc_p yushi_p idc;
run;

/*==============exercise===================*/
/*correlation*/
proc corr data=diet.bdhq2 best=8;
    var milk_p--yushi_p;
run;

/*1: Principal component analysis*/
proc princomp data=diet.bdhq2 plots=all n=4 ;
    var milk_p--yushi_p;
run;

/*2:factor anakysis*/
proc factor data=diet.bdhq2 method=ml  nfactor=4 heywood rotate=promax plots=all out=score;
    var milk_p--yushi_p;
run;

proc plot data=score;/*To use score dataset which  was outputted by  previous analysis*/ 
  plot factor1*factor2  $ idc;
  /***************************************/
run;

proc gplot data=score;
  plot factor1*factor2  ;
  symbol v=star pointlabel=('#idc');
  run;



/*3:Correspondence analysis */
/******************************************/
/*Market survey on the impressions of the products*/
/******************************************/

data diet.market;
input company $ use design buy price trust colar healthy Material Premium; 
datalines; 
A 86 65 72 55 82 86 90 15 39
B 92 74 55 39 90 44 35 55 39
C 62 68 69 67 74 20 80 95 89
D 71 49 77 73 66 30 80 62 64
E 85 62 82 73 78 69 70 25 39
F 77 80 55 69 70 73 66 78 69
G 59 82 92 84 66 67 74 92 74
;

ods pdf file="F:\corp1.pdf"; /*F:\-----   change to your PC environmen*/
proc corresp all data=diet.market dimens=2 observed short out=corpp; 
var use design buy price trust colar healthy Material Premium; id company; run; 
ods pdf close; 

proc sgplot data = corpp noautolegend;
 xaxis min = -.4 max = .4 values=(-.3 to .3 by .1) valueshint;
 yaxis min = -.3 max = .3;
 scatter x = dim1 y = dim2 /group = _type_ MARKERCHAR = company
                            markercharattrs=(size=10 weight=bold);
run; 



/*4: Cluster analysis*/
/***************************************/
/*Dietary survey (FFQ) data for college students*/
/***************************************/

/*Valclus: methods to classify variables*/
proc varclus data=diet.bdhq2 minccluster=4 maxcluster=11  plots=all;
    var milk_p--yushi_p;
run;

/*cluster:single linkage*/
proc cluster data=score method=single;
  id idc;
run;
/*cluster: comlete(maximize) linkage*/
proc cluster data=score method=complete;
  id idc;
run;
/*cluster: average linkage*/
proc cluster data=score method=average;
  id idc;
run;


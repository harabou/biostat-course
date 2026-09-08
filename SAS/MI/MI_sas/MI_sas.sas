/*Multiple Imputation*/

/*----------------------------------------------------------------*/
/*Dataset "hsb_mar"を使用する（欠測を含むデータ）*/
/*----------------------------------------------------------------*/

/*library指定　自身のPC環境に応じて*/
libname harada 'D:\harada\';


/*フォーマット指定*/
proc format;
  value female 0 = "male"
               1= "female";
  value prog 1 = "general"
             2 = "academic"
             3 = "vocation" ;
  value race 1 = "hispanic"
             2 = "asian"
             3 = "african-amer"
             4 = "white";
  value schtyp 1 = "public"
               2 = "private";
  value ses  1 =  "low"
             2 = "middle"
             3 = "high";
run;
options fmtsearch=(work);


/*欠測状況の確認*/
proc means data = harada.hsb_mar nmiss N min max mean std; 
var _numeric_ ; 
run; 

/*欠測データセットにて："Reading score"に関連する変数の検討"*/
proc glm data = harada.hsb_mar; 
class female (ref=last) prog; 
model read = write female math prog /solution ss3; 
run; 
quit;

data new;
set harada.hsb_mar;
if prog ^=. then do;
if prog =1 then progcat1=1;
else progcat1=0;
if prog =2 then progcat2=1;
else progcat2=0;
end;
run;

proc corr data = new cov outp=test; 
var write read female math progcat1 progcat2; 
run;

proc reg data = test; 
model read = write female math progcat1 progcat2; 
run; 
quit;

/*MI手順*/
/*first*/
/*欠測フラグ*/
data hsb_flag;
set new;
if female =.  then female_flag =1; else female_flag =0;
if write  = . then write_flag  =1; else write_flag  =0;
if read   = . then read_flag   =1; else read_flag   =0;
if math   = . then math_flag   =1; else math_flag   =0;
if prog   = . then prog_flag   =1; else prog_flag   =0;
run;
proc freq data=hsb_flag;
tables female_flag write_flag read_flag math_flag prog_flag;
run;


/*second*/
/*Imputation "PROC MI"*/
/*欠測パターンの表示*/
proc mi data=HSB_flag nimpute=0 ;
var socst write read female math prog;
ods select misspattern;
run;

proc mi data=HSB_flag nimpute=0 ;
var socst write read female math prog schtyp ses race;
ods select misspattern;
run;

/*t-testで確認*/
proc ttest data=hsb_flag;
var socst science;
class read_flag;
run;

proc ttest data=hsb_flag;
var socst science;
class write_flag;
run;

proc ttest data=hsb_flag;
var socst science;
class math_flag;
run;

proc ttest data=hsb_flag;
var socst science;
class female_flag;
run;

proc ttest data=hsb_flag;
var socst science;
class prog_flag;
run;


/*MCMCによる*/
/*seedは同じ値を設定すると同じ結果が再現可能*/
proc mi data= new nimpute=10 out=mi_mvn seed=54321;
var socst science write read female math progcat1 progcat2;
run;/*mi_mvnに10個分のimp後のデータ掃き出し*/

/*10個のデータについてそれぞれ解析実施*/
proc glm data = mi_mvn; 
model read = write female math progcat1 progcat2; 
by _imputation_; 
ods output ParameterEstimates=a_mvn; 
run; 
quit;

/*統合 "proc mianalyze"*/
proc mianalyze parms=a_mvn; 
modeleffects intercept write female math progcat1 progcat2; 
run;


proc mi data= harada.hsb_mar nimpute=10 out=mi_mvn; 
mcmc plots=trace plots=acf; 
var socst write read female math; 
run;



/*FCSによる*/
proc mi data= harada.hsb_mar nimpute=20 out=mi_fcs; 
class female prog; 
fcs plots=trace(mean std); 
var socst write read female math science prog; 
fcs discrim(female prog /classeffects=include) nbiter =100; 
run;


proc mi data= harada.hsb_mar nimpute=20 out=mi_fcs; 
class female prog; 
var socst write read female math science prog; 
fcs logistic(female prog /link=glogit); 
run;

proc mi data= harada.hsb_mar nimpute=20 out=mi_fcs; 
class female prog; 
var socst write read female math science prog; 
fcs logistic(female prog /link=glogit) regpmm(math read write); 
run;


proc mi data= harada.hsb_mar nimpute=20 out=mi_new1; 
class female prog; 
var socst write read female math science prog; 
fcs logistic(female= math science/link=glogit); 
fcs logistic(prog =math socst /link=glogit) regpmm(math read write); 
run;

/*解析*/
proc genmod data=mi_fcs; 
class female prog; 
model read= write female math prog /dist=normal; 
by _imputation_; 
ods output ParameterEstimates=gm_fcs; 
run;


PROC MIANALYZE parms(classvar=level)=gm_fcs; 
class female prog; 
MODELEFFECTS INTERCEPT write female math prog; 
RUN;


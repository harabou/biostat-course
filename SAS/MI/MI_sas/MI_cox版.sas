/*Multiple Imputation*/

/*----------------------------------------------------------------------------------*/
/*Dataset "pcanser"を使用する（生存時間解析用：欠測を含むデータ）*/
/*---------------------------------------------------------------------------------*/

/*library指定　自身のPC環境に応じて*/
libname harada 'D:\harada\';

/*Imputation*/
proc mi data=harada.pcancer_mod nimpute=0 ;
var time censor age sex treat stage ;
ods select misspattern;
run;

/*================================================*/
/*FCS*/
proc mi data= harada.pcancer_mod nimpute=20 out=harada.mi_fcs; 
class censor sex treat stage; 
var time censor age sex treat stage; 
fcs discrim(censor/classeffects=include) 
discrim(sex /classeffects=include)
discrim(treat/classeffects=include)
discrim(stage /classeffects=include)reg(time) reg( age);
run;

proc mi data= harada.pcancer_mod nimpute=20 out=mi_new1; 
class censor sex treat stage; 
var time censor age sex treat stage; 
fcs logistic(censor= treat stage/link=glogit); 
fcs logistic(sex =treat stage /link=glogit) ; 
fcs logistic(treat =sex stage /link=glogit);
fcs logistic(stage=treat sex /link=glogit) regpmm(time age);
 
run;


/*データ欠測がないデータでの確認（本来データ）*/
proc phreg data=harada.pcancer;
class stage treat;
model time*censor(1)=stage treat age;
assess var=(age) ph /seed=4989 resample;
output out=out survival=s resmart=r ressch=rsstage rstreat rsage;run;


/*欠測 MI例*/
proc phreg data=harada.mi_fcs;
class stage treat;
model time*censor(1)=stage treat age;
assess var=(age) ph /seed=4989 resample;
output out=out survival=s resmart=r ressch=rsstage rstreat rsage;
ods output ParameterEstimates=cox_fcs; 
by _imputation_; 
run;

/*統合*/
/*Parm指定*/
PROC MIANALYZE parms(classvar=classval)=cox_fcs; 
MODELEFFECTS   stage treat age; 
RUN;


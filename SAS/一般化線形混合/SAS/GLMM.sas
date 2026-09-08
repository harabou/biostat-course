
/*************************************/
/*JMPのSAS転送ファイル書き出しの読み込み*/
/*Lib　haradaに保存して用いる*/


/* 1. XPTファイルと、保存先のデータセット名を指定します */
filename xptfile 'D:\Hsb82.xpt';

/* 2. SAS標準の変換マクロを実行します */
libname harada 'd:\harada';

/* 引数を filespec= に修正し、ファイルのパスを直接指定します */
%xpt2loc(libref=harada, filespec='D:\Hsb82.xpt');
/*************************************/



/*************************************/
/******一般混合モデル_1 学校データ*******/
/*************************************/

/*STEP1*/
PROC MIXED data=harada.hsb82 covtest noclprint ;
	Class school;
	model mach= /solution ddfm = SATTERTHWAITE;
	random intercept / sub=school;
run;

/*STEP2*/
PROC MIXED data=harada.hsb82  covtest noclprint ;
class school;
model mach = meanses/solution ddfm = bw;
random intercept / sub=school;
run;

/*STEP3*/
PROC MIXED data=harada.hsb82 covtest noclprint;
class school;
model mach = cses/solution ddfm = SATTERTHWAITE notest;
random intercept cses / sub=school type =un gcorr;
run;

/*STEP4*/
PROC MIXED data=harada.hsb82 covtest noclprint;
class school sector;
model mach = meanses cses meanses*cses sector*cses /solution ddfm = bw notest;
random intercept cses / sub=school type =un;
run;



/*************************************/
/****一般混合モデル_2 成長曲線データ*****/
/*************************************/

/* 1. XPTファイルと、保存先のデータセット名を指定します */
filename xptfile 'D:\WILLETT_.xpt';

/* 2. SAS標準の変換マクロを実行します */
libname harada 'd:\harada';

/* 引数を filespec= に修正し、ファイルのパスを直接指定します */
%xpt2loc(libref=harada, filespec='D:\WILLETT_.xpt');



/*スパゲッティプロット*/
/* IDごとに線（join）で結ぶという設定を定義（1回書けばOK） */
symbol1 i=join r=100; /* r=100 はリピート回数。IDが多ければ増やします */
proc gplot data=harada. WILLETT_;
plot y*time =id;
run;
quit;

proc sgplot data=harada.WILLETT_;
   /* group=id で被験者ごとに色分けし、series で線グラフを描きます */
   series x=time y=y / group=id;
run;


/*STEP1*/
PROC MIXED data=harada. WILLETT_ covtest noclprint;
class id;
model y=time /solution ddfm = SATTERTHWAITE notest;
random intercept time / sub=id type =un;
run;

/*STEP2*/
PROC MIXED data=harada. WILLETT_ covtest noclprint;
class id;
model y=time ccovar time*ccovar/solution ddfm = SATTERTHWAITE notest;
random intercept time / sub=id type =un gcorr;
run;

/*STEP3*/
/*CS*/
PROC MIXED data=harada. WILLETT_ covtest noclprint;
class id wave;
model y=time/s notest;
repeated wave /type =cs sub=id r;
run;

/*無構造*/
PROC MIXED data=harada. WILLETT_ covtest noclprint;
class id wave;
model y=time/s notest;
repeated wave /type =un sub=id r;
run;

/*AR*/
PROC MIXED data=harada. WILLETT_ covtest noclprint;
class id wave;
model y=time/s notest;
repeated wave /type =ar(1) sub=id r;
run;

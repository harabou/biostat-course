
/*************************************/
/*JMPのSAS転送ファイル書き出しの読み込み*/

/* 1. XPTファイルと、保存先のデータセット名を指定します */
filename xptfile  'D:\WHEEZE_S.xpt';

/* 2. SAS標準の変換マクロを実行します */
libname harada 'd:\harada';

/* 引数を filespec= に修正し、ファイルのパスを直接指定します */
%xpt2loc(libref=harada, filespec= 'D:\WHEEZE_S.xpt');
/*************************************/


/*GEE *Genmod* */
data harada.WHEEZE_S;
set harada.WHEEZE_S;
Proc Genmod DESCENDING;
Class   ID;
Model  Outcome = Age  Smoke/ dist = Binomial 
					      link = logit ;
Repeated  subject = ID   / type= AR corrw modelse ;
Run;

/*GEE*/
TITLE 'AR';
proc gee data=harada.WHEEZE_S descending;
    class ID;
    model Outcome = Age Smoke / dist=binomial link=logit;
    repeated subject=ID / type=AR(1) corrw modelse;
run;

TITLE 'exch';
proc gee data=harada.WHEEZE_S descending;
    class ID;
    model Outcome = Age Smoke / dist=binomial link=logit;
    repeated subject=ID / type=exch corrw modelse;
run;

TITLE 'CS';
proc gee data=harada.WHEEZE_S descending;
    class ID;
    model Outcome = Age Smoke / dist=binomial link=logit;
    repeated subject=ID / type=CS corrw modelse;
run;

/*野球選手の年俸を予測する*/

/*dataset作成*/
data ads;
    set sashelp.baseball;
    if cmiss(of n:, of Cr:, logSalary, Division, League) = 0;*データセットから、特定の変数に1つも空欄がないデータだけを抽出; /* 「of 接頭辞:」で特定の文字から始まる変数をすべて指定 */
    if Division="West"   then Division_West  =1; else Division_West  =0; *One-hot encoding;
    if League="American" then League_American=1; else League_American=0; *One-hot encoding;
run;



ods graphics on;

/* 1. Lasso */
proc glmselect data=ads plots=all seed=19;
    model logSalary = nAtBat nHits nHome nRuns nRBI nBB nOuts nAssts nError
                      CrAtBat CrHits CrHome CrRuns CrRbi CrBB
                      Division_West League_American
                      / selection=lasso(choose=SBC) stb;
    ods output FitStatistics = Lasso_Fit; 
run;

/* 2. Elastic Net */
proc glmselect data=ads plots=all seed=19;
    model logSalary = nAtBat nHits nHome nRuns nRBI nBB nOuts nAssts nError
                      CrAtBat CrHits CrHome CrRuns CrRbi CrBB
                      Division_West League_American
                      / selection=elasticnet(l2search=grid choose=SBC) stb;
    ods output FitStatistics = ENet_Fit; 
run;

/*3 Redge ｌ1＝0*/
/* 真のRidge：l1=0でLARのL1選択自体を無効化 */
proc glmselect data=ads plots=all seed=19;
    model logSalary = nAtBat nHits nHome nRuns nRBI nBB nOuts nAssts nError
                      CrAtBat CrHits CrHome CrRuns CrRbi CrBB
                      Division_West League_American
                      / selection=elasticnet(l1=0 l2search=grid choose=SBC) stb;
    ods output FitStatistics = Ridge_Fit;
run;



ods graphics off;


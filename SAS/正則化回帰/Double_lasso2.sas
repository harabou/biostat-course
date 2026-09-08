
/*Double Lasso*/

/* --------------------------------------------------
   手順 A: 目的変数 (logSalary) を予測する重要変数をLassoで選択
   -------------------------------------------------- */
proc glmselect data=ads;
    model logSalary = nAtBat nHome nRuns nRBI nBB nOuts nAssts nError 
                      CrAtBat CrHits CrHome CrRuns CrRbi CrBB 
                      Division_West League_American 
                      / selection=lasso(choose=SBC);
    ods output SelectedEffects = Y_effects; /* 選ばれた変数を保存 */
run;

/* --------------------------------------------------
   手順 B: 原因変数 (nHits) を予測する重要変数をLassoで選択
   -------------------------------------------------- */
proc glmselect data=ads;
    model nHits     = nAtBat nHome nRuns nRBI nBB nOuts nAssts nError 
                      CrAtBat CrHits CrHome CrRuns CrRbi CrBB 
                      Division_West League_American 
                      / selection=lasso(choose=SBC);
    ods output SelectedEffects = X_effects; /* 選ばれた変数を保存 */
run;

/* --------------------------------------------------
   手順 C: AとBで選ばれた変数を合体させる (重複は除く)
   -------------------------------------------------- */
proc sql noprint;
    select distinct effect into :final_controls separated by ' ' from 
    (select effect from Y_effects union select effect from X_effects)
    where lowcase(effect) not in ('intercept', 'nhits'); /* 割付変数自身などは除く */
quit;


/*causal graph*/
proc causalgraph method=backdoor;
    /* 1. ドメイン知識に基づく因果関係（グラフ）の定義 */
    model "Baseball_Salary_DAG"
        nAtBat ==> nHits,
        CrHits ==> nHits logSalary, /* 過去の実績は今季のヒット数にも年俸にも影響（交絡） */
        nAtBat ==> logSalary,
        League_American ==> nAtBat;

    /* 2. 評価したい因果関係（原因 ==> 結果）の指定 */
    identify nHits ==> logSalary;
run;


/* 理論（DAG）とデータ（Lasso）の知恵を融合させた最終モデル */
proc reg data=ads;
    model logSalary = nHits          /* 知りたい原因変数 */
                      CrHits nAtBat  /* DAGから「必須」と指定された変数 */
                      nRuns;         /* Lassoから「予測に重要」と選ばれた変数 */
run;
quit;



/*西地区東地区の所属が年俸に影響するかどうか*/

ods graphics on;

proc causaltrt data=ads method=IPWR; 
    /* 1. 結果変数を指定（イコールの右側は空欄にするのがIPWの基本形） */
    model logSalary = ;
    
    /* 2. 処置変数（Division_West）と、それを予測するための共変量を指定 */
    psmodel Division_West = nAtBat nHits CrAtBat CrHits League_American;
run;

ods graphics off;

/* 修正案：pre-treatmentな通算成績とリーグのみに絞る */
ods graphics on;
proc causaltrt data=ads method=IPWR att;
    model logSalary = ;
    psmodel Division_West = CrAtBat CrHits League_American;
run;
ods graphics off;


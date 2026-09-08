
/* TIMES OF REMISSION (WEEKS) OF LEUKAEMIA PATIENTS
               (GEHAN,1965,BIOMETRIKA,52,203)*/
/*slide #25-#26 SAS code*/
libname surv 'D:\';
proc format;
     value dr  0='6-MP'
                  1='CONTROL';
     value re  0='CENSORED'
                  1='EVENT';
data surv.gehan;
     input drug week remiss;
     format  drug dr. remiss re.;
     cards;
0 6 0
0 6 1
0 6 1
0 6 1
0 7 1
0 9 0
0 10 0
0 10 1
0 11 0
0 13 1
0 16 1
0 17 0
0 19 0
0 20 0
0 22 1
0 23 1
0 25 0
0 32 0
0 32 0
0 34 0
0 35 0
1 1 1
1 1 1
1 2 1
1 2 1
1 3 1
1 4 1
1 4 1
1 5 1
1 5 1
1 8 1
1 8 1
1 8 1
1 8 1
1 11 1
1 11 1
1 12 1
1 12 1
1 15 1
1 17 1
1 22 1
1 23 1
;
proc lifetest data=gehan  atrisk plots=(s(cl),lls);
    strata drug;
    time week*remiss(0);
run;



/* WEEKKS TO DEATH OF LEUKAEMIA PATIENTS AND WBC
      (FEIGL AND ZELEN,1965,BIOMETRICS,21,826)
Slide #39*/

DATA FEIGL;
     INPUT AG WBC WEEK DEATH;
     LWEEK=LOG(WEEK);
     Z1=AG;
     Z2=LOG(WBC)-9.531;
     Z3=(Z1-0.5152)*Z2;
     LABEL LWEEK='LOG(WEEK)'
           Z1='AG(TYPE)'
           Z2='STAND. LOG(WBC)'
           Z3='INTERACTION OF AG AND WBC';
     CARDS;
1 2300 65 1
1 750 156 1
1 4300 100 1
1 2600 134 1
1 6000 16 1
1 10500 108 1
1 10000 121 1
1 17000 4 1
1 5400 39 1
1 7000 143 1
1 9400 56 1
1 32000 26 1
1 35000 22 1
1 100000 1 1
1 100000 1 1
1 52000 5 1
1 100000 65 1
0 4400 56 1
0 3000 65 1
0 4000 17 1
0 1500 7 1
0 9000 16 1
0 5300 22 1
0 10000 3  1
0 19000 4 1
0 27000 2 1
0 28000 3 1
0 31000 8 1
0 26000 4 1
0 21000 3 1
0 79000 30 1
0 100000 4 1
0 100000 43 1
;
proc phreg data=feigl;
   model week*death(0)=z1 z2 z3;
run;



/*膵癌データの解析 モデルの妥当性評価 　SAS解析例　ASSESS文大橋・浜田　(1995) SASによる生存時間解析　東京大学出版会*/
/*Analysis of pancreatic cancer data Validation of the model SAS analysis example ASSESS statement
Ohashi and Hamada (1995) Survival time analysis by SAS University of Tokyo Press*/
/*Slide #44-#48  Report Q3 */

data pcancer;
input CASENO	TIME	CENSOR	 AGE	SEX	TREAT	BUI	CH	P	STAGE	PS;
cards;
1	2.4	0	66	0	0	1	4	1	4	3
2	1.7	0	69	0	0	1	4	1	4	3
3	0.1	0	48	0	0	1	1	0	3	2
4	1.0	0	73	0	0	1	4	0	3	4
5	4.8	0	65	0	0	1	4	0	4	2
6	6.4	0	38	0	0	0	4	0	3	3
7	10.8	0	62	1	0	1	4	0	3	3
9	5.1	0	59	1	0	1	1	1	4	3
10	1.1	0	53	0	0	1	1	1	4	3
11	0.5	0	70	0	0	1	1	1	4	3
12	0.8	0	71	0	0	0	3	0	4	3
14	4.0	0	61	1	0	1	4	0	4	3
15	4.0	0	69	0	0	0	4	0	3	3
16	4.0	0	41	1	0	1	4	0	4	4
17	8.5	0	49	0	0	1	4	0	3	2
18	3.6	0	56	0	0	0	4	0	3	2
19	6.9	0	59	1	0	0	4	1	3	4
20	6.2	0	53	0	0	0	3	1	4	4
21	1.0	0	72	1	0	0	3	0	4	2
22	6.2	0	57	1	0	0	3	0	3	2
23	4.3	0	49	0	0	0	3	0	4	2
24	3.1	0	74	0	0	1	4	0	3	3
25	8.3	0	43	1	1	1	4	0	4	2
26	12.7	0	60	1	1	1	4	1	3	3
28	4.9	0	55	1	1	1	4	0	3	3
30	2.7	0	70	0	1	1	3	0	3	3
33	10.6	0	63	0	1	1	1	0	3	2
35	18.2	0	69	1	1	0	4	0	3	2
36	1.4	0	66	1	1	1	1	1	4	2
37	5.8	0	58	1	1	1	1	0	4	2
38	3.0	0	67	1	1	1	1	1	4	3
39	1.5	0	74	0	1	1	1	1	4	2
40	2.4	0	77	1	1	1	1	1	3	2
41	2.0	0	70	1	1	1	4	0	3	4
42	1.1	0	75	0	1	1	4	0	4	2
43	2.5	0	65	1	1	1	2	0	3	2
44	5.4	0	71	1	1	1	4	0	3	2
45	4.4	0	50	0	1	1	1	1	4	2
46	4.8	0	56	0	1	1	3	0	3	2
47	3.1	0	68	1	1	1	1	0	3	1
48	5.6	0	65	1	1	1	3	0	3	3
49	3.1	0	65	0	1	0	3	0	3	2
50	1.3	0	43	1	1	1	3	0	3	2
51	11.5	0	83	0	1	0	3	0	3	2
53	3.8	0	65	0	1	1	2	0	3	2
54	2.9	0	63	0	1	1	1	0	4	3
55	2.2	0	47	1	1	1	2	0	4	2
56	1.7	0	75	1	1	1	2	1	4	2
58	3.5	0	63	1	1	1	1	1	4	2
62	11.3	0	54	0	1	1	2	0	3	2
63	9.0	0	56	1	1	0	4	0	4	3
64	12.5	0	50	0	1	0	1	0	3	1
65	6.8	0	62	0	1	1	1	0	3	1
66	10.8	0	53	1	1	1	1	0	3	3
67	3.0	0	63	0	1	1	1	1	4	4
68	1.8	0	59	0	1	1	4	0	4	4
69	5.0	0	66	1	1	1	4	0	4	2
70	8.0	0	62	0	1	0	3	0	3	2
71	6.8	0	72	0	1	1	1	0	3	2
72	11.1	1	54	0	1	0	3	0	3	1
73	9.4	0	68	1	1	0	3	0	3	2
74	3.9	0	63	1	1	0	4	0	3	2
75	2.1	0	68	1	1	1	2	0	3	2
76	4.3	0	48	1	1	1	4	0	3	3
77	9.3	0	68	0	1	1	1	0	4	2
78	8.8	0	75	1	1	1	1	0	4	2
79	2.4	0	49	0	1	1	1	1	4	3
80	21.6	0	62	0	1	1	1	0	4	3
81	5.6	0	56	1	1	1	1	0	4	2
83	11.4	0	56	0	1	1	1	0	3	2
84	18.3	0	59	1	1	1	1	1	4	3
85	9.2	0	59	0	1	1	1	1	3	2
86	4.5	0	48	0	1	1	2	1	3	3
87	8.2	0	64	0	1	1	2	0	3	2
88	15.0	0	60	0	1	1	4	0	3	4
89	6.9	0	75	0	1	1	1	0	4	2
90	3.5	0	46	0	1	1	1	1	4	2
91	2.1	0	53	1	1	1	1	1	4	2
92	3.1	0	62	0	1	1	3	0	3	3
93	3.2	0	47	0	1	1	3	0	4	3
94	1.9	0	62	0	1	1	1	0	4	3
95	2.1	0	55	0	1	1	1	1	3	2
96	7.0	0	80	0	1	1	1	0	4	3
;
run;


/*比例ハザード性*/
proc phreg data=pcancer;
model time*censor(1)=stage treat age;
assess var=(age) ph /seed=4989 resample;
output out=out survival=s resmart=r ressch=rsstage rstreat rsage;run;


proc phreg data=pcancer;
model time*censor(1)=stage treat age;
assess var=(age) ph /seed=4989 resample;
output out=out survival=s resmart=r ressch=rsstage rstreat rsage;run;


/*線型モデル仮定*/
proc format;
     value agec  0-<50 ='1'
					  50-<60='2'
					  60-<70='3'
					  70-100 = '4'
				 ;

ods pdf file="F:\cox.pdf";
proc phreg data=pcancer;
 	class Stage(ref='3') Treat(ref='0') age(ref='1');
	model Time*Censor(1)=Stage Treat Age;
	format age agec.;
	run;
ods pdf close;

	proc phreg data=pcancer;
model time*censor(1)=stage treat age;
assess var=(age) ph /seed=4989 resample;
output out=out survival=s resmart=r ressch=rsstage rstreat rsage;run;







/*----------------------------------------------------------*/

/* TIMES OF REMISSION (WEEKS) OF LEUKAEMIA PATIENTS
               (GEHAN,1965,BIOMETRIKA,52,203)*/
proc format;
     value dr  0='6-MP'
                  1='CONTROL';
     value re  0='CENSORED'
                  1='EVENT';
data gehan;
     input drug week remiss;
     format  drug dr. remiss re.;
     cards;
0 6 0
0 6 1
0 6 1
0 6 1
0 7 1
0 9 0
0 10 0
0 10 1
0 11 0
0 13 1
0 16 1
0 17 0
0 19 0
0 20 0
0 22 1
0 23 1
0 25 0
0 32 0
0 32 0
0 34 0
0 35 0
1 1 1
1 1 1
1 2 1
1 2 1
1 3 1
1 4 1
1 4 1
1 5 1
1 5 1
1 8 1
1 8 1
1 8 1
1 8 1
1 11 1
1 11 1
1 12 1
1 12 1
1 15 1
1 17 1
1 22 1
1 23 1
;
proc lifetest data=gehan  atrisk plots=(s(cl),lls);
    strata drug;
    time week*remiss(0);
run;

*Bone marrow trasplant data (Klein and Moeschberger (1997);

proc print data=sashelp.bmt;run;
proc lifetest data=sashelp.bmt plots=(s(cb=hw strata=panel) lls);
* hw: Hall-Wellner confidence band ;
   time t * status(0);
   strata group/adjust=tukey;
run;


* WEEKKS TO DEATH OF LEUKAEMIA PATIENTS AND WBC
      (FEIGL AND ZELEN,1965,BIOMETRICS,21,826);
DATA FEIGL;
     INPUT AG WBC WEEK DEATH;
     LWEEK=LOG(WEEK);
     Z1=AG;
     Z2=LOG(WBC)-9.531;
     Z3=(Z1-0.5152)*Z2;
     LABEL LWEEK='LOG(WEEK)'
           Z1='AG(TYPE)'
           Z2='STAND. LOG(WBC)'
           Z3='INTERACTION OF AG AND WBC';
     CARDS;
1 2300 65 1
1 750 156 1
1 4300 100 1
1 2600 134 1
1 6000 16 1
1 10500 108 1
1 10000 121 1
1 17000 4 1
1 5400 39 1
1 7000 143 1
1 9400 56 1
1 32000 26 1
1 35000 22 1
1 100000 1 1
1 100000 1 1
1 52000 5 1
1 100000 65 1
0 4400 56 1
0 3000 65 1
0 4000 17 1
0 1500 7 1
0 9000 16 1
0 5300 22 1
0 10000 3  1
0 19000 4 1
0 27000 2 1
0 28000 3 1
0 31000 8 1
0 26000 4 1
0 21000 3 1
0 79000 30 1
0 100000 4 1
0 100000 43 1
;
proc phreg data=feigl;
   model week*death(0)=z1 z2 z3;
run;



/*膵癌データの解析 モデルの妥当性評価 　ASSESS文大橋・浜田・魚住　(2016) SASによる生存時間解析　応用編　東京大学出版会*/
/*残差統計量*/
ods listing close;
proc phreg data=pcancer;
 model Time*Censor(1)= treat BUI stage;
 output out=out logsurv=LogS resdev=Dev resmart=Mart;
 run;
ods listing;
data out;set out;
 CS=-LogS;
 if ID in (72) then ID2=ID;
 else ID2=.;
 label CS="COx-Snell";
 run;
 ods graphics on;
 ods pdf file="F:\cox_c.pdf";
 proc corr data=out plots=matrix(histogram);
  var Time Mart Dev CS;
  run;
  proc sgscatter data=out;
  matrix Time Mart Dev CS; / datalabel=ID2;
  run;
ods pdf close;

/*比例ハザード性*/
proc phreg data=pcancer;
model time*censor(1)=stage treat age;
assess var=(age) ph /seed=4989 resample;
output out=out survival=s resmart=r ressch=rsstage rstreat rsage;run;


proc phreg data=pcancer;
model time*censor(1)=stage treat age;
assess var=(age) ph /seed=4989 resample;
output out=out survival=s resmart=r ressch=rsstage rstreat rsage;run;

proc format;
     value agec  0-<50 ='1'
					  50-<60='2'
					  60-<70='3'
					  70-100 = '4'
				 ;

/*線型モデル仮定*/
ods pdf file="F:\cox.pdf";
proc phreg data=pcancer;
 	class Stage(ref='3') Treat(ref='0') age(ref='1');
	model Time*Censor(1)=Stage Treat Age;
	format age agec.;
	run;
ods pdf close;

	proc phreg data=pcancer;
model time*censor(1)=stage treat age;
assess var=(age) ph /seed=4989 resample;
output out=out survival=s resmart=r ressch=rsstage rstreat rsage;run;

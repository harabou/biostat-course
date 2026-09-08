
/*Å´Å´Å´Å´Å´Å´Å´Å´Å´Å´Å´Å´Å´Å´Å´Å´Å´Å´Å´Å´Å´Å´Å´Å´Å´*/
/*Logistic regression  data=Neuralagia*/
/*Study of Analgesics for Neuralgia in the Elderly*/

Data Neuralgia;
input Treatment $ Sex $ Age Duration Pain $ @@;
datalines;
P F 68 1 No B M 74 16 No P F 67 30 No P M 66 26 Yes
B F 67 28 No B F 77 16 No A F 71 12 No B F 72 50 No
B F 76 9 Yes A M 71 17 Yes A F 63 27 No A F 69 18 Yes
B F 66 12 No A M 62 42 No P F 64 1 Yes A F 64 17 No
P M 74 4 No A F 72 25 No P M 70 1 Yes B M 66 19 No
B M 59 29 No A F 64 30 No A M 70 28 No A M 69 1 No
B F 78 1 No P M 83 1 Yes B F 69 42 No B M 75 30 Yes
P M 77 29 Yes P F 79 20 Yes A M 70 12 No A F 69 12 No
B F 65 14 No B M 70 1 No B M 67 23 No A M 76 25 Yes
P M 78 12 Yes B M 77 1 Yes B F 69 24 No P M 66 4 Yes
P F 65 29 No P M 60 26 Yes A M 78 15 Yes B M 75 21 Yes
A F 67 11 No P F 72 27 No P F 70 13 Yes A M 75 6 Yes
B F 65 7 No P F 68 27 Yes P M 68 11 Yes P M 67 17 Yes
B M 70 22 No A M 65 15 No P F 67 1 Yes A M 67 10 No
P F 72 11 Yes A F 74 1 No B M 80 21 Yes A F 69 3 No
run;

ods pdf file='F:\log.pdf';
Proc logistic PLOTS=(ODDSRATIO EFFECT)
data=neuralgia;
Class treatment sex/param=glm;
model pain=treatment;
Oddsratio treatment;
Run;
ods pdf close;

/*multiple comparison tukey case*/
ods pdf file='F:\log2.pdf';
proc logistic data=Neuralgia PLOTS=(ODDSRATIO(TYPE=HORIZONTALSTAT)); 
class treatment sex / param=glm; 
model pain= treatment sex age duration; 
lsmeans treatment/adj=tukey cl exp; /*multiple comparison tukey case*/
run; 
ods pdf close;

/*multiple comparison bonferroni case*/
ods pdf file='F:\log2.pdf';
proc logistic data=Neuralgia PLOTS=(ODDSRATIO(TYPE=HORIZONTALSTAT)); 
class treatment sex / param=glm; 
model pain= treatment sex age duration; 
lsmeans treatment/adj=bonferroni cl exp; /*multiple comparison bonferroni case*/
run; 
ods pdf close;

/*Plot Prediction Probabilities*/
ods pdf file='F:\log3.pdf';
proc logistic data=Neuralgia PLOTS=(EFFECT); 
class treatment sex / param=glm; 
model pain= treatment sex age duration; 
oddsratio treatment; 
run; 
ods pdf close;


/*Create ROC curve and compare AUC Modeldata=Neuralgia */
/*slide #25*/
ods pdf file='F:\log6.pdf';
ods graphics on;
proc logistic data=neuralgia
PLOT=ROC(ID=PROB);
Class treatment sex/param=glm;
Model pain=treatment sex age duration;
roc 'age' age;
Roc 'duration' duration;
Roccontrast reference (model)/estimate e;
Run;
ods graphics off;
ods pdf close;


/*Å´Å´Å´Å´Å´Å´Å´Å´Å´Å´Å´Å´Å´Å´Å´Å´Å´Å´Å´Å´Å´Å´Å´Å´Å´*/
/*poisson regression data=earinfection*/

Data earinfection;
input swimmer $ location $ age $ gender $  infections;
datalines;
Occas	NonBeach	15-19	Male	0
Occas	NonBeach	15-19	Male	0
Occas	NonBeach	15-19	Male	0
Occas	NonBeach	15-19	Male	0
Occas	NonBeach	15-19	Male	0
Occas	NonBeach	15-19	Male	0
Occas	NonBeach	15-19	Male	0
Occas	NonBeach	15-19	Male	0
Occas	NonBeach	15-19	Male	0
Occas	NonBeach	15-19	Male	0
Occas	NonBeach	15-19	Male	0
Occas	NonBeach	15-19	Male	1
Occas	NonBeach	15-19	Male	1
Occas	NonBeach	15-19	Male	1
Occas	NonBeach	15-19	Male	1
Occas	NonBeach	15-19	Male	1
Occas	NonBeach	15-19	Male	1
Occas	NonBeach	15-19	Male	1
Occas	NonBeach	15-19	Male	2
Occas	NonBeach	15-19	Male	2
Occas	NonBeach	15-19	Male	2
Occas	NonBeach	15-19	Male	2
Occas	NonBeach	15-19	Male	3
Occas	NonBeach	15-19	Male	3
Occas	NonBeach	15-19	Male	3
Occas	NonBeach	15-19	Male	3
Occas	NonBeach	15-19	Male	4
Occas	NonBeach	15-19	Male	4
Occas	NonBeach	15-19	Male	6
Occas	NonBeach	15-19	Male	11
Occas	NonBeach	15-19	Male	16
Occas	NonBeach	15-19	Female	0
Occas	NonBeach	15-19	Female	0
Occas	NonBeach	15-19	Female	4
Occas	NonBeach	15-19	Female	10
Occas	NonBeach	20-24	Male	0
Occas	NonBeach	20-24	Male	0
Occas	NonBeach	20-24	Male	0
Occas	NonBeach	20-24	Male	0
Occas	NonBeach	20-24	Male	1
Occas	NonBeach	20-24	Male	2
Occas	NonBeach	20-24	Male	2
Occas	NonBeach	20-24	Male	2
Occas	NonBeach	20-24	Male	3
Occas	NonBeach	20-24	Male	3
Occas	NonBeach	20-24	Male	5
Occas	NonBeach	20-24	Male	17
Occas	NonBeach	20-24	Female	0
Occas	NonBeach	20-24	Female	0
Occas	NonBeach	20-24	Female	0
Occas	NonBeach	20-24	Female	0
Occas	NonBeach	20-24	Female	0
Occas	NonBeach	20-24	Female	1
Occas	NonBeach	20-24	Female	2
Occas	NonBeach	20-24	Female	3
Occas	NonBeach	20-24	Female	3
Occas	NonBeach	20-24	Female	3
Occas	NonBeach	20-24	Female	4
Occas	NonBeach	25-29	Male	1
Occas	NonBeach	25-29	Male	1
Occas	NonBeach	25-29	Male	2
Occas	NonBeach	25-29	Male	3
Occas	NonBeach	25-29	Male	4
Occas	NonBeach	25-29	Male	4
Occas	NonBeach	25-29	Male	10
Occas	NonBeach	25-29	Female	0
Occas	NonBeach	25-29	Female	0
Occas	NonBeach	25-29	Female	2
Occas	NonBeach	25-29	Female	2
Freq	NonBeach	15-19	Male	0
Freq	NonBeach	15-19	Male	0
Freq	NonBeach	15-19	Male	0
Freq	NonBeach	15-19	Male	0
Freq	NonBeach	15-19	Male	0
Freq	NonBeach	15-19	Male	0
Freq	NonBeach	15-19	Male	0
Freq	NonBeach	15-19	Male	0
Freq	NonBeach	15-19	Male	0
Freq	NonBeach	15-19	Male	0
Freq	NonBeach	15-19	Male	0
Freq	NonBeach	15-19	Male	0
Freq	NonBeach	15-19	Male	0
Freq	NonBeach	15-19	Male	0
Freq	NonBeach	15-19	Male	0
Freq	NonBeach	15-19	Male	1
Freq	NonBeach	15-19	Male	1
Freq	NonBeach	15-19	Male	1
Freq	NonBeach	15-19	Male	2
Freq	NonBeach	15-19	Male	2
Freq	NonBeach	15-19	Male	2
Freq	NonBeach	15-19	Male	2
Freq	NonBeach	15-19	Male	2
Freq	NonBeach	15-19	Male	3
Freq	NonBeach	15-19	Male	3
Freq	NonBeach	15-19	Male	3
Freq	NonBeach	15-19	Male	3
Freq	NonBeach	15-19	Male	3
Freq	NonBeach	15-19	Male	4
Freq	NonBeach	15-19	Male	4
Freq	NonBeach	15-19	Male	4
Freq	NonBeach	15-19	Male	5
Freq	NonBeach	15-19	Female	0
Freq	NonBeach	15-19	Female	0
Freq	NonBeach	15-19	Female	0
Freq	NonBeach	15-19	Female	6
Freq	NonBeach	20-24	Male	0
Freq	NonBeach	20-24	Male	0
Freq	NonBeach	20-24	Male	0
Freq	NonBeach	20-24	Male	0
Freq	NonBeach	20-24	Male	0
Freq	NonBeach	20-24	Male	0
Freq	NonBeach	20-24	Male	0
Freq	NonBeach	20-24	Male	1
Freq	NonBeach	20-24	Male	1
Freq	NonBeach	20-24	Male	2
Freq	NonBeach	20-24	Male	2
Freq	NonBeach	20-24	Male	3
Freq	NonBeach	20-24	Male	3
Freq	NonBeach	20-24	Female	0
Freq	NonBeach	20-24	Female	0
Freq	NonBeach	20-24	Female	0
Freq	NonBeach	20-24	Female	0
Freq	NonBeach	20-24	Female	0
Freq	NonBeach	20-24	Female	1
Freq	NonBeach	20-24	Female	1
Freq	NonBeach	20-24	Female	2
Freq	NonBeach	20-24	Female	2
Freq	NonBeach	20-24	Female	3
Freq	NonBeach	25-29	Male	0
Freq	NonBeach	25-29	Male	0
Freq	NonBeach	25-29	Male	0
Freq	NonBeach	25-29	Male	0
Freq	NonBeach	25-29	Male	1
Freq	NonBeach	25-29	Male	1
Freq	NonBeach	25-29	Male	3
Freq	NonBeach	25-29	Male	3
Freq	NonBeach	25-29	Female	0
Freq	NonBeach	25-29	Female	0
Freq	NonBeach	25-29	Female	0
Freq	NonBeach	25-29	Female	1
Occas	Beach	15-19	Male	0
Occas	Beach	15-19	Male	0
Occas	Beach	15-19	Male	0
Occas	Beach	15-19	Male	0
Occas	Beach	15-19	Male	0
Occas	Beach	15-19	Male	0
Occas	Beach	15-19	Male	0
Occas	Beach	15-19	Male	0
Occas	Beach	15-19	Male	0
Occas	Beach	15-19	Male	0
Occas	Beach	15-19	Male	0
Occas	Beach	15-19	Male	1
Occas	Beach	15-19	Male	1
Occas	Beach	15-19	Male	2
Occas	Beach	15-19	Male	2
Occas	Beach	15-19	Male	3
Occas	Beach	15-19	Male	4
Occas	Beach	15-19	Male	4
Occas	Beach	15-19	Male	4
Occas	Beach	15-19	Male	9
Occas	Beach	15-19	Female	0
Occas	Beach	15-19	Female	0
Occas	Beach	15-19	Female	0
Occas	Beach	15-19	Female	0
Occas	Beach	15-19	Female	0
Occas	Beach	15-19	Female	0
Occas	Beach	15-19	Female	0
Occas	Beach	15-19	Female	0
Occas	Beach	15-19	Female	0
Occas	Beach	15-19	Female	1
Occas	Beach	15-19	Female	2
Occas	Beach	15-19	Female	3
Occas	Beach	15-19	Female	3
Occas	Beach	15-19	Female	6
Occas	Beach	15-19	Female	9
Occas	Beach	20-24	Male	0
Occas	Beach	20-24	Male	0
Occas	Beach	20-24	Male	0
Occas	Beach	20-24	Male	0
Occas	Beach	20-24	Male	0
Occas	Beach	20-24	Male	0
Occas	Beach	20-24	Male	1
Occas	Beach	20-24	Female	0
Occas	Beach	20-24	Female	0
Occas	Beach	20-24	Female	0
Occas	Beach	20-24	Female	0
Occas	Beach	20-24	Female	0
Occas	Beach	20-24	Female	1
Occas	Beach	20-24	Female	1
Occas	Beach	20-24	Female	2
Occas	Beach	20-24	Female	3
Occas	Beach	25-29	Male	0
Occas	Beach	25-29	Male	0
Occas	Beach	25-29	Male	0
Occas	Beach	25-29	Male	0
Occas	Beach	25-29	Male	0
Occas	Beach	25-29	Male	0
Occas	Beach	25-29	Male	0
Occas	Beach	25-29	Male	0
Occas	Beach	25-29	Male	0
Occas	Beach	25-29	Male	0
Occas	Beach	25-29	Male	0
Occas	Beach	25-29	Male	1
Occas	Beach	25-29	Male	1
Occas	Beach	25-29	Male	2
Occas	Beach	25-29	Male	2
Occas	Beach	25-29	Male	9
Occas	Beach	25-29	Female	0
Occas	Beach	25-29	Female	0
Occas	Beach	25-29	Female	0
Occas	Beach	25-29	Female	1
Occas	Beach	25-29	Female	3
Occas	Beach	25-29	Female	4
Occas	Beach	25-29	Female	5
Occas	Beach	25-29	Female	6
Freq	Beach	15-19	Male	0
Freq	Beach	15-19	Male	0
Freq	Beach	15-19	Male	0
Freq	Beach	15-19	Male	0
Freq	Beach	15-19	Male	0
Freq	Beach	15-19	Male	0
Freq	Beach	15-19	Male	0
Freq	Beach	15-19	Male	0
Freq	Beach	15-19	Male	0
Freq	Beach	15-19	Male	0
Freq	Beach	15-19	Male	0
Freq	Beach	15-19	Male	0
Freq	Beach	15-19	Male	1
Freq	Beach	15-19	Male	1
Freq	Beach	15-19	Male	1
Freq	Beach	15-19	Male	2
Freq	Beach	15-19	Male	2
Freq	Beach	15-19	Male	2
Freq	Beach	15-19	Male	2
Freq	Beach	15-19	Male	5
Freq	Beach	15-19	Female	0
Freq	Beach	15-19	Female	0
Freq	Beach	15-19	Female	0
Freq	Beach	15-19	Female	0
Freq	Beach	15-19	Female	0
Freq	Beach	15-19	Female	0
Freq	Beach	15-19	Female	0
Freq	Beach	15-19	Female	0
Freq	Beach	15-19	Female	1
Freq	Beach	15-19	Female	2
Freq	Beach	15-19	Female	2
Freq	Beach	15-19	Female	2
Freq	Beach	15-19	Female	3
Freq	Beach	15-19	Female	10
Freq	Beach	20-24	Male	0
Freq	Beach	20-24	Male	0
Freq	Beach	20-24	Male	0
Freq	Beach	20-24	Male	0
Freq	Beach	20-24	Male	1
Freq	Beach	20-24	Male	1
Freq	Beach	20-24	Male	5
Freq	Beach	20-24	Female	0
Freq	Beach	20-24	Female	0
Freq	Beach	20-24	Female	0
Freq	Beach	20-24	Female	0
Freq	Beach	20-24	Female	0
Freq	Beach	20-24	Female	0
Freq	Beach	20-24	Female	1
Freq	Beach	20-24	Female	1
Freq	Beach	20-24	Female	1
Freq	Beach	20-24	Female	2
Freq	Beach	25-29	Male	0
Freq	Beach	25-29	Male	0
Freq	Beach	25-29	Male	0
Freq	Beach	25-29	Male	0
Freq	Beach	25-29	Male	0
Freq	Beach	25-29	Male	0
Freq	Beach	25-29	Male	0
Freq	Beach	25-29	Male	0
Freq	Beach	25-29	Male	0
Freq	Beach	25-29	Male	0
Freq	Beach	25-29	Male	0
Freq	Beach	25-29	Male	0
Freq	Beach	25-29	Male	1
Freq	Beach	25-29	Male	2
Freq	Beach	25-29	Male	2
Freq	Beach	25-29	Female	0
Freq	Beach	25-29	Female	0
Freq	Beach	25-29	Female	0
Freq	Beach	25-29	Female	2
Freq	Beach	25-29	Female	2
Freq	Beach	25-29	Female	2
;
run;

/*Freq*/
ods pdf file='F:\pois1.pdf';;
proc freq;
table swimmer location  age  gender  infections;
run;
ods pdf close;

proc freq;
table infections*(swimmer location  age  gender);
run;


/*Poisson regression using PROV GEMOD*/
/*Factors associated with the development of ear infections*/

PROC GENMOD data=earinfection;
CLASS swimmer (param=ref ref=first)
location (param=ref ref=first)
gender (param=ref ref=last)
age (param=ref ref=last);
MODEL infections = swimmer location gender
age age*age
/ dist=poi link=log type3;
RUN;

/*Output of RR using Estimete statement */
ods pdf file='F:\pois2.pdf';;
PROC GENMOD data=earinfection;
CLASS swimmer (param=ref ref=first)
location (param=ref ref=first)
gender (param=ref ref=last)
age (param=ref ref=first);
MODEL infections = swimmer location age gender
/ dist=poi link=log type3;
ESTIMATE 'Occasional vs. Frequent swimmer'
swimmer 1 / exp;
ESTIMATE 'Non-Beach vs. Beach' location 1 / exp;   /*Designation of "exp" */
ESTIMATE 'Female vs. Male' gender 1 / exp;
ESTIMATE ' 20-24 vs. 15-19 ' age -1 1 / exp;
ESTIMATE ' 25-29 vs. 15-19 ' age -1 0/ exp;
ESTIMATE ' 25-29 vs. 20-24 ' age 0  1/ exp;
RUN;
ods pdf close;

/*Over Dispersion adjustment "pscale"*/
PROC GENMOD data=earinfection;
CLASS swimmer (param=ref ref=first)
location (param=ref ref=first)
gender (param=ref ref=last)
age (param=ref ref=first);
MODEL infections = swimmer location gender
age age*age
/ dist=poi link=log type3 pscale;           /*Designation of "pscale" */
ESTIMATE 'Occasional vs. Frequent swimmer'
swimmer 1 / exp;
ESTIMATE 'Non-Beach vs. Beach' location 1 / exp;
ESTIMATE 'Female vs. Male' gender 1 / exp;
ESTIMATE ' 20-24 vs. 15-19 ' age -1 1 / exp;
ESTIMATE ' 25-29 vs. 15-19 ' age -1 0/ exp;
ESTIMATE ' 25-29 vs. 20-24 ' age 0  1/ exp;
RUN;





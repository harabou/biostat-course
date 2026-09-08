
/*競合リスク　原因別*/
proc phreg data=cp;
class CR12 PS34;
model DaysPFS*CompRisk(0,2)=CR12 PS34 Age;

proc phreg data＝cp;
class CR12 PS34;
model DaysPFS*CompRisk(0)=CR12 PS34 Age/eventcode(cox)=1;
run;


/*競合リスク　CIF Fine&Gray*/
proc phreg data=cp;
class CR12 PS34;
model DaysPFS*CompRisk(0)=CR12 PS34 Age/eventcode(fg)=1;
run;

/*競合リスク　CIF Gray*/
proc lifetest data=cp;
time DaysPFS*CompRisk(0)/eventcode=1;
Strata CR12;
run;

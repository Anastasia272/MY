libname last '/home/u62574527/last';

data ae(KEEP=PROJECT SUBJECT SUBJECTID PROJECT PROJECTID SITENUMBER 
		DATAPAGENAME STUDYID AETERM AESER AEACN AEACNOTH_STD AEREL_STD AEACNSP AEOUT AESCONG 
		AESDISAB AESDTH AESLIFE AECONTRT AESHOSP AESMIE AESTDAT AEENDTC AESTDTC AEENDAT 
		AETOXGR);
	set last.ae;
run;

data ae (rename=(PROJECT=STUDYID DATAPAGENAME=DOMAIN AEACNSP=AERELNST 
		AETOXGR=AESEV AEACNOTH_STD=AEACNOTH AEREL_STD=AEREL));
	set ae;
run;

data AE;
	SET ae;
	SUBJID=catx('_', vvalue(SUBJECTID), vvalue(SUBJECT));
	USUBJID=catx('-', vvalue(STUDYID), vvalue(SUBJID));
run;

proc sort data=AE;
	by usubjid aeterm;
run;

data AE2;
	length USUBJID $19;
	set AE;

	IF AESTDTC=' ' THEN
		AESTDTC=AESTDAT;

	IF AEENDTC=' ' THEN
		AEENDTC=AEENDAT;

	if DOMAIN="Adverse Events" then
		DOMAIN="AE";
	drop AESTDAT AENDAT;
run;

proc sort data=AE2;
	by AESTDTC AEENDTC;
run;

data AE3;
	format A1 A2 yymmdd10.;
	length A1 8 A2 8;
	set AE2;
	A1=input(AESTDTC, date9.);
	A2=input(AEENDTC, date9.);
run;

/* aseq надо поссчитать,сделать сортировка по дате */
proc sort data=AE3;
	by SUBJID A1 A2 AETERM;
run;

data ae3;
	SET AE3;
	BY SUBJID A1 A2 AETERM;
		RETAIN ASEQ;
IF FIRST.SUBJID THEN ASEQ=1;
ELSE ASEQ=ASEQ+1;
run;

data AE4 (RENAME=(ASEQ=AESEQ));
	SET ae3;
	attrib _all_ label = " ";

	IF AESER="YES" THEN
		AESER="Y";
	else
		AESER="N";
		
	IF AECONTRT="YES" then
		AECONTRT="Y";
	ELSE
		AECONTRT="N";

run;

proc sql outobs=21;
    create table AdverseEvent as select STUDYID,DOMAIN,USUBJID,AESEQ,AETERM,AESEV,AESER,AEACN,AEACNOTH,AEREL, 
AERELNST,AEOUT,AESCONG,AESDISAB,AESDTH,AESHOSP,AESLIFE,AESMIE,AECONTRT,AESTDTC,AEENDTC  from AE4;
    run; 
    
/* DATA AE5; */
/* SET AE4; */
/* DROP A1 A2 PROJECTID SUBJECTID SUBJECT SITENUMBER AEENDAT SUBJID;RUN; */


ods rtf file= "/home/u62574527/last/Mokhovayalast.rtf";
proc report data=AE4;
column STUDYID DOMAIN USUBJID AESEQ AETERM AESEV AESER AEACN AEACNOTH AEREL 
AERELNST AEOUT AESCONG AESDISAB AESDTH AESHOSP AESLIFE AESMIE AECONTRT AESTDTC AEENDTC; 
run;
ods rtf close;


/* proc sql; */
/* 	create table task11 as SELECT distinct(AESEV), COUNT(AESEV) FROM WORK.AE4; */
/* QUIT; */

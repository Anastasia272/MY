
/* Patient Number */
/* Treatment Arm  */
/* (PLB/ BRIc-201)	 */
/* Gender	 */
/* Race/Ethnicity	 */
/* Age, years	 */
/* Height, cm/Weight, kg */


libname all "/home/u62574527/dz8";

data cm ;
length countper2 $200;
set all.hw8;
race = propcase(race);
ethnic = tranwrd(propcase(ethnic),"Or", "or");
countper1=catx('/',vvalue(height), vvalue(weight));
countper2=catx('/',vvalue(Race), vvalue(Ethnic));
run;

data cm (KEEP=SEX AGE countper1 countper2 usubjid arm);
length sex $200;
  set work.cm;
  if sex = "F" then sex = "Female";
	else sex= "Male";
  RUN;
  
data cm1;
retain USUBJID ARM sex countper2 Age countper1;
set cm;
run;
proc sort data = cm1; by usubjid; run;
data cm2 (rename=(USUBJID=col1 ARM=col2 sex=col3 countper2=col4 Age=col5 countper1=col6));
set cm1;
run;

data all;
	label col1 = "Patient Number"
		col2 = "Treatment Arm~(PLB/BRIc-201)"
		col3 = "Gender"
		col4 = "Race/Ethnicity"
		col5 = "Age,years"
		col6="Height, cm/Weight, kg";
	retain col1 col2 col3 col4 col5 col6;
	length col2 col3 col4 $200;
	set cm2;
run;
data all;
set work.all;
col5=compbl(col5);
run;

options orientation=LANDSCAPE;
ods tagsets.rtf 
        file = "/home/u62574527/dz8/HW_08.02_Mokhovaya1.rtf" 
        style =listing;

title1 "(*ESC*)S={font_weight=bold}Listing 8.2.1 (*ESC*)S={}Demographic Data and Anthropometric Measures (Modified ITT Set, n = )";
title2 " ";

proc report 
	data=all
	split = "~";

      	columns  col1 - col6; 

		define col1 / 
		style(header) = [cellwidth = 15% just = center asis =on verticalalign=middle font_weight=bold]
	    style(column) = [cellwidth = 15% just = right asis =on verticalalign=middle];

		define col2 / 
		style(header) = [cellwidth = 15% just = center asis = on verticalalign=middle font_weight=bold]
		style(column) = [cellwidth = 15% just = right asis = on verticalalign=middle];

		define col3 / 
			style(header) = [cellwidth = 15% just = center asis = on verticalalign=middle font_weight=bold]
			style(column) = [cellwidth = 15% just = right asis = on verticalalign=middle];

		define col4 / 
			style(header) = [cellwidth = 15% just = center asis = on verticalalign=middle font_weight=bold]
			style(column) = [cellwidth = 15% just = center asis = on verticalalign=middle];

		define col5 / 
			style(header) = [cellwidth = 15% just = center asis = on verticalalign=middle font_weight=bold]
			style(column) = [cellwidth = 15% just = right asis = on verticalalign=middle];
			
		define col6 / 
			style(header) = [cellwidth = 15% just = center asis = on verticalalign=middle font_weight=bold]
			style(column) = [cellwidth = 15% just = right asis = on verticalalign=middle];
		endcomp;

    run;

ods tagsets.rtf close;

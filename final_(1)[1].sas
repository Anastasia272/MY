libname lenght '/home/u62574527/задание 2711';

%macro fixleng(data=, update=no);
 %local data_upcase library_name member_name character_vars
 length_character_vars num_charvars i;

/* обрабатываем данные */
 %if &data= %then %do;
 %put NOTE: не указаны данные, закончить макрос;
 %return;
 %end;
/*  используем заглавные буквы */
 %let update=%lowcase(&update); 
 
 %let data_upcase = %upcase(&data);
 %let member_name=%scan(&data_upcase, -1, %str(.));
 %let library_name=%scan(&data_upcase, 1, %str(.));
 %if &library_name = &member_name
 %then %let library_name=WORK;
/* копируем длины */
 proc sql noprint;
 select name, length
 into :character_vars separated by ' ',
 :length_character_vars separated by ' '
 from dictionary.columns
 where libname="&library_name"
 and memname="&member_name"
 and type = "char";
 %let num_charvars=&sqlobs;
 quit;
 %if &num_charvars=0 %then %do;
 %put NOTE: нет переменных char в &data, закончить макрос;
 %return;
 %end;
 
/* обработка данных */
 data _null_;
 set &data end=last;
 array char_vars (&num_charvars) $32 &character_vars;
 array char_vars_length (&num_charvars) _temporary_
 (&length_character_vars);
 array char_vars_max_length (&num_charvars) _temporary_
 (&num_charvars*1);
 length varname $32;
 do i = 1 to dim(char_vars);
 char_vars_max_length(i) =
 max(length(char_vars(i)), char_vars_max_length(i));
 end;
 
/* сокращаем переменные */
 if last then do;
 do i = 1 to dim(char_vars) while
 (char_vars_length(i) = char_vars_max_length(i));
 end;
 if i = dim(char_vars)+1
 then put "NOTE: все переменные минимальны, завершаем макрос";
 else do;
 

 ii=0; /* поссчитаем количество */
 do i=1 to dim(char_vars);
 varname = vname(char_vars(i));
 
 /* отчет о длинах */
 if char_vars_max_length(i) = char_vars_length(i)
 then put @1 varname @34 char_vars_length(i) 5. -r
 @44 char_vars_max_length(i) 5. -r;
 else do;
 
 
  /* сокращаем текущую переменную */
 put @1 varname @34 char_vars_length(i) 5. -r
 @44 char_vars_max_length(i) 5. -r @63 "shorten";
 length_statement=cat("length ",varname," $",
 char_vars_max_length(i),";");
 rename_statement=cat("rename=(",varname,"=attr",compress(put(i, 5.)),")");
 expr_statement=cat(varname,"=attr",compress(put(i, 5.)));
 drop_statement=cat("drop attr",compress(put(i, 5.)),";");
 
 
 /* создаем макропеременные для дальшейнего сокращения */
 ii=ii+1; /* считаем количество */
 call symput("lengthtrim" || compress(put(ii,5.)),
 compbl(length_statement));
 call symput("renameattr" || compress(put(ii,5.)),
 compbl(rename_statement));
 call symput("exprattr" || compress(put(ii,5.)),
 compbl(expr_statement));
 call symput("dropattr" || compress(put(ii,5.)),
 compbl(drop_statement));
 end; /* если еще делаем*/
 end; /* dim(char_vars) */
 end; /*  dim(char_vars)+1 */
 call symputx("num_lengthtrim",ii); 
 end; 
 run;
 
 
/* отображаем датасет */
 %if &update=yes %then %do; 
	%if &num_lengthtrim ne . %then %do;
		data &data._lenght;
		%do i= 1 %to &num_lengthtrim;
			&&lengthtrim&i;
		%end;
		set
		%if &num_lengthtrim ne . %then %do;
			&data(
				%do i= 1 %to &num_lengthtrim;
					&&renameattr&i 
				%end;
			);
			%do i= 1 %to &num_lengthtrim;
				&&exprattr&i;
			%end;
			%do i= 1 %to &num_lengthtrim;
				&&dropattr&i
			%end;
		%end;
	run;
	%put NOTE: Char переменные сокращены &data;
 	%end; 
	%else %do;
	%put NOTE: Char переменные не сокращены &data;
	%end;
 %end; /* of %if &update=yes %then %do; */

 %else %do; 
 %put Data set &data not changed, DATA step statements to shrink
character variables are:;
 %put ;
 %put data &data %str(;);
 %if &num_lengthtrim ne . %then %do;
 %do i= 1 %to &num_lengthtrim;
 %put &&lengthtrim&i;
 %end;
 %end; /* end of internal %if of checking the missing macrovar num_lengthtrim */
 %put set &data %str(;);
 %put run %str(;);
 %end; /* of %else %do for %if &update=yes %then %do; */
 %mend fixleng;

 %fixleng(data=lenght.fa, update=yes);
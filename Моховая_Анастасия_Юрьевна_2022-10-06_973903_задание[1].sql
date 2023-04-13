-- ПРАКТИЧЕСКАЯ РАБОТА № 5
-- ВЫПОЛНЕННОЕ ПРАКТИЧЕСКОЕ ЗАДАНИЕ - ЭТО ФАЙЛ ФОРМАТА .SQL. 

-- ШАГ 1. ПРОСТЫЕ ВЫБОРКИ: ИЗ ОДНОЙ ТАБЛИЦЫ
-- 1.1 SELECT , LIMIT - ВЫБРАТЬ 5 ЗАПИСЕЙ ИЗ ТАБЛИЦЫ MOVIES

SELECT * FROM movies  LIMIT 5;

-- 1.2 WHERE, LIKE - ВЫБРАТЬ ИЗ ТАБЛИЦЫ LINKS ВСЁ ЗАПИСИ, У КОТОРЫХ IMDBID ОКАНЧИВАЕТСЯ НА "42", А ПОЛЕ MOVIEID МЕЖДУ 100 И 1000

select * from links where IMDBID like '%42' and MOVIEID between 100 and 1000 LIMIT 4;

-- 1.3 DESC, ORDER BY, LIMIT - ВЫБРАТЬ ТОП-5 ФИЛЬМОВ C МАКСИМАЛЬНОМ ПРИБЫЛЬЮ (прибыль: доход REVENUE-бюджет BUDGET)

select title, (REVENUE-BUDGET) as mx from movies order by (REVENUE-BUDGET) desc 
limit 5;

-- ШАГ 2. СЛОЖНЫЕ ВЫБОРКИ: ОБЪЕДИНЕНИЕ ТАБЛИЦ
-- 2.1  JOIN, DISTINCT - ВЫБРАТЬ ИЗ ТАБЛИЦЫ MOVIES УНИКАЛЬНЫЕ НАЗВАНИЯ ФИЛЬМОВ (TITLE), КОТОРЫМ СТАВИЛИ ОЦЕНКУ 5.
--  ВЫВЕСТИ ПЕРВЫЕ 5
 select DISTINCT TITLE, rating from ratings r join movies m on m.id=r.movieid where rating=5 limit 5;
 
 
 
-- ШАГ 3. АГГРЕГАЦИЯ ДАННЫХ: БАЗОВЫЕ СТАТИСТИКИ
-- 3.1 COUNT(), DISTINCT - ПОСЧИТАТЬ КОЛИЧЕСТВО ФИЛЬМОВ, КОТОРЫМ СТАВИЛИ ОЦЕНКУ 1.
select count(distinct MOVIEID) as count from ratings where RATING=1;

-- 3.2 GROUP BY, ORDER BY, COUNT() - ВЫВЕСТИ НАЗВАНИЯ ТОП-5 САМЫХ ПОПУЛЯРНЫХ ФИЛЬМОВ (TITLE) 
-- (ПОПУЛЯРНОСТЬ СЧИТАТЬ ПО КОЛИЧЕСТВУ ОЦЕНОК в таблице ratings)
!! не получается никак((
select count(RATING), title as top from ratings r join movies m on m.ID=r.MOVIEID
group by m.title
order by top
limit 5;

-- ШАГ 4. ИЕРАРХИЧЕСКИЕ ЗАПРОСЫ
-- 4.1 ПОДЗАПРОСЫ: ВЫВЕСТИ НАЗВАНИЯ И КОЛИЧЕСТВО ОЦЕНОК (ИЗ ТАБЛИЦЫ RATINGS) У ФИЛЬМОВ C МАКСИМАЛЬНЫМ СРЕДНИМ РЕЙТИНГОМ (VOTE_AVERAGE ИЗ ТАБЛИЦЫ MOVIES).

Select title, count(*) from movies mov join ratings rat ON mov.ID=rat.MOVIEID
group by title, VOTE_COUNT
order by count(*) desc;
select vote_average from movies;
select title, count(*) 
from movies mov join ratings rat on mov.ID=rat.MOVIEID
where VOTE_AVERAGE= (select max(VOTE_AVERAGE)
from movies)
group by title 
having max(VOTE_AVERAGE);
 




-- ШАГ 5. ЗАГРУЗИТЬ ФАЙЛ РАСШИРЕНИЯ *.SQL НА ПЛАТФОРМУ ODIN.
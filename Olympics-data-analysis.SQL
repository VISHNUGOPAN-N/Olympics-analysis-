create database olympics;
use olympics;
select count(*) from athletesnew;
# Data Under standing
describe athletesnew;
select * from athletesnew;
# Data cleaning
set autocommit=1;
set sql_safe_updates=0;
alter table  athletesnew rename column nationality_full to nationality;
alter table athletesnew drop  country;
alter table athletesnew rename column country_full to country;
update athletesnew set country="Türkiye" where country_code="TUR";
select * from athletesnew where country='Türkiye';
update athletesnew set nationality="Türkiye" where country='Türkiye';
update athletesnew set disciplines=substring_index(disciplines,"[",-1);
update athletesnew set disciplines=substring_index(disciplines,"]",1);
update athletesnew set events=substring_index(events, "[",-1);
update athletesnew set events=substring_index(events, "]",1);
alter table athletesnew modify birth_date date;
alter table athletesnew  drop name;
alter table athletesnew rename column name_tv to name;
alter table athletesnew modify name text after code;
alter table athletesnew rename column functions to `function`;
alter table athletesnew drop nationality_code;


# Analysis
select * from athletesnew;

select distinct(disciplines)as events,count(*) as count from athletesnew group by disciplines order by count;
select * from athletesnew where disciplines="'breaking'";

select distinct(gender), count(gender) as count from athletesnew group by gender;
select * from athletesnew order by height desc;

# How many athletes and alternate athletes are participating in 2024 Olympics?
select distinct `function`, count(*)as count from athletesnew group by `function` order by count;

# Which country has the most diverse set of disciplines?
select country ,count(distinct(disciplines)) as count from athletesnew group by country order by count desc limit 1;

# What are the top 5 disciplines with the highest number of athletes?
select disciplines, count(disciplines) as count from athletesnew group by disciplines order by count desc limit 5;

# What is the average height of athletes for each disciplines?
select disciplines, avg(height) as average_height from athletesnew group by disciplines order by average_height desc;
select * from athletesnew where disciplines= "'judo'";

# what is the average weight of the athletes for each disciplines?
select disciplines, avg(weight) as average_weight from athletesnew group by disciplines order by average_weight desc ;

# Feature enginnering

# Creating a column named "age" for upcoming analysis.
select  case when year(birth_date) then year(current_date())-year(birth_date) end as  current_age from athletesnew group by birth_date ;
alter table athletesnew add column age int;
update athletesnew set age= (case when year(birth_date) then year(current_date())-year(birth_date)end);

# What is the average age of every athlete?
select avg(age) as avg_age from athletesnew;

# How does the average age of athletes vary by gender?
select distinct(gender),avg(age) as age from athletesnew group by gender order by gender;

# Youngest athletes pardicipated and their age in each disciplines.
select distinct(disciplines),min(age) as min_age from athletesnew group by disciplines order by min_age;

# Youngest athlet in 2024 olympics
select name , min(age) as minimum_age from athletesnew group by name order by minimum_age limit 1;

####Generate a bar chart showing the number of athletes from each country.

# Top 5 most number of athletes from each country.
select country, count(name) as number_of_athletes from  athletesnew group by country order by number_of_athletes desc limit 5;

# Proportion of athletes by gender.
select gender, (count(gender)*100/(select count(*) from athletesnew)) as percentage from athletesnew group by gender;

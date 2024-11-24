select *
from lego_sets;

create table lego_sets2
like lego_sets;

insert into lego_sets2
select *
from lego_sets;

select *
from lego_sets2;

select *,
row_number() over(partition by ï»¿set_id,`name`, `year`, theme, subtheme, themeGroup, category, pieces, minifigs, agerange_min, US_retailPrice, 
bricksetURL, thumbnailURL, imageURL ) as row_num
from lego_sets2;

with duplicate_cte as
(select *,
row_number() over(partition by ï»¿set_id,`name`, `year`, theme, subtheme, themeGroup, category, pieces, minifigs, agerange_min, US_retailPrice, 
bricksetURL, thumbnailURL, imageURL ) as row_num
from lego_sets2)
select *
from duplicate_cte
where row_num > 1;

select *
from lego_sets2;

CREATE TABLE `lego_sets3` (
  `ï»¿set_id` text,
  `name` text,
  `year` int DEFAULT NULL,
  `theme` text,
  `subtheme` text,
  `themeGroup` text,
  `category` text,
  `pieces` text,
  `minifigs` text,
  `agerange_min` text,
  `US_retailPrice` text,
  `bricksetURL` text,
  `thumbnailURL` text,
  `imageURL` text,
	`row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

insert into lego_sets3
select *,
row_number() over(partition by ï»¿set_id,`name`, `year`, theme, subtheme, themeGroup, category, pieces, minifigs, agerange_min, US_retailPrice, 
bricksetURL, thumbnailURL, imageURL ) as row_num
from lego_sets2;

delete
from lego_sets3
where row_num > 1;

update lego_sets3
set 
	ï»¿set_id = trim(ï»¿set_id),
    `name` = trim(`name`),
    `year` = trim(`year`),
    theme = trim(theme),
    subtheme = trim(subtheme),
    themeGroup = trim(themeGroup),
    category = trim(category),
    pieces = trim(pieces),
    minifigs = trim(minifigs),
    agerange_min = trim(agerange_min),
    US_retailPrice = trim(US_retailPrice),
    bricksetURL = trim(bricksetURL),
    thumbnailURL = trim(thumbnailURL),
    imageURL = trim(imageURL);

alter table lego_sets3
rename column ï»¿set_id to set_id;

select *
from lego_sets3
where `name` = '(Unnamed)';

update lego_sets3
set `name` = ''
where `name` = '(Unnamed)';

update lego_sets3
set `name` = ''
where `name` = '{?}';

select trim(`name`)
from lego_sets3;

update lego_sets3
set `name` =trim(`name`);

select distinct `name`
from lego_sets3
order by 1;

select concat('$', format (US_retailPrice,2))
from lego_sets3;

update lego_sets3
set US_retailPrice = concat('$', format (US_retailPrice,2));

alter table lego_sets3
drop column row_num;

select *
from lego_sets3;










   
   



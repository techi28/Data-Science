-- *********************************
--        GLOBAL OUTLOOK        *
-- *********************************
CREATE 
OR REPLACE VIEW forestation AS 
SELECT 
  f.country_code AS code, 
  f.country_name AS name, 
  f.year AS year, 
  round(f.forest_area_sqkm, 2) AS fareakm2, 
  round(l.total_area_sq_mi * 2.59, 2) AS areakm2, 
  r.region AS region, 
  r.income_group AS incmgrp 
FROM 
  forest_area f 
  Join land_area l ON f.country_code = l.country_code 
  AND f.year = l.year 
  JOIN regions r ON l.country_code = r.country_code;
-- --------------
Select 
  name, 
  round(fareakm2, 2) as fareakm2 
From 
  forestation 
Where 
  name = 'World' 
  And year = 1990;
-- --------------
Select 
  name, 
  round(fareakm2, 2) as fareakm2 
From 
  forestation 
Where 
  name = 'World' 
  And year = 2016;
-- --------------
With sub90 as (
  Select 
    name, 
    round(fareakm2, 2) as A90 
  From 
    forestation 
  Where 
    name = 'World' 
    And year = 1990
), 
sub16 as (
  Select 
    name, 
    round(fareakm2, 2) as A16 
  From 
    forestation 
  Where 
    name = 'World' 
    And year = 2016
) 
Select 
  name, 
  round(
    Abs(A90 - A16), 
    2
  ) as Difference, 
  round(
    (
      Abs(A90 - A16) * 100 / A90
    ), 
    2
  ) as PDifference 
From 
  sub90 
  Join sub16 using(name);
-- --------------
Select 
  name, 
  round(areakm2, 2) 
From 
  forestation 
Where 
  areakm2 < 1324449 
  and YEAR = 2016 
  and name != 'world' 
Order by 
  areakm2 DESC 
LIMIT 
  1;
-- *********************************
--        REGIONAL OUTLOOK        *
-- *********************************
CREATE 
OR REPLACE VIEW Regional AS 
SELECT 
  f.year AS year, 
  r.region, 
  f.country_name as country, 
  round(
    sum(f.forest_area_sqkm), 
    2
  ) AS Tfrorest, 
  round(
    sum(l.total_area_sq_mi * 2.59), 
    2
  ) AS Tarea, 
  round(
    sum(f.forest_area_sqkm) / (
      sum(l.total_area_sq_mi)* 2.59
    )* 100, 
    2
  ) AS pcentforestarea 
FROM 
  forest_area f 
  Join land_area l ON f.country_code = l.country_code 
  AND f.year = l.year 
  JOIN regions r ON l.country_name = r.country_name 
Group by 
  1, 
  2 
Order by 
  1, 
  2;
-- --------------
Select 
  region, 
  pcentforestarea 
From 
  Regional 
Where 
  year = '2016' 
  AND region = 'World';
-- --------------
Select 
  region, 
  pcentforestarea 
From 
  Regional 
Where 
  year = '2016' 
Order by 
  pcentforestarea DESC;
-- --------------
Select 
  region, 
  pcentforestarea 
From 
  Regional 
Where 
  year = '1990' 
  AND region = 'World';
-- --------------
Select 
  region, 
  pcentforestarea 
From 
  Regional 
Where 
  year = '1990' 
Order by 
  pcentforestarea DESC;
-- --------------
-- *********************************
--       COUNTRY OUTLOOK       *
-- *********************************
With con90 as (
  Select 
    f.country_code, 
    f.country_name, 
    f.year, 
    f.forest_area_sqkm as A90 
  From 
    forest_area f 
  Where 
    f.year = '1990' 
    AND f.forest_area_sqkm IS NOT NULL 
    AND f.country_name != 'World'
), 
con16 as (
  Select 
    f.country_code, 
    f.country_name, 
    f.year, 
    f.forest_area_sqkm as A16 
  From 
    forest_area f 
  Where 
    f.year = '2016' 
    AND f.forest_area_sqkm IS NOT NULL 
    AND f.country_name != 'World'
) 
Select 
  con16.country_name, 
  r.region, 
  con90.A90 as area90, 
  con16.A16 as area16, 
  round(
    (con90.A90 - con16.A16), 
    2
  ) as Difference, 
  round(
    (
      Abs(con90.A90 - con16.A16) * 100 / con90.A90
    ), 
    2
  ) as PDifference 
From 
  con90 
  Join con16 on con90.country_code = con16.country_code 
  Join regions r on con16.country_code = r.country_code 
Order by 
  Difference;
-- --------------
With con90 as (
  Select 
    f.country_code, 
    f.country_name, 
    f.year, 
    f.forest_area_sqkm as A90 
  From 
    forest_area f 
  Where 
    f.year = '1990' 
    AND f.forest_area_sqkm IS NOT NULL 
    AND f.country_name != 'World'
), 
con16 as (
  Select 
    f.country_code, 
    f.country_name, 
    f.year, 
    f.forest_area_sqkm as A16 
  From 
    forest_area f 
  Where 
    f.year = '2016' 
    AND f.forest_area_sqkm IS NOT NULL 
    AND f.country_name != 'World'
) 
Select 
  con16.country_name, 
  r.region, 
  con90.A90 as area90, 
  con16.A16 as area16, 
  round(
    (con90.A90 - con16.A16), 
    2
  ) as Difference, 
  round(
    (
      Abs(con90.A90 - con16.A16) * 100 / con90.A90
    ), 
    2
  ) as PDifference 
From 
  con90 
  Join con16 on con90.country_code = con16.country_code 
  Join regions r on con16.country_code = r.country_code 
Order by 
  PDifference DESC 
LIMIT 
  5;
-- --------------
With con90 as (
  Select 
    f.country_code, 
    f.country_name, 
    f.year, 
    f.forest_area_sqkm as A90 
  From 
    forest_area f 
  Where 
    f.year = '1990' 
    AND f.forest_area_sqkm IS NOT NULL 
    AND f.country_name != 'World'
), 
con16 as (
  Select 
    f.country_code, 
    f.country_name, 
    f.year, 
    f.forest_area_sqkm as A16 
  From 
    forest_area f 
  Where 
    f.year = '2016' 
    AND f.forest_area_sqkm IS NOT NULL 
    AND f.country_name != 'World'
) 
Select 
  con16.country_name, 
  r.region, 
  con90.A90 as area90, 
  con16.A16 as area16, 
  round(
    (con90.A90 - con16.A16), 
    2
  ) as Difference, 
  round(
    (
      Abs(con90.A90 - con16.A16) * 100 / con90.A90
    ), 
    2
  ) as PDifference 
From 
  con90 
  Join con16 on con90.country_code = con16.country_code 
  Join regions r on con16.country_code = r.country_code 
Order by 
  Difference DESC 
LIMIT 
  5;
-- --------------
With con90 as (
  Select 
    f.country_code, 
    f.country_name, 
    f.year, 
    f.forest_area_sqkm as A90 
  From 
    forest_area f 
  Where 
    f.year = '1990' 
    AND f.forest_area_sqkm IS NOT NULL 
    AND f.country_name != 'World'
), 
con16 as (
  Select 
    f.country_code, 
    f.country_name, 
    f.year, 
    f.forest_area_sqkm as A16 
  From 
    forest_area f 
  Where 
    f.year = '2016' 
    AND f.forest_area_sqkm != 0 
    AND f.country_name != 'World'
) 
Select 
  con16.country_name, 
  r.region, 
  round(con90.A90, 2) as area90, 
  round(con16.A16, 2) as area16, 
  round(
    (con90.A90 - con16.A16), 
    2
  ) as Difference, 
  round(
    (
      (con16.A16 - con90.A90) / con90.A90 * 100
    ), 
    2
  ) as PDifference 
From 
  con90 
  Join con16 on con90.country_code = con16.country_code 
  AND (
    con90.A90 != 0 
    AND con16.A16 != 0
  ) 
  Join regions r on con16.country_code = r.country_code 
Order by 
  6 
LIMIT 
  5;
-- *********************************
--       Quartile OUTLOOK       *
-- *********************************
With Tab1 as (
  Select 
    f.country_code AS code, 
    f.country_name AS name, 
    f.year AS year, 
    round(f.forest_area_sqkm, 2) AS fareakm2, 
    round(l.total_area_sq_mi * 2.59, 2) AS areakm2, 
    r.region AS region, 
    r.income_group AS incmgrp 
  FROM 
    forest_area f 
    Join land_area l ON f.country_code = l.country_code 
    AND f.year = l.year 
    JOIN regions r ON l.country_code = r.country_code 
  Where 
    f.country_name != 'World' 
    And f.year = '2016' 
    and f.forest_area_sqkm != 0
), 
Tab2 as (
  Select 
    name, 
    region, 
    fareakm2, 
    areakm2, 
    round(
      cast(
        (fareakm2 * 100 / areakm2) as float
      ), 
      2
    ) AS pcentfarea, 
    CASE When round(
      cast(
        (fareakm2 * 100 / areakm2) as float
      ), 
      2
    ) >= 75 THEN 4 WHEN round(
      cast(
        (fareakm2 * 100 / areakm2) as float
      ), 
      2
    ) <= 75 
    AND round(
      cast(
        (fareakm2 * 100 / areakm2) as float
      ), 
      2
    ) >= 50 THEN 3 WHEN round(
      cast(
        (fareakm2 * 100 / areakm2) as float
      ), 
      2
    ) <= 50 
    AND round(
      cast(
        (fareakm2 * 100 / areakm2) as float
      ), 
      2
    ) >= 25 THEN 2 ELSE 1 END as QUARTILE 
  From 
    Tab1 
  Where 
    name != 'World' 
    AND year = '2016' 
    and fareakm2 != 0 
  ORDER BY 
    QUARTILE
) 
Select 
  tab2.QUARTILE, 
  count(tab2.QUARTILE) 
From 
  tab2 
GROUP BY 
  1 
order by 
  1;
-- --------------
With Tab1 as (
  Select 
    f.country_code AS code, 
    f.country_name AS name, 
    f.year AS year, 
    round(f.forest_area_sqkm, 2) AS fareakm2, 
    round(l.total_area_sq_mi * 2.59, 2) AS areakm2, 
    r.region AS region, 
    r.income_group AS incmgrp 
  FROM 
    forest_area f 
    Join land_area l ON f.country_code = l.country_code 
    AND f.year = l.year 
    JOIN regions r ON l.country_code = r.country_code 
  Where 
    f.country_name != 'World' 
    And f.year = '2016' 
    and f.forest_area_sqkm != 0
), 
Tab2 as (
  Select 
    name, 
    region, 
    fareakm2, 
    areakm2, 
    round(
      cast(
        (fareakm2 * 100 / areakm2) as float
      ), 
      2
    ) AS pcentfarea, 
    CASE When round(
      cast(
        (fareakm2 * 100 / areakm2) as float
      ), 
      2
    ) >= 75 THEN 4 WHEN round(
      cast(
        (fareakm2 * 100 / areakm2) as float
      ), 
      2
    ) <= 75 
    AND round(
      cast(
        (fareakm2 * 100 / areakm2) as float
      ), 
      2
    ) >= 50 THEN 3 WHEN round(
      cast(
        (fareakm2 * 100 / areakm2) as float
      ), 
      2
    ) <= 50 
    AND round(
      cast(
        (fareakm2 * 100 / areakm2) as float
      ), 
      2
    ) >= 25 THEN 2 ELSE 1 END as QUARTILE 
  From 
    Tab1 
  Where 
    name != 'World' 
    AND year = '2016' 
    and fareakm2 != 0 
  ORDER BY 
    QUARTILE
) 
Select 
  name, 
  region, 
  pcentfarea, 
  tab2.QUARTILE 
From 
  tab2 
Where 
  Quartile = 4 
order by 
  3;
-- *********************************
--    HOW MANY COUNTRIES ABOVE USA *
-- *********************************
With Tab1 as (
  Select 
    f.country_code AS code, 
    f.country_name AS name, 
    f.year AS year, 
    round(f.forest_area_sqkm, 2) AS fareakm2, 
    round(l.total_area_sq_mi * 2.59, 2) AS areakm2, 
    r.region AS region, 
    r.income_group AS incmgrp 
  FROM 
    forest_area f 
    Join land_area l ON f.country_code = l.country_code 
    AND f.year = l.year 
    JOIN regions r ON l.country_code = r.country_code 
  Where 
    f.country_name != 'World' 
    And f.year = '2016' 
    and f.forest_area_sqkm != 0
), 
Tab2 as (
  Select 
    name, 
    region, 
    fareakm2, 
    areakm2, 
    round(
      cast(
        (fareakm2 * 100 / areakm2) as float
      ), 
      2
    ) AS pcentfarea, 
    CASE When round(
      cast(
        (fareakm2 * 100 / areakm2) as float
      ), 
      2
    ) >= 75 THEN 4 WHEN round(
      cast(
        (fareakm2 * 100 / areakm2) as float
      ), 
      2
    ) <= 75 
    AND round(
      cast(
        (fareakm2 * 100 / areakm2) as float
      ), 
      2
    ) >= 50 THEN 3 WHEN round(
      cast(
        (fareakm2 * 100 / areakm2) as float
      ), 
      2
    ) <= 50 
    AND round(
      cast(
        (fareakm2 * 100 / areakm2) as float
      ), 
      2
    ) >= 25 THEN 2 ELSE 1 END as QUARTILE 
  From 
    Tab1 
  Where 
    name != 'World' 
    AND year = '2016' 
    and fareakm2 != 0 
  ORDER BY 
    QUARTILE
) 
Select 
  count(name) 
From 
  tab2 
Where 
  pcentfarea > (
    Select 
      pcentfarea 
    From 
      tab2 
    Where 
      tab2.name = 'United States'
  );
-- -------------------------------------------------
With Tab1 as (
  Select 
    f.country_code AS code, 
    f.country_name AS name, 
    f.year AS year, 
    round(f.forest_area_sqkm, 2) AS fareakm2, 
    round(l.total_area_sq_mi * 2.59, 2) AS areakm2, 
    r.region AS region, 
    r.income_group AS incmgrp 
  FROM 
    forest_area f 
    Join land_area l ON f.country_code = l.country_code 
    AND f.year = l.year 
    JOIN regions r ON l.country_code = r.country_code 
  Where 
    f.country_name != 'World' 
    And f.year = '2016' 
    and f.forest_area_sqkm != 0
), 
Tab2 as (
  Select 
    name, 
    region, 
    fareakm2, 
    areakm2, 
    round(
      cast(
        (fareakm2 * 100 / areakm2) as float
      ), 
      2
    ) AS pcentfarea, 
    CASE When round( cast( (fareakm2 * 100 / areakm2) as float), 2
    ) >= 75 THEN 4 WHEN round(
      cast(
        (fareakm2 * 100 / areakm2) as float
      ), 
      2
    ) <= 75 
    AND round(
      cast(
        (fareakm2 * 100 / areakm2) as float
      ), 
      2
    ) >= 50 THEN 3 WHEN round(
      cast(
        (fareakm2 * 100 / areakm2) as float
      ), 
      2
    ) <= 50 
    AND round(
      cast(
        (fareakm2 * 100 / areakm2) as float
      ), 
      2
    ) >= 25 THEN 2 ELSE 1 END as QUARTILE 
  From 
    Tab1 
  Where 
    name != 'World' 
    AND year = '2016' 
    and fareakm2 != 0 
  ORDER BY 
    QUARTILE
) 
Select 
  count(name) 
From 
  tab2 
Where 
  pcentfarea > (
    Select 
      pcentfarea 
    From 
      tab2 
    Where 
      tab2.name = 'United States'
  );
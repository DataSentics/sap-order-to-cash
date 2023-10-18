-- Copyright 2022 Google LLC
-- Copyright 2023 DataSentics
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     https://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.

with calendar_date_dim AS (
    SELECT
        dt.col AS Date,
        CAST(date_format(dt.col, 'yyyyMMdd') AS BIGINT) AS DateInt,
        date_format(dt.col, 'yyyyMMdd') AS DateStr,
        date_format(dt.col, 'yyyy-MM-dd') AS DateStr2,
        EXTRACT(YEAR FROM dt.col) AS CalYear,
        IF(EXTRACT(QUARTER FROM dt.col) IN (1, 2), 1, 2) AS CalSemester,
        EXTRACT(QUARTER FROM dt.col) AS CalQuarter,
        EXTRACT(MONTH FROM dt.col) AS CalMonth,
        EXTRACT(WEEK FROM dt.col) AS CalWeek,
        CAST(EXTRACT(YEAR FROM dt.col) AS STRING) AS CalYearStr,
        IF(EXTRACT(QUARTER FROM dt.col) IN (1, 2), '01', '02') AS CalSemesterStr,
        IF(EXTRACT(QUARTER FROM dt.col) IN (1, 2), 'S1', 'S2') AS CalSemesterStr2,
        '0' || EXTRACT(QUARTER FROM dt.col) AS CalQuarterStr,
        'Q' || EXTRACT(QUARTER FROM dt.col) AS CalQuarterStr2,
        date_format(dt.col, 'MMMM') AS CalMonthLongStr,
        date_format(dt.col, 'MMM') AS CalMonthShortStr,
        '0' || (EXTRACT(WEEK FROM dt.col)) AS CalWeekStr,
        date_format(dt.col, 'EEEE') AS DayNameLong,
        date_format(dt.col, 'EEE') AS DayNameShort,
        EXTRACT(DAYOFWEEK FROM dt.col) AS DayOfWeek,
        dayofmonth(dt.col) AS DayOfMonth,
        DATE_DIFF(DAY, dt.col, DATE_TRUNC('QUARTER', dt.col)) + 1 AS DayOfQuarter,
        IF(
            EXTRACT(QUARTER FROM dt.col) IN (1, 2),
            dayofyear(dt.col),
            IF(
            EXTRACT(QUARTER FROM dt.col) = 3,
            dayofyear(dt.col) - dayofyear(DATE_SUB(DATE_TRUNC('QUARTER', dt.col), 1)),
            dayofyear(dt.col) - dayofyear(DATE_TRUNC('QUARTER', dt.col - INTERVAL '3' MONTH))
            )
        ) AS DayOfSemester,
        dayofyear(dt.col) AS DayOfYear,
        IF(
            EXTRACT(QUARTER FROM dt.col) IN (1, 2),
            EXTRACT(YEAR FROM dt.col) || 'S1',
            EXTRACT(YEAR FROM dt.col) || 'S2'
        ) AS YearSemester,
        EXTRACT(YEAR FROM dt.col) || 'Q' || EXTRACT(QUARTER FROM dt.col) AS YearQuarter,
        CAST(date_format(dt.col, 'yyyyMM') AS STRING) AS YearMonth,
        EXTRACT(YEAR FROM dt.col) || ' ' || date_format(dt.col, 'MMM') AS YearMonth2,
        concat(date_format(dt.col, 'yyyy'), lpad(weekofyear(dt.col), 2, '0')) AS YearWeek,
        (DATE_TRUNC('YEAR', dt.col) = dt.col) AS IsFirstDayOfYear,
        ((DATE_TRUNC('YEAR', dt.col) + INTERVAL '1' YEAR ) - INTERVAL 1 DAY = dt.col) AS IsLastDayOfYear,
        (EXTRACT(MONTH FROM dt.col) IN (1, 7) AND EXTRACT(DAY FROM dt.col) = 1) AS IsFirstDayOfSemester,
        ((EXTRACT(MONTH FROM dt.col) IN (6) AND EXTRACT(DAY FROM dt.col) IN (30))
            OR (EXTRACT(MONTH FROM dt.col) IN (12) AND EXTRACT(DAY FROM dt.col) IN (31))) AS IsLastDayOfSemester,
        (DATE_TRUNC('QUARTER', dt.col) = dt.col) AS IsFirstDayOfQuarter,
        ((DATE_TRUNC('QUARTER', dt.col) + INTERVAL '3' MONTH) - INTERVAL 1 DAY = dt.col) AS IsLastDayOfQuarter,
        (DATE_TRUNC('MONTH', dt.col) = dt.col) AS IsFirstDayOfMonth,
        (LAST_DAY(dt.col) = dt.col) AS IsLastDayOfMonth,
        (DATE_TRUNC('WEEK', dt.col) = dt.col) AS IsFirstDayOfWeek,
        (DATE_TRUNC('WEEK', dt.col) + INTERVAL 6 DAY = dt.col) AS IsLastDayOfWeek,
        ((MOD(EXTRACT(YEAR FROM dt.col), 4) = 0 AND MOD(EXTRACT(YEAR FROM dt.col), 100) != 0)
            OR MOD(EXTRACT(YEAR FROM dt.col), 400) = 0) AS IsLeapYear,
        (date_format(dt.col, 'EEEE') NOT IN ('Saturday', 'Sunday')) AS IsWeekDay,
        (date_format(dt.col, 'EEEE') IN ('Saturday', 'Sunday')) AS IsWeekEnd,
        (DATE_TRUNC('WEEK', dt.col)) AS WeekStartDate,
        (DATE_TRUNC('WEEK', dt.col) + INTERVAL 6 DAY) AS WeekEndDate,
        (DATE_TRUNC('MONTH',  dt.col)) AS MonthStartDate,
        (LAST_DAY(dt.col)) AS MonthEndDate,
        (weekofyear((DATE_TRUNC('YEAR', dt.col) + INTERVAL '1' YEAR ) - INTERVAL 1 DAY) = 53) AS Has53Weeks
    FROM explode(
        sequence(
        DATE_TRUNC('YEAR', CURRENT_DATE()) - INTERVAL '20' YEAR,
        LAST_DAY(CURRENT_DATE()) + INTERVAL '20' YEAR,
        INTERVAL 1 DAY)
    ) as dt
)

SELECT * FROM calendar_date_dim
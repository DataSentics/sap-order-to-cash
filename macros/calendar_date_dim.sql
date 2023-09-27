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

{% macro create_date_dim_table() %}
    CREATE TABLE IF NOT EXISTS calendar_date_dim(
        Date DATE,
        DateInt BIGINT,
        DateStr STRING,
        DateStr2 STRING,
        CalYear BIGINT,
        CalSemester BIGINT,
        CalQuarter BIGINT,
        CalMonth BIGINT,
        CalWeek BIGINT,
        CalYearStr STRING,
        CalSemesterStr STRING,
        CalSemesterStr2 STRING,
        CalQuarterStr STRING,
        CalQuarterStr2 STRING,
        CalMonthLongStr STRING,
        CalMonthShortStr STRING,
        CalWeekStr STRING,
        DayNameLong STRING,
        DayNameShort STRING,
        DayOfWeek BIGINT,
        DayOfMonth BIGINT,
        DayOfQuarter BIGINT,
        DayOfSemester BIGINT,
        DayOfYear BIGINT,
        YearSemester STRING,
        YearQuarter STRING,
        YearMonth STRING,
        YearMonth2 STRING,
        YearWeek STRING,
        IsFirstDayOfYear BOOLEAN,
        IsLastDayOfYear BOOLEAN,
        IsFirstDayOfSemester BOOLEAN,
        IsLastDayOfSemester BOOLEAN,
        IsFirstDayOfQuarter BOOLEAN,
        IsLastDayOfQuarter BOOLEAN,
        IsFirstDayOfMonth BOOLEAN,
        IsLastDayOfMonth BOOLEAN,
        IsFirstDayOfWeek BOOLEAN,
        IsLastDayOfWeek BOOLEAN,
        IsLeapYear BOOLEAN,
        IsWeekDay BOOLEAN,
        IsWeekEnd BOOLEAN,
        WeekStartDate DATE,
        WeekEndDate DATE,
        MonthStartDate DATE,
        MonthEndDate DATE,
        Has53Weeks BOOLEAN
    )
{% endmacro %}
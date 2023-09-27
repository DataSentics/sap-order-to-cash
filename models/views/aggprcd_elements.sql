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

with aggprcd_elements AS (
    SELECT
        PRCD_ELEMENTS.KNUMV,
        PRCD_ELEMENTS.KPOSN,
        PRCD_ELEMENTS.CLIENT,
        SUM(IF(TRIM(PRCD_ELEMENTS.KRECH) = 'C' AND PRCD_ELEMENTS.KOAID = 'B' AND PRCD_ELEMENTS.KINAK IS NULL, PRCD_ELEMENTS.KWERT, NULL)) AS ListPrice,
        SUM(IF(TRIM(PRCD_ELEMENTS.KRECH) = 'C' AND PRCD_ELEMENTS.KOAID = 'B' AND PRCD_ELEMENTS.KSCHL = 'PB00', PRCD_ELEMENTS.KWERT, NULL)) AS AdjustedPrice,
        SUM(IF(PRCD_ELEMENTS.KOAID = 'A' AND PRCD_ELEMENTS.KINAK IS NULL, PRCD_ELEMENTS.KWERT, NULL)) AS Discount,
        SUM(IF(PRCD_ELEMENTS.KFKIV = 'X' AND PRCD_ELEMENTS.KOAID = 'B' AND PRCD_ELEMENTS.KINAK IS NULL, PRCD_ELEMENTS.KWERT, NULL)) AS InterCompanyPrice
    FROM
        {{ source("source_db", "prcd_elements") }} AS PRCD_ELEMENTS
    GROUP BY PRCD_ELEMENTS.KNUMV, PRCD_ELEMENTS.KPOSN, PRCD_ELEMENTS.CLIENT
)

SELECT * FROM aggprcd_elements

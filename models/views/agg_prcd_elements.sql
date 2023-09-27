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

with agg_prds_elements AS (
    SELECT
        Prcd_Elements.knumv AS Knumv,
        Prcd_Elements.kposn AS Kposn,
        SUM(IF(Prcd_Elements.koaid = 'C' AND Prcd_Elements.kinak IS NULL, Prcd_Elements.kwert, NULL )) AS Rebate
    FROM
        {{ source("source_db", "prcd_elements") }} AS Prcd_Elements
    GROUP BY Knumv, Kposn
)

SELECT * FROM agg_prds_elements

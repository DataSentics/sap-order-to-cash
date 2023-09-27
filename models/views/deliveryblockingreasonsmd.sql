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

with delivery_blocking_reasons AS (
    SELECT
        TVLST.MANDT AS Client_MANDT,
        TVLST.SPRAS AS LanguageKey_SPRAS,
        TVLST.LIFSP AS DefaultDeliveryBlock_LIFSP,
        TVLST.VTEXT AS DeliveryBlockReason_VTEXT
    FROM {{ source("source_db", "tvlst") }} AS TVLST
)

SELECT * FROM delivery_blocking_reasons

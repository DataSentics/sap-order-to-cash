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

with one_touch_order AS (
    SELECT DISTINCT
        OneTouchOrder.VBAPClient_MANDT,
        OneTouchOrder.VBAPSalesDocument_VBELN,
        OneTouchOrder.VBAPSalesDocument_Item_POSNR,
        OneTouchOrder.VBAPTotalOrder_KWMENG,
        vbrp.FKIMG AS ActualBilledQuantity_FKIMG,
        OneTouchOrder.OneTouchOrderCount
    FROM
        (
        SELECT
            vbap.MANDT AS VBAPClient_MANDT,
            vbap.VBELN AS VBAPSalesDocument_VBELN,
            vbap.POSNR AS VBAPSalesDocument_Item_POSNR,
            vbap.KWMENG AS VBAPTotalOrder_KWMENG,
            vbap.NETWR AS VBAPNetValueOfTheOrderItemInDocumentCurrency_NETWR,
            -- vbap.RECORDSTAMP AS VBAPRecordTimeStamp,
            vbep.MANDT AS VBEPClient_MANDT,
            vbep.VBELN AS VBEPSalesDocument_VBELN,
            vbep.POSNR AS VBEPSalesDocumentItem_POSNR,
            vbep.ETENR AS VBEPScheduleLineNumber_ETENR,
            vbep.BMENG AS VBEPConfirmedQuantity_BMENG,
            lips.MANDT AS LIPSClient_MANDT,
            lips.VBELN AS LIPSDelivery_VBELN,
            lips.POSNR AS LIPSDeliveryItem_POSNR,
            lips.ERDAT AS LIPSCreationDate_ERDAT,
            lips.AEDAT AS LIPSDateOfLastChange_AEDAT,
            -- lips.RECORDSTAMP AS LIPSRecordTimeStamp,
            COUNT(*) AS OneTouchOrderCount
        FROM
            {{ source("source_db", "vbap") }} AS vbap,
            {{ source("source_db", "vbep") }} AS vbep,
            {{ source("source_db", "lips") }} AS lips
        WHERE
            vbap.mandt = vbep.mandt
            AND vbap.vbeln = vbep.vbeln
            AND vbap.posnr = vbep.posnr
            AND vbap.mandt = lips.mandt
            AND vbap.vbeln = lips.vgbel
            AND vbap.posnr = lips.vgpos
        GROUP BY
            vbap.mandt,
            vbap.vbeln,
            vbap.posnr,
            vbap.kwmeng,
            vbap.netwr,
            -- vbap.recordstamp,
            vbep.mandt,
            vbep.vbeln,
            vbep.posnr,
            vbep.etenr,
            vbep.bmeng,
            lips.mandt,
            lips.vbeln,
            lips.posnr,
            lips.erdat,
            lips.aedat 
            -- lips.recordstamp
        HAVING
            COUNT(*) < 2 ) AS OneTouchOrder
    INNER JOIN
        {{ source("source_db", "vbrp") }} AS vbrp
        ON
        OneTouchOrder.VBAPClient_MANDT = vbrp.mandt
        AND OneTouchOrder.VBAPSalesDocument_VBELN = vbrp.aubel
        AND OneTouchOrder.VBAPSalesDocument_Item_POSNR = vbrp.posnr
    WHERE
        OneTouchOrder.VBAPTotalOrder_KWMENG = vbrp.fkimg
)

SELECT * FROM one_touch_order

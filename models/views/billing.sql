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

{{ config(
    pre_hook=[create_date_dim_table()]
) }}

with billing AS (
    SELECT
        VBRK.MANDT AS Client_MANDT,
        VBRK.FKART AS BillingType_FKART,
        VBRK.FKTYP AS BillingCategory_FKTYP,
        VBRK.VKORG AS SalesOrganization_VKORG,
        VBRK.VTWEG AS DistributionChannel_VTWEG,
        VBRK.SPART AS Division_SPART,
        VBRK.VBTYP AS SDDocumentCategory_VBTYP,
        VBRK.BZIRK AS SalesDistrict_BZIRK,
        VBRK.PLTYP AS PriceListType_PLTYP,
        VBRK.FKSTO AS BillingDocumentIsCancelled_FKSTO,
        VBRK.KUNRG AS Payer_KUNRG,
        VBRK.INCO1 AS IncotermsPart1_INCO1,
        VBRK.INCO2 AS IncotermsPart2_INCO2,
        VBRK.LAND1 AS DestinationCountry_LAND1,
        VBRK.REGIO AS Region_REGIO,
        VBRK.COUNC AS CountryCode_COUNC,
        VBRK.CITYC AS CityCode_CITYC,
        VBRK.TAXK1 AS TaxClassification1ForCustomer_TAXK1,
        VBRK.TAXK2 AS TaxClassification2ForCustomer_TAXK2,
        VBRK.TAXK3 AS TaxClassification3ForCustomer_TAXK3,
        VBRK.TAXK4 AS TaxClassification4ForCustomer_TAXK4,
        VBRK.TAXK5 AS TaxClassification5ForCustomer_TAXK5,
        VBRK.LANDTX AS TaxDepartureCountry_LANDTX,
        VBRK.STCEG_H AS OriginOfSalesTaxIDNumber_STCEG_H,
        VBRK.STCEG_L AS CountryOfSalesTaxIDNumber_STCEG_L,
        VBRK.XBLNR AS ReferenceDocumentNumber_XBLNR,
        VBRK.KONDA AS CustomerPriceGroup_KONDA,
        VBRK.RFBSK AS StatusForTransferToAccounting_RFBSK,
        VBRK.FKDAT AS BillingDate_FKDAT,
        VBRK.GJAHR AS FiscalYear_GJAHR,
        VBRK.POPER AS PostingPeriod_POPER,
        VBRK.ERDAT AS RecordCreationDate_ERDAT,
        VBRK.AEDAT AS LastChangeDate_AEDAT,
        VBRK.KDGRP AS CustomerGroup_KDGRP,
        VBRK.ZLSCH AS PaymentMethod_ZLSCH,
        VBRK.BUKRS AS CompanyCode_BUKRS,
        VBRK.MSCHL AS DunningKey_MSCHL,
        VBRK.MANSP AS DunningBlock_MANSP,
        VBRK.KUNAG AS SoldToParty_KUNAG,
        VBRK.FKART_AB AS AccrualBillingType_FKART,
        VBRK.BELNR AS AccountingDocumentNumber_BELNR,
        VBRK.VSBED AS ShippingConditions_VSBED,
        VBRK.WAERK AS SdDocumentCurrency_WAERK,
        VBRP.GSBER AS BusinessArea_GSBER,
        VBRP.VBELN AS BillingDocument_VBELN,
        VBRP.POSNR AS BillingItem_POSNR,
        VBRP.PSTYV AS SalesDocumentItemCategory_PSTYV,
        VBRP.POSAR AS ItemType_POSAR,
        VBRP.KOSTL AS CostCenter_KOSTL,
        VBRP.VKGRP AS SalesGroup_VKGRP,
        VBRP.VKBUR AS SalesOffice_VKBUR,
        VBRP.PRCTR AS ProfitCenter_PRCTR,
        VBRP.KOKRS AS ControllingArea_KOKRS,
        VBRP.VGTYP AS DocumentCategoryOfPrecedingSDDocument_VGTYP,
        VBRP.MATNR AS MaterialNumber_MATNR,
        VBRP.PMATN AS PricingReferenceMaterial_PMATN,
        VBRP.CHARG AS BatchNumber_CHARG,
        VBRP.MATKL AS MaterialGroup_MATKL,
        VBRP.PRODH AS ProductHierarchy_PRODH,
        VBRP.WERKS AS Plant_WERKS,
        VBRP.KONDM AS MaterialPriceGroup_KONDM,
        VBRP.LGORT AS StorageLocation_LGORT,
        VBRP.EAN11 AS InternationalArticleNumber_EAN11,
        VBRP.MVGR1 AS MaterialGroup1_MVGR1,
        VBRP.MVGR2 AS MaterialGroup2_MVGR2,
        VBRP.MVGR3 AS MaterialGroup3_MVGR3,
        VBRP.MVGR4 AS MaterialGroup4_MVGR4,
        VBRP.MVGR5 AS MaterialGroup5_MVGR5,
        VBRP.SERNR AS BOMExplosionNumber_SERNR,
        VBRP.KVGR1 AS CustomerGroup1_KVGR1,
        VBRP.KVGR2 AS CustomerGroup2_KVGR2,
        VBRP.KVGR3 AS CustomerGroup3_KVGR3,
        VBRP.KVGR4 AS CustomerGroup4_KVGR4,
        VBRP.KVGR5 AS CustomerGroup5_KVGR5,
        VBRP.TXJCD AS TaxJurisdiction_TXJCD,
        VBRP.VSTEL AS ShippingPointReceivingPoint_VSTEL,
        VBRP.VGBEL AS DocumentNumberOfTheReferenceDocument_VGBEL,
        VBRP.VGPOS AS ItemNumberOfTheReferenceItem_VGPOS,
        VBRP.AUBEL AS SalesDocument_AUBEL,
        VBRP.AUPOS AS SalesDocumentItem_AUPOS,
        VBRP.FKIMG AS ActualBilledQuantity_FKIMG,
        VBRP.VOLUM AS Volume_VOLUM,
        VBRP.BRGEW AS GrossWeight_BRGEW,
        VBRP.NTGEW AS NetWeight_NTGEW,
        AGG_PRCD_ELEMENTS.KNUMV AS NumberOfTheDocumentCondition_KNUMV,
        AGG_PRCD_ELEMENTS.KPOSN AS ConditionItemNumber_KPOSN,
        CalendarDateDimension_FKDAT.CalYear AS YearOfBillingDate_FKDAT,
        CalendarDateDimension_FKDAT.CalMonth AS MonthOfBillingDate_FKDAT,
        CalendarDateDimension_FKDAT.CalWeek AS WeekOfBillingDate_FKDAT,
        CalendarDateDimension_FKDAT.CalQuarter AS DayOfBillingDate_FKDAT,
        COALESCE(VBRP.NETWR * currency_decimal.CURRFIX, VBRP.NETWR) AS NetValue_NETWR,
        COALESCE(VBRK.MWSBK * currency_decimal.CURRFIX, VBRK.MWSBK) AS TaxAmount_MWSBK,
        COALESCE(VBRP.MWSBP * currency_decimal.CURRFIX, VBRP.MWSBP) AS TaxAmountPos_MWSBP,
        COALESCE(AGG_PRCD_ELEMENTS.rebate * currency_decimal.CURRFIX, AGG_PRCD_ELEMENTS.rebate) AS Rebate,
        COUNT(VBRK.VBELN) OVER(PARTITION BY CalendarDateDimension_FKDAT.CalYear) AS YearOrderCount,
        COUNT(VBRK.VBELN) OVER(PARTITION BY CalendarDateDimension_FKDAT.CalYear, CalendarDateDimension_FKDAT.CalMonth) AS MonthOrderCount,
        COUNT(VBRK.VBELN) OVER(PARTITION BY CalendarDateDimension_FKDAT.CalYear, CalendarDateDimension_FKDAT.CalMonth, CalendarDateDimension_FKDAT.CalWeek) AS WeekOrderCount
    FROM {{ source("source_db", "vbrk") }} AS VBRK
    INNER JOIN {{ source("source_db", "vbrp") }} AS VBRP
        ON
        VBRK.VBELN = VBRP.VBELN
        AND VBRK.MANDT = VBRP.MANDT
    INNER JOIN {{ ref("agg_prcd_elements") }} AS AGG_PRCD_ELEMENTS
        ON
        CAST(AGG_PRCD_ELEMENTS.Knumv AS STRING) = vbrk.knumv
        AND CAST(AGG_PRCD_ELEMENTS.Kposn AS STRING) = vbrp.posnr
    LEFT JOIN {{ ref("currency_decimal") }} AS currency_decimal
        ON vbrk.WAERK = currency_decimal.CURRKEY
    LEFT JOIN calendar_date_dim AS CalendarDateDimension_FKDAT
        ON CalendarDateDimension_FKDAT.Date = VBRK.FKDAT
)

SELECT * FROM billing

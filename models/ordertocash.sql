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

with order_to_cash AS (
    SELECT
        SalesOrders.Client_MANDT,
        Deliveries.Delivery_VBELN,
        Deliveries.DeliveryItem_POSNR,
        SalesOrders.SalesDocument_VBELN,
        SalesOrders.Item_POSNR,
        Deliveries.ActualQuantityDelivered_InSalesUnits_LFIMG,
        Deliveries.BaseUnitOfMeasure_MEINS AS BaseUoM_MEINS,
        Deliveries.NetPrice_NETPR,
        Deliveries.NetValueInDocumentCurrency_NETWR,
        Deliveries.SdDocumentCurrency_WAERK AS DeliveryDocumentCurrency_WAERK,
        Deliveries.DeliveryBlock_DocumentHeader_LIFSK,
        Deliveries.BillingBlockInSdDocument_FAKSK,
        Deliveries.Date__proofOfDelivery___PODAT,
        Deliveries.BillingDateForBillingIndexAndPrintout_FKDAT,
        Deliveries.SalesOrderNumber_VGBEL AS SalesOrderNumber,
        Deliveries.DeliveryDate_LFDAT,
        Deliveries.ActualGoodsMovementDate_WADAT_IST,
        SalesOrders.ExchangeRateType_KURST,
        SalesOrders.Requesteddeliverydate_VDATU,
        SalesOrders.CumulativeOrderQuantity_KWMENG AS SalesOrderQty,
        SalesOrders.BaseUnitofMeasure_MEINS,
        SalesOrders.Netprice_NETPR AS SalesOrderNetPrice,
        SalesOrders.Currency_WAERK AS SalesOrderDocumentCurrency_WAERK,
        SalesOrders.ShippingReceivingPoint_VSTEL AS ShippingLocation,
        SalesOrders.SoldToParty_KUNNR,
        SalesOrders.SoldToPartyItem_KUNNR,
        SalesOrders.SoldToPartyItemName_KUNNR,
        SalesOrders.ShipToPartyItem_KUNNR,
        SalesOrders.ShipToPartyItemName_KUNNR,
        SalesOrders.BillToPartyItem_KUNNR,
        SalesOrders.BillToPartyItemName_KUNNR,
        SalesOrders.PayerItem_KUNNR,
        SalesOrders.PayerItemName_KUNNR,
        SalesOrders.SoldToPartyHeader_KUNNR,
        SalesOrders.SoldToPartyHeaderName_KUNNR,
        SalesOrders.ShipToPartyHeader_KUNNR,
        SalesOrders.ShipToPartyHeaderName_KUNNR,
        SalesOrders.BillToPartyHeader_KUNNR,
        SalesOrders.BillToPartyHeaderName_KUNNR,
        SalesOrders.PayerHeader_KUNNR,
        SalesOrders.PayerHeaderName_KUNNR,
        SalesOrders.SalesOrganization_VKORG AS SalesOrganization,
        SalesOrders.DistributionChannel_VTWEG AS DistributionChannel,
        SalesOrders.OverallDeliveryStatus_LFGSK AS DeliveryStatus,
        SalesOrders.ListPrice AS ListPrice,
        SalesOrders.AdjustedPrice AS AdjustedPrice,
        SalesOrders.InterCompanyPrice AS InterCompanyPrice,
        SalesOrders.Discount AS Discount,
        SalesOrders.ConfirmedOrderQuantity_BMENG,
        SalesOrders.BaseUnitofMeasure_MEINS AS SalesUnitMeasure,
        SalesOrders.CreationDate_ERDAT,
        SalesOrders.DocumentCategory_VBTYP,
        SalesOrders.PrecedingDocCategory_VGTYP,
        SalesOrders.Documentnumberofthereferencedocument_VGBEL,
        SalesOrders.ReferenceItem_VGPOS,
        SalesOrders.RejectionReason_ABGRU,
        CustomersMD.CustomerNumber_KUNNR AS CustomerNumber,
        CustomersMD.Name1_NAME1 AS CustomerName1,
        CustomersMD.Name2_NAME2 AS CustomerName2,
        CustomersMD.City_ORT01 AS City,
        CustomersMD.CountryKey_LAND1 AS Country,
        CustomersMD.PostalCode_PSTLZ AS PostalCode,
        CustomersMD.CustomerRegion_REGIO AS CustomerRegion,
        CustomersMD.Address_ADRNR AS CustomerAddress,
        CustomersMD.LanguageKey_SPRAS AS CustomerLanguage,
        MaterialsMD.MaterialNumber_MATNR AS MaterialNumber,
        MaterialsMD.MaterialType_MTART AS MaterialType,
        MaterialsMD.Division_SPART AS Division,
        MaterialsMD.MaterialCategory_ATTYP AS ProductCategory,
        MaterialsMD.Brand_BRAND_ID AS Brand,
        MaterialsMD.MaterialText_MAKTX AS MaterialDescription,
        MaterialsMD.Language_SPRAS AS Language_SPRAS,
        Billing.ActualBilledQuantity_FKIMG AS BilledQty,
        Billing.BillingDocument_VBELN,
        Billing.Rebate,
        Billing.TaxAmount_MWSBK,
        Billing.Volume_VOLUM,
        Billing.GrossWeight_BRGEW,
        Billing.BillingDate_FKDAT,
        Billing.BillingItem_POSNR,
        Billing.NetWeight_NTGEW,
        Billing.NetValue_NETWR AS BillingNetValue,
        Billing.SdDocumentCurrency_WAERK AS BillingDOcumentCurrency_WAERK,
        SalesOrganizationsMD.SalesOrgName_VTEXT AS SalesOrganizationName,
        DistributionChannelMD.DistributionChannelName_VTEXT AS DistributionChannelName,
        CountriesMD.CountryName_LANDX AS RegionDescription,
        OneTouchOrder.OneTouchOrderCount AS OneTouchOrderCount,
        OneTouchOrder.VBAPSalesDocument_VBELN AS OneTouchOrders,
        DivisionsMD.DivisionName_VTEXT AS DivisionDescription,
        SalesOrders.OverallProcessingStatus_GBSTK,
        TVLST.DeliveryBlockReason_VTEXT AS DeliveryBlockReasonDescription,
        TVFST.BillingBlockReason_VTEXT AS BillingBlockReasonDescription,
        CASE SalesOrders.OverallProcessingStatus_GBSTK
        WHEN 'A' THEN 'Not yet Processed'
        WHEN 'B' THEN 'Partially Processed'
        WHEN 'C' THEN 'Completely Processed'
        ELSE 'Not relevant'
        END
        AS ReturnOrderDescription,
        Deliveries.ActualQuantityDelivered_InSalesUnits_LFIMG * Deliveries.NetPrice_NETPR AS DeliveredValue,
        Deliveries.ActualQuantityDelivered_InSalesUnits_LFIMG * Deliveries.NetValueInDocumentCurrency_NETWR AS Value,
        SalesOrders.CumulativeOrderQuantity_KWMENG * SalesOrders.Netprice_NETPR AS SalesOrderNetValue,
        SUM(Deliveries.ActualQuantityDelivered_InSalesUnits_LFIMG * Deliveries.NetPrice_NETPR) OVER(PARTITION BY Deliveries.DeliveryItem_POSNR, Deliveries.Delivery_VBELN) AS DeliveredNetValue,
        IF(Deliveries.Date__proofOfDelivery___PODAT > Deliveries.DeliveryDate_LFDAT,
        'Delayed',
        'NotDelayed') AS LateDeliveries,
        IF(Deliveries.DeliveryBlock_documentHeader_LIFSK IS NULL
        AND Deliveries.BillingBlockInSdDocument_FAKSK IS NULL,
        'NotBlocked',
        'Blocked' ) AS BlockedSalesOrder,
        SIZE(COLLECT_SET(SalesOrders.SalesDocument_VBELN) OVER(PARTITION BY SalesOrders.Client_MANDT)) AS TotalOrders,
        SIZE(COLLECT_SET(SalesOrders.Item_POSNR) OVER(PARTITION BY SalesOrders.Client_MANDT)) AS TotalOrderItems,

        SIZE(COLLECT_SET(Deliveries.DeliveryItem_POSNR) OVER(PARTITION BY SalesOrders.Client_MANDT)) AS TotalDeliveries,
        SUM(SalesOrders.CumulativeOrderQuantity_KWMENG ) OVER(PARTITION BY SalesOrders.Client_MANDT, SalesOrders.SalesDocument_VBELN, SalesOrders.Item_POSNR) AS SalesOrderQuantity,

        SUM(SalesOrders.Netprice_NETPR * SalesOrders.CumulativeOrderQuantity_KWMENG) OVER(PARTITION BY SalesOrders.Client_MANDT, SalesOrders.SalesDocument_VBELN, SalesOrders.Item_POSNR) AS SalesOrderValue,

        IF(SalesOrders.DocumentCategory_VBTYP = 'C',
        SalesOrders.SalesDocument_VBELN,
        NULL) AS IncomingOrderNum,

        IF(SalesOrders.CumulativeOrderQuantity_KWMENG = Deliveries.ActualQuantityDelivered_InSalesUnits_LFIMG,
        'DeliveredInFull',
        'NotDeliverdInFull') AS InFullDelivery,

        IF(Deliveries.Date__proofOfDelivery___PODAT <= Deliveries.DeliveryDate_LFDAT
        AND SalesOrders.CumulativeOrderQuantity_KWMENG = Deliveries.ActualQuantityDelivered_InSalesUnits_LFIMG,
        'OTIF',
        'NotOTIF') AS OTIF,

        (SalesOrders.ConfirmedOrderQuantity_BMENG / NULLIF(SalesOrders.CumulativeOrderQuantity_KWMENG, 0)) * 100 AS FillRatePercent,

        IF(SalesOrders.CumulativeOrderQuantity_KWMENG > SalesOrders.ConfirmedOrderQuantity_BMENG,
        'BackOrder',
        'NotBackOrder') AS BackOrder,

        IF(Deliveries.ActualQuantityDelivered_InSalesUnits_LFIMG = SalesOrders.CumulativeOrderQuantity_KWMENG
        AND SalesOrders.CumulativeOrderQuantity_KWMENG = Billing.ActualBilledQuantity_FKIMG,
        'NotOpenOrder',
        'OpenOrder') AS OpenOrder,

        IF( SalesOrders.DocumentCategory_VBTYP = 'H',
        IF( SalesOrders.PrecedingDocCategory_VGTYP = 'C' AND SalesOrders.ReferenceDocument_VGBEL = SalesOrders.Documentnumberofthereferencedocument_VGBEL
            AND SalesOrders.Item_POSNR = SalesOrders.ReferenceItem_VGPOS,
            'Returned',
            'NotReturned'),
        IF( SalesOrders.PrecedingDocCategory_VGTYP = 'M' AND SalesOrders.ReferenceDocument_VGBEL = Billing.DocumentNumberOfTheReferenceDocument_VGBEL
            AND SalesOrders.ReferenceItem_VGPOS = Billing.ItemNumberOfTheReferenceItem_VGPOS
            AND Billing.SalesDocument_AUBEL = SalesOrders.SalesDocument_VBELN
            AND Billing.SalesDocumentItem_AUPOS = SalesOrders.Item_POSNR,
            'Returned',
            'NotReturned') ) AS ReturnOrder,

        IF(SalesOrders.RejectionReason_ABGRU IS NOT NULL,
        'Canceled',
        'NotCanceled') AS CanceledOrder,

        IF(Deliveries.ActualGoodsMovementDate_WADAT_IST IS NOT NULL,
        TIMESTAMPDIFF(DAY ,CAST(CONCAT(Deliveries.Date__proofOfDelivery___PODAT, ' ',
            SUBSTRING(Deliveries.ConfirmationTime_POTIM,1,2), ':',
            SUBSTRING(Deliveries.ConfirmationTime_POTIM,3,2), ':',
            SUBSTRING(Deliveries.ConfirmationTime_POTIM,5,2)) AS TIMESTAMP),
            CAST(CONCAT(SalesOrders.CreationDate_ERDAT, ' ',
            SUBSTRING(SalesOrders.CreationTime_ERZET,1,2), ':',
            SUBSTRING(SalesOrders.CreationTime_ERZET,3,2), ':',
            SUBSTRING(SalesOrders.CreationTime_ERZET,5,2)) AS TIMESTAMP)), NULL) AS OrderCycleTimeInDays,

        IF(Deliveries.Date__proofOfDelivery___PODAT <= Deliveries.DeliveryDate_LFDAT,
        'DeliveredOnTime',
        'NotDeliveredOnTime') AS OnTimeDelivery

    FROM {{ ref("salesorders") }}
    LEFT JOIN {{ ref("deliveries") }} AS Deliveries
        ON
        SalesOrders.SalesDocument_VBELN = Deliveries.SalesOrderNumber_VGBEL
        AND SalesOrders.Item_POSNR = Deliveries.SalesOrderItem_VGPOS
        AND SalesOrders.Client_MANDT = Deliveries.Client_MANDT
    LEFT JOIN {{ ref("billing") }} AS Billing
        ON
        SalesOrders.SalesDocument_VBELN = Billing.SalesDocument_AUBEL
        AND SalesOrders.Item_POSNR = Billing.SalesDocumentItem_AUPOS
        AND SalesOrders.Client_MANDT = Billing.Client_MANDT
    LEFT JOIN {{ ref("customersmd") }} AS CustomersMD
        ON
        SalesOrders.SoldtoParty_KUNNR = CustomersMD.CustomerNumber_KUNNR
        AND SalesOrders.Client_MANDT = CustomersMD.Client_MANDT
    LEFT JOIN {{ ref("materialsmd") }} AS MaterialsMD
        ON
        SalesOrders.MaterialNumber_MATNR = MaterialsMD.MaterialNumber_MATNR
        AND SalesOrders.Client_MANDT = MaterialsMD.Client_MANDT
    LEFT JOIN {{ ref("salesorganizationsmd") }} AS SalesOrganizationsMD
        ON
        SalesOrders.Client_MANDT = SalesOrganizationsMD.Client_MANDT
        AND SalesOrders.SalesOrganization_VKORG = SalesOrganizationsMD.SalesOrg_VKORG
        AND SalesOrganizationsMD.Language_SPRAS = MaterialsMD.Language_SPRAS
    LEFT JOIN {{ ref("distributionchannelmd") }} AS DistributionChannelMD
        ON
        SalesOrders.Client_MANDT = DistributionChannelMD.Client_MANDT
        AND SalesOrders.DistributionChannel_VTWEG = DistributionChannelMD.DistributionChannel_VTWEG
        AND DistributionChannelMD.Language_SPRAS = MaterialsMD.Language_SPRAS
    LEFT JOIN {{ ref("countriesmd") }} AS CountriesMD
        ON
        SalesOrders.Client_MANDT = CountriesMD.Client_MANDT
        AND CustomersMD.CountryKey_LAND1 = CountriesMD.CountryKey_LAND1
        AND CountriesMD.Language_SPRAS = MaterialsMD.Language_SPRAS
    LEFT JOIN {{ ref("onetouchorder") }} AS OneTouchOrder
        ON
        SalesOrders.Client_MANDT = OneTouchOrder.VBAPClient_MANDT
        AND SalesOrders.SalesDocument_VBELN = OneTouchOrder.VBAPSalesDocument_VBELN
        AND SalesOrders.Item_POSNR = OneTouchOrder.VBAPSalesDocument_Item_POSNR
    LEFT JOIN {{ ref("divisionsmd") }} AS DivisionsMD
        ON MaterialsMD.Client_MANDT = DivisionsMD.Client_MANDT
        AND MaterialsMD.Division_SPART = DivisionsMD.Division_SPART
        AND DivisionsMD.LanguageKey_SPRAS = MaterialsMD.Language_SPRAS
    LEFT JOIN {{ ref("deliveryblockingreasonsmd") }} AS TVLST
        ON
        Deliveries.Client_MANDT = TVLST.Client_MANDT
        AND Deliveries.DeliveryBlock_DocumentHeader_LIFSK = TVLST.DefaultDeliveryBlock_LIFSP
        AND MaterialsMD.Language_SPRAS = TVLST.LanguageKey_SPRAS
    LEFT JOIN {{ ref("billingblockingreasonsmd") }} AS TVFST
        ON
        Deliveries.Client_MANDT = TVFST.Client_MANDT
        AND Deliveries.BillingBlockInSdDocument_FAKSK = TVFST.Block_FAKSP
        AND TVFST.LanguageKey_SPRAS = MaterialsMD.Language_SPRAS
)

SeLECT * FROM order_to_cash

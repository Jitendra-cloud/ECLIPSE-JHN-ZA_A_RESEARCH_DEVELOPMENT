@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption for ZCJS_I_RAPCInvoice'
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity ZSE_C_RAPCINVOICE
  provider contract transactional_query
  as projection on ZSE_I_RAPCINVOICE as Invoice
{
          @Search.defaultSearchElement: true
          @Search.fuzzinessThreshold: 1.0
  key     Document,
          DocDate,
          DocTime,
          @Search.defaultSearchElement: true
          @Search.fuzzinessThreshold: 0.8
          Partner,
          HidePosition1,
          HidePosition2,
//          Material,  //added field
          ButtonCriticality,
          LocalLastChanged,
          LastChanged,
          _Items : redirected to composition child ZSE_C_RAPCITEMS,
          _Items2 : redirected to composition child ZSE_C_RAPCITEMS2,
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLJS_VIRTUAL_INVOICE_SE'
  virtual NumberOfPositions : abap.int4
}

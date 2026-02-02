@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption for ZCJS_I_RAPCItems'
@Metadata.allowExtensions: true
define view entity ZSE_C_RAPCITEMS2
  as projection on ZSE_I_RAPCITEMS2 as Items2
{
  key Document,
  key ItemNumber,
      Material,
      Quantity,
      Unit,
      Price,
      Currency,
      _Invoice : redirected to parent ZSE_C_RAPCINVOICE
}

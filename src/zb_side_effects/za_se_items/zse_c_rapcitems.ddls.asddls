@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption for ZCJS_I_RAPCItems'
@Metadata.allowExtensions: true
define view entity ZSE_C_RAPCITEMS
  as projection on ZSE_I_RAPCITEMS as Items
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

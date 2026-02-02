@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection Entity - Excel Data'
//@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZCJS_C_XL_DATA
  as projection on ZCJS_I_XL_DATA
{
  key EndUser,
  key FileId,
  key LineId,
  key LineNumber,
      PoNumber,
      PoItem,
      GrQuantity,
      UnitOfMeasure,
      SiteId,
      HeaderText,
      /* Associations */
      _XLUser: redirected to parent ZCJS_C_XL_USER
}

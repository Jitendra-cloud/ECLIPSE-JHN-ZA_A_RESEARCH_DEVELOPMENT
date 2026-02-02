@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View - Excel Data'
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCJS_I_XL_DATA
  as select from zdjs_excel_data
  association to parent ZCJS_I_XL_USER as _XLUser on  $projection.EndUser = _XLUser.EndUser
                                                   and $projection.FileId  = _XLUser.FileId

{
  key end_user        as EndUser,
  key file_id         as FileId,
  key line_id         as LineId,
  key line_no         as LineNumber,
      po_number       as PoNumber,
      po_item         as PoItem,
      gr_quantity     as GrQuantity,
      unit_of_measure as UnitOfMeasure,
      site_id         as SiteId,
      header_text     as HeaderText,

      _XLUser
}

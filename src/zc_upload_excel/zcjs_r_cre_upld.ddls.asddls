@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZCJS_R_CRE_UPLD
  as select from zdjs_cre_upld as CRE
{
  key tck_id                as TckId,
      excel_attachment      as ExcelAttachment,
      excel_filename        as ExcelFilename,
      target_database       as TargetDatabase,
      excel_mimetype        as ExcelMimetype,

      local_created_by      as LocalCreatedBy,
      local_created_at      as LocalCreatedAt,
      local_last_changed_by as LocalLastChangedBy,
      local_last_changed_at as LocalLastChangedAt,
      last_changed_at       as LastChangedAt

}

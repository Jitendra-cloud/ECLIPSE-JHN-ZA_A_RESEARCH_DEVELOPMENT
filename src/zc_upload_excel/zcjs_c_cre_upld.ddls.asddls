@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZCJS_C_CRE_UPLD
  provider contract transactional_query
  as projection on ZCJS_R_CRE_UPLD
{
  key TckId,

      @Semantics.largeObject: { mimeType : 'ExcelMimetype',
                              fileName : 'ExcelFilename',
                              contentDispositionPreference: #INLINE,
                              acceptableMimeTypes: [ 'application/vnd.ms-excel', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' ] }
      ExcelAttachment,

      @Semantics.mimeType: true
      ExcelFilename,
      ExcelMimetype,
      TargetDatabase,
      
      LocalCreatedBy,
      LocalCreatedAt,
      LocalLastChangedBy,
      LocalLastChangedAt,
      LastChangedAt

}

@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection Entity - Excel User'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: [ 'FileStatus', 'Filename' ]
define root view entity ZCJS_C_XL_USER
  provider contract transactional_query
  as projection on ZCJS_I_XL_USER
{
  key     EndUser,
  key     FileId,
          FileStatus,
          @Semantics.largeObject:
                { mimeType: 'Mimetype',
                fileName: 'Filename',
                acceptableMimeTypes: [ 'application/vnd.ms-excel','application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' ],
                contentDispositionPreference: #INLINE }

          Attachment,
          Mimetype,
          Filename,
          CriticalityGreen,
          LocalCreatedBy,
          LocalCreatedAt,
          LocalLastChangedBy,
          LocalLastChangedAt,
          LastChangedAt,
          /* Associations */
          _XLData : redirected to composition child ZCJS_C_XL_DATA,
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLJS_VIRTUAL_EXCEL_LINES'
  virtual ExcelLineCount : abap.int4
}

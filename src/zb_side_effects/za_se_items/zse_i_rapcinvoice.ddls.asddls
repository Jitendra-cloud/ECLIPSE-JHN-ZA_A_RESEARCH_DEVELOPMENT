@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface for ZDJS_INVOICE'
//@Metadata.ignorePropagatedAnnotations: true
define root view entity ZSE_I_RAPCINVOICE
  as select from zdse_invoice
  composition [0..*] of ZSE_I_RAPCITEMS  as _Items
  composition [0..*] of ZSE_I_RAPCITEMS2 as _Items2
//  association [0..*] to ZSE_I_RAPCITEMS  as _Item3 on $projection.Document = _Item3.Document
{
  key document                     as Document,
      doc_date                     as DocDate,
      doc_time                     as DocTime,
      partner                      as Partner,
      //      cast( hide_pos1 as boole_d )       as HidePosition1,
      //      cast( case when hide_pos1 = 'X'
      //      then ' ' else 'X' end as boole_d ) as HidePosition2,
      cast( hide_pos1 as boole_d ) as HidePosition1,
      cast( hide_pos2 as boole_d ) as HidePosition2,
//      _Item3.Material              as Material,
      3 as ButtonCriticality, 
      local_last_changed           as LocalLastChanged,
      last_changed                 as LastChanged,
      _Items,
      _Items2
//      ,_Item3
}

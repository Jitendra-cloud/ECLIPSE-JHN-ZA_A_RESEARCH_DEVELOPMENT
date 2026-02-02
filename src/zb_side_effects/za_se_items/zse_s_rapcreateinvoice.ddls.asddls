@EndUserText.label: 'Create Invoice'
define root abstract entity ZSE_S_RAPCREATEINVOICE
{
  key DummyKey  : abap.char(1);
      Document  : abap.char(8);
      Partner   : abap.char(10);
      _Items : composition [0..*] of ZSE_S_RAPCREATE_ITEMS;

}

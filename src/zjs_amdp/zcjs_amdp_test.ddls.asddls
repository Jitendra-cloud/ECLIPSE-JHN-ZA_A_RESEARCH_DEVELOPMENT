@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'AMDP Testing'
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
define table function ZCJS_AMDP_TEST
returns
{
  client   : abap.clnt;
  document : abap.char(8);
  item_no  : abap.int2;
  material : abap.char(5);
  quantity : abap.decfloat34;
  price    : abap.decfloat34;
  currency : abap.char(5);

}
implemented by method
  zjs_cl_amdp_test=>amdp_test_method;
CLASS zjs_cl_amdp_test DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES:
        if_amdp_marker_hdb.

  CLASS-METHODS amdp_test_method for TABLE FUNCTION zcjs_amdp_test.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZJS_CL_AMDP_TEST IMPLEMENTATION.


  METHOD amdp_test_method
         BY DATABASE FUNCTION FOR HDB LANGUAGE SQLSCRIPT
         OPTIONS READ-ONLY
         USING zse_i_rapcitems.
    itab_rapcitems =
        SELECT DISTINCT
            zse_i_rapcitems.mandt as client,
            zse_i_rapcitems.document as Document,
            zse_i_rapcitems.ItemNumber as Item_no,
            zse_i_rapcitems.Material as Material,
            zse_i_rapcitems.Quantity as Quantity,
            zse_i_rapcitems.Price as Price,
            zse_i_rapcitems.Currency as Currency
         FROM zse_i_rapcitems;

     return
        select client, document, item_no, material, quantity, price, currency
        from :itab_rapcitems;

  ENDMETHOD.
ENDCLASS.

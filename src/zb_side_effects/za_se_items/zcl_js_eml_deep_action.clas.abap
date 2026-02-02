CLASS zcl_js_eml_deep_action DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .

    TYPES tt_document TYPE TABLE FOR ACTION IMPORT ZSE_I_RAPCInvoice~CreateInvoiceDocument.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_js_eml_deep_action IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA lt_document TYPE tt_document.

    TRY.
        lt_document = VALUE #( ( %cid   = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) )
                                 %param = VALUE #( Document  = 'TEST'
                                                   Partner   = '6000000999'
                                                   _items = VALUE #(
                                                       "Unit     = 'ST'
                                                       Currency = 'EUR'
                                                       ( Material = 'F0001' Quantity = '2' Price = '13.12' )
                                                       ( Material = 'H0001' Quantity = '1' Price = '28.54' ) ) ) ) ).
        CATCH CX_UUID_ERROR.
    ENDTRY.

    MODIFY ENTITIES OF ZSE_I_RAPCInvoice
        ENTITY Invoice
            EXECUTE CreateInvoiceDocument FROM lt_document  FAILED DATA(ls_failed_deep)
                                                            REPORTED DATA(ls_reported_deep).

    COMMIT WORK.

  ENDMETHOD.
ENDCLASS.

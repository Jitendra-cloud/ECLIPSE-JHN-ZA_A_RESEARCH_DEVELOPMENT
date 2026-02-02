CLASS lsc_zse_i_rapcinvoice DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

ENDCLASS.

CLASS lsc_zse_i_rapcinvoice IMPLEMENTATION.

  METHOD save_modified.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_Invoice DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Invoice RESULT result.
    METHODS create_items2 FOR DETERMINE ON MODIFY
      IMPORTING keys FOR invoice~create_items2.
    METHODS hidelineitem2 FOR DETERMINE ON MODIFY
      IMPORTING keys FOR invoice~hidelineitem2.
    METHODS createitem FOR MODIFY
      IMPORTING keys FOR ACTION invoice~createitem RESULT result.
    METHODS switchitem FOR MODIFY
      IMPORTING keys FOR ACTION invoice~switchitem RESULT result.
    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR invoice RESULT result.
    METHODS createinvoicedocument FOR MODIFY
      IMPORTING keys FOR ACTION invoice~createinvoicedocument.
    METHODS earlynumbering_cba_items FOR NUMBERING
      IMPORTING entities FOR CREATE invoice\_items.
    METHODS earlynumbering_cba_items2 FOR NUMBERING
      IMPORTING entities FOR CREATE invoice\_items2.
    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE invoice.


ENDCLASS.

CLASS lhc_Invoice IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.


  METHOD earlynumbering_create.
    SELECT FROM zdse_invoice FIELDS MAX( document ) INTO @DATA(ld_max_result).

    LOOP AT entities INTO DATA(entity).
      ld_max_result += 1.
      APPEND VALUE #( %cid = entity-%cid
                     "" %key      = entity-%key
                      %is_draft = entity-%is_draft
                      Document = ld_max_result ) TO mapped-invoice.
    ENDLOOP.
  ENDMETHOD.

  METHOD create_items2.

    DATA lt_upd_invoice TYPE TABLE FOR UPDATE zse_i_rapcinvoice.
    DATA lt_create_items TYPE TABLE FOR CREATE zse_i_rapcinvoice\_Items.
    DATA lt_create_items2 TYPE TABLE FOR CREATE zse_i_rapcinvoice\_Items2.

    READ ENTITIES OF zse_i_rapcinvoice IN LOCAL MODE
        ENTITY Invoice ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT DATA(lt_head)
        ENTITY Invoice BY \_Items2 ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT DATA(lt_items2).

    IF lt_head[ 1 ]-Partner = '6000000001'.

      lt_create_items2 = VALUE #( ( "%cid_ref  = 'Item2'   ""keys[ 1 ]-%cid
                                    %is_draft = keys[ 1 ]-%is_draft
                                    Document  = keys[ 1 ]-Document
                                    %target   = VALUE #( (  %is_draft = keys[ 1 ]-%is_draft
                                                             %data    = VALUE #( Material    = 'MT001'
                                                                                 Quantity    = '10.50'
                                                                                 "Unit        = 'GM'
                                                                                 Price       = '100'
                                                                                 Currency    = 'INR' )
                                                             %control = VALUE #( Material    = if_abap_behv=>mk-on
                                                                                 Quantity    = if_abap_behv=>mk-on
                                                                                 "Unit        = if_abap_behv=>mk-on
                                                                                 Price       = if_abap_behv=>mk-on
                                                                                 Currency    = if_abap_behv=>mk-on ) ) ) ) ).

      MODIFY ENTITIES OF zse_i_rapcinvoice IN LOCAL MODE
          ENTITY Invoice CREATE BY \_Items2
              AUTO FILL CID WITH lt_create_items2 MAPPED DATA(lt_mapped)
                                                  REPORTED DATA(lt_reported).

      reported = CORRESPONDING #( DEEP lt_reported ).

    ENDIF.

  ENDMETHOD.

  METHOD hideLineItem2.

    DATA lt_upd_invoice TYPE TABLE FOR UPDATE zse_i_rapcinvoice.
*    DATA lt_upd_invoice2 TYPE TABLE FOR UPDATE zse_i_rapcinvoice.

    READ ENTITIES OF zse_i_rapcinvoice IN LOCAL MODE
    ENTITY Invoice ALL FIELDS WITH CORRESPONDING #( keys ) RESULT DATA(lt_invoice).

    DATA(ls_invoice) = VALUE #( lt_invoice[ 1 ] OPTIONAL ).

    APPEND VALUE #( %tky = lt_invoice[ 1 ]-%tky
                    HidePosition2 = ' ' ) TO lt_upd_invoice.

    DATA(lv_pos) = 'X'.
    IF lt_invoice[ 1 ]-HidePosition1 = ' '.
      lv_pos = 'X'.
    ELSEIF lt_invoice[ 1 ]-HidePosition1 = 'X'.
      lv_pos = ' '.
    ENDIF.

    SELECT MAX( partner ) FROM zdse_invoice INTO @DATA(max_partner).
    max_partner += 1.

    MODIFY ENTITIES OF zse_i_rapcinvoice IN LOCAL MODE
           ENTITY Invoice
           UPDATE FIELDS ( HidePosition2 Partner ) WITH VALUE #( ( %tky = lt_invoice[ 1 ]-%tky
                                                                   HidePosition2          = lv_pos
                                                                   Partner                = COND #( WHEN ls_invoice-Partner IS INITIAL THEN max_partner ELSE ls_invoice-Partner )
                                                                   %control-HidePosition2 = if_abap_behv=>mk-on
                                                                   %control-Partner       = if_abap_behv=>mk-on ) ) MAPPED DATA(lt_mapped)
                                                                                                                    REPORTED DATA(lt_reported).
    reported = CORRESPONDING #( DEEP lt_reported ).

  ENDMETHOD.

  METHOD createItem.

    DATA lt_upd_invoice TYPE TABLE FOR UPDATE zse_i_rapcinvoice.
    DATA lt_create_items TYPE TABLE FOR CREATE zse_i_rapcinvoice\_Items.
    DATA lt_create_items2 TYPE TABLE FOR CREATE zse_i_rapcinvoice\_Items2.

    READ ENTITIES OF zse_i_rapcinvoice IN LOCAL MODE
        ENTITY Invoice ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT DATA(lt_head)
        ENTITY Invoice BY \_Items2 ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT DATA(lt_items2).

    SORT lt_items2 BY ItemNumber DESCENDING.
    DATA(lv_max_item) = VALUE #( lt_items2[ 1 ]-ItemNumber OPTIONAL ).

    lv_max_item += 1.

    lt_create_items = VALUE #( ( "%cid_ref  = keys[ 1 ]-%cid_ref
                                  %is_draft = keys[ 1 ]-%is_draft
                                  Document  = keys[ 1 ]-Document
                                  %target   = VALUE #( (  %is_draft = keys[ 1 ]-%is_draft
                                                           %data    = VALUE #( "ItemNumber  = lv_max_item
                                                                               Material    = 'CH101'
                                                                               Quantity    = '10.50'
                                                                               "Unit        = 'GM'
                                                                               Price       = '100'
                                                                               Currency    = 'INR' )
                                                           %control = VALUE #( "ItemNumber  = lv_max_item
                                                                               Material    = if_abap_behv=>mk-on
                                                                               Quantity    = if_abap_behv=>mk-on
                                                                               "Unit        = if_abap_behv=>mk-on
                                                                               Price       = if_abap_behv=>mk-on
                                                                               Currency    = if_abap_behv=>mk-on ) ) ) ) ).

    lt_create_items2 = VALUE #( ( "%cid_ref  = keys[ 1 ]-%cid_ref
                                  %is_draft = keys[ 1 ]-%is_draft
                                  Document  = keys[ 1 ]-Document
                                  %target   = VALUE #( (  %is_draft = keys[ 1 ]-%is_draft
                                                           %data    = VALUE #( "ItemNumber  = lv_max_item
                                                                               Material    = 'CH201'
                                                                               Quantity    = '10.50'
                                                                               "Unit        = 'GM'
                                                                               Price       = '100'
                                                                               Currency    = 'INR' )
                                                           %control = VALUE #( "ItemNumber  = lv_max_item
                                                                               Material    = if_abap_behv=>mk-on
                                                                               Quantity    = if_abap_behv=>mk-on
                                                                               "Unit        = if_abap_behv=>mk-on
                                                                               Price       = if_abap_behv=>mk-on
                                                                               Currency    = if_abap_behv=>mk-on ) ) ) ) ).
    IF lt_head[ 1 ]-HidePosition1 = 'X'.
      MODIFY ENTITIES OF zse_i_rapcinvoice IN LOCAL MODE
          ENTITY Invoice CREATE BY \_Items
              AUTO FILL CID WITH lt_create_items MAPPED DATA(lt_mapped)
                                                  REPORTED DATA(lt_reported)
                                                  FAILED DATA(ls_failed).

      reported = CORRESPONDING #( DEEP lt_reported ).

      READ ENTITIES OF zse_i_rapcinvoice IN LOCAL MODE
          ENTITY Invoice ALL FIELDS WITH CORRESPONDING #( lt_create_items )
              RESULT DATA(lt_requests_submitted).

      result = VALUE #(  FOR ls_request IN lt_requests_submitted ( %tky = ls_request-%tky
                                                                   %param = ls_request ) ).
    ELSE.
      MODIFY ENTITIES OF zse_i_rapcinvoice IN LOCAL MODE
          ENTITY Invoice CREATE BY \_Items2
              AUTO FILL CID WITH lt_create_items2 MAPPED DATA(lt_mapped2)
                                                  REPORTED DATA(lt_reported2)
                                                  FAILED DATA(ls_failed2).

      reported = CORRESPONDING #( DEEP lt_reported2 ).

      READ ENTITIES OF zse_i_rapcinvoice IN LOCAL MODE
          ENTITY Invoice ALL FIELDS WITH CORRESPONDING #( lt_create_items2 )
              RESULT DATA(lt_requests_submitted2).

      result = VALUE #(  FOR ls_request IN lt_requests_submitted2 ( %tky = ls_request-%tky
                                                                   %param = ls_request ) ).
    ENDIF.

  ENDMETHOD.

  METHOD earlynumbering_cba_Items2.

    READ ENTITIES OF zse_i_rapcinvoice IN LOCAL MODE
        ENTITY Invoice ALL FIELDS WITH VALUE #( ( Document = entities[ 1 ]-Document %is_draft = entities[ 1 ]-%is_draft ) )
            RESULT DATA(lt_head)
        ENTITY Invoice BY \_Items2 ALL FIELDS WITH VALUE #( ( Document = entities[ 1 ]-Document %is_draft = entities[ 1 ]-%target[ 1 ]-%is_draft ) )
            RESULT DATA(lt_items)
            FAILED DATA(lt_failed).

    SORT lt_items BY ItemNumber DESCENDING.

    DATA(lv_max_itemnumber) = VALUE #( lt_items[ 1 ]-ItemNumber OPTIONAL ).

    lv_max_itemnumber += 1.

    LOOP AT entities[ 1 ]-%target INTO DATA(ls_item).
      IF ls_item-ItemNumber IS INITIAL.
        ls_item-ItemNumber = lv_max_itemnumber.
        APPEND CORRESPONDING #( ls_item ) TO mapped-items2.
      ELSE.
        APPEND CORRESPONDING #( ls_item ) TO mapped-items2.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD earlynumbering_cba_Items.

    READ ENTITIES OF zse_i_rapcinvoice IN LOCAL MODE
        ENTITY Invoice ALL FIELDS WITH VALUE #( ( Document = entities[ 1 ]-Document %is_draft = entities[ 1 ]-%is_draft ) )
            RESULT DATA(lt_head)
        ENTITY Invoice BY \_Items ALL FIELDS WITH VALUE #( ( Document = entities[ 1 ]-Document %is_draft = entities[ 1 ]-%target[ 1 ]-%is_draft ) )
            RESULT DATA(lt_items)
            FAILED DATA(lt_failed).

    SORT lt_items BY ItemNumber DESCENDING.

    DATA(lv_max_itemnumber) = VALUE #( lt_items[ 1 ]-ItemNumber OPTIONAL ).

    lv_max_itemnumber += 1.

    LOOP AT entities[ 1 ]-%target INTO DATA(ls_item).
      IF ls_item-ItemNumber IS INITIAL.
        ls_item-ItemNumber = lv_max_itemnumber.
        APPEND CORRESPONDING #( ls_item ) TO mapped-items.
      ELSE.
        APPEND CORRESPONDING #( ls_item ) TO mapped-items.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD switchItem.

    DATA lt_upd_invoice TYPE TABLE FOR UPDATE zse_i_rapcinvoice.

    READ ENTITIES OF zse_i_rapcinvoice IN LOCAL MODE
        ENTITY Invoice ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT DATA(lt_invoice).

    DATA(ls_invoice) = VALUE #( lt_invoice[ 1 ] OPTIONAL ).

    APPEND VALUE #( %tky = lt_invoice[ 1 ]-%tky
                    HidePosition2 = ' ' ) TO lt_upd_invoice.

    DATA(lv_pos) = 'X'.
    IF lt_invoice[ 1 ]-HidePosition1 = ' '.
      lv_pos = 'X'.
    ELSEIF lt_invoice[ 1 ]-HidePosition1 = 'X'.
      lv_pos = ' '.
    ENDIF.

    MODIFY ENTITIES OF zse_i_rapcinvoice IN LOCAL MODE
           ENTITY Invoice
           UPDATE FIELDS ( HidePosition1 ) WITH VALUE #( ( %tky                   = lt_invoice[ 1 ]-%tky
                                                           HidePosition1          = lv_pos
                                                           %control-HidePosition1 = if_abap_behv=>mk-on ) ) MAPPED DATA(lt_mapped)
                                                                                                            REPORTED DATA(lt_reported).
    reported = CORRESPONDING #( DEEP lt_reported ).

    READ ENTITIES OF zse_i_rapcinvoice IN LOCAL MODE
        ENTITY Invoice ALL FIELDS WITH CORRESPONDING #( lt_invoice )
            RESULT DATA(lt_requests_submitted2).

    result = VALUE #(  FOR ls_request IN lt_requests_submitted2 ( %tky = ls_request-%tky
                                                                  %param = ls_request ) ).

  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD CreateInvoiceDocument.

    IF 0 = 0.
    ENDIF.

    DATA lt_create_invoice TYPE TABLE FOR CREATE zse_i_rapcinvoice.
    DATA lt_create_items TYPE TABLE FOR CREATE zse_i_rapcinvoice\_Items.

*    lt_create_invoice = CORRESPONDING #( keys ).
*      lt_create_invoice = VALUE #( ( %cid  = keys[ 1 ]-%cid
*                                     document = keys[ 1 ]-%param-Document
*                                     partner = keys[ 1 ]-%param-Partner
*                                     %control = VALUE #( ( material =  ) ) ) )
**                                    %is_draft = keys[ 1 ]-%is_draft
**                                    Document  = keys[ 1 ]-Document
**                                    %target   = VALUE #( (  %is_draft = keys[ 1 ]-%is_draft
**                                                             %data    = VALUE #( Material    = 'MT001'
**                                                                                 Quantity    = '10.50'
**                                                                                 "Unit        = 'GM'
**                                                                                 Price       = '100'
**                                                                                 Currency    = 'INR' )
**                                                             %control = VALUE #( Material    = if_abap_behv=>mk-on
**                                                                                 Quantity    = if_abap_behv=>mk-on
**                                                                                 "Unit        = if_abap_behv=>mk-on
**                                                                                 Price       = if_abap_behv=>mk-on
**                                                                                 Currency    = if_abap_behv=>mk-on ) ) ) ) ).

      MODIFY ENTITIES OF zse_i_rapcinvoice IN LOCAL MODE
          ENTITY Invoice CREATE FIELDS ( Partner )
                WITH VALUE #( ( %cid  = keys[ 1 ]-%cid
                                "document = keys[ 1 ]-%param-Document
                                partner = keys[ 1 ]-%param-Partner ) ) "BY \_Items2
          CREATE BY \_Items FIELDS ( Material Quantity Price Currency )
                WITH VALUE #( ( %cid_ref = keys[ 1 ]-%cid
                                %target = VALUE #( ( %cid = 'dummy1'
                                                     Material = keys[ 1 ]-%param-_items[ 1 ]-Material
                                                     Quantity = keys[ 1 ]-%param-_items[ 1 ]-Quantity
                                                     Price = keys[ 1 ]-%param-_items[ 1 ]-Price
                                                     Currency = keys[ 1 ]-%param-_items[ 1 ]-Currency ) ) ) ) MAPPED DATA(lt_mapped)
                                                                                                              FAILED DATA(lt_failed)
                                                                                                              REPORTED data(lt_reported).

      reported = CORRESPONDING #( DEEP lt_reported ).

*    DATA lt_document TYPE TABLE FOR ACTION IMPORT ZSE_I_RAPCInvoice~CreateInvoiceDocument.
*
*    TRY.
*        lt_document = VALUE #( ( %cid   = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) )
*                                 %param = VALUE #( Document  = 'TEST'
*                                                   Partner   = '6000000999'
*                                                   _items = VALUE #(
*                                                       "Unit     = 'ST'
*                                                       Currency = 'EUR'
*                                                       ( Material = 'F0001' Quantity = '2' Price = '13.12' )
*                                                       ( Material = 'H0001' Quantity = '1' Price = '28.54' ) ) ) ) ).
*        CATCH CX_UUID_ERROR.
*    ENDTRY.
*
*    MODIFY ENTITIES OF ZSE_I_RAPCInvoice
*        ENTITY Invoice
*            EXECUTE CreateInvoiceDocument FROM lt_document  FAILED DATA(ls_failed_deep)
*                                                            REPORTED DATA(ls_reported_deep).

  ENDMETHOD.

ENDCLASS.

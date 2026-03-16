CLASS zjs_db_master_data DEFINITION PUBLIC FINAL CREATE PUBLIC .
  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZJS_DB_MASTER_DATA IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA lt_actions TYPE STANDARD TABLE OF zdt_actions.

    lt_actions = VALUE #( ( pernr = '00000001' begda = '20111017' endda = '47121231' massn = '' massg = '' stat2 = '1' )
                          ( pernr = '00000002' begda = '20130105' endda = '47121231' massn = '' massg = '' stat2 = '1' ) ).

    SELECT * FROM zdjs_cre_upld INTO TABLE @DATA(lt_tab2).

    LOOP AT lt_tab2 ASSIGNING FIELD-SYMBOL(<ls_tab2>).

      out->write( |( client = '{ <ls_tab2>-client }' tck_id = '{ <ls_tab2>-tck_id }' excel_attachment = '{ <ls_tab2>-excel_attachment }'| &&
                  | excel_mimetype = '{ <ls_tab2>-excel_mimetype }' excel_filename = '{ <ls_tab2>-excel_filename }' target_database = '{ <ls_tab2>-target_database }'| ).

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.

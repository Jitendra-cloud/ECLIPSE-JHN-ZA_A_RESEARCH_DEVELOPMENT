CLASS zjs_cl_01_table_data_operation DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA lt_data TYPE STANDARD TABLE OF zdjs_un_data.

    METHODS:
      create_test_data,
      delete_from_table,
      create_test_data_from_table,
      copy_from_one_to_other_dtbase.

ENDCLASS.



CLASS ZJS_CL_01_TABLE_DATA_OPERATION IMPLEMENTATION.


  METHOD copy_from_one_to_other_dtbase.

*        SELECT * FROM zdemo_abap_flsch INTO TABLE @data(lt_flsch).
*        INSERT zdjs_abap_flsch FROM TABLE @lt_flsch.

*        SELECT * FROM zdjs_items INTO TABLE @data(lt_items).
*        INSERT zdjs_items2 FROM TABLE @lt_items.

    DELETE FROM zdjs_cre_upld_2.
    SELECT * FROM zdjs_cre_upld INTO TABLE @DATA(lt_tab2).
    INSERT zdjs_cre_upld_2 FROM TABLE @lt_tab2.

  ENDMETHOD.


  METHOD create_test_data.

    DATA lt_actions TYPE STANDARD TABLE OF zdt_actions.
    DATA lt_orgassig TYPE STANDARD TABLE OF zdt_orgassig.
    DATA lt_personaldata TYPE STANDARD TABLE OF zdt_personaldata.
    DATA lt_datespecs TYPE STANDARD TABLE OF zdt_datespecs.
    DATA lt_comm TYPE STANDARD TABLE OF zdt_comm.

    lt_actions = VALUE #( ( pernr = '00000001' begda = '20111017' endda = '47121231' massn = '' massg = '' stat2 = '1' )
                          ( pernr = '00000002' begda = '20130105' endda = '47121231' massn = '' massg = '' stat2 = '1' ) ).
    DELETE FROM zdt_actions.
    INSERT zdt_actions FROM TABLE @lt_actions.

    lt_orgassig = VALUE #( ( pernr = '00000001' begda = '20250418' endda = '47121231' bukrs = '1100' werks = 'FIEL' btrtl = 'FIEL' persg = 'F' persk = 'EM' kostl = '11001040' abkrs = 'US' )
                           ( pernr = '00000002' begda = '20230105' endda = '47121231' bukrs = '1100' werks = 'FIEL' btrtl = 'FIEL' persg = 'F' persk = 'EM' kostl = '11001040' abkrs = 'US' ) ).
    DELETE FROM zdt_orgassig.
    INSERT zdt_orgassig FROM TABLE @lt_orgassig.

    lt_personaldata = VALUE #( ( pernr = '00000001' anred = 'MR.' vorna = 'Lloydasinh' nachn = 'Hurleyy'   midnm = 'A' gesch = 'M' gbdat = '19000813' rufnm = 'Lonny' )
                               ( pernr = '00000002' anred = 'MS.' vorna = 'Paigeeser'  nachn = 'Austinere' midnm = 'A' gesch = 'F' gbdat = '19000224' rufnm = 'Paige' ) ).
    DELETE FROM zdt_personaldata.
    INSERT zdt_personaldata FROM TABLE @lt_personaldata.

    lt_datespecs = VALUE #( ( pernr = '00000001' dat01 = '20111017' dat02 = '20111017' dat03 = '20111017' )
                            ( pernr = '00000002' dat01 = '20130105' dat02 = '20130105' dat03 = '20130105' ) ).
    DELETE FROM zdt_datespecs.
    INSERT zdt_datespecs FROM TABLE @lt_datespecs.

    lt_comm = VALUE #( ( pernr = '00000001' usrid_long1 = '12' usrid_long2 = 'abc@alkermes.com' usrid_long3 = 'xyz@alkermes.com' usrid_long4 = '22222' usrid_long5 = '2500' )
                       ( pernr = '00000002' usrid_long1 = '13' usrid_long2 = 'abd@alkermes.com' usrid_long3 = 'zxy@alkermes.com' usrid_long4 = '22915' usrid_long5 = '50000' ) ).
    DELETE FROM zdt_comm.
    INSERT zdt_comm FROM TABLE @lt_comm.

  ENDMETHOD.


  METHOD create_test_data_from_table.

    DATA ls_invoice TYPE zdse_invoice.

    SELECT * FROM zdjs_invoice INTO TABLE @DATA(lt_result).

    LOOP AT lt_result INTO DATA(ls_result).
      ls_invoice-document = ls_result-document.
      ls_invoice-doc_date = ls_result-doc_date.
      ls_invoice-doc_time = ls_result-doc_time.
      ls_invoice-partner  = ls_result-partner.

*        APPEND ls_invoice to zdse_invoice.
      INSERT zdse_invoice FROM @ls_invoice.
    ENDLOOP.

*      zdse_invoice = value #( for ls_line1 in lt_result )

*     INSERT VALUE #(  )

  ENDMETHOD.


  METHOD delete_from_table.

    DELETE FROM zdjs_invoice WHERE doc_date IS INITIAL.

  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.
*    create_test_data( ).
*    out->write( |Partner: { lines( lt_data ) }| ).

*    delete_from_table(  ).

*     create_test_data_from_table( ).

    copy_from_one_to_other_dtbase(  ).

  ENDMETHOD.
ENDCLASS.

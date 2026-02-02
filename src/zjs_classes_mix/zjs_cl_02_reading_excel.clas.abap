CLASS zjs_cl_02_reading_excel DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

    TYPES tt_excel TYPE STANDARD TABLE OF zdjs_EXCEL_USER WITH EMPTY KEY.

    METHODS convert_excel_file_to_table
      IMPORTING id_stream        TYPE xstring
      RETURNING VALUE(rt_result) TYPE tt_excel
      RAISING   zcxjs_excel_error.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZJS_CL_02_READING_EXCEL IMPLEMENTATION.


  METHOD convert_excel_file_to_table.

    DATA(lo_sheet) = xco_cp_xlsx=>document->for_file_content( id_stream )->read_access( )->get_workbook( )->worksheet->at_position( 1 ).
*    IF NOT lo_sheet->exists( ).
*      RAISE EXCEPTION NEW zcxjs_excel_error( textid = VALUE #( msgid = 'ZMJS__RAP_PATTERN'
*                                                                 msgno = '002' ) ).
*    ENDIF.
    DATA(lo_pattern) = xco_cp_xlsx_selection=>pattern_builder->simple_from_to( )->from_column( xco_cp_xlsx=>coordinate->for_alphabetic_value( 'A' ) )->from_row( xco_cp_xlsx=>coordinate->for_numeric_value( 2 ) )->get_pattern( ).

*    lo_sheet->select( lo_pattern )->row_stream( )->operation->write_to( REF #( rt_result ) )->set_value_transformation( xco_cp_xlsx_read_access=>value_transformation->string_value )->execute( ).

    DATA(lo_sheet2) = lo_sheet->select( lo_pattern )->row_stream( )->operation->write_to( REF #( rt_result ) ).
    DATA(lo_string_val) = lo_sheet2->set_value_transformation( xco_cp_xlsx_read_access=>value_transformation->string_value ).
    DATA(lo_execute) = lo_string_val->execute( ).

  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.

    SELECT * FROM zdjs_cre_upld
    WHERE excel_filename = '62. ZDJS_EXCEL_USER.xlsx'
    INTO TABLE @DATA(ls_attachement).

    TRY.
        DATA(lt_excel) = convert_excel_file_to_table( ls_attachement[ 1 ]-excel_attachment ).
      CATCH zcxjs_excel_error INTO DATA(lo_excel_error).
*        INSERT lo_excel_error INTO TABLE data(reported).
        RETURN.
    ENDTRY.

    DELETE FROM zdjs_EXCEL_USER.
    LOOP AT lt_excel INTO DATA(ls_excel).
*        ls_excel-MANDT = 100.
      INSERT zdjs_EXCEL_USER FROM @ls_excel.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.

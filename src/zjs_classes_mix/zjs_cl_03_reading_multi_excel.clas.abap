CLASS zjs_cl_03_reading_multi_excel DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zjs_cl_03_reading_multi_excel IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    SELECT * FROM zdjs_cre_upld
    INTO TABLE @DATA(lt_attachement).

    SORT lt_attachement BY excel_filename ASCENDING.

    LOOP AT lt_attachement INTO DATA(ls_attachement).

      IF ls_attachement-target_database = 'ZDJS_CSR_LOG' OR ls_attachement-target_database = 'ZDJS_STPO'.

        CONTINUE.

      ELSE.

        DATA: lo_struct TYPE REF TO cl_abap_structdescr,
              lo_table  TYPE REF TO cl_abap_tabledescr,
              lr_data   TYPE REF TO data,
              lv_type2  TYPE tabname.

        lo_struct ?= cl_abap_typedescr=>describe_by_name( ls_attachement-target_database ).
        lo_table = cl_abap_tabledescr=>create( p_line_type  = lo_struct
                                               p_table_kind = cl_abap_tabledescr=>tablekind_std ).
        CREATE DATA lr_data TYPE HANDLE lo_table.
        FIELD-SYMBOLS <lt_excel> TYPE STANDARD TABLE.
        ASSIGN lr_data->* TO <lt_excel>.


        TRY.
            DATA(lo_sheet) = xco_cp_xlsx=>document->for_file_content( ls_attachement-excel_attachment )->read_access( )->get_workbook( )->worksheet->at_position( 1 ).
            DATA(lo_pattern) = xco_cp_xlsx_selection=>pattern_builder->simple_from_to( )->from_column( xco_cp_xlsx=>coordinate->for_alphabetic_value( 'A' ) )->from_row( xco_cp_xlsx=>coordinate->for_numeric_value( 2 ) )->get_pattern( ).
            DATA(lo_sheet2) = lo_sheet->select( lo_pattern )->row_stream( )->operation->write_to( REF #( <lt_excel> ) ).
            DATA(lo_string_val) = lo_sheet2->set_value_transformation( xco_cp_xlsx_read_access=>value_transformation->string_value ).
            DATA(lo_execute) = lo_string_val->execute( ).

            DELETE FROM (ls_attachement-target_database).
            INSERT (ls_attachement-target_database) FROM TABLE @<lt_excel>.

            out->write( | { ls_attachement-target_database } : Data generated Successfully| ).

*        CATCH zcxjs_excel_error INTO DATA(lo_excel_error).
          CATCH cx_root INTO DATA(lo_excel_error).

            out->write( |Error while processing Excel for table { ls_attachement-target_database }: | && lo_excel_error->get_text( ) ).

            CONTINUE.
        ENDTRY.

      ENDIF.

    ENDLOOP.


  ENDMETHOD.
ENDCLASS.

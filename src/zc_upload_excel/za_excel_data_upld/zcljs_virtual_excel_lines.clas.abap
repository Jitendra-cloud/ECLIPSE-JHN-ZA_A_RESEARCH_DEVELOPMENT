CLASS zcljs_virtual_excel_lines DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_sadl_exit_calc_element_read.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcljs_virtual_excel_lines IMPLEMENTATION.
  METHOD if_sadl_exit_calc_element_read~calculate.
    LOOP AT it_requested_calc_elements INTO DATA(ld_virtual_field).
      LOOP AT ct_calculated_data ASSIGNING FIELD-SYMBOL(<ls_calculated_data>).
        DATA(ld_tabix) = sy-tabix.
        ASSIGN COMPONENT ld_virtual_field OF STRUCTURE <ls_calculated_data> TO FIELD-SYMBOL(<ld_field>).

        DATA(ls_original) = CORRESPONDING ZCJS_C_XL_USER( it_original_data[ ld_tabix ] ).

        IF ls_original-EndUser = '1000000002'.
          <ld_field> = 999.

        ELSE.

*          SELECT FROM zdjs_xl_data_dr
*            FIELDS  lineid, draftentitylastchangedatetime
*            WHERE enduser = @ls_original-EndUser and fileid = @ls_original-FileId "GROUP BY lineid, draftentitylastchangedatetime
*            INTO @<ld_field>.
*          ENDSELECT.

          SELECT lineid, draftentitycreationdatetime
            FROM zdjs_xl_data_dr GROUP BY lineid, draftentitycreationdatetime INTO TABLE @Data(lt_data).

          SORT lt_data BY draftentitycreationdatetime DESCENDING.
          data(lv_data) = VALUE #( lt_data[ 1 ] OPTIONAL ).

            SELECT FROM zdjs_xl_data_dr
                FIELDS COUNT( * )
                WHERE enduser = @ls_original-EndUser
                and fileid = @ls_original-FileId
                and draftentitylastchangedatetime = @lv_data-draftentitycreationdatetime
                INTO @<ld_field>.

            if <ld_field> is INITIAL.
                SELECT FROM zdjs_excel_data
                FIELDS COUNT( * )
                WHERE end_user = @ls_original-EndUser
                and file_id = @ls_original-FileId
                INTO @<ld_field>.
            ENDIF.

*          SELECT FROM zdjs_excel_data
*            FIELDS COUNT( * )
*            WHERE end_user = @ls_original-EndUser
*            and file_id = @ls_original-FileId
*            INTO @<ld_field>.
        ENDIF.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

  METHOD if_sadl_exit_calc_element_read~get_calculation_info.

  ENDMETHOD.

ENDCLASS.

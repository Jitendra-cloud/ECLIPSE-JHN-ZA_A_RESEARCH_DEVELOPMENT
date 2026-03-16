CLASS zjs_cl_nr_util DEFINITION PUBLIC FINAL CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.



CLASS ZJS_CL_NR_UTIL IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.	
    " Maintain No Range Object
    DATA:
      lv_object   TYPE cl_numberrange_objects=>nr_attributes-object,  "nrobj
      lv_devclass TYPE devclass,    "cl_numberrange_objects=>nr_attributes-devclass,
      lv_corrnr   TYPE trkorr.  "cl_numberrange_objects=>nr_attributes-corrnr.

    lv_object = 'ZJSNUM_TL'.  ""Domain
    lv_devclass = 'ZJS_NUMBER_RANGE'.  ""Package
    lv_corrnr = 'TRLK910074'.  ""TR NO


    TRY.
        cl_numberrange_objects=>create(
                                  EXPORTING
                                    attributes = VALUE #( object = lv_object
                                                          domlen = 'ZJS_DO_TLR_ID'
                                                          percentage = 10
                                                          buffer = abap_on
                                                          noivbuffer = 10
                                                          devclass = lv_devclass
                                                          corrnr = lv_corrnr )
                                    obj_text = VALUE #( object = lv_object
                                                        langu = sy-langu
                                                        txt = 'Timing Letter No.'
                                                        txtshort = 'Create Timing Letter No.' )
                                  IMPORTING
                                    errors = DATA(lt_error)
                                    returncode = DATA(lv_returncode) ).

*        cl_numberrange_objects=>update(
*                             EXPORTING
*                               attributes = VALUE #( object = lv_object
*                                                     domlen = 'ZPDBP'
*                                                     percentage = 10
*                                                     buffer = abap_on
*                                                     noivbuffer = 10
*                                                     devclass = lv_devclass
*                                                     corrnr = lv_corrnr )
*                               obj_text = VALUE #( object = lv_object
*                                                   langu = sy-langu
*                                                   txt = 'Patner No'
*                                                   txtshort = 'Create Partner No.' )
*                             IMPORTING
*                               errors = lt_error
*                               returncode = lv_returncode ).
*
*        cl_numberrange_objects=>delete(
*                                  EXPORTING
*                                    object = lv_object
*                                    corrnr = lv_corrnr ).
*
*        cl_numberrange_objects=>read(
*                                  EXPORTING
*                                    language = sy-langu
*                                    object = lv_object
*                                  IMPORTING
*                                    attributes = DATA(ls_attributes)
*                                    interval_exists = DATA(lv_interval_exists)
*                                    obj_text = DATA(obj_text) ).

      CATCH cx_number_ranges. " cx_nr_object_not_found.
    ENDTRY.

    " Maintain No Range Intervals

    DATA: "lv_object   TYPE cl_numberrange_objects=>nr_attributes-object,
           lt_interval TYPE cl_numberrange_intervals=>nr_interval.
*          ls_interval TYPE cl_numberrange_intervals=>nr_nriv_line.

    "lv_object = 'Z_TEST_03'.
    " Intervals
    APPEND VALUE #( nrrangenr = '01'
                    fromnumber = '00000001'
                    tonumber = '19999999'
                    procind = 'I' ) TO lt_interval.

    APPEND VALUE #( nrrangenr = '02'
                    fromnumber = '20000000'
                    tonumber = '29999999'
                    procind = 'I' ) TO lt_interval.

* Create Intervals
    TRY.
        out->write( |Create Intervals for Object: { lv_object } | ).
        cl_numberrange_intervals=>create(
                                    EXPORTING
                                      interval  = lt_interval
                                      object    = lv_object
                                      "subobject = ' '
                                      "option = ' '
                                    IMPORTING
                                      error     = DATA(lv_error)
                                      error_inf = DATA(ls_error)
                                      error_iv  = DATA(lt_error_iv)
                                      warning   = DATA(lv_warning) ).

*        lv_object = 'Z_TEST_03'.
* intervals
        APPEND VALUE #( nrrangenr = '01'
                        fromnumber = '00000002'
                        tonumber = '19999998'
                        procind = 'U' ) TO lt_interval.

        APPEND VALUE #( nrrangenr = '02'
                        fromnumber = '20000002'
                        tonumber = '29999997'
                        procind = 'U' ) TO lt_interval.

        cl_numberrange_intervals=>update(
                                    EXPORTING
                                      interval  = lt_interval
                                      object    = lv_object
                                      subobject = ' '
*                                      option = ' '
                                    IMPORTING
                                      error     = lv_error
                                      error_inf = ls_error
                                      error_iv  = lt_error_iv
                                      warning   = lv_warning ).

* intervals
        APPEND VALUE #( nrrangenr = '01'
                        fromnumber = '00000001'
                        tonumber = '19999999'
                        procind = 'D' ) TO lt_interval.

        APPEND VALUE #( nrrangenr = '02'
                        fromnumber = '20000000'
                        tonumber = '29999999'
                        procind = 'D' ) TO lt_interval.

        cl_numberrange_intervals=>delete(
                                    EXPORTING
                                      interval = lt_interval
                                      object = lv_object
                                      subobject = ' '
*                                      option = ' '
                                    IMPORTING
                                      error = lv_error
                                      error_inf = ls_error
                                      error_iv = lt_error_iv
                                      warning = lv_warning ).

        cl_numberrange_intervals=>read(
                                    EXPORTING
                                      nr_range_nr1 = ' '
                                      nr_range_nr2 = ' '
                                      object = lv_object
                                      subobject = ' '
                                   IMPORTING
                                      interval = lt_interval ).

*    Check No
        cl_numberrange_runtime=>number_check(
                                  EXPORTING
                                    nr_range_nr   = '01'
*                                    number        =
*                                    numeric_check =
                                    object        = lv_object
*                                    subobject     =
*                                    toyear        =
*                                    number_alpha  =
*                                    length_check  =
                                  IMPORTING
                                    returncode    = DATA(lv_rcode) ).

        cl_numberrange_runtime=>number_get(
                                  EXPORTING
*                                    ignore_buffer     =
                                    nr_range_nr       = '01'
                                    object            = lv_object
*                                    quantity          =
*                                    subobject         =
*                                    toyear            =
                                  IMPORTING
                                    number            = DATA(lv_number)
                                    returncode        = lv_rcode
*                                    returned_quantity =
                                ).

        cl_numberrange_runtime=>number_status(
                                  EXPORTING
                                    nr_range_nr = '01'
                                    object      = lv_object
*                                    subobject   =
*                                    toyear      =
                                  IMPORTING
                                    number      = lv_number ).

* RAP
*        lv_object = 'ZIG_NR5'.
*        lv_interval = '01'.
*        lv_quantity = 10.
        cl_numberrange_buffer=>get_instance( )->if_numberrange_buffer~number_get_main_memory(
          EXPORTING
            iv_object            = lv_object
*            iv_subobject         =
            iv_interval          = '01'
*            iv_quantity          =
*            iv_toyear            =
          IMPORTING
            ev_number            = DATA(lv_curr_number)
            ev_returncode        = lv_returncode
            ev_returned_quantity = DATA(lv_quantity) ).

        cl_numberrange_buffer=>get_instance( )->if_numberrange_buffer~number_get_parallel(
          EXPORTING
            iv_object     = lv_object
*            iv_subobject  =
            iv_interval   = '01'
*            iv_toyear     =
          IMPORTING
            ev_number     = lv_curr_number
            ev_returncode = lv_returncode ).

        cl_numberrange_buffer=>get_instance( )->if_numberrange_buffer~number_get_no_buffer(
          EXPORTING
            iv_object            = lv_object
*            iv_subobject         =
            iv_interval          = '01'
*            iv_toyear            =
            iv_quantity          = lv_quantity
*            iv_ignore_buffer     =
          IMPORTING
            ev_number            = lv_curr_number
            ev_returncode        = lv_returncode
*            ev_returned_quantity = lv_quantity
        ).

      CATCH cx_number_ranges.   " cx_nr_subobject. " cx_nr_object_not_found.
    ENDTRY.

  ENDMETHOD.
ENDCLASS.

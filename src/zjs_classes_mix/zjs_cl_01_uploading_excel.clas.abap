CLASS zjs_cl_01_uploading_excel DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

  INTERFACES if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZJS_CL_01_UPLOADING_EXCEL IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.


DATA: lv_file_path TYPE string,
      lv_xstring   TYPE xstring,
      lt_file_table type TABLE OF zjs_st_file_table,
      lv_rc  TYPE i,
      lt_raw       TYPE STANDARD TABLE OF zjs_do_x255.

*CALL METHOD cl_gui_frontend_services=>file_open_dialog
*  EXPORTING
*    window_title = 'Select an Excel file'
*    file_filter  = 'Excel Files (*.xlsx)|*.xlsx|'
*  CHANGING
*    file_table   = lt_file_table
*    rc           = lv_rc
*  EXCEPTIONS
*    OTHERS       = 1.

IF sy-subrc = 0 AND lv_rc > 0.
  lv_file_path = lt_file_table[ 1 ]-filename.
ENDIF.

*CALL METHOD cl_gui_frontend_services=>gui_upload
*  EXPORTING
*    filename                = lv_file_path
*    filetype                = 'BIN'
*  IMPORTING
*    filelength              = DATA(lv_filelength)
*  CHANGING
*    data_tab                = lt_raw
*  EXCEPTIONS
*    file_open_error         = 1
*    file_read_error         = 2
*    no_batch                = 3
*    gui_refuse_filetransfer = 4
*    invalid_type            = 5
*    no_authority            = 6
*    unknown_error           = 7
*    bad_data_format         = 8
*    header_not_allowed      = 9
*    separator_not_allowed   = 10
*    header_too_long         = 11
*    unknown_dp_error        = 12
*    access_denied           = 13
*    dp_out_of_memory        = 14
*    disk_full               = 15
*    dp_timeout              = 16
*    OTHERS                  = 17.

IF sy-subrc = 0.
*  CALL FUNCTION 'SCMS_BINARY_TO_XSTRING'
*    EXPORTING
*      input_length = lv_filelength
*    IMPORTING
*      buffer       = lv_xstring
*    TABLES
*      binary_tab   = lt_raw.
ENDIF.


  ENDMETHOD.
ENDCLASS.

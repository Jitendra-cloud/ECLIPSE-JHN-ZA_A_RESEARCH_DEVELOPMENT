CLASS lhc_XLData DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR XLData RESULT result.

    METHODS processData FOR MODIFY
      IMPORTING keys FOR ACTION XLData~processData RESULT result.
    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR XLData RESULT result.

ENDCLASS.

CLASS lhc_XLData IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD processData.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

ENDCLASS.

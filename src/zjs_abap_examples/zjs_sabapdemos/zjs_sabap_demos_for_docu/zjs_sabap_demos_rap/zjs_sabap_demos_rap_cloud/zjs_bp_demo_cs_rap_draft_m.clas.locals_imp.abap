CLASS lhc_calc DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR calc RESULT result.

    METHODS calculation FOR MODIFY
      IMPORTING keys FOR ACTION calc~calculation.

    METHODS delete_all FOR MODIFY
      IMPORTING keys FOR ACTION calc~delete_all.

    METHODS det_modify FOR DETERMINE ON MODIFY
      IMPORTING keys FOR calc~det_modify.

    METHODS validate FOR VALIDATE ON SAVE
      IMPORTING keys FOR calc~validate.

ENDCLASS.

CLASS lhc_calc IMPLEMENTATION.

  METHOD delete_all.
    "Purpose: The method deletes all persisted database entries.

    DATA all_keys TYPE TABLE FOR DELETE zcjs_cs_rap_draft_m.

    SELECT id FROM zdjs_cs_tab_calc INTO CORRESPONDING FIELDS OF TABLE @all_keys.

    READ ENTITIES OF zcjs_cs_rap_draft_m IN LOCAL MODE
    ENTITY calc
      ALL FIELDS WITH CORRESPONDING #( all_keys )
        RESULT DATA(lt_del).

    IF lt_del IS NOT INITIAL.

      MODIFY ENTITY IN LOCAL MODE zcjs_cs_rap_draft_m
        DELETE FROM CORRESPONDING #( lt_del ).

      APPEND VALUE #( %msg = new_message_with_text( text     = 'All persisted calculations were deleted.'
                                                                severity = if_abap_behv_message=>severity-information )
                                ) TO reported-calc.

    ELSE.
      APPEND VALUE #( %msg = new_message_with_text( text     = 'No persisted calculations available.'
                                                                severity = if_abap_behv_message=>severity-information )
                                ) TO reported-calc.

    ENDIF.

  ENDMETHOD.

  METHOD get_global_authorizations.
    "No implementation on purpose.
  ENDMETHOD.

  METHOD validate.

    "Retrieving instances based on requested keys
    READ ENTITIES OF zcjs_cs_rap_draft_m IN LOCAL MODE
     ENTITY calc
     ALL FIELDS
     WITH CORRESPONDING #( keys )
     RESULT DATA(result_validate)
     FAILED DATA(f).

    CHECK result_validate IS NOT INITIAL.

    LOOP AT result_validate ASSIGNING FIELD-SYMBOL(<fs>).


      APPEND VALUE #(  %tky                 = <fs>-%tky
                       %state_area          = 'VALIDATE_CALCULATION'
                           ) TO reported-calc.

      IF <fs>-calc_result = `Wrong operator`.
        APPEND VALUE #( %tky = <fs>-%tky ) TO failed-calc.

        APPEND VALUE #( %tky                = <fs>-%tky
                        %state_area         = 'VALIDATE_CALCULATION'
                         %msg  = new_message_with_text( text     = 'Only + - * / P allowed as operators.'
                                                       severity = if_abap_behv_message=>severity-error )
"element highlights the input field!!!
                        %element-arithm_op = if_abap_behv=>mk-on
                      ) TO reported-calc.

      ELSEIF <fs>-calc_result = `Division by 0`.

        APPEND VALUE #( %tky = <fs>-%tky ) TO failed-calc.

        APPEND VALUE #( %tky        = <fs>-%tky
                        %state_area         = 'VALIDATE_CALCULATION'
                         %msg  = new_message_with_text( text     = 'Zero division not possible.'
                                                        severity = if_abap_behv_message=>severity-error )
                        %element-arithm_op = if_abap_behv=>mk-on
                        %element-num2 = if_abap_behv=>mk-on

                      ) TO reported-calc.

      ELSEIF <fs>-calc_result = `Overflow error`.

        APPEND VALUE #( %tky = <fs>-%tky ) TO failed-calc.


        APPEND VALUE #( %tky        = <fs>-%tky
                        %state_area         = 'VALIDATE_CALCULATION'
                         %msg  = new_message_with_text( text     = 'Check the numbers. Try smaller ones.'
                                                        severity = if_abap_behv_message=>severity-error )
                       %element-num1 = if_abap_behv=>mk-on
                       %element-num2 = if_abap_behv=>mk-on

                      ) TO reported-calc.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD det_modify.

    MODIFY ENTITIES OF zcjs_cs_rap_draft_m IN LOCAL MODE
       ENTITY calc
         EXECUTE calculation
         FROM CORRESPONDING #( keys ).

  ENDMETHOD.

  METHOD calculation.

    READ ENTITIES OF zcjs_cs_rap_draft_m IN LOCAL MODE
          ENTITY calc
            FIELDS ( num1 num2 arithm_op ) WITH CORRESPONDING #( keys )
            RESULT DATA(lt_calc)
            FAILED DATA(f).

    LOOP AT lt_calc ASSIGNING FIELD-SYMBOL(<calc>).

      TRY.
          <calc>-calc_result = SWITCH #( <calc>-arithm_op
                                          WHEN `+` THEN <calc>-num1 + <calc>-num2
                                          WHEN `-` THEN <calc>-num1  -  <calc>-num2
                                          WHEN `*` THEN  <calc>-num1  * <calc>-num2
                                          WHEN `/` THEN <calc>-num1  /  <calc>-num2
                                          WHEN `P` THEN ipow( base = <calc>-num1 exp = <calc>-num2 )
                                          ELSE `Wrong operator` ).

          "Bringing "-" to the front in case of negative values in the string
          IF <calc>-calc_result CA `-`.
            <calc>-calc_result = shift_right( val = <calc>-calc_result circular = 1 ).
          ENDIF.

          "Removing trailing .0 from the string
          REPLACE PCRE `\.0+\b` IN <calc>-calc_result WITH ``.

          "Handling the fact that ABAP allows division by zero if the dividend itself is zero.
          IF <calc>-num1 = 0 AND <calc>-num2 = 0 AND <calc>-arithm_op = `/`.
            <calc>-calc_result = `Division by 0`.
          ENDIF.

        CATCH cx_sy_zerodivide.
          <calc>-calc_result = `Division by 0`.

        CATCH cx_sy_arithmetic_overflow.
          <calc>-calc_result = `Overflow error`.

      ENDTRY.

    ENDLOOP.

*    MODIFY ENTITY IN LOCAL MODE demo_cs_rap_draft_m
*            UPDATE FIELDS ( calc_result )
*            WITH VALUE #( FOR ls_calc IN lt_calc ( %tky = ls_calc-%tky  calc_result = ls_calc-calc_result ) ).

    MODIFY ENTITY IN LOCAL MODE zcjs_cs_rap_draft_m
            UPDATE FIELDS ( calc_result )
            WITH CORRESPONDING #( lt_calc ).

  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZCJS_CS_RAP_DRAFT_M DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS adjust_numbers REDEFINITION.

ENDCLASS.

CLASS lsc_ZCJS_CS_RAP_DRAFT_M IMPLEMENTATION.

  METHOD adjust_numbers.

    LOOP AT mapped-calc ASSIGNING FIELD-SYMBOL(<fs>).
      <fs>-id = <fs>-%pid.
    ENDLOOP.


  ENDMETHOD.


ENDCLASS.

CLASS lhc_ZAP_I_CUSTOMER DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zap_i_customer RESULT result.

    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE zap_i_customer.

ENDCLASS.

CLASS lhc_ZAP_I_CUSTOMER IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

METHOD earlynumbering_create.

  DATA:
    lv_max_char TYPE zap_customer-customer_id,
    lv_max_int  TYPE i.

  SELECT SINGLE MAX( customer_id )
    FROM zap_customer
    INTO @lv_max_char.

  IF lv_max_char IS INITIAL.

    lv_max_int = 1.

  ELSE.

    " 'CUS' first 3 characters, remaining 7 characters are numeric
    lv_max_int = lv_max_char+3(7).
    lv_max_int = lv_max_int + 1.

  ENDIF.

  mapped-zap_i_customer = CORRESPONDING #( entities ).

  LOOP AT mapped-zap_i_customer ASSIGNING FIELD-SYMBOL(<mapping>).

    <mapping>-CustomerId =
      |CUS{ lv_max_int WIDTH = 7 PAD = '0' ALIGN = RIGHT }|.

    lv_max_int = lv_max_int + 1.

  ENDLOOP.

ENDMETHOD.

ENDCLASS.

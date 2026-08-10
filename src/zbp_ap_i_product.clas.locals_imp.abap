CLASS lhc_ZAP_I_PRODUCT DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zap_i_product RESULT result.
    METHODS validateduplicateproduct FOR VALIDATE ON SAVE
      IMPORTING keys FOR zap_i_product~validateduplicateproduct.

    METHODS validatestock FOR VALIDATE ON SAVE
      IMPORTING keys FOR zap_i_product~validatestock.

    METHODS validateunitprice FOR VALIDATE ON SAVE
      IMPORTING keys FOR zap_i_product~validateunitprice.

    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE zap_i_product.

ENDCLASS.

CLASS lhc_ZAP_I_PRODUCT IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

*  METHOD earlynumbering_create.
*
*    DATA:
*      lv_max_char TYPE zap_product-product_id,
*      lv_max_int  TYPE i.
*
*    SELECT MAX( product_id )
*      FROM zap_product
*      INTO @lv_max_char.
*
*    IF sy-subrc <> 0 OR lv_max_char IS INITIAL.
*
*      lv_max_int = 1.
*
*    ELSE.
*
*      " Existing ID format : PRD000001
*      REPLACE FIRST OCCURRENCE OF 'PRD' IN lv_max_char WITH ''.
*      lv_max_int = CONV i( lv_max_char ).
*      lv_max_int = lv_max_int + 1.
*
*    ENDIF.
*
*    mapped-zap_i_product = CORRESPONDING #( entities ).
*
*    LOOP AT mapped-zap_i_product ASSIGNING FIELD-SYMBOL(<mapping>).
*
*      <mapping>-ProductId = |PRD{ lv_max_int WIDTH = 6 PAD = '0' }|.
*
*      lv_max_int = lv_max_int + 1.
*
*    ENDLOOP.
*
*  ENDMETHOD.

METHOD earlynumbering_create.
  DATA: lv_max_char TYPE zap_product-product_id,
        lv_max_int  TYPE i.

  SELECT SINGLE MAX( product_id ) FROM zap_product INTO @lv_max_char.

  IF lv_max_char IS INITIAL.
    lv_max_int = 1.
  ELSE.
    " 'PRD' hamesha first 3 chars ahet, offset ne kadha (REPLACE peksha safe)
    lv_max_int = lv_max_char+3(6).
    lv_max_int = lv_max_int + 1.
  ENDIF.

  mapped-zap_i_product = CORRESPONDING #( entities ).
  LOOP AT mapped-zap_i_product ASSIGNING FIELD-SYMBOL(<mapping>).
    <mapping>-ProductId = |PRD{ lv_max_int WIDTH = 6 PAD = '0' ALIGN = RIGHT }|.
    lv_max_int = lv_max_int + 1.
  ENDLOOP.
ENDMETHOD.

  METHOD ValidateDuplicateProduct.

    READ ENTITIES OF zap_i_product IN LOCAL MODE
      ENTITY zap_i_product
        FIELDS ( ProductId ProductName Brand )
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_product).

    LOOP AT lt_product ASSIGNING FIELD-SYMBOL(<ls_product>).

      SELECT SINGLE product_id
        FROM zap_product
        WHERE product_name = @<ls_product>-ProductName
          AND brand        = @<ls_product>-Brand
          AND product_id  <> @<ls_product>-ProductId
        INTO @DATA(lv_product).

      IF sy-subrc = 0.

        APPEND VALUE #(
          %tky = <ls_product>-%tky
        ) TO failed-zap_i_product.

        APPEND VALUE #(
          %tky = <ls_product>-%tky
          %msg = new_message(
                   id       = 'ZCM_AP_PRODUCT'
                   number   = '003'
                   severity = if_abap_behv_message=>severity-error )
        ) TO reported-zap_i_product.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.
  METHOD ValidateStock.

    READ ENTITIES OF zap_i_product IN LOCAL MODE
      ENTITY zap_i_product
        FIELDS ( StockQty )
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_product).

    LOOP AT lt_product ASSIGNING FIELD-SYMBOL(<ls_product>).

      IF <ls_product>-StockQty < 0.

        APPEND VALUE #(
          %tky = <ls_product>-%tky
        ) TO failed-zap_i_product.

        APPEND VALUE #(
          %tky = <ls_product>-%tky
          %msg = new_message(
                   id       = 'ZCM_AP_PRODUCT'
                   number   = '002'
                   severity = if_abap_behv_message=>severity-error )
        ) TO reported-zap_i_product.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD ValidateUnitPrice.

    READ ENTITIES OF zap_i_product IN LOCAL MODE
      ENTITY zap_i_product
        FIELDS ( UnitPrice )
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_product).

    LOOP AT lt_product ASSIGNING FIELD-SYMBOL(<ls_product>).

      IF <ls_product>-UnitPrice IS INITIAL
         OR <ls_product>-UnitPrice <= 0.

        APPEND VALUE #(
          %tky = <ls_product>-%tky
        ) TO failed-zap_i_product.

        APPEND VALUE #(
          %tky = <ls_product>-%tky
          %msg = new_message(
                   id       = 'ZCM_AP_PRODUCT'
                   number   = '001'
                   severity = if_abap_behv_message=>severity-error )
        ) TO reported-zap_i_product.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

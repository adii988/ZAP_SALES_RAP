CLASS lhc_ZAP_I_SO_HEADER DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zap_i_so_header RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR zap_i_so_header RESULT result.

    METHODS Approve FOR MODIFY
      IMPORTING keys FOR ACTION zap_i_so_header~Approve.

    METHODS Cancel FOR MODIFY
      IMPORTING keys FOR ACTION zap_i_so_header~Cancel.

    METHODS Dispatch FOR MODIFY
      IMPORTING keys FOR ACTION zap_i_so_header~Dispatch.

    METHODS GenerateInvoice FOR MODIFY
      IMPORTING keys FOR ACTION zap_i_so_header~GenerateInvoice.

    METHODS RecordPayment FOR MODIFY
      IMPORTING keys FOR ACTION zap_i_so_header~RecordPayment.

    METHODS Reject FOR MODIFY
      IMPORTING keys FOR ACTION zap_i_so_header~Reject.

    METHODS CalculateGST FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zap_i_so_header~CalculateGST.

*    METHODS CalculateTotalAmount FOR DETERMINE ON MODIFY
*      IMPORTING keys FOR zap_i_so_header~CalculateTotalAmount.

*    METHODS ValidateCustomer FOR VALIDATE ON SAVE
*      IMPORTING keys FOR zap_i_so_header~ValidateCustomer.

    METHODS ValidateDeliveryDate FOR VALIDATE ON SAVE
      IMPORTING keys FOR zap_i_so_header~ValidateDeliveryDate.

    METHODS earlynumbering_create
      FOR NUMBERING
      IMPORTING entities FOR CREATE zap_i_so_header.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zap_i_so_header RESULT result.

    METHODS SetInitialStatus FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zap_i_so_header~SetInitialStatus.

    METHODS AutoApproveStatus FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zap_i_so_header~AutoApproveStatus.

ENDCLASS.








CLASS lhc_ZAP_I_SO_HEADER IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD Approve.

    READ ENTITIES OF zap_i_so_header
      IN LOCAL MODE
      ENTITY zap_i_so_header
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_header).

    LOOP AT lt_header INTO DATA(ls_header).

      IF ls_header-Status = 'Approved'.

        APPEND VALUE #(
          %tky = ls_header-%tky
        ) TO failed-zap_i_so_header.

        APPEND VALUE #(
          %tky = ls_header-%tky
          %msg = NEW zcm_ap_so(
                    textid = zcm_ap_so=>already_approved )
        ) TO reported-zap_i_so_header.

      ELSE.

        MODIFY ENTITIES OF zap_i_so_header
          IN LOCAL MODE
          ENTITY zap_i_so_header
          UPDATE
          FIELDS ( Status )
          WITH VALUE #(
            (
              %tky   = ls_header-%tky
              Status = 'Approved'
            )
          )
          REPORTED DATA(update_reported).

        reported = CORRESPONDING #( DEEP update_reported ).

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD Cancel.

    READ ENTITIES OF zap_i_so_header
      IN LOCAL MODE
      ENTITY zap_i_so_header
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_header).

    LOOP AT lt_header INTO DATA(ls_header).

      IF ls_header-Status = 'Cancelled'.

        APPEND VALUE #(
          %tky = ls_header-%tky
        ) TO failed-zap_i_so_header.

        APPEND VALUE #(
          %tky = ls_header-%tky
          %msg = NEW zcm_ap_so(
                    textid = zcm_ap_so=>already_cancelled )
        ) TO reported-zap_i_so_header.

      ELSE.

        MODIFY ENTITIES OF zap_i_so_header
          IN LOCAL MODE
          ENTITY zap_i_so_header
          UPDATE
          FIELDS ( Status )
          WITH VALUE #(
            (
              %tky   = ls_header-%tky
              Status = 'Cancelled'
            )
          )
          REPORTED DATA(update_reported).

        reported = CORRESPONDING #( DEEP update_reported ).

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD Dispatch.

    READ ENTITIES OF zap_i_so_header
      IN LOCAL MODE
      ENTITY zap_i_so_header
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_header).

    LOOP AT lt_header INTO DATA(ls_header).

      IF ls_header-Status = 'Dispatched'.

        APPEND VALUE #(
          %tky = ls_header-%tky
        ) TO failed-zap_i_so_header.

        APPEND VALUE #(
          %tky = ls_header-%tky
          %msg = NEW zcm_ap_so(
                    textid = zcm_ap_so=>already_dispatched )
        ) TO reported-zap_i_so_header.

      ELSEIF ls_header-Status <> 'Approved'.

        APPEND VALUE #(
          %tky = ls_header-%tky
        ) TO failed-zap_i_so_header.

        APPEND VALUE #(
          %tky = ls_header-%tky
          %msg = NEW zcm_ap_so(
                    textid = zcm_ap_so=>dispatch_not_allowed )
        ) TO reported-zap_i_so_header.

      ELSE.

        MODIFY ENTITIES OF zap_i_so_header
          IN LOCAL MODE
          ENTITY zap_i_so_header
          UPDATE
          FIELDS ( Status )
          WITH VALUE #(
            (
              %tky   = ls_header-%tky
              Status = 'Dispatched'
            )
          )
          REPORTED DATA(update_reported).

        reported = CORRESPONDING #( DEEP update_reported ).

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD GenerateInvoice.

    READ ENTITIES OF zap_i_so_header
      IN LOCAL MODE
      ENTITY zap_i_so_header
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_header).

    LOOP AT lt_header INTO DATA(ls_header).

      IF ls_header-Status = 'Invoiced'.

        APPEND VALUE #(
          %tky = ls_header-%tky
        ) TO failed-zap_i_so_header.

        APPEND VALUE #(
          %tky = ls_header-%tky
          %msg = NEW zcm_ap_so(
                    textid = zcm_ap_so=>invoice_created )
        ) TO reported-zap_i_so_header.

      ELSEIF ls_header-Status <> 'Dispatched'.

        APPEND VALUE #(
          %tky = ls_header-%tky
        ) TO failed-zap_i_so_header.

        APPEND VALUE #(
          %tky = ls_header-%tky
          %msg = NEW zcm_ap_so(
                    textid = zcm_ap_so=>invoice_not_allowed )
        ) TO reported-zap_i_so_header.

      ELSE.

*        MODIFY ENTITIES OF zap_i_so_header
*          IN LOCAL MODE
*          ENTITY zap_i_so_header
*          UPDATE
*          FIELDS ( Status )
*          WITH VALUE #(
*            (
*              %tky   = ls_header-%tky
*              Status = 'Invoiced'
*            )
*          )
*          REPORTED DATA(update_reported).
        MODIFY ENTITIES OF zap_i_so_header
        IN LOCAL MODE
        ENTITY zap_i_so_header
        UPDATE
        FIELDS ( Status BalanceAmount )
        WITH VALUE #(
                      (
                         %tky          = ls_header-%tky
                         Status        = 'Payment Pending'
                         BalanceAmount = ls_header-TotalAmount
                           )
                          )
               REPORTED DATA(update_reported).

        reported = CORRESPONDING #( DEEP update_reported ).

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD RecordPayment.

    READ ENTITIES OF zap_i_so_header
      IN LOCAL MODE
      ENTITY zap_i_so_header
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_header).

    LOOP AT lt_header INTO DATA(ls_header).

      IF ls_header-Status = 'Paid'.

        APPEND VALUE #(
          %tky = ls_header-%tky
        ) TO failed-zap_i_so_header.

        APPEND VALUE #(
          %tky = ls_header-%tky
          %msg = NEW zcm_ap_so(
                    textid = zcm_ap_so=>payment_already_recorded )
        ) TO reported-zap_i_so_header.

*      ELSEIF ls_header-Status <> 'Invoiced'.
       ELSEIF ls_header-Status <> 'Payment Pending'.

        APPEND VALUE #(
          %tky = ls_header-%tky
        ) TO failed-zap_i_so_header.

        APPEND VALUE #(
          %tky = ls_header-%tky
          %msg = NEW zcm_ap_so(
                    textid = zcm_ap_so=>payment_not_allowed )
        ) TO reported-zap_i_so_header.

      ELSE.

         MODIFY ENTITIES OF zap_i_so_header
    IN LOCAL MODE
    ENTITY zap_i_so_header
    UPDATE
    FIELDS ( Status PaidAmount BalanceAmount )
    WITH VALUE #(
      (
        %tky          = ls_header-%tky
        Status        = 'Paid'
        PaidAmount    = ls_header-TotalAmount
        BalanceAmount = 0
      )
    )
    REPORTED DATA(update_reported).

  reported = CORRESPONDING #( DEEP update_reported ).

        ENDIF.

*        MODIFY ENTITIES OF zap_i_so_header
*          IN LOCAL MODE
*          ENTITY zap_i_so_header
*          UPDATE
*          FIELDS ( Status )
*          WITH VALUE #(
*            (
*              %tky   = ls_header-%tky
*              Status = 'Paid'
*            )
*          )
*          REPORTED DATA(update_reported).
*
*        reported = CORRESPONDING #( DEEP update_reported ).
*
*      ENDIF.

    ENDLOOP.

  ENDMETHOD.
  METHOD Reject.

    READ ENTITIES OF zap_i_so_header
      IN LOCAL MODE
      ENTITY zap_i_so_header
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_header).

    LOOP AT lt_header INTO DATA(ls_header).

      IF ls_header-Status = 'Rejected'.

        APPEND VALUE #(
          %tky = ls_header-%tky
        ) TO failed-zap_i_so_header.

        APPEND VALUE #(
          %tky = ls_header-%tky
          %msg = NEW zcm_ap_so(
                    textid = zcm_ap_so=>already_rejected )
        ) TO reported-zap_i_so_header.

      ELSEIF ls_header-Status = 'Cancelled'.

        APPEND VALUE #(
          %tky = ls_header-%tky
        ) TO failed-zap_i_so_header.

        APPEND VALUE #(
          %tky = ls_header-%tky
          %msg = NEW zcm_ap_so(
                    textid = zcm_ap_so=>already_cancelled )
        ) TO reported-zap_i_so_header.

      ELSEIF ls_header-Status = 'Approved'.

        APPEND VALUE #(
          %tky = ls_header-%tky
        ) TO failed-zap_i_so_header.

        APPEND VALUE #(
          %tky = ls_header-%tky
          %msg = NEW zcm_ap_so(
                    textid = zcm_ap_so=>already_approved )
        ) TO reported-zap_i_so_header.

      ELSE.

        MODIFY ENTITIES OF zap_i_so_header
          IN LOCAL MODE
          ENTITY zap_i_so_header
          UPDATE
          FIELDS ( Status )
          WITH VALUE #(
            (
              %tky   = ls_header-%tky
              Status = 'Rejected'
            )
          )
          REPORTED DATA(update_reported).

        reported = CORRESPONDING #( DEEP update_reported ).

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD CalculateGST.

    DATA: lv_net TYPE zap_so_header-total_amount,
          lv_gst TYPE zap_so_header-total_amount.

    READ ENTITIES OF zap_i_so_header IN LOCAL MODE
      ENTITY zap_i_so_header
        FIELDS ( NetAmount )
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_header).

    DATA lt_header_update TYPE TABLE FOR UPDATE zap_i_so_header.

    LOOP AT lt_header ASSIGNING FIELD-SYMBOL(<ls_header>).

      CLEAR: lv_net,
             lv_gst.

      lv_net = <ls_header>-NetAmount.

      "18 % GST
      lv_gst = ( lv_net * 18 ) / 100.

      APPEND VALUE #(
        %tky        = <ls_header>-%tky
        TotalAmount = lv_net + lv_gst
      ) TO lt_header_update.

    ENDLOOP.

    MODIFY ENTITIES OF zap_i_so_header
      IN LOCAL MODE
      ENTITY zap_i_so_header
        UPDATE
        FIELDS ( TotalAmount )
        WITH lt_header_update
        REPORTED DATA(update_reported).

    reported = CORRESPONDING #( DEEP update_reported ).

  ENDMETHOD.




*  METHOD ValidateDeliveryDate.
*
*    CONSTANTS c_area TYPE string VALUE 'DELIVERYDATE'.
*
*    READ ENTITIES OF zap_i_so_header IN LOCAL MODE
*      ENTITY zap_i_so_header
*        FIELDS ( OrderDate DeliveryDate )
*        WITH CORRESPONDING #( keys )
*        RESULT DATA(lt_header).
*
*    LOOP AT lt_header ASSIGNING FIELD-SYMBOL(<ls_header>).
*
*      APPEND VALUE #(
*        %tky        = <ls_header>-%tky
*        %state_area = c_area
*      ) TO reported-zap_i_so_header.
*
*      IF <ls_header>-DeliveryDate IS INITIAL.
*
*        APPEND VALUE #(
*          %tky = <ls_header>-%tky
*        ) TO failed-zap_i_so_header.
*
*        APPEND VALUE #(
*          %tky                   = <ls_header>-%tky
*          %msg                   = NEW zcm_ap_so(
*                                     textid = zcm_ap_so=>field_empty )
*          %element-DeliveryDate  = if_abap_behv=>mk-on
*          %state_area            = c_area
*        ) TO reported-zap_i_so_header.
*
*      ELSEIF <ls_header>-DeliveryDate < <ls_header>-OrderDate.
*
*        APPEND VALUE #(
*          %tky = <ls_header>-%tky
*        ) TO failed-zap_i_so_header.
*
*        APPEND VALUE #(
*          %tky                   = <ls_header>-%tky
*          %msg                   = NEW zcm_ap_so(
*                                     textid = zcm_ap_so=>invalid_delivery_date )
*          %element-DeliveryDate  = if_abap_behv=>mk-on
*          %element-OrderDate     = if_abap_behv=>mk-on
*          %state_area            = c_area
*        ) TO reported-zap_i_so_header.
*
*      ENDIF.
*
*    ENDLOOP.
*
*  ENDMETHOD.

METHOD ValidateDeliveryDate.

  CONSTANTS c_area TYPE string VALUE 'DELIVERYDATE'.

  READ ENTITIES OF zap_i_so_header IN LOCAL MODE
    ENTITY zap_i_so_header
      FIELDS ( OrderDate DeliveryDate )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_header).

  LOOP AT lt_header ASSIGNING FIELD-SYMBOL(<ls_header>).

    APPEND VALUE #(
      %tky        = <ls_header>-%tky
      %state_area = c_area
    ) TO reported-zap_i_so_header.


    "--------------------------------------------------
    " 1. Order Date cannot be before today's date
    "--------------------------------------------------

    IF <ls_header>-OrderDate < cl_abap_context_info=>get_system_date( ).

*      APPEND VALUE #(
*        %tky = <ls_header>-%tky
*      ) TO failed-zap_i_so_header.
*
*      APPEND VALUE #(
*        %tky               = <ls_header>-%tky
*        %msg               = NEW zcm_ap_so(
*                               textid = zcm_ap_so=>invalid_order_date )
*        %element-OrderDate = if_abap_behv=>mk-on
*        %state_area        = c_area
*      ) TO reported-zap_i_so_header.


    "--------------------------------------------------
    " 2. Delivery Date is empty
    "--------------------------------------------------

    ELSEIF <ls_header>-DeliveryDate IS INITIAL.

      APPEND VALUE #(
        %tky = <ls_header>-%tky
      ) TO failed-zap_i_so_header.

      APPEND VALUE #(
        %tky                  = <ls_header>-%tky
        %msg                  = NEW zcm_ap_so(
                                  textid = zcm_ap_so=>field_empty )
        %element-DeliveryDate = if_abap_behv=>mk-on
        %state_area           = c_area
      ) TO reported-zap_i_so_header.


    "--------------------------------------------------
    " 3. Delivery Date cannot be before Order Date
    "--------------------------------------------------

    ELSEIF <ls_header>-DeliveryDate < <ls_header>-OrderDate.

      APPEND VALUE #(
        %tky = <ls_header>-%tky
      ) TO failed-zap_i_so_header.

      APPEND VALUE #(
        %tky                  = <ls_header>-%tky
        %msg                  = NEW zcm_ap_so(
                                  textid = zcm_ap_so=>invalid_delivery_date )
        %element-DeliveryDate = if_abap_behv=>mk-on
        %element-OrderDate    = if_abap_behv=>mk-on
        %state_area           = c_area
      ) TO reported-zap_i_so_header.

    ENDIF.

  ENDLOOP.

ENDMETHOD.


  METHOD earlynumbering_create.

    DATA:
      lv_max_char TYPE zap_so_header-sales_order_id,
      lv_max_int  TYPE i.

    SELECT MAX( sales_order_id )
      FROM zap_so_header
      INTO @lv_max_char.

    IF sy-subrc <> 0 OR lv_max_char IS INITIAL.
      lv_max_int = 1.
    ELSE.
      lv_max_int = lv_max_char.
      lv_max_int = lv_max_int + 1.
    ENDIF.


    mapped-zap_i_so_header = CORRESPONDING #( entities ).

    LOOP AT mapped-zap_i_so_header ASSIGNING FIELD-SYMBOL(<mapping>).
      <mapping>-SalesOrderId = |{ lv_max_int WIDTH = 10 PAD = '0' }|.
      lv_max_int = lv_max_int + 1.
    ENDLOOP.

  ENDMETHOD.




  METHOD get_instance_features.

    READ ENTITIES OF zap_i_so_header IN LOCAL MODE
      ENTITY zap_i_so_header
        FIELDS ( Status )
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_header).

    result = VALUE #( FOR ls_header IN lt_header
      ( %tky = ls_header-%tky

        %action-Approve         = COND #( WHEN ls_header-Status = 'Pending Approval'
                                           THEN if_abap_behv=>fc-o-enabled
                                           ELSE if_abap_behv=>fc-o-disabled )

        %action-Reject          = COND #( WHEN ls_header-Status = 'Pending Approval'
                                           THEN if_abap_behv=>fc-o-enabled
                                           ELSE if_abap_behv=>fc-o-disabled )

        %action-Cancel          = COND #( WHEN ls_header-Status = 'New'
                                              OR ls_header-Status = 'Pending Approval'
                                              OR ls_header-Status = 'Approved'
                                           THEN if_abap_behv=>fc-o-enabled
                                           ELSE if_abap_behv=>fc-o-disabled )

        %action-Dispatch        = COND #( WHEN ls_header-Status = 'Approved'
                                           THEN if_abap_behv=>fc-o-enabled
                                           ELSE if_abap_behv=>fc-o-disabled )

*        %action-GenerateInvoice = COND #( WHEN ls_header-Status = 'Dispatched'
*                                           THEN if_abap_behv=>fc-o-enabled
*                                           ELSE if_abap_behv=>fc-o-disabled )
         %action-GenerateInvoice = COND #( WHEN ls_header-Status = 'Dispatched'
                                   THEN if_abap_behv=>fc-o-enabled
                                   ELSE if_abap_behv=>fc-o-disabled )

          %action-RecordPayment   = COND #( WHEN ls_header-Status = 'Payment Pending'
                                   THEN if_abap_behv=>fc-o-enabled
                                   ELSE if_abap_behv=>fc-o-disabled )
*         %action-RecordPayment   = COND #( WHEN ls_header-Status = 'Invoiced'
*                                   THEN if_abap_behv=>fc-o-enabled
*                                   ELSE if_abap_behv=>fc-o-disabled )
      ) ).

  ENDMETHOD.


  METHOD SetInitialStatus.

    MODIFY ENTITIES OF zap_i_so_header
      IN LOCAL MODE
      ENTITY zap_i_so_header
      UPDATE FIELDS ( Status )
      WITH VALUE #( FOR key IN keys
        ( %tky = key-%tky Status = 'New' ) ).

  ENDMETHOD.


  METHOD AutoApproveStatus.

    READ ENTITIES OF zap_i_so_header IN LOCAL MODE
      ENTITY zap_i_so_header
        FIELDS ( NetAmount Status )
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_header).

    DATA lt_update TYPE TABLE FOR UPDATE zap_i_so_header.

    LOOP AT lt_header INTO DATA(ls_header).

      " फक्त 'New' / 'Pending Approval' state मध्येच auto-decide करायचं
      " (Approved/Rejected/Dispatched/Cancelled वगैरे झालेल्यांना touch करू नये)
      IF ls_header-Status = 'New' OR ls_header-Status = 'Pending Approval'.

        IF ls_header-NetAmount < 5000.
          APPEND VALUE #( %tky = ls_header-%tky Status = 'Approved' ) TO lt_update.
        ELSE.
          APPEND VALUE #( %tky = ls_header-%tky Status = 'Pending Approval' ) TO lt_update.
        ENDIF.

      ENDIF.

    ENDLOOP.

    IF lt_update IS NOT INITIAL.
      MODIFY ENTITIES OF zap_i_so_header
        IN LOCAL MODE
        ENTITY zap_i_so_header
        UPDATE FIELDS ( Status )
        WITH lt_update.
    ENDIF.

  ENDMETHOD.





ENDCLASS.

CLASS lhc_ZAP_I_SO_ITEM DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS CalculateLineAmount FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zap_i_so_item~CalculateLineAmount.

*    METHODS ValidateProduct FOR VALIDATE ON SAVE
*      IMPORTING keys FOR zap_i_so_item~ValidateProduct.

    METHODS ValidateQuantity FOR VALIDATE ON SAVE
      IMPORTING keys FOR zap_i_so_item~ValidateQuantity.

    METHODS ValidateStock FOR VALIDATE ON SAVE
      IMPORTING keys FOR zap_i_so_item~ValidateStock.

    METHODS UpdateHeaderTotal FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zap_i_so_item~UpdateHeaderTotal.

    METHODS UpdateHeaderTotalOnDelete FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zap_i_so_item~UpdateHeaderTotalOnDelete.

    METHODS GetProductPrice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR ZAP_I_SO_ITEM~GetProductPrice.
    METHODS AdjustStock FOR DETERMINE ON SAVE
      IMPORTING keys FOR ZAP_I_SO_ITEM~AdjustStock.








ENDCLASS.

CLASS lhc_ZAP_I_SO_ITEM IMPLEMENTATION.

  METHOD CalculateLineAmount.

    DATA lv_lineamount TYPE zap_so_item-line_amount.

    READ ENTITIES OF zap_i_so_header IN LOCAL MODE
      ENTITY zap_i_so_item
        FIELDS ( Quantity UnitPrice LineAmount )
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_item).

    DATA lt_update TYPE TABLE FOR UPDATE zap_i_so_item.

    LOOP AT lt_item ASSIGNING FIELD-SYMBOL(<ls_item>).

      lv_lineamount = <ls_item>-Quantity * <ls_item>-UnitPrice.

      IF lv_lineamount <> <ls_item>-LineAmount.

        APPEND VALUE #(
          %tky       = <ls_item>-%tky
          LineAmount = lv_lineamount
        ) TO lt_update.

      ENDIF.

    ENDLOOP.

    IF lt_update IS NOT INITIAL.

      MODIFY ENTITIES OF zap_i_so_header
        IN LOCAL MODE
        ENTITY zap_i_so_item
        UPDATE
        FIELDS ( LineAmount )
        WITH lt_update.

    ENDIF.
  ENDMETHOD.

*  METHOD ValidateProduct.
*
*  CONSTANTS c_area TYPE string VALUE 'PRODUCT'.
*
*  READ ENTITIES OF zap_i_so_header IN LOCAL MODE
*    ENTITY ZAP_I_SO_ITEM
*      FIELDS ( ProductId )
*      WITH CORRESPONDING #( keys )
*      RESULT DATA(lt_item).
*
*  LOOP AT lt_item ASSIGNING FIELD-SYMBOL(<ls_item>).
*
*    APPEND VALUE #(
*      %tky        = <ls_item>-%tky
*      %state_area = c_area
*    ) TO reported-zap_i_so_item.
*
*    IF <ls_item>-ProductId IS INITIAL.
*
*      APPEND VALUE #(
*        %tky = <ls_item>-%tky
*      ) TO failed-zap_i_so_item.
*
*      APPEND VALUE #(
*        %tky               = <ls_item>-%tky
*        %msg               = NEW zcm_ap_so(
*                                textid = zcm_ap_so=>field_empty )
*        %element-ProductId = if_abap_behv=>mk-on
*        %state_area        = c_area
*      ) TO reported-zap_i_so_item.
*
*    ELSE.
*
*      SELECT SINGLE product_id
*        FROM zap_product
*        WHERE product_id = @<ls_item>-ProductId
*        INTO @DATA(lv_product).
*
*      IF sy-subrc <> 0.
*
*        APPEND VALUE #(
*          %tky = <ls_item>-%tky
*        ) TO failed-zap_i_so_item.
*
*        APPEND VALUE #(
*          %tky               = <ls_item>-%tky
*          %msg               = NEW zcm_ap_so(
*                                 textid = zcm_ap_so=>invalid_product )
*          %element-ProductId = if_abap_behv=>mk-on
*          %state_area        = c_area
*        ) TO reported-zap_i_so_item.
*
*      ENDIF.
*
*    ENDIF.
*
*  ENDLOOP.
*
*ENDMETHOD.

  METHOD ValidateQuantity.

    CONSTANTS c_area TYPE string VALUE 'QUANTITY'.

    READ ENTITIES OF zap_i_so_header IN LOCAL MODE
      ENTITY zap_i_so_item
        FIELDS ( Quantity )
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_item).

    LOOP AT lt_item ASSIGNING FIELD-SYMBOL(<ls_item>).

      APPEND VALUE #(
        %tky        = <ls_item>-%tky
        %state_area = c_area
      ) TO reported-zap_i_so_item.

      IF <ls_item>-Quantity IS INITIAL
         OR <ls_item>-Quantity <= 0.

        APPEND VALUE #(
          %tky = <ls_item>-%tky
        ) TO failed-zap_i_so_item.

        APPEND VALUE #(
          %tky              = <ls_item>-%tky
          %msg              = NEW zcm_ap_so(
                                textid = zcm_ap_so=>quantity_invalid )
          %element-Quantity = if_abap_behv=>mk-on
          %state_area       = c_area
        ) TO reported-zap_i_so_item.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


METHOD ValidateStock.

  READ ENTITIES OF zap_i_so_header IN LOCAL MODE
    ENTITY ZAP_I_SO_ITEM
    FIELDS ( ProductId Quantity )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_item).

  LOOP AT lt_item ASSIGNING FIELD-SYMBOL(<item>).

    SELECT SINGLE stock_qty
      FROM zap_product
      WHERE product_id = @<item>-ProductId
      INTO @DATA(lv_stock).



    IF lv_stock < <item>-Quantity.

      APPEND VALUE #(
      %tky = <item>-%tky
      ) TO failed-zap_i_so_item.

      APPEND VALUE #(
      %tky = <item>-%tky
     %msg = NEW zcm_ap_so(
          textid = zcm_ap_so=>stock_not_available
       )
      ) TO reported-zap_i_so_item.

    ENDIF.

  ENDLOOP.


ENDMETHOD.




  METHOD UpdateHeaderTotal.

    DATA lt_update TYPE TABLE FOR UPDATE zap_i_so_header.

    READ ENTITIES OF zap_i_so_header IN LOCAL MODE
      ENTITY zap_i_so_item
        BY \_SalesOrder
        FROM CORRESPONDING #( keys )
        LINK DATA(lt_link).

    DATA lt_header_keys TYPE TABLE FOR READ IMPORT zap_i_so_header.

    LOOP AT lt_link ASSIGNING FIELD-SYMBOL(<link>).
      APPEND VALUE #( %tky = <link>-target-%tky ) TO lt_header_keys.
    ENDLOOP.

    SORT lt_header_keys BY %tky.
    DELETE ADJACENT DUPLICATES FROM lt_header_keys COMPARING %tky.

    LOOP AT lt_header_keys ASSIGNING FIELD-SYMBOL(<hkey>).

      READ ENTITIES OF zap_i_so_header IN LOCAL MODE
        ENTITY zap_i_so_header
          BY \_Items
          FIELDS ( LineAmount )
          WITH VALUE #( ( %tky = <hkey>-%tky ) )
          RESULT DATA(lt_all_items).

      DATA(lv_total) = REDUCE zap_so_header-net_amount(
        INIT sum = 0
        FOR it IN lt_all_items
        NEXT sum += it-LineAmount ).

      APPEND VALUE #(
        %tky      = <hkey>-%tky
        NetAmount = lv_total
      ) TO lt_update.

    ENDLOOP.

    IF lt_update IS NOT INITIAL.
      MODIFY ENTITIES OF zap_i_so_header
        IN LOCAL MODE
        ENTITY zap_i_so_header
        UPDATE
        FIELDS ( NetAmount )
        WITH lt_update.
    ENDIF.

  ENDMETHOD.
 METHOD UpdateHeaderTotalOnDelete.

  DATA lt_update TYPE TABLE FOR UPDATE zap_i_so_header.
  DATA lt_header_keys TYPE TABLE FOR READ IMPORT zap_i_so_header.

  LOOP AT keys ASSIGNING FIELD-SYMBOL(<key>).
    APPEND VALUE #( %tky-SalesOrderId = <key>-%tky-SalesOrderId
                     %is_draft        = <key>-%is_draft ) TO lt_header_keys.
  ENDLOOP.

  SORT lt_header_keys BY %tky.
  DELETE ADJACENT DUPLICATES FROM lt_header_keys COMPARING %tky.

  LOOP AT lt_header_keys ASSIGNING FIELD-SYMBOL(<hkey>).

    READ ENTITIES OF zap_i_so_header IN LOCAL MODE
      ENTITY zap_i_so_header
        BY \_Items
        FIELDS ( LineAmount )
        WITH VALUE #( ( %tky = <hkey>-%tky ) )
        RESULT DATA(lt_all_items).

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<del_key>).
      DELETE lt_all_items WHERE ItemUuid = <del_key>-ItemUuid.
    ENDLOOP.

    DATA(lv_total) = REDUCE zap_so_header-net_amount(
      INIT sum = 0
      FOR it IN lt_all_items
      NEXT sum += it-LineAmount ).

    APPEND VALUE #(
      %tky      = <hkey>-%tky
      NetAmount = lv_total
    ) TO lt_update.

  ENDLOOP.

  IF lt_update IS NOT INITIAL.
    MODIFY ENTITIES OF zap_i_so_header
      IN LOCAL MODE
      ENTITY zap_i_so_header
      UPDATE
      FIELDS ( NetAmount )
      WITH lt_update.
  ENDIF.

ENDMETHOD.

METHOD GetProductPrice.

  READ ENTITIES OF zap_i_so_header IN LOCAL MODE
    ENTITY zap_i_so_item
      FIELDS ( ProductId )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_item).

  DATA lt_update TYPE TABLE FOR UPDATE zap_i_so_item.

  LOOP AT lt_item ASSIGNING FIELD-SYMBOL(<ls_item>).

    SELECT SINGLE unit_price
      FROM zap_product
      WHERE product_id = @<ls_item>-ProductId
      INTO @DATA(lv_price).

    IF sy-subrc = 0.

      APPEND VALUE #(
        %tky      = <ls_item>-%tky
        UnitPrice = lv_price
      ) TO lt_update.

    ENDIF.

  ENDLOOP.

  IF lt_update IS NOT INITIAL.

    MODIFY ENTITIES OF zap_i_so_header IN LOCAL MODE
      ENTITY zap_i_so_item
      UPDATE
      FIELDS ( UnitPrice )
      WITH lt_update.

  ENDIF.

ENDMETHOD.





METHOD AdjustStock.

    TYPES: BEGIN OF ty_delta,
             product_id TYPE zap_so_item-product_id,
             delta      TYPE zap_so_item-quantity,
           END OF ty_delta.

    DATA lt_delta TYPE TABLE OF ty_delta.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<key>).

      " 1. Junya (aadhi save zalelya) quantity/product vacha
      SELECT SINGLE product_id, quantity
        FROM zap_so_item
        WHERE sales_order_id = @<key>-SalesOrderId
          AND item_uuid      = @<key>-ItemUuid
        INTO @DATA(ls_old).

      " 2. Navin (current draft-modified) quantity vacha - EML dwara
      READ ENTITIES OF zap_i_so_header IN LOCAL MODE
        ENTITY zap_i_so_item
          FIELDS ( ProductId Quantity )
          WITH VALUE #( ( %tky = <key>-%tky ) )
          RESULT DATA(lt_new).

      IF lt_new IS NOT INITIAL.
        " ---- CREATE ya UPDATE ----
        DATA(ls_new) = lt_new[ 1 ].

        IF sy-subrc <> 0 OR ls_old IS INITIAL.
          " CREATE: pura navin quantity kami kara
          APPEND VALUE #( product_id = ls_new-ProductId
                           delta      = ls_new-Quantity ) TO lt_delta.
        ELSE.
          " UPDATE: fakt farak (delta) adjust kara
          DATA(lv_diff) = ls_new-Quantity - ls_old-quantity.
          IF lv_diff <> 0.
            APPEND VALUE #( product_id = ls_new-ProductId
                             delta      = lv_diff ) TO lt_delta.
          ENDIF.
        ENDIF.

      ELSE.
        " ---- DELETE: entity aata astitvatach nahi, junya quantity परत jama kara ----
        IF ls_old IS NOT INITIAL.
          APPEND VALUE #( product_id = ls_old-product_id
                           delta      = ls_old-quantity * -1 ) TO lt_delta.
        ENDIF.
      ENDIF.

    ENDLOOP.

    CHECK lt_delta IS NOT INITIAL.

    " 3. Sagle deltas product-nusar ekatra kara (ekach product cha 2 items असतील तर)
    DATA lt_sum TYPE TABLE OF ty_delta.
    LOOP AT lt_delta INTO DATA(ls_d).
      COLLECT ls_d INTO lt_sum.
    ENDLOOP.

    " 4. Current stock vacha ani navin stock lihoo
    DATA lt_product TYPE TABLE FOR READ RESULT zap_i_product.

    READ ENTITIES OF zap_i_product
      ENTITY zap_i_product
        FIELDS ( StockQty )
        WITH VALUE #( FOR s IN lt_sum ( ProductId = s-product_id ) )
        RESULT lt_product.

    DATA lt_update TYPE TABLE FOR UPDATE zap_i_product.

    LOOP AT lt_sum INTO DATA(ls_sum).
      READ TABLE lt_product INTO DATA(ls_prod)
        WITH KEY ProductId = ls_sum-product_id.
      IF sy-subrc = 0.
        APPEND VALUE #(
          ProductId = ls_prod-ProductId
          StockQty  = ls_prod-StockQty - ls_sum-delta
        ) TO lt_update.
      ENDIF.
    ENDLOOP.

    IF lt_update IS NOT INITIAL.
      MODIFY ENTITIES OF zap_i_product
        ENTITY zap_i_product
        UPDATE FIELDS ( StockQty )
        WITH lt_update.
    ENDIF.

  ENDMETHOD.

ENDCLASS.





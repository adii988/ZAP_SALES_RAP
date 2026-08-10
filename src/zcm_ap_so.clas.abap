CLASS zcm_ap_so DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    INTERFACES if_abap_behv_message.
    INTERFACES if_t100_dyn_msg.
    INTERFACES if_t100_message.

    DATA customerid TYPE zap_customer-customer_id.
    DATA productid  TYPE zap_product-product_id.

    CONSTANTS:

      BEGIN OF already_approved,
        msgid TYPE symsgid VALUE 'ZAP_SO',
        msgno TYPE symsgno VALUE '001',
        attr1 TYPE scx_attrname VALUE 'Sales Order is already Approved',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF already_approved,

      BEGIN OF already_rejected,
        msgid TYPE symsgid VALUE 'ZAP_SO',
        msgno TYPE symsgno VALUE '002',
        attr1 TYPE scx_attrname VALUE 'Sales Order is already Rejected',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF already_rejected,

      BEGIN OF already_cancelled,
        msgid TYPE symsgid VALUE 'ZAP_SO',
        msgno TYPE symsgno VALUE '003',
        attr1 TYPE scx_attrname VALUE 'Sales Order is already Cancelled',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF already_cancelled,

      BEGIN OF invalid_customer,
        msgid TYPE symsgid VALUE 'ZAP_SO',
        msgno TYPE symsgno VALUE '004',
        attr1 TYPE scx_attrname VALUE 'Customer does not exist',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF invalid_customer,

      BEGIN OF invalid_product,
        msgid TYPE symsgid VALUE 'ZAP_SO',
        msgno TYPE symsgno VALUE '005',
        attr1 TYPE scx_attrname VALUE 'Product does not exist',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF invalid_product,

      BEGIN OF quantity_invalid,
        msgid TYPE symsgid VALUE 'ZAP_SO',
        msgno TYPE symsgno VALUE '006',
        attr1 TYPE scx_attrname VALUE 'Quantity must be greater than zero',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF quantity_invalid,

      BEGIN OF stock_not_available,
        msgid TYPE symsgid VALUE 'ZAP_SO',
        msgno TYPE symsgno VALUE '007',
        attr1 TYPE scx_attrname VALUE 'Insufficient stock available',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF stock_not_available,

      BEGIN OF invalid_delivery_date,
        msgid TYPE symsgid VALUE 'ZAP_SO',
        msgno TYPE symsgno VALUE '008',
        attr1 TYPE scx_attrname VALUE 'Delivery Date must be after Order Date',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF invalid_delivery_date,

      BEGIN OF invoice_created,
        msgid TYPE symsgid VALUE 'ZAP_SO',
        msgno TYPE symsgno VALUE '009',
        attr1 TYPE scx_attrname VALUE 'Invoice Generated Successfully',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF invoice_created,

      BEGIN OF invoice_not_allowed,
        msgid TYPE symsgid VALUE 'ZAP_SO',
        msgno TYPE symsgno VALUE '015',
        attr1 TYPE scx_attrname VALUE 'Invoice can be generated only after Dispatch',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF invoice_not_allowed,

      BEGIN OF payment_recorded,
        msgid TYPE symsgid VALUE 'ZAP_SO',
        msgno TYPE symsgno VALUE '010',
        attr1 TYPE scx_attrname VALUE 'Payment Recorded Successfully',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF payment_recorded,

      BEGIN OF field_empty,
        msgid TYPE symsgid VALUE 'ZAP_SO',
        msgno TYPE symsgno VALUE '011',
        attr1 TYPE scx_attrname VALUE 'Please enter required value',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF field_empty,

      BEGIN OF already_dispatched,
        msgid TYPE symsgid VALUE 'ZAP_SO',
        msgno TYPE symsgno VALUE '012',
        attr1 TYPE scx_attrname VALUE 'Sales Order Already Dispatched',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF already_dispatched,

      BEGIN OF dispatch_not_allowed,
        msgid TYPE symsgid VALUE 'ZAP_SO',
        msgno TYPE symsgno VALUE '013',
        attr1 TYPE scx_attrname VALUE 'Only Approved Orders can be Dispatched',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF dispatch_not_allowed,

      BEGIN OF payment_already_recorded,
        msgid TYPE symsgid VALUE 'ZAP_SO',
        msgno TYPE symsgno VALUE '016',
        attr1 TYPE scx_attrname VALUE 'Payment is already recorded',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF payment_already_recorded,

      BEGIN OF payment_not_allowed,
        msgid TYPE symsgid VALUE 'ZAP_SO',
        msgno TYPE symsgno VALUE '017',
        attr1 TYPE scx_attrname VALUE 'Payment can be recorded only after Invoice Generation',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF payment_not_allowed,

      BEGIN OF invalid_order_date,
        msgid TYPE symsgid VALUE 'ZAP_SO',
        msgno TYPE symsgno VALUE '018',
        attr1 TYPE scx_attrname VALUE 'Enter the Valid Order Date',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF invalid_order_date.

    METHODS constructor
      IMPORTING
        !textid    LIKE if_t100_message=>t100key OPTIONAL
        severity   LIKE if_abap_behv_message~m_severity OPTIONAL
        customerid TYPE zap_customer-customer_id OPTIONAL
        productid  TYPE zap_product-product_id OPTIONAL.

ENDCLASS.



CLASS zcm_ap_so IMPLEMENTATION.

  METHOD constructor ##ADT_SUPPRESS_GENERATION.

    super->constructor( ).

    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.

    IF severity IS INITIAL.
      if_abap_behv_message~m_severity =
        if_abap_behv_message=>severity-error.
    ELSE.
      if_abap_behv_message~m_severity = severity.
    ENDIF.

  ENDMETHOD.

ENDCLASS.

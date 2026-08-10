@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface CDS View for Invoice'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZAP_I_INVOICE
  as select from zap_invoice

  association [1..1] to ZAP_I_SO_HEADER as _SalesOrder
    on $projection.SalesOrderId = _SalesOrder.SalesOrderId
{
    key invoice_id  as InvoiceId,
    sales_order_id  as SalesOrderId,
    invoice_date    as InvoiceDate,
    subtotal_amount as SubtotalAmount,
    gst_percent     as GstPercent,
    gst_amount      as GstAmount,
    total_amount    as TotalAmount,
    status          as Status,
    _SalesOrder
}

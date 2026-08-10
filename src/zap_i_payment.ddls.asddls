@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface CDS View for Payment'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZAP_I_PAYMENT
  as select from zap_payment

  association [1..1] to ZAP_I_INVOICE as _Invoice
    on $projection.InvoiceId = _Invoice.InvoiceId

{
    key payment_id  as PaymentId,
    invoice_id      as InvoiceId,
    payment_date    as PaymentDate,
    payment_mode    as PaymentMode,
    amount          as Amount,
    transaction_id  as TransactionId,
    status          as Status,
    _Invoice
    
}

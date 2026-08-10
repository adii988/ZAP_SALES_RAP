@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface CDS Sales Order Header'
@Metadata.ignorePropagatedAnnotations: true

define root view entity ZAP_I_SO_HEADER
  as select from zap_so_header

  association [1..1] to ZAP_I_CUSTOMER as _Customer
    on $projection.CustomerId = _Customer.CustomerId

  composition [0..*] of ZAP_I_SO_ITEM as _Items
{
  key sales_order_id as SalesOrderId,

      customer_id    as CustomerId,
      order_date     as OrderDate,
      delivery_date  as DeliveryDate,
      currency       as Currency,
      total_amount   as TotalAmount,
      net_amount     as NetAmount,
      status         as Status,
      paid_amount    as PaidAmount,
      balance_amount as BalanceAmount,

      @Semantics.systemDateTime.lastChangedAt: true
      lastchangedat  as ChangedAt,
      @Semantics.user.lastChangedBy: true
      localchangedby as ChangedBy,
      _Customer,
      _Items
}

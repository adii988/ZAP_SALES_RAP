@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface CDS View for Sales Order Item'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZAP_I_SO_ITEM
  as select from zap_so_item

  association [1..1] to ZAP_I_PRODUCT as _Product
    on $projection.ProductId = _Product.ProductId
    
   association to parent ZAP_I_SO_HEADER as _SalesOrder
    on $projection.SalesOrderId = _SalesOrder.SalesOrderId

{
    key sales_order_id as SalesOrderId,
    key item_uuid as ItemUuid,
     item_no        as ItemNo,
    product_id         as ProductId,
    quantity           as Quantity,
    unit_price         as UnitPrice,
    line_amount        as LineAmount,
    @Semantics.systemDateTime.lastChangedAt: true
      lastchangedat  as ChangedAt,
      @Semantics.user.lastChangedBy: true
      localchangedby as ChangedBy,
    _Product,
    _SalesOrder 
}

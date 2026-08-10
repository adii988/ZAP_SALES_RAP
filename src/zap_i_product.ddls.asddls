@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface CDS View for Product'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZAP_I_PRODUCT
  as select from zap_product
{
    key product_id as ProductId,
    product_name as ProductName,
    category as Category,
    brand as Brand,
    unit_price as UnitPrice,
    currency as Currency,
    stock_qty as StockQty,
    @Semantics.systemDateTime.lastChangedAt: true
      lastchangedat  as ChangedAt,
      @Semantics.user.lastChangedBy: true
      localchangedby as ChangedBy
}

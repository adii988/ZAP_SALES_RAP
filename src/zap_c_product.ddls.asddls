@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection CDS for Product'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZAP_C_PRODUCT
  provider contract transactional_query as projection on ZAP_I_PRODUCT
{
    key ProductId,
    ProductName,
    Category,
    Brand,
    UnitPrice,
    Currency,
    StockQty,
    ChangedAt,
    ChangedBy
}

@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection CDS for Sales Order Item'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZAP_C_SO_ITEM
  as projection on ZAP_I_SO_ITEM
{
  key SalesOrderId,
  key ItemUuid,
      ItemNo,
      @Consumption.valueHelpDefinition: [
      {
      entity: {
        name    : 'ZAP_C_PRODUCT',
        element : 'ProductId'
      }
      }
      ]
      ProductId,
      Quantity,
      UnitPrice,
      LineAmount,
      ChangedAt,
      ChangedBy,
      /* Associations */
      _Product,
      _SalesOrder : redirected to parent ZAP_C_SO_HEADER
}

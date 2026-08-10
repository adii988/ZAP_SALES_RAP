@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection CDS for Sales Order Header'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZAP_C_SO_HEADER
  provider contract transactional_query
  as projection on ZAP_I_SO_HEADER
{
    key SalesOrderId,
    @Consumption.valueHelpDefinition: [
      {
      entity: {
        name    : 'ZAP_C_CUSTOMER',
        element : 'CustomerId'
      }
      }
      ]
    CustomerId,
    OrderDate,
    DeliveryDate,
   @Consumption.valueHelpDefinition: [
  { entity: { name: 'I_Currency', element: 'Currency' } }
]
    Currency,
    TotalAmount,
    NetAmount,
    Status,
    PaidAmount,
    BalanceAmount,
    ChangedAt,
    ChangedBy,
    /* Associations */
    _Customer,
    _Items : redirected to composition child ZAP_C_SO_ITEM
}

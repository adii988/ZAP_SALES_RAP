@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection CDS for Customer'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZAP_C_CUSTOMER
provider contract transactional_query as projection on ZAP_I_CUSTOMER
{
    key CustomerId,
    CustomerName,
    Email,
    Phone,

    City,
    PostalCode,
    State,
    Country,
    Status,
    ChangedAt,
    ChangedBy
}

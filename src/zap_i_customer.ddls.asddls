@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface CDS View for Customer'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZAP_I_CUSTOMER as select from zap_customer
{
    key customer_id as CustomerId,
    customer_name as CustomerName,
  
    email as Email,
    phone as Phone,

    city as City,
    state as State,
    country as Country,
    postal_code as PostalCode,
    status as Status,
      @Semantics.systemDateTime.lastChangedAt: true
      lastchangedat  as ChangedAt,
      @Semantics.user.lastChangedBy: true
      localchangedby as ChangedBy
}

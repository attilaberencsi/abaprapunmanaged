@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'MySalesOrder Interface View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_MySalesOrder 
  as select from zvbak as MySalesOrder
{
  key id      as SalesOrderID,
  
      kunnr   as Customer,
      memo1   as MemoText1,
      memo2   as MemoText2,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      zeitpkt as LocalLastChangedAt,
      @Semantics.amount.currencyCode: 'Currency'
      netwr as NetAmount,
      waerk as Currency,
      status as Status
}

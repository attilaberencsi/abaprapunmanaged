@EndUserText.label: 'MySalesOrder Projection View'
@AccessControl.authorizationCheck: #CHECK
@Search.searchable: true
@Metadata.allowExtensions: true
define root view entity ZC_MySalesOrder
  as projection on ZI_MySalesOrder as MySalesOrder
{
  key SalesOrderID,
      @Consumption.valueHelpDefinition: [
      { entity:  { name:    'I_Customer_VH',
                   element: 'Customer' }
      }]
      Customer,
      @EndUserText.label: 'Notiz 1'
      @Search.defaultSearchElement: true
      MemoText1,
      @EndUserText.label: 'Notiz 2'      
      @Search.defaultSearchElement: true      
      MemoText2,
      LocalLastChangedAt,
      NetAmount,
      Currency,
      Status
}

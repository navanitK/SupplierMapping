public class SupplierSummaryController{

    @AuraEnabled(cacheable=true)
    public static Object getSupplierData(String accountId, String city, String supplierName, Integer pageSize, Integer pageNumber){
        try {
            Integer offset = (pageNumber - 1) * pageSize;
            String searchKeyword = '%'+supplierName+'%';
            List<Supplier__c> suppliers = new List<Supplier__c> ();
            if(supplierName != null){
                
                suppliers = Database.query(
                ' SELECT id, Name, City__c, SupplierLocation__c ' + 
                ' FROM Supplier__c ' + 
                ' WHERE Name like : searchKeyword');
            }else {
                suppliers = Database.query(
                ' SELECT id, Name, City__c, SupplierLocation__c ' + 
                ' FROM Supplier__c ');
            }
            
            
            System.debug('**** suppliers' + suppliers);
            return suppliers;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
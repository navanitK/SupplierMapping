public class SupplierSummaryController{

    @AuraEnabled(cacheable=true)
    public static Object getSupplierData(String city, String searchKey, Integer pageSize, Integer pageNumber){
        try {
            Integer offset = (pageNumber - 1) * pageSize;
            system.debug('\n Result' + city + searchKey + pageSize + pageNumber);
            
            SupplierSelector selector = (SupplierSelector) new OrgApplication.selector().newInstance(SupplierSelector.class);
            List<Supplier__c> suppliers = (List<Supplier__c>)selector.getSuppliersByCity( city, searchKey, pageSize, pageNumber, offset);
            system.debug('\n Result' + suppliers.size());
            Integer totalRecords = selector.getSuppliersCountByCity(city, searchKey);
            return new SupplierDataWrapper(
                suppliers,totalRecords
            );            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class SupplierDataWrapper{
        @AuraEnabled
        public List<Supplier__c> supplierData;
        @AuraEnabled
        public Integer totalRecords;
        SupplierDataWrapper(){
            supplierData = new List<Supplier__c>();
            totalRecords = 0;
        }
        SupplierDataWrapper(List<Supplier__c> suppliers, Integer total ){
            supplierData = suppliers;
            totalRecords = total;
        }

    }
}
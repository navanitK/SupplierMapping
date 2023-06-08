public class SupplierSummaryController{

    @AuraEnabled(cacheable=true)
    public static Object getSupplierData(String city, String searchKey, Integer pageSize, Integer pageNumber){
        try {
            Integer offset = (pageNumber - 1) * pageSize;
            system.debug('\n Result' + city + searchKey + pageSize + pageNumber);
            List<Supplier__c> suppliers = (List<Supplier__c>);
            SupplierSelector selector = (SupplierSelector) new OrgApplication.selector().newInstance(SupplierSelector.class);
            return new SupplierDataWrapper(
                supplierData = selector.getSuppliersByCity( city, searchKey, pageSize, pageNumber, offset),
                
            );
            return ;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class SupplierDataWrapper{
        @AuraEnabled
        public Object supplierData;
        @AuraEnabled
        public Integer totalRecords;
        SupplierDataWrapper(){
            supplierData = null;
            totalRecords = 0;
        }

    }
}
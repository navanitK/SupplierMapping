public with sharing class SupplierSelector {
    public List<Supplier__c> getSuppliersByCity (String city, String searchKey, Integer pageSize, Integer pageNumber, Integer offset){
        String searchKeyword = '%'+searchKey+'%';
        String query = '';
        QueryBuilder qb = new QueryBuilder();
        qb.setSelect(' id, Name, City__c, SupplierLocation__c').setFrom('Supplier__c');
        query = qb.query;
        if(searchKey != null){
            query = query + ' WHERE Name like : searchKeyword AND City__c = : city   WITH SECURITY_ENFORCED';
        }else{
            query = query + ' WHERE City__c = : city   WITH SECURITY_ENFORCED';
        }
        query = query + ' ORDER BY Name ';
        query = query + ' LIMIT : pageSize OFFSET : offset';
        system.debug('\n\n *** query' + query);
        return Database.query(query);
    }

    public Integer getSuppliersCountByCity (String city, String searchKey){
        String searchKeyword = '%'+searchKey+'%';
        String query = 'SELECT Count() FROM Supplier__c ';        
        
        if(searchKey != null){
            query = query + ' WHERE Name like : searchKeyword AND City__c = : city   WITH SECURITY_ENFORCED';
        }else{
            query = query + ' WHERE City__c = : city  WITH SECURITY_ENFORCED';
        }
        return Database.countQuery(query);
    }
}
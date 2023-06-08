public with sharing class SupplierSelector {
    public List<Supplier__c> getSuppliersByCity (String city, String searchKey, Integer pageSize, Integer pageNumber, Integer offset){
        String searchKeyword = '%'+searchKey+'%';
        String query = '';
        QueryBuilder qb = new QueryBuilder();
        qb.setSelect(' id, Name, City__c, SupplierLocation__c').setFrom('Supplier__c');
        query = qb.query;
        if(searchKey != null){
            query = query + ' WHERE Name like : searchKeyword AND City__c = : city';
        }else{
            query = query + ' WHERE City__c = : city';
        }
        query = query + ' ORDER BY Name ';
        query = query + ' LIMIT : pageSize OFFSET : offset ';
        system.debug('\n\n *** query' + query);
        return Database.query(query);
    }
}
public with sharing class AccountSelector {
    public List<account> getAccountsByAccountIds (Set<Id> accountIds){
        return Database.query(' SELECT id, AvgCSATRating__c ' +
                ' FROM Account ' + 
                ' Where Id in : accountIds' + 
                '  WITH SECURITY_ENFORCED');
    }
}
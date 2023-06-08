public with sharing class CaseSelector {
    public List<AggregateResult> getClosedCaseCountByAccountId(Set<Id> accountIds){
        return Database.query('SELECT AccountId, Count(Id) ClosedCaseCount FROM Case WHERE isClosed = true AND AccountId IN : accountIds  WITH SECURITY_ENFORCED GROUP BY AccountId');
    }
}
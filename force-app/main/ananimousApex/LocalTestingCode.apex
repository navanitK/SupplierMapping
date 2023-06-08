
Set<Id> accountIds = new Set<Id> {'0015i00000lzOFCAA2'};
List<AggregateResult> groupedResults = [SELECT AccountId, Count(Id) ClosedCaseCount FROM Case WHERE isClosed = true AND AccountId = : accountIds GROUP BY AccountId];
for (AggregateResult ar : groupedResults)  {
    System.debug('AccountId ' + ar.get('AccountId'));
    System.debug('Count' + ar.get('ClosedCaseCount'));
}

QueryBuilder q = new QueryBuilder();
q.setSelect('Name').setFrom('Account');
system.debug('\n\n**' + q.query);
public class CaseService implements ICaseService {    
    
    public List<Case> getCasesWithRatingSet(List<Case> records, Map<Id,Case> oldRecords){
        List<Case> casesWithUpdatedRating = new List<Case> ();
        for(Case currentCase : records){
            if(currentCase.CaseCSATRating__c != oldRecords.get(currentCase.Id).CaseCSATRating__c){
                casesWithUpdatedRating.add(currentCase);
            }   
        }
        return casesWithUpdatedRating;
    }
    /* Assumes that cases dont get re-opened. 
    *  In that scenario, when cases move from Closed to Open, we need to set the Account Rating with a different calculation.
    *  Basically taking away from the Average already set. 
    */
    public void setAverageRatingForAccount(List<Case> records){
        Set<Id> accountIds = getAccountIds(records);
        Map<Id, Integer> totalClosedCasesByAccountId = getTotalClosedCasesByAccountId(records, accountIds);
        Map<Id, Integer> totalClosedCasesInCurrentOperationByAccountId = getTotalClosedCasesInCurrentOperationByAccountId(records);  
        Map<Id, Decimal> oldAvgRatingByAccount = getOldRatingByAccount(accountIds);      
        Map<Id, Decimal> totalRatingInCurrentOperationByAccountId = getTotalRatingInCurrentOperationByAccountId(records);
        Map<Id, Decimal> newAvgRatingByAccount = doMath(totalClosedCasesByAccountId, totalClosedCasesInCurrentOperationByAccountId, oldAvgRatingByAccount, totalRatingInCurrentOperationByAccountId);
        System.debug('newAvgRatingByAccount' + newAvgRatingByAccount);
        AccountService accountService = (AccountService) new OrgApplication.service().newInstance(AccountService.class);
        accountService.setNewRating(newAvgRatingByAccount);
    }

    

    private Map<Id, Decimal> doMath(
            Map<Id, Integer> totalClosedCasesByAccountId, 
            Map<Id, Integer> totalClosedCasesInCurrentOperationByAccountId, 
            Map<Id, Decimal> oldAvgRatingByAccount, 
            Map<Id, Decimal> totalRatingInCurrentOperationByAccountId){

        Integer totalClosedAllTime = 0;
        Integer totalClosedNow = 0;
        Integer totalClosedBeforeOperation = 0; 
        Decimal oldRating = 0;
        Decimal newAvgRating = 0;
        Decimal totalRatingInOperation = 0;
        Map<Id, Decimal> newAvgRatingByAccount = new  Map<Id, Decimal>();       

        for(Id accountId : totalClosedCasesByAccountId.keySet()){
            totalClosedAllTime = totalClosedCasesByAccountId.get(accountId);
            totalClosedNow = totalClosedCasesInCurrentOperationByAccountId.get(accountId);
            totalClosedBeforeOperation = totalClosedAllTime - totalClosedNow;
            oldRating = oldAvgRatingByAccount.get(accountId);
            totalRatingInOperation = totalRatingInCurrentOperationByAccountId.get(accountId);

            system.debug('\n ****' + totalClosedAllTime + '\t' + totalClosedNow + '\t' + totalClosedBeforeOperation + '\t' + oldRating  + '\t' + totalRatingInOperation);

            newAvgRating = ((oldRating * totalClosedBeforeOperation ) + totalRatingInOperation)/totalClosedAllTime;
            system.debug('\n ****' + newAvgRating);
            newAvgRatingByAccount.put(accountId, newAvgRating);
            
        }
        return newAvgRatingByAccount;
    }

    private Map<Id, Decimal> getTotalRatingInCurrentOperationByAccountId(List<Case> records){
        Map<Id, Decimal> totalRatingByAccount = new Map<Id, Decimal>();
        for(Case currentCase : records){
            if(totalRatingByAccount.containsKey(currentCase.AccountId)){
                totalRatingByAccount.put(currentCase.AccountId, (totalRatingByAccount.get(currentCase.AccountId) + currentCase.CaseCSATRating__c));
            }else {
                totalRatingByAccount.put(currentCase.AccountId, currentCase.CaseCSATRating__c);
            }
        }
        return totalRatingByAccount;
    }

    private Map<Id, Decimal> getOldRatingByAccount(Set<Id> accountIds){
        AccountSelector accSelector = (AccountSelector) new OrgApplication.selector().newInstance(AccountSelector.class);
        List<Account> caseAccounts = accSelector.getAccountsByAccountIds(accountIds);
        Map<Id, Decimal> currentAvgRatingByAccount = new Map<Id, Decimal>();
        for(Account currentAcc : caseAccounts){
            currentAvgRatingByAccount.put(currentAcc.Id, currentAcc.AvgCSATRating__c);
        }
        return currentAvgRatingByAccount;
    }

    private Map<Id, Integer> getTotalClosedCasesInCurrentOperationByAccountId(List<Case> records){
        Map<Id, Integer> totalClosedCasesInCurrentOperationByAccountId = new Map<Id, Integer>();
        for(Case currentCase : records){
            if(totalClosedCasesInCurrentOperationByAccountId.containsKey(currentCase.AccountId)){
                totalClosedCasesInCurrentOperationByAccountId.put(currentCase.AccountId, (totalClosedCasesInCurrentOperationByAccountId.get(currentCase.AccountId) + 1));
            }else {
                totalClosedCasesInCurrentOperationByAccountId.put(currentCase.AccountId, 1);
            }
        }
        return totalClosedCasesInCurrentOperationByAccountId;
    }

    private Map<Id, Integer> getTotalClosedCasesByAccountId(List<Case> records, Set<Id> accountIds){
        CaseSelector caseSelector = (CaseSelector) new OrgApplication.selector().newInstance(CaseSelector.class);
        
        Map<Id, Integer> totalClosedCasesByAccountId = new Map<Id, Integer>();
        
        List<AggregateResult> aggResult = caseSelector.getClosedCaseCountByAccountId(accountIds);

        for(AggregateResult arRow : aggResult){
            totalClosedCasesByAccountId.put((String) arRow.get('AccountId'), (Integer) arRow.get('ClosedCaseCount'));
        }
        return totalClosedCasesByAccountId;
    }
    
    private Set<Id> getAccountIds(List<Case> records){
        Set<Id> accountIds = new Set<Id>();
        for(Case currentCase : records){
            accountIds.add(currentCase.AccountId);
        }
        return accountIds;
    }    
}
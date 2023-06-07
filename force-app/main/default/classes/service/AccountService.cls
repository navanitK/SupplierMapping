public class AccountService implements IAccountService {

    public void setNewRating(Map<Id, Decimal> ratingByAccountId){
        List<Account> accs = new List<Account>();

        for(Id currentAccId : ratingByAccountId.keySet()){
            accs.add(new Account(
                Id = currentAccId,
                AvgCSATRating__c = ratingByAccountId.get(currentAccId)
            ));
        }
        update accs;
    }

    public class ApplicationException extends Exception {}

}
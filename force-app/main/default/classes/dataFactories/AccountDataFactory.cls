public class AccountDataFactory{

    public Account getAccount(String accName, Boolean doInsert){
        Account newAcc = new Account(Name = accName, AvgCSATRating__c = 0);
        if(doInsert){
            insert newAcc;
        }
        return newAcc; 
    }
}
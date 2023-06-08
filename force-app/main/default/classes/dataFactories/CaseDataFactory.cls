public class CaseDataFactory{

    public List<Case> getCases(String accId, Boolean doInsert, Integer count){
        List<Case> cases = new List<Case>();
        for(Integer i=0; i<count ; i++){
            cases.add(new Case(
            AccountId = accId, 
            CaseCSATRating__c = 0,
            Origin = 'Phone',
            Status = 'New'
            ));
        }
        
        if(doInsert){
            insert cases;
        }
        return cases; 
    }
}
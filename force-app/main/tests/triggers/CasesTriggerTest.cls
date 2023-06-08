@IsTest(IsParallel=true)
private class CasesTriggerTest{
    private static String ACCOUNT_NAME = 'Test Account';
    private static String ACCOUNT_NAME_TWO = 'BOSE';
    private static String CASE_NAME = 'Test Case';

    @TestSetup
    static void makeData(){
        Account account =  new AccountDataFactory().getAccount(ACCOUNT_NAME, true);
        Account boseAccount =  new AccountDataFactory().getAccount(ACCOUNT_NAME_TWO, true);
        List<Case> cases = new CaseDataFactory().getCases(account.Id, true, 10);
        List<Case> boseCases = new CaseDataFactory().getCases(boseAccount.Id, true, 10);        
    }

    @IsTest 
    private static void testAfterUpdate_NoArgs_AverageRatingGetsSetForAccount() {
        Account acc = [SELECT Id, AvgCSATRating__c FROM Account WHERE name = : ACCOUNT_NAME LIMIT 1];
        List<Case> cases = new List<Case>([SELECT Id, CaseCSATRating__c, Status FROM Case WHERE AccountId = : acc.Id]);
        List<Case> casesForUpdate =  new List<Case>();
        Integer counter = 0;
        
        system.assertEquals(0, acc.AvgCSATRating__c); //Rating is initially 0 on Account as no Case is closed.
        
        for(Case currentCase : cases){
            if(counter >= 5){
                break;
            }
            casesForUpdate.add(new Case(
                Id = currentCase.Id,
                CaseCSATRating__c = 5,
                Status = CaseService.CASE_STATUS_CLOSED) );
                counter++;
        }
        Test.startTest();
        update casesForUpdate; // Here I am only updating 5 Cases. not all 10. 
        Test.stopTest();
        
        //Since I have updated 5 cases with 5 Rating 
        //average should be 25/5 = 5 
        //notice its not 25/10 , rating is only considered for Closed Cases. 

        System.assertEquals(5, [SELECT AvgCSATRating__c FROM Account WHERE Id = : acc.Id LIMIT 1].AvgCSATRating__c);

        casesForUpdate = new List<Case>();
        //Now lets update remaining Cases to Closed with 3 rating . 
       
        for(integer i = 5; i< 10 ; i ++ ){            
            casesForUpdate.add(new Case(
                Id = cases[i].Id,
                CaseCSATRating__c = 3,
                Status = CaseService.CASE_STATUS_CLOSED) );
                
        }
        update casesForUpdate;
        //new average should be 
        //(5*5 + 3*5)/10 = 4
        System.assertEquals(4, [SELECT AvgCSATRating__c FROM Account WHERE Id = : acc.Id LIMIT 1].AvgCSATRating__c);
        
    }

    @IsTest 
    private static void testAfterUpdateCrossAccounts_NoArgs_AverageRatingGetsSetForAccount() {
        Account acc = [SELECT Id, AvgCSATRating__c FROM Account WHERE name = : ACCOUNT_NAME LIMIT 1];
        Account boseAcc = [SELECT Id, AvgCSATRating__c FROM Account WHERE name = : ACCOUNT_NAME_TWO LIMIT 1];
        
        List<Case> cases = new List<Case>([SELECT Id, CaseCSATRating__c, Status FROM Case WHERE AccountId = : acc.Id]);
        List<Case> boseCases = new List<Case>([SELECT Id, CaseCSATRating__c, Status FROM Case WHERE AccountId = : boseAcc.Id]);
        
        List<Case> casesForUpdate =  new List<Case>();
        Integer counter = 0;
        
        system.assertEquals(0, acc.AvgCSATRating__c); //Rating is initially 0 on Account as no Case is closed.
        
        
        for(integer i = 0; i< 10 ; i ++ ){    
            if(i<5){
                casesForUpdate.add(new Case(
                    Id = cases[i].Id,
                    CaseCSATRating__c = 5,
                    Status = CaseService.CASE_STATUS_CLOSED) );
            }else{
                casesForUpdate.add(new Case(
                    Id = boseCases[i].Id,
                    CaseCSATRating__c = 3,
                    Status = CaseService.CASE_STATUS_CLOSED) );
            }   
        }
        Test.startTest();
        update casesForUpdate;//single operation multiple accounts. 
        Test.stopTest();
        //5 Cases for ACC1 , set to 5, resulting average = 5
        //5 Cases for ACC2 , set to 3, resulting average = 3*5 / 5 = 3

        System.assertEquals(5, [SELECT AvgCSATRating__c FROM Account WHERE Id = : acc.Id LIMIT 1].AvgCSATRating__c);
        System.assertEquals(3, [SELECT AvgCSATRating__c FROM Account WHERE Id = : boseAcc.Id LIMIT 1].AvgCSATRating__c);
        
    }
}
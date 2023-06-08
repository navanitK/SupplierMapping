public class Cases implements ITriggerHandler {
    public Cases(){
        System.System.debug('Cases Instantiated');
    }
    public void onAfterInsert(List<sObject> records){
        //This is assuming Case is not created in Closed Status, as it is not generally.
    }

    public void onAfterUpdate(List<sObject> records, Map<Id, sObject> oldRecords){
        System.debug('After Update called');
        ICaseService caseService = (ICaseService) new OrgApplication.service().newInstance(ICaseService.class);
        List<Case> casesWithUpdatedRating = caseService.getCasesWithRatingSet((List<Case>)records, (Map<Id,Case>) oldRecords);
        caseService.setAverageRatingForAccount(casesWithUpdatedRating);
    }
}
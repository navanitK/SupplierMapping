public class DomainCoordinator {

    public static void triggerHandler(){
        
        triggerHandler(
            DomainService.getDomainImplementation(Trigger.New),
            Trigger.isInsert,
            Trigger.isUpdate,
            Trigger.isBefore,
            Trigger.isAfter,
            Trigger.New,
            Trigger.OldMap );
    }

    private static void triggerHandler(
        ITriggerHandler domainObject, 
        Boolean isInsert, 
        Boolean isUpdate, 
        Boolean isBefore, 
        Boolean isAfter,
        List<sObject> records,
        Map<Id,sObject> oldRecords){

            if(domainObject == null)
            {
                return;
            }
            if(Trigger.isBefore){
                //No Implementation needed

            } else {
                if(isInsert){
                    domainObject.onAfterInsert(records);
                }
                if(isUpdate){
                    domainObject.onAfterUpdate(records, oldRecords);
                }
            }

    }
}
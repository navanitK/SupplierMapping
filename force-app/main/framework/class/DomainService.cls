public class DomainService {

    public static ITriggerHandler getDomainImplementation(List<sObject> records){
        String objectType = String.valueOf(getSobjectType(records));
        return DomainService.getDomainClassHandler(objectType);
    }

    private static ITriggerHandler getDomainClassHandler(String objectName){
        
        DomainConfiguration__mdt domainConfig = DomainConfiguration__mdt.getInstance(objectName);
        if(domainConfig.isActive__c){
            return (ITriggerHandler) Type.forName(domainConfig.DomainClassName__c).newInstance();
        }
        
        return null;
    }

    private static Schema.SObjectType getSobjectType(List<sObject> records){
        return records.getSobjectType();
    }

}
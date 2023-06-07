public interface ITriggerHandler {
    void onAfterInsert(List<sObject> records);
    void onAfterUpdate(List<sObject> records, Map<Id, sObject> oldRecords);
}
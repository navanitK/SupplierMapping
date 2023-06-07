public interface ICaseService{
    List<Case> getCasesWithRatingSet(List<Case> records, Map<Id,Case> oldRecords);
    void setAverageRatingForAccount(List<Case> records);
}
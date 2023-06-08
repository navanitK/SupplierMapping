public class QueryBuilder{
    public String query = ''; 

    public QueryBuilder setSelect(String selectStr){
        this.query = query +  'SELECT ' + selectStr;   
        return this;
    }

    public QueryBuilder setFrom(String fromStr){
        this.query = query +  ' FROM ' + fromStr;   
        return this;
    }
}
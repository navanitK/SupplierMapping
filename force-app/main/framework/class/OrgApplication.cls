public class OrgApplication {
    
    public class Service{
        public Object newInstance(Type serviceType) {
             if(serviceType == ICaseService.class) {
                return CaseServiceFactory.getService();
             } else if(serviceType == CaseService.class) {
                return new CaseService();
             } else {
                return null;
             }
        }
    }
    
    public class Selector{
        public Object newInstance(Type selectorType){
            if(selectorType == CaseSelector.class){
                return new CaseSelector();
            } else 
            if(selectorType == AccountSelector.class){
                return new AccountSelector();
            } else {
                return null;
            }
        }
    }
}
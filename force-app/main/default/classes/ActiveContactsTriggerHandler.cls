public class ActiveContactsTriggerHandler {
    
    
    public static void contactUndeleteHandler(List<Contact> newContacts) {
        
        Set<ID> accountIds = new Set<ID>();
        for(Contact con: newContacts)
        {
            if(String.isNotBlank(con.AccountId))
            {
                accountIds.add(con.AccountId);
            }
        }
        
        UpdateActiveContactsAccountServiceClass.updateContactsAccount(accountIds);
        
    }
    
    public static void ContactDeleteHandler(List<Contact> oldContacts) {
        
        Set<ID> accountIds = new Set<ID>();
        for(Contact con: oldContacts)
        {
            if(String.isNotBlank(con.AccountId))
            {
                accountIds.add(con.AccountId);
            }
        }
        
        UpdateActiveContactsAccountServiceClass.updateContactsAccount(accountIds);
        
    }
    public static void updateNoOfContactsOnAccountInsertHandler(List<Contact> newContacts)
    {
        
        Set<ID> accountIds = new Set<ID>();
        for(Contact con: newContacts)
        {
            if(String.isNotBlank(con.AccountId))
            {
                accountIds.add(con.AccountId);
            }
        }
        
        UpdateActiveContactsAccountServiceClass.updateContactsAccount(accountIds);
        
    }
    
    
    public static void updateNoOfContactsOnAccountUpdateHandler(List<Contact> newContacts, Map<Id, Contact> oldContactMap)
    {
        Set<ID> accountIds = new Set<ID>();
        for(Contact con: newContacts)
        {
            if(String.isNotBlank(con.AccountId) && oldContactMap.get(con.Id).is_Active__c != con.is_Active__c)
            {
                accountIds.add(con.AccountId);
            }
            else if(oldContactMap.get(con.Id).AccountId != con.AccountId)
            {
                accountIds.add(oldContactMap.get(con.Id).AccountId);
                accountIds.add(con.AccountId);
            }
            
        }
        
        UpdateActiveContactsAccountServiceClass.updateContactsAccount(accountIds);
    }
    
    
    
    
    
    
    
}
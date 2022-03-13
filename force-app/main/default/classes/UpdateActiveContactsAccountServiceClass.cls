public with sharing class UpdateActiveContactsAccountServiceClass {
 
    
    public static void updateContactsAccount(Set<Id> accountIds) {
        
        List<Account> accountsToUpdate = new List<Account>();
        List<Account> accountsList = [Select Id, Active_Accounts__c, 
                                      (Select Id from Contacts 
                                       where is_Active__c = true) FROM Account Where Id in :accountIds];
        
        for(Account acc : accountsList)
        {
            if(acc.Contacts.size() == 0)
            {
                acc.Active_Accounts__c = 0;
            }
            else
            {
                acc.Active_Accounts__c=(Decimal)acc.Contacts.size();
            }
            accountsToUpdate.add(acc);
                
        }
        if(accountsToUpdate.size()>0)
        {
            update accountsToUpdate;
        }
        
        //This code is was written by Manish but it had a bug so refer the above code
        /*
        List <AggregateResult> aggResultList = [Select AccountId, Count(Id) countNoOfContact 
                                                FROM 
                                                Contact WHERE is_Active__c = true 
                                                AND AccountId in :accountIds GROUP BY AccountId];

        List<Account> accList = new List<Account>();
        for(AggregateResult agg: aggResultList)
        {
            String accountId     = String.valueOf(agg.get('AccountId'));
            Integer noOfContacts = Integer.valueOf(agg.get('countNoOfContact'));

            Account acc = new Account(Id = accountId);
            acc.Active_Accounts__c = noOfContacts;
            accList.add(acc);

        }
        if(accList.size() > 0)
        {
            update accList;
        }
        */
    }
}
trigger PersonTrigger on Person__c (before insert, before update, before delete, 
                                    after insert, after delete, after update, after undelete) {
    
    switch on Trigger.operationType {
        when BEFORE_INSERT{
            List<Person__c> personListToInsert = new List<Person__c>();
            for(Person__c pobj: Trigger.new)
            {
                pobj.Health_Status__c = 'Green';
                pobj.Token__c = CTPersonController.getToken(pobj.Mobile__c);
                pobj.Status_Update_Date__c=Date.today();
                personListToInsert.add(pobj);
            }
            
        }
        
        when BEFORE_UPDATE
        {
            List<Person__c> personListToUpdate = new List<Person__c>();
            for(Person__c pobj: Trigger.new)
            {
                if(Trigger.oldMap.get(pobj.Id).Health_Status__c != pobj.Health_Status__c)
                {
                    pobj.Status_Update_Date__c=Date.today();
                    personListToUpdate.add(pobj);
                    System.debug('Inside Update Trigger.');
                }
            }
            
        }
        when else {
            
        }
    }
    

}
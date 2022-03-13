public with sharing class CTPersonTriggerHandler {
    
    public static void beforeInsert(List<Person__c> newPersonRecords) {
            for(Person__c pobj: newPersonRecords)
            {
                pobj.Health_Status__c = 'Green';
                pobj.Token__c = CTPersonController.getToken(pobj.Mobile__c);
                pobj.Status_Update_Date__c=Date.today();
            }
        
    }

    public static void beforeUpdate(List<Person__c> newPersonRecords, Map<Id, Person__c> oldPersonMap) {
            for(Person__c pobj: newPersonRecords)
            {
                if(oldPersonMap.get(pobj.Id).Health_Status__c != pobj.Health_Status__c)
                {
                    pobj.Status_Update_Date__c=Date.today();
                    System.debug('Inside Update Trigger.');
                }
            }
        
    }
    public static void afterUpdate(List<Person__c> newPersonRecords, Map<Id, Person__c> oldPersonMap) {

        Set<Id> statusChange = new Set<Id>();
        Set<Id> redStatus = new Set<Id>();
        Set<Id> yellowStatus = new Set<Id>();
        Set<Id> orangeStatus = new Set<Id>();

        for(Person__c pobj: newPersonRecords)
        {
            if(oldPersonMap.get(pobj.Id).Health_Status__c != pobj.Health_Status__c)
            {
                statusChange.add(pobj.Id); 
            }
            
            if(pobj.Health_Status__c == 'Red' && oldPersonMap.get(pobj.Id).Health_Status__c != 'Red')
            {
                redStatus.add(pobj.Id);
            }

            
        }
        List<Person__C> personToUpdate = new List<Person__C>(); 

        Set<Id> alreadyProcessed = new Set<Id>();
        alreadyProcessed.addAll(redStatus);

        //Lets add Cohabitants
        orangeStatus.addAll(CTPersonController.getCohabitants(redStatus, alreadyProcessed));

        //Lets add primaryContacts of persons in redStatus
        Set<Id> primaryContacts = CTPersonController.getPrimaryContacts(redStatus, alreadyProcessed);
        orangeStatus.addAll(primaryContacts);

        //Lets add neighbours
        yellowStatus.addAll(CTPersonController.getNeighbours(redStatus, alreadyProcessed));
        
        //Lets add secondaryContacts
        yellowStatus.addAll(CTPersonController.getSecondaryContacts(primaryContacts, alreadyProcessed));

        for(Id pid: orangeStatus)
        {
            personToUpdate.add(new Person__c(Id = pid, Health_Status__c = 'Orange'));

        }

        for(Id pid: yellowStatus)
        {
            personToUpdate.add(new Person__c(Id = pid, Health_Status__c= 'Yellow'));
        }

        if (personToUpdate.size() > 0) {
            update personToUpdate;
            Set<Id> locationIds = new Set<Id>();

            List<Location_Tracing__c> locTraces = CTLocationTracingController.getlocationByPersonIds(statusChange);
            for(Location_Tracing__c locTrac: locTraces)
            {
                locationIds.add(locTrac.Location__c);
            }
            CTLocationController.updateRedScore(locationIds);
        }
        
    
    }
}

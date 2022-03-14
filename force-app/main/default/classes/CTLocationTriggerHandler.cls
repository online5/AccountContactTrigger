
/****************************
 * Author: Deepak Patil
 * Date: 11/Jan/2021
 * Description: CT Location Trigger Handler, handles all trigger events and scenario
*****************************/
public with sharing class CTLocationTriggerHandler {
    

    //Function to make sure the new location inserted have Status as 'Green'
    public static void beforeInsert(List<Location__c> newLocationToInsert) {

        for(Location__c loc: newLocationToInsert)
        {
            loc.Status__c = 'Green';
            
        }
        
    }
    //If location's status changes to Red, then all the person who visited in the last 10 days 
    // are made to quaratine themselves i.e their health status is set to 'Yellow'
    public static void afterUpdate(List<Location__c> newLocations, Map<Id, Location__C> oldMap) {

        Set<Id> locationIds = new Set<Id>();
        for(Location__c loc: newLocations)
        {
            if(loc.Status__c == 'Red' && oldMap.get(loc.Id).Status__c != 'Red')
            {
                locationIds.add(loc.Id);
            }
        }

        List<Location_Tracing__c> locTraces = CTLocationTracingController.getLocationsByLocationIds(locationIds);
        List<Person__c> personsToUpdate = new List<Person__c>();

        for(Location_Tracing__c loc: locTraces)
        {
            Person__c personObj = new Person__C(Health_Status__c = 'Yellow', Id = loc.Person__c);
            if(!personsToUpdate.contains(personObj))
            {
                personsToUpdate.add(personObj);
            }
            
        }
        System.debug('Size of personsToUpdate: '+personsToUpdate.size());

        if(personsToUpdate.size() > 0)
        {
            update personsToUpdate;
        }

        
    }

    // If a location status is changed then Status update date of the location 
    //is set to the date when status is changed.
    public static void beforeUpdate(List<Location__c> locations, Map<Id, Location__c> oldLocationMap) 
    {
        for(Location__c locRec: locations)
            {
                if(locRec.Status__c != oldLocationMap.get(locRec.Id).Status__C )
                {
                    locRec.Status_Update_Date__c = Date.today();
                }
                
            }

    }
        
    

}

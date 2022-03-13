public with sharing class CTLocationTracingController {
    
    public static List<Location_Tracing__c> getVisitors(Set<Id> locationId) {
    
        List<Location_Tracing__c> visitorList = [SELECT Id, Person__c, Location__c, Visit_Date__c, Person__r.Health_Status__c, Person__r.Token__c 
                                                FROM Location_Tracing__c WHERE Id IN :locationId ORDER BY Visit_Date__C DESC];
        return visitorList;
        
    }

    public static List<Location_Tracing__c> getlocationByPersonIds(Set<Id> personIds)  {
        List<Location_Tracing__c> locationTracingRecords = [SELECT Id, Person__c, Location__c
                                                            FROM Location_Tracing__c 
                                                            WHERE Person__C IN :personIds AND Visit_Date__C = LAST_N_DAYS:10];
        return locationTracingRecords;

        
    }
    public static List<Location_Tracing__c> getLocationsByLocationIds(Set<Id> locationIds) {
        if(locationIds == null)
        {
            return null;
        }
        List<Location_Tracing__c> locationTracingRecords = [SELECT Id, Name, Person__r.Health_Status__c, Location__c, Visit_Date__c 
                                                                FROM Location_Tracing__c 
                                                                WHERE Person__r.Health_Status__c = 'Green' 
                                                                AND  Location__c in :locationIds AND Visit_Date__c = LAST_N_DAYS:10];
        return locationTracingRecords;
        
    }


    public static List<Location_Tracing__c> checkDuplicates(List<Location_Tracing__c> locationTraces) {
        if(locationTraces == null)
        {
            return null;
        }
        Set<Id> locationTracesLocationIds = new Set<Id>();
        Set<Id> locationTracesPersonIds = new Set<Id>();
        List<Location_Tracing__c> duplicateLocationTraces = new List<Location_Tracing__c>();

        for(Location_Tracing__c locTrac: locationTraces)
        {
            locationTracesLocationIds.add(locTrac.Location__c);
            locationTracesPersonIds.add(locTrac.Person__c);

        }

        List<Location_Tracing__c> existingLocationTraces = [Select Id, Location__c, Person__c, Visit_Date__c 
                                                            FROM Location_Tracing__c WHERE Location__c IN :locationTracesLocationIds
                                                            AND Person__c IN :locationTracesPersonIds
                                                            ];

        Map<Id, Set<Id>> SetOfPersonIdsVsLocation = new Map<Id, Set<Id>>();
        if(existingLocationTraces != null && existingLocationTraces.size() > 0)
        {

            for(Location_Tracing__c locTrac: existingLocationTraces)
            {
                    if(!SetOfPersonIdsVsLocation.containsKey(locTrac.Location__c))
                    {
                         SetOfPersonIdsVsLocation.put(locTrac.Location__c, new Set<Id>());
                    }
                     SetOfPersonIdsVsLocation.get(locTrac.Location__c).add(locTrac.Person__c);
            
            }
            for (Location_Tracing__c locTrac : locationTraces) {

                    if(SetOfPersonIdsVsLocation.containsKey(locTrac.Location__c)
                     && SetOfPersonIdsVsLocation.get(locTrac.Location__c).contains(locTrac.Person__c))
                    {
                        duplicateLocationTraces.add(locTrac);

                    }
            
                }

        }
        
        return duplicateLocationTraces;
        
        
        
    }
}
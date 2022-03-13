public with sharing class CTLocationController {


    //Query and returns no of locations corresponding with each health status

    public static Map<String, Integer> getStatusCount()
    {
        Map<String, Integer> locationStatusCountMap = new Map<String, Integer>();  

        for(AggregateResult agg: [Select Count(Id) countNo, Status__c FROM Location__c GROUP BY Status__c])
        {
            Integer countVal = Integer.valueOf(agg.get('countNo'));
            String statusVal = String.valueOf(agg.get('Status__C'));
            locationStatusCountMap.put(statusVal, countVal);
        }
        return locationStatusCountMap;
    }


    public static void updateRedScore(Set<Id> locationIds)
    {
        List<Location__c> locationToUpdate = new List<Location__c>();
        List<AggregateResult> aggResList = [SELECT Location__c, Count(Id) totalRec FROM Location_Tracing__c
                                            WHERE Location__c IN :locationIds
                                            AND Person__r.Health_Status__C = 'Red'
                                            AND Visit_Date__c = LAST_N_DAYS:10
                                            GROUP BY Location__c];
        
        for(AggregateResult agg: aggResList)
        {
            String locationId = String.valueOf(agg.get('Location__c'));
            Integer redScore = Integer.valueOf(agg.get('totalRec'));
            String status = getStatus(redScore);
            locationToUpdate.add(new Location__C(Id = locationId, Red_Score__c = redScore, Status__c = status));

        }
        if(locationToUpdate != null && locationToUpdate.size() > 0)
        {
            update locationToUpdate;
        }

    }

    public static String getStatus(Integer redScore) {
        if(redScore == 0)
        {
            return 'Green';
        }
        else if(redScore <= 5)
        {
            return 'Yellow';
        }
        else if(redScore <= 10)
        {
            return 'Orange';
        }
        else
        {
            return 'Red';
        }
        
    }


    public static List<Location__c> getRecentStatusChanges() {
        List<Location__c> locationList = [SELECT Status_Update_Date__c, Address__c, Pincode__c, Red_Score__c, Status__c, Name, Id 
                                            FROM Location__c 
                                            ORDER BY Status_Update_Date__c DESC NULLS LAST LIMIT 100];
        return locationList;
        
    }
    public static List<Location__c> searchLocations(String searchItem) {
        searchItem += '%';
        List<Location__c> locationList = [SELECT Status_Update_Date__c, Address__c, Pincode__c, Red_Score__c, Status__c, Name, Id 
                                            FROM Location__c WHERE Address__c like :searchItem OR Name like :searchItem OR Pincode__c like :searchItem];
        return locationList;
        
    }
    public static Location__c getLocationById(String locationId) {
        if(String.isBlank(locationId))
        {
            return null;
        }
        List<Location__c> locationList = [SELECT Status_Update_Date__c, Address__c, Pincode__c, Red_Score__c, Status__c, Name, Id 
        FROM Location__c where Id =:locationId];
        if(locationList != null && locationList.size() > 0)
        {
            return locationList[0];
        }
        return null;
        
    }
}
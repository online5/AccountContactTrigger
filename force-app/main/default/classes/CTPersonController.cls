public with sharing class CTPersonController {
    

    public static Map<String, Integer> getHealthStatusCount()
    {
        Map<String, Integer> healthStatusCountMap = new Map<String, Integer>();
        AggregateResult[] aggResult 
                        = [SELECT Count(Id) countNo, Health_Status__c 
                          FROM Person__c Group BY Health_Status__C ];

        for(AggregateResult agg: aggResult)
        {
            Integer no   = Integer.valueOf(agg.get('countNo'));
            String status = String.valueOf(agg.get('Health_Status__c'));
            healthStatusCountMap.put(status, no);
        }

        return healthStatusCountMap;

    }
    
    public static String getToken(String mobile) {
        if(String.isBlank(mobile))
        {
            return null;
        }
        Blob mobileHash = Crypto.generateDigest('MD5', Blob.valueOf(mobile));
        return EncodingUtil.base64Encode(mobileHash);
    }
    public static List<Person__c> getRecentHealthChanges()
    {
        List<Person__c> personList = [SELECT Id, Name,Health_Status__c, Mobile__c, 
        Status_Update_Date__c, Token__c FROM Person__c ORDER BY Status_Update_Date__c DESC NULLS LAST limit 100];
        return personList;
    }

    public static List<Person__c> searchPeople(String searchTerm) {
        List<Person__c> personList = [SELECT Id, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c 
                                    FROM Person__c 
                                    WHERE Name like :searchTerm+'%' or Mobile__c like :searchTerm+'%' or Token__c like :searchTerm+'%' ];
        return personList;
    }

    public static Set<Id> getNeighbours(Set<Id> personIds, Set<Id> alreadyProcessed)
    {
        List<People_Tracing__c> peopleTraces = [Select Id, Person_1__c, Person_2__c FROM People_Tracing__c 
                                    WHERE (Person_1__c IN :personIds OR Person_2__c IN :personIds) 
                                    AND Contact_Type__c = 'Neighbour' 
                                    AND (Person_1__r.Health_Status__c = 'Green' OR Person_2__r.Health_Status__c = 'Green')];
        Set<Id> neighbours = new Set<Id>();
        for(People_Tracing__c pobj: peopleTraces)
        {
            if(!alreadyProcessed.contains(pobj.Person_1__c))
            {
                neighbours.add(pobj.Person_1__c);
                alreadyProcessed.add(pobj.Person_1__c);
            }
            if(!alreadyProcessed.contains(pobj.Person_2__c))
            {
                neighbours.add(pobj.Person_2__c);
                alreadyProcessed.add(pobj.Person_2__c);
            }
        }
        return neighbours;

    }
    public static Set<Id> getCohabitants(Set<Id> personIds, Set<Id> alreadyProcessed)
    {
        List<String> healthStatus = new List<String>{'Green', 'Yellow'};

         List<People_Tracing__c> peopleTraces = [Select Id, Person_1__c, Person_2__c FROM People_Tracing__c 
                                                WHERE (Person_1__c IN :personIds OR Person_2__c IN :personIds) 
                                                AND Contact_Type__c = 'Cohabitant' 
                                                AND (Person_1__r.Health_Status__c IN :healthStatus OR Person_2__r.Health_Status__c IN :healthStatus)];
        Set<Id> cohabitants = new Set<Id>();
        for(People_Tracing__c pobj: peopleTraces)
        {
            if(!alreadyProcessed.contains(pobj.Person_1__c))
            {
                cohabitants.add(pobj.Person_1__c);
                alreadyProcessed.add(pobj.Person_1__c);
            }
            if(!alreadyProcessed.contains(pobj.Person_2__c))
            {
                cohabitants.add(pobj.Person_2__c);
                alreadyProcessed.add(pobj.Person_2__c);
            }
        }
        return cohabitants;
    }

    public static Set<Id> getPrimaryContacts(Set<Id> personIds, Set<Id> alreadyProcessed)
    {
        List<String> healthStatus = new List<String>{'Green', 'Yellow'};

         List<People_Tracing__c> peopleTraces = [Select Id, Person_1__c, Person_2__c FROM People_Tracing__c 
                                                WHERE (Person_1__c IN :personIds OR Person_2__c IN :personIds) 
                                                AND Contact_Type__c = 'Other' 
                                                AND Contact_Date__c = LAST_N_DAYS:10
                                                AND (Person_1__r.Health_Status__c IN :healthStatus OR Person_2__r.Health_Status__c IN :healthStatus)];
        Set<Id> primaryContacts = new Set<Id>();
        for(People_Tracing__c pobj: peopleTraces)
        {
            if(!alreadyProcessed.contains(pobj.Person_1__c))
            {
                primaryContacts.add(pobj.Person_1__c);
                alreadyProcessed.add(pobj.Person_1__c);
            }
            if(!alreadyProcessed.contains(pobj.Person_2__c))
            {
                primaryContacts.add(pobj.Person_2__c);
                alreadyProcessed.add(pobj.Person_2__c);
            }
        }
        return primaryContacts;
    }

    public static Set<Id> getSecondaryContacts(Set<Id> primaryIds , Set<Id> alreadyProcessed)
    {
        List<People_Tracing__c> peopleTraces = [Select Id, Person_1__c, Person_2__c FROM People_Tracing__c 
                                    WHERE (Person_1__c IN :primaryIds OR Person_2__c IN :primaryIds) 
                                    AND Contact_Type__c = 'Other' 
                                    AND Contact_Date__c = LAST_N_DAYS:10
                                    AND (Person_1__r.Health_Status__c = 'Green' OR Person_2__r.Health_Status__c = 'Green')];
        Set<Id> secondaryContacts = new Set<Id>();
        for(People_Tracing__c pobj: peopleTraces)
        {
            if(!alreadyProcessed.contains(pobj.Person_1__c))
            {
                secondaryContacts.add(pobj.Person_1__c);
                alreadyProcessed.add(pobj.Person_1__c);
            }
            if(!alreadyProcessed.contains(pobj.Person_2__c))
            {
                secondaryContacts.add(pobj.Person_2__c);
                alreadyProcessed.add(pobj.Person_2__c);
            }
        }
        return secondaryContacts;

    }




    public static Person__c getPersonById(String personId)
    {
        if(String.isBlank(personId))
        {
            return null;
        }
        List<Person__c> pobj = [SELECT Id, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c 
                        FROM Person__c where Id =: personId];
        if(pobj != null && pobj.size() >0)
        {
            return pobj[0];
        }
        return null;
    } 
   
}
public with sharing class CTPeopleTracingController {

    public static List<People_Tracing__c> getTraces(String personId) {
        if(String.isBlank(personId))
        {
            return null;
        }
        List<People_Tracing__c> newList =[SELECT Id, Name, Person_1__r.Health_Status__C, Person_2__r.Health_Status__C, Person_1__r.Token__c, Person_2__r.Token__c,Contact_Type__c, Contact_Date__c 
                                            FROM People_Tracing__c
                                            WHERE Person_1__C =:personId OR Person_2__C =:personId 
                                            ORDER BY Contact_Date__c DESC];
        return newList;
        
    }

    public static List<People_Tracing__c> checkDuplicates (List<People_Tracing__c> peopleTraces) {
        
        if(peopleTraces == null || peopleTraces.size() == 0)
        {
            return null;
        }

        //For collecting unique Person1 and Person2 Ids which is used to query existing records
        Set<Id> personIds = new Set<Id>();

        for(People_Tracing__c peTrac: peopleTraces)
        {
            personIds.add(peTrac.Person_1__c);
            personIds.add(peTrac.Person_2__c);
        }

        List<People_Tracing__c> duplicateTracList = new List<People_Tracing__c>();

        List<People_Tracing__c> existingPeopleTraces =[SELECT Id, Name, Contact_Date__c, Contact_Type__c, Person_1__c, Person_2__c FROM
                                                    People_Tracing__c WHERE Person_1__c IN :personIds OR Person_2__c IN: personIds];


        Map<Id,Set<Id>> personAndTheirContact = new Map<Id, Set<Id>>();


        if(existingPeopleTraces != null && existingPeopleTraces.size() >0)
        {
            for(People_Tracing__c pobjTrac: existingPeopleTraces)
            {
                if(!personAndTheirContact.containsKey(pobjTrac.Person_1__c))
                {
                    personAndTheirContact.put(pobjTrac.Person_1__c, new Set<Id>());
                }
                personAndTheirContact.get(pobjTrac.Person_1__c).add(pobjTrac.Person_2__c);

                if(!personAndTheirContact.containsKey(pobjTrac.Person_2__c))
                {
                    personAndTheirContact.put(pobjTrac.Person_2__c, new Set<Id>());
                }
                personAndTheirContact.get(pobjTrac.Person_2__c).add(pobjTrac.Person_1__c);

            }

            for(People_Tracing__c newTracObj: peopleTraces)
            {
                   if(personAndTheirContact.containsKey(newTracObj.Person_1__c) && personAndTheirContact.get(newTracObj.Person_1__c).contains(newTracObj.Person_2__c) 
                        ||
                      personAndTheirContact.containsKey(newTracObj.Person_2__c) && personAndTheirContact.get(newTracObj.Person_2__c).contains(newTracObj.Person_1__c))
                   {
                       duplicateTracList.add(newTracObj);
                   }
                   
                
            }
            

        } 
        return duplicateTracList;                                          


        
    }

    





}
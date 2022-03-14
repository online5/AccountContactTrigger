public with sharing class CTPeopleTracingTriggerHandler {
    

    //Checks whether the duplicate people trace record already exists in the database.
    public static void beforeInsert(List<People_Tracing__c> peopleTraces) {

        List<People_Tracing__c> duplicateList = new List<People_Tracing__c>();

        duplicateList = CTPeopleTracingController.checkDuplicates(peopleTraces);
        if(duplicateList != null && duplicateList.size() != 0)
        {
            for(People_Tracing__c pobj : duplicateList)
            {
                pobj.addError('Error: Duplicate people trace record cannot be inserted');
            }
        }
    }
}

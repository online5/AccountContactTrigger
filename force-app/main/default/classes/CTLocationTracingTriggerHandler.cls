public with sharing class CTLocationTracingTriggerHandler {
    
    public static void beforeInsert(List<Location_Tracing__c> locationTraces) {

        List<Location_Tracing__c> locationTracesList = CTLocationTracingController.checkDuplicates(locationTraces);
        if(locationTracesList != null && locationTracesList.size() != 0)
        {
            for(Location_Tracing__c loc: locationTracesList)
            {
                loc.addError('Duplicate location trace record found !!');
            }
        }
    }
}

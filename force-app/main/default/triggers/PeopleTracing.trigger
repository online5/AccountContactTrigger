

//Trigger on people trace object to handle before insert event
trigger PeopleTracing on People_Tracing__c (before insert) {

    switch on Trigger.operationType {
        when BEFORE_INSERT {
            CTPeopleTracingTriggerHandler.beforeInsert(Trigger.new);
            
        }
        when else {
            
        }
    }
}
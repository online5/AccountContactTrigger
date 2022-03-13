trigger AccountTrigger on Account (before insert, after insert) {

    if(Trigger.isBefore && Trigger.isInsert)
    {
        AccountTriggerHandler.HandleBeforeInsert(Trigger.new);
    }
    else if(Trigger.isAfter && Trigger.isInsert)
    {
        AccountTriggerHandler.HandleAfterInsert(Trigger.new);
    }
}
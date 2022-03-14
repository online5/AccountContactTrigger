
/***************************************************************************************
 * Author: Deepak Patil
 * Date: 10/March/22
 * Description: Trigger on Person custom object, handles events such as insert, update
***************************************************************************************/

trigger CTPersonTrigger on Person__c (before insert, before update, before delete, 
                                        after insert, after delete, after update, after undelete) {
    
    switch on Trigger.operationType {
        when BEFORE_INSERT{
            CTPersonTriggerHandler.beforeInsert(Trigger.new);
        }
        
        when BEFORE_UPDATE
        {
            CTPersonTriggerHandler.beforeUpdate(Trigger.new, Trigger.oldMap);
            
        }
        when AFTER_UPDATE {
            CTPersonTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);

        }
    }
    

}
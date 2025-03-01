/********************************************************
 * Author: Deepak Patil
 * Date: 8/March/22
 * Description: Trigger on Location object, handles events such as insert, update
**********************************************************/

trigger CTLocationTrigger on Location__c (before insert, before update, after update, after insert) {

    switch on Trigger.operationType {
        when  BEFORE_INSERT {

            CTLocationTriggerHandler.beforeInsert(Trigger.new);

        }
        when BEFORE_UPDATE {

            CTLocationTriggerHandler.beforeUpdate(Trigger.new, Trigger.oldMap);
            
        }
        when AFTER_UPDATE {
            CTLocationTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
        }
    }

}
trigger ActiveContacts on Contact (after insert, after update, after delete, after undelete) {
    
   switch on Trigger.operationType
   {    
       when AFTER_INSERT
       {
           ActiveContactsTriggerHandler.updateNoOfContactsOnAccountInsertHandler(Trigger.new);
       }
       when AFTER_UPDATE
       {
         ActiveContactsTriggerHandler.updateNoOfContactsOnAccountUpdateHandler(Trigger.New, Trigger.oldMap);           
       }
       when AFTER_DELETE
       {
        ActiveContactsTriggerHandler.ContactDeleteHandler(Trigger.old);
       }
       when AFTER_UNDELETE
       {
        ActiveContactsTriggerHandler.contactUndeleteHandler(Trigger.new);
       }
   }
       
}
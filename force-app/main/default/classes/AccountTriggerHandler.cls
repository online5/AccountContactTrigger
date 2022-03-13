public class AccountTriggerHandler {

    public static void HandleBeforeInsert(List<account> accList)
    {
        for(Account acc: accList)
        {
            acc.Description = 'Adding Description from Trigger';
        }
    }
    public static void HandleAfterInsert(List<Account> accList)
    {
        List<Task> taskListToInsert = new List<Task>();
        for(Account acc: accList)
        {
            Task newTask = new Task();
            newTask.WhatId = acc.Id;
            newTask.OwnerId = acc.OwnerId;
            newTask.Subject = 'Follow Up Task';
            taskListToInsert.add(newTask);

        }
        insert taskListToInsert;
    }
}
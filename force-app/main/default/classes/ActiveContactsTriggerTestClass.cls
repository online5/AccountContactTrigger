@isTest
public with sharing class ActiveContactsTriggerTestClass {
    
    @isTest
    public static void test_afterInsertHandlerMethod() {

        //Test Data
        List<Account> accs = new List<Account>();
        accs.add(new Account(name ='Test Account 1'));
        accs.add(new Account(name ='Test Account 2'));

        insert accs;

        List<Contact> conList = new List<Contact>();
        conList.add(new Contact(LastName='Test Contact 1', AccountId = accs[0].Id));
        conList.add(new Contact(LastName='Test Contact 2', AccountId = accs[0].Id));
        conList.add(new Contact(LastName='Test Contact 3', AccountId = accs[0].Id));
        conList.add(new Contact(LastName='Test Contact 4', AccountId = accs[1].Id));
        System.debug('DML limits before calling Test.startMethod: '+Limits.getLimitDmlStatements());
        Test.startTest();
        System.debug('DML limits in calling Test.startMethod: '+Limits.getDmlStatements());
        insert conList;
        Test.stopTest();
        List<Account> accList = [Select Id, Active_Accounts__c from Account];
        System.assertEquals(2, accList.size());
        System.assertEquals(0, accList[0].Active_Accounts__c);
        System.assertEquals(0, accList[1].Active_Accounts__c);


    }

    @isTest
    public static void test_afterInsertHandlerMethod1() {

       //Test Data
       List<Account> accs = new List<Account>();
       accs.add(new Account(name ='Test Account 1'));
       accs.add(new Account(name ='Test Account 2'));

       insert accs;

       List<Contact> conList = new List<Contact>();
       conList.add(new Contact(LastName='Test Contact 1', AccountId = accs[0].Id, is_Active__c = true ));
       conList.add(new Contact(LastName='Test Contact 2', AccountId = accs[0].Id, is_Active__c = true));
       conList.add(new Contact(LastName='Test Contact 3', AccountId = accs[0].Id, is_Active__c = true));
       conList.add(new Contact(LastName='Test Contact 4', AccountId = accs[1].Id));

       insert conList;
       List<Account> accList = [Select Id, Name, Active_Accounts__c from Account];
       for(Account acc: accList)
       {
           if(acc.Name == 'Test Account 1')
           {
                System.assertEquals(3, acc.Active_Accounts__c);
           }
           if(acc.Name == 'Test Account 2')
           {
            System.assertEquals(0, acc.Active_Accounts__c);

           }
       }

    }


}

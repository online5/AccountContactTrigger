@isTest
public class AccountControllerTest {

    @isTest
    static void test_bulkifiedCode()
    {
        Account acc = new Account(Name='TestAccount');
        insert acc;
       
        
        System.assertEquals(2, acc.Avg_Case_Resolution_Days__c);
    }
}
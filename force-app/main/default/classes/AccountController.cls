public class AccountController {

    
    //Working Code, Code Complexity(O(n))
    public static void updateAvgCaseResolutionDays_BulkifiedAndOptimized(List<Id> accountIds)
    {
        //Create two Maps 1: for totalNumberOfcases for each Account and 2: totalNumberDaysForCases for each account;
        Map<Id, Integer> totalNoOfCasesByAccount = new Map<Id, Integer>();
        Map<Id, Integer> totalNoOfDaysToCloseByAccount = new Map<Id, Integer>();
        
        List<Case> caseList = [Select Id, AccountId, CreatedDate, ClosedDate from Case where isClosed = true and AccountId in :accountIds];
		List<Account> accsToUpdate = new List<Account>();        
        for(Case cobj : caseList)
        {
            if(!totalNoOfCasesByAccount.containsKey(cobj.AccountId))
            {
                totalNoOfCasesByAccount.put(cobj.AccountId, 0);
            }
            Integer totalCases = totalNoOfCasesByAccount.get(cobj.AccountId);
            totalCases+=1;
            totalNoOfCasesByAccount.put(cobj.AccountId, totalCases);
            
            if(!totalNoOfDaysToCloseByAccount.containsKey(cobj.AccountId))
            {
                totalNoOfDaysToCloseByAccount.put(cobj.AccountId, 0);
            }
            Integer totalDays = totalNoOfDaysToCloseByAccount.get(cobj.AccountId);
            totalDays += cobj.ClosedDate.Date().daysBetween(cobj.CreatedDate.Date());
            totalNoOfDaysToCloseByAccount.put(cobj.AccountId, totalDays);
            
        }
        
        for(Account acc: [Select Id from Account where Id in: totalNoOfCasesByAccount.keySet()])
        {
            integer totalCases =totalNoOfCasesByAccount.get(acc.Id);
            integer totalNoOfDays =totalNoOfDaysToCloseByAccount.get(acc.Id);
            Decimal avgResult = totalNoOfDays/totalCases;
            acc.Avg_Case_Resolution_Days__c = avgResult;
            accsToUpdate.add(acc);
            
        }
        if(accsToUpdate.size() != 0)
        {
            update accsToUpdate;
        }
                 
    }
    //Working Code, Code Complexity O(n2)
    public static void updateAvgCaseResolutionDays_Bulkified(List<Id> accountIds)
    {
        Integer totalDays = 0, totalCases = 0;
        List<Account> accList = [Select Id, Name, Avg_Case_Resolution_Days__c,
                                (Select Id, CreatedDate, ClosedDate from Cases where isClosed = true)
                                 from Account where Id in :accountIds
                                ];
        List<Account> accsToUpdate = new List<Account>();
        for(Account acc: accList)
        {
            List<Case> caseList = acc.Cases;
            if(caseList.size() != 0)
            {
                for(Case caseObj: caseList)
                {
                    totalCases++;
                    if(caseObj != null && caseObj.CreatedDate != null && caseObj.ClosedDate != null)
                    {
                        totalDays += caseObj.ClosedDate.date().daysBetween(caseObj.CreatedDate.date());
                    }
                }
                if(totalDays !=0 )
                {
                    Decimal resolutionDays = totalDays/totalCases;
                    acc.Avg_Case_Resolution_Days__c = resolutionDays;
                    accsToUpdate.add(acc);
                }
                
            }
            totalDays=0;
            totalCases=0;
            
        }
        
        if(accsToUpdate.size() > 0)
        {
            update accsToUpdate;
        }
  
    }
    
    public static void updateAvgCaseResolutionDays(Id accountId){
        Integer totalDays = 0, totalCases = 0;
        // retrive all the cases for this account
        // get resolution days for each account (ClosedDate - CreatedDate)
        for(Case caseObj : [SELECT Id, CreatedDate, ClosedDate
                             FROM Case
                             WHERE IsClosed=true
                            	AND AccountId =: accountId]){
            // increase number of cases
            totalCases++;
            // get duration in days and add it to totalDays
            totalDays += caseObj.CreatedDate.date().daysBetween(caseObj.ClosedDate.date());
        }
        Decimal resolutionDays = totalDays/totalCases;
        // update account object
        Account acc = new Account(Id=accountId, Avg_Case_Resolution_Days__c = resolutionDays);
        update acc;
    }
}
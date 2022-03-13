trigger LeadTrigger on Lead (before update) {
    
    for(Lead lead: Trigger.new)
    {
        if(Trigger.oldMap.get(lead.Id).Status !='Working - Contacted' 
           && (lead.Status =='Closed - Not Converted'|| Lead.Status=='Closed - Converted'))
        {
            lead.Status.addError('Lead Record cannot be converted');
        }
        
    }       
    
}
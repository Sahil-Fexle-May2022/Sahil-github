public with sharing class ContactTriggerHelper{
    //In This Method We Are Counting How Many Contacts exist in One Account
    public static void totalContactPerAccount(List<Contact> newContactList){
        try{
            if(newContactList.size() > 0){                
                Set<Id> accId = new Set<Id>();  
                if(accId.size() > 0){  
                for(Contact con : newContactList){
                    accId.add(con.AccountId);
                }            
                //Here we are add accId in conList using query
                List<Contact> conList = [Select Id, Name, AccountId From Contact where AccountId in : accId];
                //Here we are create a new Map in a new map we update old contact and put into map else add a new contact in a map
                Map<Id,Decimal> totalContactMap = new Map<Id,Decimal>();
                for(Contact con : conList){
                    if(totalContactMap.containsKey(con.AccountId)){
                        Decimal contactNo = totalContactMap.get(con.AccountId)+ 1;
                        totalContactMap.put(con.AccountId,contactNo);            
                    }
                    else{
                        totalContactMap.put(con.AccountId,1);
                    }
                }    
                //Here we are update a Account Using List to put a Contact in a Bulk 
                List<Account> accList = new List<Account>();
                for(Id aId : totalContactMap.KeySet()){
                    Account acc = new Account();
                    acc.NumberOfContact__c = totalContactMap.get(aId);
                    acc.Id = aId;
                    accList.add(acc);
                }
                
                //Here we are update a accList Using Dml
                if(accList != null){
                update accList;
                }
            }
        }
    }
        catch(DmlException e){
            system.debug('An unexpected error has occurred: ' + e.getMessage());
        }
    }
}
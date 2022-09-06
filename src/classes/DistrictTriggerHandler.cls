public with sharing class DistrictTriggerHandler {
    public static void updatingDistrictCountOnStates(List<District__c> newDistricts, Map<Id, District__c> oldDistricts){
        
        //Map to hold States to be updated
        Map<Id, State__c> mapOfStatesToBeUpdated = new Map<Id, State__c>();
        
        //Traversing on Districts
        for(District__c district : (newDistricts != null ? newDistricts : oldDistricts.values())){
            
            if(district.State__c !=null){
                mapOfStatesToBeUpdated.put(district.State__c, new State__c(Id = district.State__c,Total_Districts__c = 0));
            }
            if(oldDistricts !=null && district.State__c!= oldDistricts.get(district.Id).State__c){
                mapOfStatesToBeUpdated.put(oldDistricts.get(district.Id).State__c,
                                        new State__c(Id = oldDistricts.get(district.Id).State__c,Total_Districts__c = 0));
            }

        }
        if(!mapOfStatesToBeUpdated.isEmpty()){
            for(AggregateResult result :[SELECT Count(Id)numOfDis, State__c 
                                        FROM District__c WHERE State__c in:mapOfStatesToBeUpdated.keySet() GROUP BY State__c]){
                                            mapOfStatesToBeUpdated.get((Id)result.get('State__c')).Total_Districts__c = (Decimal)result.get('numOfDis');   
            }
            update mapOfStatesToBeUpdated.values();
        }  
    }    
}
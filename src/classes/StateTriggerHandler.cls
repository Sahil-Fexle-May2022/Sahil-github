public with sharing class StateTriggerHandler {
    
    public static void stateJsonData(List<State__c> newStateList ,Map<Id,State__c> oldStateMap){
        Set<Id> stateIds = new Set<Id>();
        for(State__c state: newStateList){
            if(state.Total_Districts__c != oldStateMap.get(state.Id).Total_Districts__c){
                stateIds.add(state.Id);
            }
        }
        if(!stateIds.isEmpty()){
            Map<Id, State__c> mapOfState = new Map<Id, State__c>([SELECT Id, Name, Total_Districts__c, (SELECT Id, Name FROM Districts__r) 
                                                                  FROM State__c WHERE Id IN :stateIds]);
            
            for(State__c st: newStateList){
                if(mapOfState.containsKey(st.Id)){ 
                    State wrapState = new State();
                    wrapState.stateName = st.Name;
                    wrapState.totalDistrict = st.Total_Districts__c;
                    wrapState.districts = new List<Districts>();
                    for(District__c district: mapOfState.get(st.Id).Districts__r){
                        Districts wrapDistrict = new Districts();
                        wrapDistrict.districtName = district.Name;
                        wrapState.districts.add(wrapDistrict);
                    }
                    String jString = JSON.serialize(wrapState);
                    st.State_JSON_Data__c = jString;
                }
            }
           // system.debug(st);
            //update state;
        }
    }
    public static void  updatingStateAndDistrictCountOnCountry(List<State__c> newStates, Map<Id, State__c> oldStates){
        // Map to be hold Country updated
        Map<Id, Country__c> mapOfCountryToBeUpdated = new Map<Id, Country__c>();
        
        // Traversing on State
        for(State__c State : (newStates != null ? newStates : oldStates.values())){
            
            // check for Insert
            if(oldStates == null){
                if(State.Country__c != null){
                    mapOfCountryToBeUpdated.put(State.Country__c, new Country__c(Id = State.Country__c, Total_District__c = 0 , Total_States__c = 0));
                }
            }
            // check for Update
            else if(oldStates != null){
                if(State.Country__c != oldStates.get(State.Id).Country__c && State.Country__c != null || State.Total_Districts__c != oldStates.get(State.Id).Total_Districts__c){
                    mapOfCountryToBeUpdated.put(oldStates.get(State.Id).Country__c, new Country__c(Id = oldStates.get(State.Id).Country__c, Total_District__c = 0, Total_States__c = 0));
                    mapOfCountryToBeUpdated.put(State.Country__c, new Country__c(Id = State.Country__c, Total_District__c = 0, Total_States__c = 0));
                    
                }
                if(newStates == null){
                    mapOfCountryToBeUpdated.put(State.Country__c, new Country__c(Id = State.Country__c, Total_District__c = 0, Total_States__c = 0));
                }
            }
        }
        
        //Check if map is empty or not
        if(!mapOfCountryToBeUpdated.values().isEmpty()){
            for(AggregateResult aggDistrictState : [SELECT Country__c, COUNT(Id)totalStateId, SUM(Total_Districts__c)TotalDistrict FROM State__c WHERE Country__c IN: mapOfCountryToBeUpdated.keySet() GROUP BY Country__c]){
                System.debug(aggDistrictState);
                mapOfCountryToBeUpdated.get((Id)aggDistrictState.get('country__c')).Total_District__c = (Decimal)aggDistrictState.get('TotalDistrict') != null ? (Decimal)aggDistrictState.get('TotalDistrict') : 0;
                mapOfCountryToBeUpdated.get((Id)aggDistrictState.get('country__c')).Total_States__c = (Decimal)aggDistrictState.get('totalStateId');   
            }
        }
        if(!mapOfCountryToBeUpdated.isEmpty()){ 
            update mapOfCountryToBeUpdated.values();
        }          
    }
    //Wrapper Classes
    public List<State> states{get; set;}
    public class State{
        Public string stateName{get; set;}
        Public List<Districts> districts{get; set;}
        public Decimal totalDistrict{get; set;}
    }
    public class Districts{
        Public String districtName{get; set;}
    } 
}
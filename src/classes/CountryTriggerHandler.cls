public with sharing class CountryTriggerHandler {
    public static void countryJsonData(List<Country__c> newCountryList ,Map<Id,Country__c> oldCountryMap){

        Set<Id> setOfCountryId = new Set<Id>();
        for(Country__c cont : newCountryList){
            if(oldCountryMap != null){   
                setOfCountryId.add(cont.Id);                             
            }
        }
        if(!setOfCountryId.isEmpty()){

            Map<Id,State__c> mapOfStatewithCountry = new Map<Id,State__c>([SELECT Id, Country__c,country__r.Id,Country__r.Name,country__r.Total_States__c,
                                                                           country__r.Total_District__c, Name,Total_Districts__c,(SELECT id, Name FROM Districts__r)
                                                                           FROM State__c WHERE country__r.Id IN : setOfCountryId]);
            System.debug(mapOfStatewithCountry.values());

            for(Country__c cont : newCountryList){
                if(setOfCountryId.contains(cont.Id)) {  
                    Country wCountry = new Country();
                    wCountry.countryName = cont.Name;
                   
                    wCountry.states = new List<states>();
                    System.debug(cont.Total_District__c);
                    System.debug(cont.Total_States__c);
                    wCountry.Total_Number_Of_States = (Integer)cont.Total_States__c;
                    wCountry.Total_Number_Of_Districts = (Integer)cont.Total_District__c;

                    for(State__c st : mapOfStatewithCountry.values()){    
                        States wrapState = new States();
                        wrapState.stateName = st.Name;
                        wrapState.districts = new List<Districts>();
                        for(District__c dt : st.Districts__r){
                            Districts wrapDistrict = new Districts();
                            wrapDistrict.districtName = dt.Name;
                            wrapState.districts.add(wrapDistrict);
                        }
                        wCountry.states.add(wrapState);
                    }
                    String jString = JSON.serialize(wCountry);
                    cont.Country_JSON_Data__c = jString;
                }
            }
        }     
    }
    public List<Country> countryList{get; set;}
    public class Country{
        public String countryName{get; set;}
        public Integer Total_Number_Of_States{get; set;}
        public Integer Total_Number_Of_Districts{get; set;}
        public List<States> states{get; set;}       
    }
    public class States{
        Public string stateName{get; set;}
        Public List<Districts> districts{get; set;}
    }
    public class Districts{
        Public String districtName{get; set;}
    }
}

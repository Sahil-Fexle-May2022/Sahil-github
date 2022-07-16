public with sharing class CountryStateDataMapProcess{
    Map<String, Map<String, List<String>>> mapOfCountry = new Map<String, Map<String,List<String>>>();  
    List<Country__c> con = [SELECT Country_JSON_Data__c FROM Country__c];
    Country cont = new Country();   

    public static void AggregateResult(){
        try{
        //Get Number Of States
        List<AggregateResult> state=[Select Country__c, COUNT(Name)Total_States from State__c Group By  Country__c];
            if(state.size()> 0)
            {
            Map<ID , Country__c> mapOfTotalStates = new  Map<ID , Country__c>();           
            for(AggregateResult states : state) { 
            Country__c stateDetail = new Country__c();
            stateDetail.ID = (ID)states.get('Country__c');
            stateDetail.Total_States__c = (Decimal)states.get('Total_States');
            mapOfTotalStates.put(stateDetail.ID,stateDetail);
            }  
            if(mapOfTotalStates!=null){
            update mapOfTotalStates.values();
            }
            } 
            
        //Get Number Of District   
        List<AggregateResult> district=[Select  State__c, COUNT(Name)Total_Districts from District__c Group By  State__c];
            if(district.size()>0)
            {
            Map<ID , State__c> mapOfTotalDistricts = new  Map<ID , State__c>();
            for(AggregateResult districts : district) { 
            State__c districtDetail = new State__c();
            districtDetail.ID = (ID)districts.get('State__c');
            districtDetail.Total_Districts__c = (Decimal)districts.get('Total_Districts');
            mapOfTotalDistricts.put(districtDetail.ID,districtDetail);
            }
            if(mapOfTotalDistricts!=null){  
            update mapOfTotalDistricts.values(); 
            }
            }
                  
        //Get Number Of Total District Of Country
        List<AggregateResult> countryDistrict=[Select Country__c,  SUM(Total_Districts__c) Total_Districts from State__c Group By  Country__c  ];
            if(countryDistrict.size()>0)
            {       
            Map<ID , Country__c> mapOfTotalCountryDistricts = new  Map<ID , Country__c>();
            for(AggregateResult countryDistricts : countryDistrict) { 
            Country__c countryDistrictDetail = new Country__c();
            countryDistrictDetail.ID = (ID)countryDistricts.get('Country__c');
            countryDistrictDetail.Total_District__c = (Decimal)countryDistricts.get('Total_Districts');        
            mapOfTotalCountryDistricts.put(countryDistrictDetail.ID,countryDistrictDetail);
            }
            if(mapOfTotalCountryDistricts!=null){  
            update mapOfTotalCountryDistricts.values();  
            } 
            }
        }
        catch(Exception e)
        {
            System.debug('An unexpected error has occurred: ' + e.getMessage());  
        }
    }
         
    public CountryStateDataMapProcess(){       
        try{    
        //Dynamic Map Fill             
        List<District__c> districtList = [SELECT Name, State__r.Name, State__r.Country__r.Name FROM District__c];
            if(districtList.size() > 0) {
            for(District__c district : districtList) {
            if (!mapOfCountry.containsKey(district.State__r.Country__r.Name))
            {
            mapOfCountry.put(district.State__r.Country__r.Name, new Map<String,List<String>>());
            }
            Map<String,List<String>> mapOfCountryStateAndDistrict = mapOfCountry.get(district.State__r.Country__r.Name);
            if (!mapOfCountryStateAndDistrict.containsKey(district.State__r.Name))
            {
            mapOfCountryStateAndDistrict.put(district.State__r.Name, new List<String>());
            }
            mapOfCountryStateAndDistrict.get(district.State__r.Name).add(district.Name);
            mapOfCountry.put(district.State__r.Country__r.Name, mapOfCountryStateAndDistrict);
            }
            }
            System.debug('Map of country with state and district:'+mapOfCountry);
        }   
        catch(Exception e)
        {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
        }
    }  

        
    public static void findSpecialKeyword(String ch){
        try{  
        //  Find out Country.State and District starts with a particular Keyword.         
            Map<String,Map<String,List<String>>> combinationOfCountryOfStateOfDistrict = new Map<String,Map<String,List<String>>>();
            
            List<District__c> listOfCombinations = [SELECT Name, State__r.Name, State__r.Country__r.Name FROM District__c WHERE (Name LIKE :ch + '%' AND State__r.Name LIKE :ch + '%' AND State__r.Country__r.Name LIKE :ch + '%')];
            if(listOfCombinations.size()>0){
            for(District__c district : listOfCombinations)
            {
            if (!combinationOfCountryOfStateOfDistrict.containsKey(district.State__r.Country__r.Name))
            {
            combinationOfCountryOfStateOfDistrict.put(district.State__r.Country__r.Name, new Map<String,List<String>>());
            }
            Map<String,List<String>> mapOfCountryStateAndDistrict = combinationOfCountryOfStateOfDistrict.get(district.State__r.Country__r.Name);
            if (!mapOfCountryStateAndDistrict.containsKey(district.State__r.Name))
            {
            mapOfCountryStateAndDistrict.put(district.State__r.Name, new List<String>());
            }
            mapOfCountryStateAndDistrict.get(district.State__r.Name).add(district.Name);
            combinationOfCountryOfStateOfDistrict.put(district.State__r.Country__r.Name, mapOfCountryStateAndDistrict);
            }
            }
            System.debug('Map of country with state and district:'+combinationOfCountryOfStateOfDistrict);
        }
        catch(Exception e)
        {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
        }
    }        
        
       
    public static void lengthOfDistrictFind(){       
        try{
        //  Find Length Of District         
            List<String> listOfDistrict = new List<String>();
            for(District__c district :[SELECT Name FROM District__c])
            {
            if(district.Name.Length()>8){
            listOfDistrict.add(district.Name);
            }
        }
            System.debug('Length Of Given District' + listOfDistrict);
        }
        catch (Exception e)
        {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
        }           
    }    
        
        //Make Wrapper Class for Initilize the Data
    public class Country{
        public String countryName{get;set;}
        public Integer totalNumberOfStates{get;set;}
        public Integer totalNumberOfDistricts{get;set;}
        public Integer CountryCode{get;set;}
    }

    public class States{
        public List<Districts> districts{get;set;}
        public Integer TotalNumberOfDistricts{get;set;}
        public String StateName{get;set;}
    }

    public class Districts{
        public String districtName{get;set;}
    }
        
    public void CountryStateJSonGenerator(String countryName,Integer countryCode){         
        try{
        //Create JSON Logic
            {
            cont.countryName = countryName;
            cont.countryCode = countryCode;
    
            
            for(String state :mapOfCountry.get(countryName).keyset())
            {
                States st = new States();
                st.stateName = state;
                st.districts = new list<Districts>();
                
            for(String dist :mapOfCountry.get(countryName).get(State)) 
            {
                Districts dis = new Districts();
                dis.districtName = dist;                            
                st.districts.add(dis);
            }    
            }
            }
        }    
        catch (Exception e)
        {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
        }
    }    
        
    public void updateCountry(){        
        try{
        //Update Data on Country for serialize the JSON            
            for(Country__c name :con)
            {
                name.Country_JSON_Data__c = JSON.serialize(cont);
            }
            update con;            
        }                
        catch (Exception e)
        {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
        }
    }   
}
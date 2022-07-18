public with sharing class CountryStateDataMapProcess{
    Map<String, Map<String, List<String>>> mapOfCountry = new Map<String, Map<String,List<String>>>();      
    
    public static void AggregateResult(){
        try{
            //Get Number Of Total Country
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
            
            //Get Number Of Total States Of Country   
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
            //  Find out Country State and District starts with a particular Keyword.         
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
            // Finding  Districts which length is more or equal to some number         
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
    
    Country cont = new Country();   
    public void CountryStateJSonGenerator(String countryName,Integer countryCode){         
        try{
            //Create JSON Logic
            List<Country__c> countryList = [SELECT Country_JSON_Data__c FROM Country__c WHERE Name = : countryName  LIMIT 1];
            if (countryList.size() > 0)
            {            
                cont.countryName = countryName;
                cont.countryCode = countryCode;
                
                List<AggregateResult> totalNumberOfState = [SELECT COUNT(Name) Total_Number_Of_States FROM State__c WHERE Country__r.Name = :countryName  Group By Country__r.Name];  
                if (totalNumberOfState.size() > 0)
                {
                    cont.totalNumberOfStates =  (Integer)totalNumberOfState[0].get('Total_Number_Of_States');
                    
                    List<AggregateResult> totalNumberOfDistrict = [SELECT COUNT(Name) Total_Number_Of_Districts FROM District__c WHERE State__r.Country__r.Name = :countryName Group By State__r.Country__r.Name];    
                    if (totalNumberOfDistrict.size() > 0) 
                    {
                        cont.totalNumberOfDistricts = (Integer)totalNumberOfDistrict[0].get('Total_Number_Of_Districts');
                        
                        for(String state :mapOfCountry.get(countryName).keyset())
                        {
                            States st = new States();
                            st.stateName = state;
                            st.districts = new list<Districts>();
                            List<AggregateResult> listOfDistrictWithState = [SELECT COUNT(Name)Total_Number_Of_Districts FROM District__c WHERE State__r.Country__r.Name = :countryName Group By State__r.Name]; 
                            if (listOfDistrictWithState.size() > 0) 
                            {
                                st.totalNumberOfDistricts = (Integer)listOfDistrictWithState[0].get('Total_Number_Of_Districts');
                                
                                for(String dist :mapOfCountry.get(countryName).get(State))
                                { 
                                    
                                    Districts dis = new Districts();
                                    dis.districtName = dist;                            
                                    st.districts.add(dis);
                                }    
                            }
                            countryList[0].Country_JSON_Data__c = JSON.serialize(cont);
                            update countryList[0];
                        }
                    }
                }
            }
        }            
        catch (Exception e)
        {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
        }
    }    
}
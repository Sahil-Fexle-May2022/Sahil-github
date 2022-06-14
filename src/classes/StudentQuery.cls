public class StudentQuery {
    public  StudentQuery(){        
    List<Student__c> studentList = [SELECT ID, Name, Roll_no__c FROM Student__c ORDER BY createdDate LIMIT 5];
        for(Student__c student : studentList){          
            System.Debug('Check Student Data :::' + student);
        }            
    }
}
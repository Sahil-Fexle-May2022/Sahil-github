public class StudentQuery {
    public  StudentQuery(){        
    List<Student__c> StudentList=     [select id, Name, Roll_no__c from Student__c order by createdDate  Limit 5];
        for(Student__c Student: StudentList){          
            System.Debug('check student data:::'+Student);
        }            
    }
}
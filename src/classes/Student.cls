public class Student{
    public Student(){
    Student__c Student1= new Student__c();
        //Student Info
    //A.id='a055i0000014QvBAAU';    
    Student1.Name = 'Sahil Sharma';
    Student1.Roll_no__c=123;
    Student1.Father_Name__c='Rakesh Sharma';
    Student1.Mobile_Number__c='8560949232';
    Student1.Father_s_Mobile_Number__c='9414322809';
    Student1.Home_Phone__c='350487';
    Student1.Email__c='infectionvirus4@gmail.com';
    Student1.Address__c='Jeevan vihar 200ftbypass';
        //Class Info
    Student1.Overall_Grade__c='A+';
    Student1.Stream__c='Economics';
    Student1.Class__c='2nd year';
    Student1.Section__c='A';
    Student1.Current_Year__c=date.parse('2/07/2022');
    Student1.Pending_Fees_Amount__c=20;
    Student1.Pending_Exam_Fees__c=80;
    Student1.X1st_Sem_Percentage__c=90;
    Student1.Subjects_in_which_back__c='Economics';
    Student1.X2nd_Sem_Percentage__c=70;
    Student1.Subject_in_which_back__c='English';
    Student1.X3rd_Sem_Percentage__c=92;
    Student1.Back_in_which_Subjects__c='Geography';
    Student1.Donation_Amount__c=56;
    Student1.Pending_Overall_Amount__c=20;
        //Bank Info
    Student1.Bank_Name__c='HDFC Bank';
    Student1.IFSC_Code__c=3456;
    Student1.Account_Number__c=3242;
    Student1.Mob_Number__c='8560949232';
    Student1.Bank_Phone_Number__c='7444472455';
    Student1.City__c='Jaipur';
    Student1.State__c='Rajasthan';   
    Student1.Exam_Fees_Submitted__c=True;
    Student1.Fees_Submitted__c=True;
    Student1.Is_Donation__c=True;    
    insert Student1;
        System.Debug('check student data:::'+Student1);
    }
}
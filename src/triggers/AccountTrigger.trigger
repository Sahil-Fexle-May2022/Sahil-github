trigger AccountTrigger on Account (before insert,after insert){ 
    if(Trigger.isInsert){
        if(Trigger.isBefore){
            AccountHelperClass.setPrefixOnAccount(Trigger.new);
        }
        if(Trigger.isAfter){
            AccountHelperClass.sendingEmail(Trigger.new);
        }
    }
}
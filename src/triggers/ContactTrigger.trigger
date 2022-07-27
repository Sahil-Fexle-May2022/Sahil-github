trigger ContactTrigger on Contact (after insert) {
    if(Trigger.isInsert){
        if(Trigger.isAfter){
            ContactTriggerHelper.totalContactPerAccount(Trigger.New);
        }
    }
}
trigger ContactTrigger on Contact (after insert) {
    if(Trigger.isInsert){
        if(Trigger.isAfter){
            ContactTriggerHelper.TotalContactPerAccount(Trigger.New);
        }
    }
}
trigger OpportunityTrigger on Opportunity (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    // Single execution router call manages the entire object footprint cleanly
    new OpportunityTriggerHandler().run();
}

public class OpportunityTriggerHandler extends TriggerHandler {
    
    // Override standard contexts to safely run your specific donation logic
    protected override void beforeInsert() {
        system.debug('OpportunityTriggerHandler.beforeInsert()');
        system.debug('OpportunityTriggerHandler.beforeInsert() - Trigger.new: ' + Trigger.new);
        // Place raw data preparation logic or pre-checks here
    }

    protected override void afterUpdate() {
        // Future donation processing hooks will execute inside this scope
    }
}

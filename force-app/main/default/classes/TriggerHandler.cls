public virtual class TriggerHandler {

    // Internal static set to track bypassed handlers globally in the running thread
    private static Set<String> bypassedHandlers = new Set<String>();

    // Context tracking variable to manage execution state
    @TestVisible
    private TriggerContext context;

    // Execution control flag to prevent infinite loops / recursive limits
    @TestVisible
    private Boolean isTriggerExecuting;

    // Core constructor initializing operational state variables
    public TriggerHandler() {
        this.setContext();
    }

    // Main execution router mapping standard platform trigger context properties
    public void run() {
        if(validateRun()) {
            switch on this.context {
                when BEFORE_INSERT { this.beforeInsert(); }
                when BEFORE_UPDATE { this.beforeUpdate(); }
                when BEFORE_DELETE { this.beforeDelete(); }
                when AFTER_INSERT  { this.afterInsert(); }
                when AFTER_UPDATE  { this.afterUpdate(); }
                when AFTER_DELETE  { this.afterDelete(); }
                when AFTER_UNDELETE { this.afterUndelete(); }
            }
        }
    }

    // Global Operational Management: Framework Bypass Controls
    public static void bypass(String handlerName) {
        bypassedHandlers.add(handlerName);
    }

    public static void clearBypass(String handlerName) {
        bypassedHandlers.remove(handlerName);
    }

    public static Boolean isBypassed(String handlerName) {
        return bypassedHandlers.contains(handlerName);
    }

    public static void clearAllBypasses() {
        bypassedHandlers.clear();
    }

    // Virtual context hooks designed for subclass inheritance and overriding
    protected virtual void beforeInsert() {}
    protected virtual void beforeUpdate() {}
    protected virtual void beforeDelete() {}
    protected virtual void afterInsert() {}
    protected virtual void afterUpdate() {}
    protected virtual void afterDelete() {}
    protected virtual void afterUndelete() {}

    // Context definitions
    @TestVisible
    private void setContext() {
        this.isTriggerExecuting = Trigger.isExecuting;
        if(Trigger.isBefore && Trigger.isInsert) { this.context = TriggerContext.BEFORE_INSERT; }
        else if(Trigger.isBefore && Trigger.isUpdate) { this.context = TriggerContext.BEFORE_UPDATE; }
        else if(Trigger.isBefore && Trigger.isDelete) { this.context = TriggerContext.BEFORE_DELETE; }
        else if(Trigger.isAfter && Trigger.isInsert) { this.context = TriggerContext.AFTER_INSERT; }
        else if(Trigger.isAfter && Trigger.isUpdate) { this.context = TriggerContext.AFTER_UPDATE; }
        else if(Trigger.isAfter && Trigger.isDelete) { this.context = TriggerContext.AFTER_DELETE; }
        else if(Trigger.isAfter && Trigger.isUndelete) { this.context = TriggerContext.AFTER_UNDELETE; }
    }

    @TestVisible
    private Boolean validateRun() {
        if(!this.isTriggerExecuting || this.context == null) {
            throw new TriggerHandlerException('Trigger handler called outside of Trigger execution context.');
        }
        return !bypassedHandlers.contains(getHandlerName());
    }

    private String getHandlerName() {
        return String.valueOf(this).split(':').get(0);
    }

    // Custom Context Enumerations
    @TestVisible
    private enum TriggerContext {
        BEFORE_INSERT, BEFORE_UPDATE, BEFORE_DELETE,
        AFTER_INSERT, AFTER_UPDATE, AFTER_DELETE, AFTER_UNDELETE
    }

    // Exception definition layer
    public class TriggerHandlerException extends Exception {}
}

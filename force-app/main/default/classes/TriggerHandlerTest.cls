@isTest
private class TriggerHandlerTest {

    private static final String BYPASS_NAME = 'OpportunityTriggerHandler';

    @isTest
    static void testBypassControls() {
        // Confirm bypass registers true
        TriggerHandler.bypass(BYPASS_NAME);
        System.assert(TriggerHandler.isBypassed(BYPASS_NAME), 'Handler should report as bypassed.');

        // Confirm bypass removal registers false
        TriggerHandler.clearBypass(BYPASS_NAME);
        System.assertNotEquals(true, TriggerHandler.isBypassed(BYPASS_NAME), 'Bypass state should be cleared.');
    }

    @isTest
    static void testExecutionOutsideContextThrowsException() {
        TriggerHandler handler = new TriggerHandler();
        Boolean exceptionCaught = false;
        try {
            handler.run();
        } catch(TriggerHandler.TriggerHandlerException e) {
            exceptionCaught = true;
        }
        System.assert(exceptionCaught, 'Running handler logic outside operational platform context must fail with custom exception.');
    }
}

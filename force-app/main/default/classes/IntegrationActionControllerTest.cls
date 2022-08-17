/**
 * Created by BalazsBiro on 16/08/2022.
 */

@IsTest
private class IntegrationActionControllerTest {

    @TestSetup
    static void makeData() {
        TestUtility.insertOrder(true);
    }

    @IsTest
    static void testCalloutSuccess() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(200));

        Order orderBefore = [SELECT Id, Status FROM Order];

        Test.startTest();

        IntegrationActionController.integrateOrder(orderBefore.Id);

        Exception expectedException;
        try {
            IntegrationActionController.integrateOrder(orderBefore.Id);
        } catch (Exception e) {
            expectedException = e;
        }

        Test.stopTest();

        Order orderAfter = [SELECT Id, Status FROM Order];
        System.assertEquals(OrderConstants.STATUSES.get(OrderConstants.STATUS_DRAFT), orderBefore.Status);
        System.assertEquals(OrderConstants.STATUSES.get(OrderConstants.STATUS_ACTIVATED), orderAfter.Status);
        System.assertNotEquals(null, expectedException);
    }

    @IsTest
    static void testCalloutFailure() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(500));

        Order orderBefore = [SELECT Id, Status FROM Order];

        Test.startTest();

        Exception expectedException;
        try {
            IntegrationActionController.integrateOrder(orderBefore.Id);
        } catch (Exception e) {
            expectedException = e;
        }

        Test.stopTest();

        System.assertNotEquals(null, expectedException);

        Order orderAfter = [SELECT Id, Status FROM Order];
        System.assertEquals(OrderConstants.STATUSES.get(OrderConstants.STATUS_DRAFT), orderBefore.Status);
        System.assertEquals(OrderConstants.STATUSES.get(OrderConstants.STATUS_DRAFT), orderAfter.Status);
    }
}
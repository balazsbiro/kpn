/**
 * Created by BalazsBiro on 16/08/2022.
 */

@IsTest
private class AvailableProductsControllerTest {

    @TestSetup
    static void makeData() {
        TestUtility.insertOrder(false);
    }

    @IsTest
    static void testScenario() {
        Order order = [SELECT Id FROM Order];
        Product2 product = [SELECT Id FROM Product2];
        List<OrderItem> orderItemsBefore = [SELECT Id, Quantity FROM OrderItem];

        Test.startTest();

        AvailableProductsController.PriceBookWrapper priceBookWrapper = AvailableProductsController.getPricebookEntries(order.Id, 10, 1);
        AvailableProductsController.addProduct(order.Id, product.Id);
        AvailableProductsController.addProduct(order.Id, product.Id);
        List<OrderItem> orderItemsAfter = OrderProductsController.getOrderProducts(order.Id);

        order.Status = OrderConstants.STATUSES.get(OrderConstants.STATUS_ACTIVATED);
        update order;

        Exception expectedException;
        try {
            AvailableProductsController.addProduct(order.Id, product.Id);
        } catch (Exception e) {
            expectedException = e;
        }

        Test.stopTest();

        System.assertEquals(1, priceBookWrapper.pricebookEntries.size());
        System.assertEquals('Test Product', priceBookWrapper.pricebookEntries.get(0).Name);
        System.assert(orderItemsBefore.isEmpty());
        System.assertEquals(1, orderItemsAfter.size());
        System.assertEquals(2, orderItemsAfter.get(0).Quantity);
        System.assertNotEquals(null, expectedException);
    }
}
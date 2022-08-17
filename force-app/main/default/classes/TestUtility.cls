/**
 * Created by BalazsBiro on 16/08/2022.
 */

public with sharing class TestUtility {

    public static void insertOrder(Boolean withOrderItem) {
        Account account = new Account();
        account.Name = 'Test Account';
        insert account;

        Product2 product = new Product2();
        product.Name = 'Test Product';
        product.Description = 'Test Product Entry 1';
        product.ProductCode = 'ABC';
        product.IsActive = true;
        insert product;

        Id pricebookId = Test.getStandardPricebookId();

        PricebookEntry standardPrice = new PricebookEntry();
        standardPrice.Pricebook2Id = pricebookId;
        standardPrice.Product2Id = product.Id;
        standardPrice.UnitPrice = 1;
        standardPrice.IsActive = true;
        standardPrice.UseStandardPrice = false;
        insert standardPrice ;

        Order order = new Order();
        order.Name = 'Test Order';
        order.Status = OrderConstants.STATUSES.get(OrderConstants.STATUS_DRAFT);
        order.EffectiveDate = System.today();
        order.EndDate = System.today() + 4;
        order.AccountId = account.Id;
        order.Pricebook2Id = pricebookId ;
        insert order;

        if(withOrderItem)
        {
            OrderItem orderItem = new OrderItem();
            orderItem.OrderId = order.Id;
            orderItem.Quantity = 1;
            orderItem.UnitPrice = 1000;
            orderItem.Product2Id = product.Id;
            orderItem.PricebookEntryId = standardPrice.Id;
            insert orderItem;
        }
    }
}
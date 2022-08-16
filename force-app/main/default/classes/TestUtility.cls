/**
 * Created by BalazsBiro on 16/08/2022.
 */

public with sharing class TestUtility {

    public static void insertOrder(Boolean withOrderItem) {
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;

        Product2 p = new Product2();
        p.Name = 'Test Product';
        p.Description = 'Test Product Entry 1';
        p.ProductCode = 'ABC';
        p.IsActive = true;
        insert p;

        Id pricebookId = Test.getStandardPricebookId();

        PricebookEntry standardPrice = new PricebookEntry();
        standardPrice.Pricebook2Id = pricebookId;
        standardPrice.Product2Id = p.Id;
        standardPrice.UnitPrice = 1;
        standardPrice.IsActive = true;
        standardPrice.UseStandardPrice = false;
        insert standardPrice ;

        Order o = new Order();
        o.Name = 'Test Order';
        o.Status = OrderConstants.STATUSES.get(OrderConstants.STATUS_DRAFT);
        o.EffectiveDate = System.today();
        o.EndDate = System.today() + 4;
        o.AccountId = a.Id;
        o.Pricebook2Id = pricebookId ;
        insert o;

        if(withOrderItem)
        {
            OrderItem i = new OrderItem();
            i.OrderId = o.Id;
            i.Quantity = 1;
            i.UnitPrice = 1000;
            i.Product2Id = p.Id;
            i.PricebookEntryId = standardPrice.Id;
            insert i;
        }
    }
}
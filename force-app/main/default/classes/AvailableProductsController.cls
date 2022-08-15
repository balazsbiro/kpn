/**
 * Created by BalazsBiro on 14/08/2022.
 */

public with sharing class AvailableProductsController {

    public class PriceBookWrapper {
        @AuraEnabled
        public Integer recordStart { get; set; }
        @AuraEnabled
        public Integer pageNumber { get; set; }
        @AuraEnabled
        public Integer totalRecords { get; set; }
        @AuraEnabled
        public Integer recordEnd { get; set; }
        @AuraEnabled
        public Integer pageSize { get; set; }
        @AuraEnabled
        public List<PricebookEntry> pricebookEntries { get; set; }
    }

    @AuraEnabled
    public static PriceBookWrapper getPricebookEntries(Id orderId, Integer pageSize, Integer pageNumber) {
        Integer recordEnd = pageSize * pageNumber;

        PriceBookWrapper priceBookWrapper = new PriceBookWrapper();
        priceBookWrapper.pageNumber = pageNumber;
        priceBookWrapper.pageSize = pageSize;

        Integer offset = (pageNumber - 1) * pageSize;

        priceBookWrapper.recordStart = offset + 1;

        Id priceBookId = getOrdersPriceBook(orderId);

        Integer totalRecords = [
                SELECT
                        COUNT()
                FROM PricebookEntry
                WHERE
                        IsActive = TRUE
                        AND Pricebook2Id = :priceBookId
                LIMIT 50000
        ];

        priceBookWrapper.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
        priceBookWrapper.totalRecords = totalRecords;
        priceBookWrapper.pricebookEntries = [
                SELECT
                        Id,
                        Name,
                        UnitPrice,
                        Product2Id
                FROM PricebookEntry
                WHERE
                        IsActive = TRUE
                        AND Pricebook2Id = :priceBookId
                WITH SECURITY_ENFORCED
                LIMIT :Math.min(pageSize, 50000)
                OFFSET :offset
        ];

        return priceBookWrapper;
    }

    @AuraEnabled
    public static void addProduct(Id orderId, Id productId) {

        if(getOrderActivated(orderId))
        {
            throw new AuraHandledException('Cannot add Product, because Order is already activated');
        }

        List<OrderItem> existingOrderItem = [
                SELECT
                        Id,
                        Quantity
                FROM OrderItem
                WHERE
                        OrderId = :orderId
                        AND Product2Id = :productId
                LIMIT 1
        ];

        OrderItem orderItemToUpsert;

        if (existingOrderItem.isEmpty()) {
            Id priceBookId = getOrdersPriceBook(orderId);
            PricebookEntry pbEntry = [
                    SELECT
                            Id,
                            UnitPrice
                    FROM PricebookEntry
                    WHERE
                            Product2Id = :productId
                            AND Pricebook2Id = :priceBookId
            ];

            orderItemToUpsert = new OrderItem(
                    OrderId = orderId,
                    PricebookEntryId = pbEntry.Id,
                    Product2Id = productId,
                    Quantity = 1,
                    UnitPrice = pbEntry.UnitPrice
            );
        } else {
            orderItemToUpsert = existingOrderItem.get(0);
            orderItemToUpsert.Quantity++;
        }

        upsert orderItemToUpsert;
    }

    private static Id getOrdersPriceBook(Id orderId) {
        return [
                SELECT
                        Pricebook2Id
                FROM Order
                WHERE Id = :orderId
                WITH SECURITY_ENFORCED
        ].Pricebook2Id;
    }

    public static Boolean getOrderActivated(Id recordId) {
        System.debug(recordId);
        Order order = [
                SELECT
                        Id,
                        Status
                FROM Order
                WHERE Id = :recordId
        ];

        return order.Status == 'Activated';
    }
}
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
        PriceBookWrapper priceBookWrapper = new PriceBookWrapper();
        priceBookWrapper.pageNumber = pageNumber;
        priceBookWrapper.pageSize = pageSize;

        Id priceBookId = OrderSelector.getOrdersPriceBook(orderId);

        Integer totalRecords = PriceBookEntrySelector.countPriceBookEntries(priceBookId);
        Integer recordEnd = pageSize * pageNumber;

        priceBookWrapper.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
        priceBookWrapper.totalRecords = totalRecords;
        priceBookWrapper.recordStart = ((pageNumber - 1) * pageSize) + 1;
        priceBookWrapper.pricebookEntries = PriceBookEntrySelector.getPaginatedPriceBookEntries(priceBookId, pageSize, pageNumber);

        return priceBookWrapper;
    }

    @AuraEnabled
    public static void addProduct(Id orderId, Id productId) {

        if (OrderSelector.getOrderIsActivated(orderId)) {
            throw new AuraHandledException(Label.OrderAlreadyActivated);
        }

        List<OrderItem> existingOrderItem = OrderItemSelector.getOrderItem(orderId, productId);

        OrderItem orderItemToUpsert;

        if (existingOrderItem.isEmpty()) {
            Id priceBookId = OrderSelector.getOrdersPriceBook(orderId);
            PricebookEntry pbEntry = PriceBookEntrySelector.getPriceBookEntry(productId, priceBookId);
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
}
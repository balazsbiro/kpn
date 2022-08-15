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

    @AuraEnabled(Cacheable=true)
    public static PriceBookWrapper getPricebookEntries(Id orderId, Integer pageSize, Integer pageNumber) {
        Id priceBookId = [
                SELECT
                        Pricebook2Id
                FROM Order
                WHERE Id = :orderId
                WITH SECURITY_ENFORCED
        ].Pricebook2Id;

        Integer recordEnd = pageSize * pageNumber;

        PriceBookWrapper priceBookWrapper = new PriceBookWrapper();
        priceBookWrapper.pageNumber = pageNumber;
        priceBookWrapper.pageSize = pageSize;

        Integer offset = (pageNumber - 1) * pageSize;

        priceBookWrapper.recordStart = offset + 1;

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

    }
}
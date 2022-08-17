/**
 * Created by BalazsBiro on 16/08/2022.
 */

public with sharing class PriceBookEntrySelector {

    public static Integer countPriceBookEntries(Id priceBookId) {
        return [
                SELECT
                        COUNT()
                FROM PricebookEntry
                WHERE
                        IsActive = TRUE
                        AND Pricebook2Id = :priceBookId
                WITH SECURITY_ENFORCED
                LIMIT 50000
        ];
    }

    public static List<PricebookEntry> getPaginatedPriceBookEntries(Id priceBookId, Integer pageSize, Integer pageNumber) {
        return [
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
                OFFSET :((pageNumber - 1) * pageSize)
        ];
    }

    public static PricebookEntry getPriceBookEntry(Id productId, Id priceBookId) {
        return [
                SELECT
                        Id,
                        UnitPrice
                FROM PricebookEntry
                WHERE
                        Product2Id = :productId
                        AND Pricebook2Id = :priceBookId
                WITH SECURITY_ENFORCED
                LIMIT 1
        ];
    }

}
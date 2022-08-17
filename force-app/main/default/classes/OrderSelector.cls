/**
 * Created by BalazsBiro on 16/08/2022.
 */

public with sharing class OrderSelector {

    public static Id getOrdersPriceBook(Id orderId) {
        return [
                SELECT
                        Pricebook2Id
                FROM Order
                WHERE Id = :orderId
                WITH SECURITY_ENFORCED
                LIMIT 1
        ].Pricebook2Id;
    }

    public static Boolean getOrderIsActivated(Id recordId) {
        Order order = [
                SELECT
                        Id,
                        Status
                FROM Order
                WHERE Id = :recordId
                WITH SECURITY_ENFORCED
                LIMIT 1
        ];

        return order.Status == OrderConstants.STATUSES.get(OrderConstants.STATUS_ACTIVATED);
    }

    public static Order getOrderWithOrderItems(Id orderId) {
        return [
                SELECT
                        Id,
                        Account.AccountNumber,
                        OrderNumber,
                        Type,
                        Status,
                        (
                                SELECT
                                        Id,
                                        Product2.Name,
                                        Product2.ProductCode,
                                        UnitPrice,
                                        Quantity
                                FROM OrderItems
                        )
                FROM Order
                WHERE
                        Id = :orderId
                WITH SECURITY_ENFORCED
                LIMIT 1
        ];
    }
}
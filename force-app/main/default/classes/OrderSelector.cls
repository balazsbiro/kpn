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
        ];

        return order.Status == 'Activated';
    }
}
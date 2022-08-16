/**
 * Created by BalazsBiro on 16/08/2022.
 */

public with sharing class OrderItemSelector {

    public static List<OrderItem> getOrderItem(Id orderId, Id productId) {
        return [
                SELECT
                        Id,
                        Quantity
                FROM OrderItem
                WHERE
                        OrderId = :orderId
                        AND Product2Id = :productId
                WITH SECURITY_ENFORCED
                LIMIT 1
        ];
    }
}
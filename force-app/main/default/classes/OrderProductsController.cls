/**
 * Created by BalazsBiro on 15/08/2022.
 */

public with sharing class OrderProductsController {

    @AuraEnabled
    public static List<OrderItem> getOrderProducts(Id orderId) {
        return [
                SELECT
                        Id,
                        Product2.Name,
                        UnitPrice,
                        Quantity,
                        TotalPrice
                FROM OrderItem
                WHERE
                        OrderId = :orderId
        ];
    }
}
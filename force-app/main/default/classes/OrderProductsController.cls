/**
 * Created by BalazsBiro on 15/08/2022.
 */

public with sharing class OrderProductsController {

    @AuraEnabled
    public static List<OrderItem> getOrderProducts(Id orderId) {
        return OrderItemSelector.getOrderItems(orderId);
    }
}
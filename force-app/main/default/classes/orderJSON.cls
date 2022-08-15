/**
 * Created by BalazsBiro on 15/08/2022.
 */

public with sharing class orderJSON {
    public String accountNumber;    //
    public String orderNumber;    //
    public String type;    //order type
    public String status;    //order status
    public List<cls_orderProducts> orderProducts;

    class cls_orderProducts {
        public String name;    //product name
        public String code;    //product code
        public Decimal unitPrice;    //10
        public Integer quantity;    //1

        public cls_orderProducts(String name, String code, Decimal unitPrice, Decimal quantity) {
            this.name = name;
            this.code = code;
            this.unitPrice = unitPrice;
            this.quantity = quantity.intValue();
        }
    }

    public orderJSON(Id orderId) {
        Order orderWithProducts = [
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
        ];

        accountNumber = orderWithProducts.Account.AccountNumber;
        orderNumber = orderWithProducts.OrderNumber;
        type = orderWithProducts.Type;
        status = orderWithProducts.Status;

        orderProducts = new List<cls_orderProducts>();
        for (OrderItem orderItem : orderWithProducts.OrderItems) {
            orderProducts.add(new cls_orderProducts(
                    orderItem.Product2.Name,
                    orderItem.Product2.ProductCode,
                    orderItem.UnitPrice,
                    orderItem.Quantity
            ));
        }
    }
}
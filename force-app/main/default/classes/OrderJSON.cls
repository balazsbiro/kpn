/**
 * Created by BalazsBiro on 15/08/2022.
 */

public with sharing class OrderJSON {
    public String accountNumber;
    public String orderNumber;
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

    public OrderJSON(Id orderId) {
        Order orderWithOrderItems = OrderSelector.getOrderWithOrderItems(orderId);

        accountNumber = orderWithOrderItems.Account.AccountNumber;
        orderNumber = orderWithOrderItems.OrderNumber;
        type = orderWithOrderItems.Type;
        status = orderWithOrderItems.Status;

        orderProducts = new List<cls_orderProducts>();
        for (OrderItem orderItem : orderWithOrderItems.OrderItems) {
            orderProducts.add(new cls_orderProducts(
                    orderItem.Product2.Name,
                    orderItem.Product2.ProductCode,
                    orderItem.UnitPrice,
                    orderItem.Quantity
            ));
        }
    }
}
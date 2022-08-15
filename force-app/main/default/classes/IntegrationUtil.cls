/**
 * Created by BalazsBiro on 15/08/2022.
 */

public with sharing class IntegrationUtil {

    public static final Integer API_TIMEOUT = 120000;
    public static final Integer SUCCESS_CODE = 200;


    @AuraEnabled
    public static void integrateOrder(Id orderId)
    {

        if(AvailableProductsController.getOrderActivated(orderId))
        {
            throw new AuraHandledException('Cannot Integrate Order, because Order is already activated');
        }

        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setTimeout(API_TIMEOUT);
        req.setHeader('Content-Type', 'application/json');
        req.setEndpoint('callout:ExternalSystem');
        req.setBody(JSON.serialize(new orderJSON(orderId)));

        Http http = new Http();
        HttpResponse res = http.send(req);

        if (res.getStatusCode() == SUCCESS_CODE) {
            update new Order(Id = orderId, Status = 'Activated');
        }
        else {
            throw new AuraHandledException('Failed To Integrate The Order');
        }
    }
}
/**
 * Created by BalazsBiro on 16/08/2022.
 */

@IsTest
global class MockHttpResponseGenerator implements HttpCalloutMock {
    private Integer statusCode;

    global MockHttpResponseGenerator(Integer statusCode){
        this.statusCode = statusCode;
    }

    global HttpResponse respond(HttpRequest req) {
        HttpResponse res = new HttpResponse();
        res.setStatusCode(statusCode);
        return res;
    }
}
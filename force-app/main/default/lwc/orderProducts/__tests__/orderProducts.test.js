import { createElement } from 'lwc'
import OrderProducts from 'c/orderProducts'
import getOrderProducts from '@salesforce/apex/OrderProductsController.getOrderProducts';

const APEX_ORDER_PRODUCTS = require('./data/orderProducts.json')

jest.mock(
    '@salesforce/apex/OrderProductsController.getOrderProducts',
    () => {
        return {
            default: jest.fn()
        };
    },
    { virtual: true }
);

describe('c-order-products', ()=>{
    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }

        jest.clearAllMocks();
    });

    beforeEach(()=>{
        const element = createElement('c-order-products', {
            is:OrderProducts
        });
        getOrderProducts.mockResolvedValue(APEX_ORDER_PRODUCTS);
        document.body.appendChild(element);
    });

    test('testCase1', ()=>{
        const element = document.querySelector('c-order-products');
        const table = element.shadowRoot.querySelector('lightning-datatable');
        expect(table.data.length).toBe(APEX_ORDER_PRODUCTS.length);
        expect(table.data[0].ProductName).toBe(APEX_ORDER_PRODUCTS[0].Product2.Name);
    });
})
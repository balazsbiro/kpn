import { createElement } from 'lwc'
import AvailableProducts from 'c/availableProducts'
import getPricebookEntries from '@salesforce/apex/AvailableProductsController.getPricebookEntries';

const APEX_PRICEBOOK_WRAPPER = require('./data/priceBookWrapper.json')

jest.mock(
    '@salesforce/apex/AvailableProductsController.getPricebookEntries',
    () => {
        return {
            default: jest.fn()
        };
    },
    { virtual: true }
);

describe('c-available-products', ()=>{
    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }

        jest.clearAllMocks();
    });

    beforeEach(()=>{
        const element = createElement('c-available-products', {
            is:AvailableProducts
        });
        getPricebookEntries.mockResolvedValue(APEX_PRICEBOOK_WRAPPER);
        document.body.appendChild(element);
    });

    test('testCase1', ()=>{
        const element = document.querySelector('c-available-products');
        const table = element.shadowRoot.querySelector('lightning-datatable');
        expect(table.data.length).toBe(APEX_PRICEBOOK_WRAPPER.pricebookEntries.length);
        expect(table.data[0].Name).toBe(APEX_PRICEBOOK_WRAPPER.pricebookEntries[0].Name);

        element.shadowRoot
            .querySelectorAll('lightning-button')
            .forEach((button) => {
                button.click();
        });
    });
})
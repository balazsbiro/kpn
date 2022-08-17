import { createElement } from 'lwc'
import IntegrationAction from 'c/integrationAction'
import integrateOrder from '@salesforce/apex/IntegrationActionController.integrateOrder';

jest.mock(
    '@salesforce/apex/IntegrationActionController.integrateOrder',
    () => {
        return {
            default: jest.fn()
        };
    },
    { virtual: true }
);

describe('c-integration-action', ()=>{
    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }

        jest.clearAllMocks();
    });

    beforeEach(()=>{
        const element = createElement('c-integration-action', {
            is:IntegrationAction
        });
        document.body.appendChild(element);
    });

    test('testCase1', ()=>{
        integrateOrder.mockResolvedValue(null);
        const element = document.querySelector('c-integration-action');
        const button = element.shadowRoot.querySelector('lightning-button');
        button.click();
    });
})
/**
 * Created by BalazsBiro on 14/08/2022.
 */

import { LightningElement, api, wire } from 'lwc';
import getProducts from '@salesforce/apex/OrderProductsController.getOrderProducts';
import {subscribe,createMessageContext,releaseMessageContext } from 'lightning/messageService';
import productAddedChannel from "@salesforce/messageChannel/ProductAddedChannel__c";

const columns = [
    {
        label: 'Product Name',
        fieldName: 'ProductName',
        type: 'text'
    },
    {
        label: 'Unit Price',
        fieldName: 'UnitPrice',
        type: 'currency',
        typeAttributes: { currencyCode: 'EUR', step: '0.01' },
    },
    {
        label: 'Quantity',
        fieldName: 'Quantity',
        type: 'number'
    },
    {
        label: 'Total Price',
        fieldName: 'TotalPrice',
        type: 'currency',
        typeAttributes: { currencyCode: 'EUR', step: '0.01' },
    },
];

export default class OrderProducts extends LightningElement {
    @api recordId;
    products;
    columns = columns;
    subscription = null;
    context = createMessageContext();

    connectedCallback() {
        this.getProducts();
        this.subscribeMC();
    }

    getProducts(){
        getProducts({orderId: this.recordId})
        .then(result => {
            this.products = this.populateProductName(result);
            this.error = undefined;
        })
        .catch(error => {
            this.error = error;
            this.products = undefined;
        });
    }

    populateProductName(products){
        return products.map((product) =>{
            product.ProductName = product.Product2.Name;
            return product;
        });
    }

    disconnectedCallback() {
        releaseMessageContext(this.context);
    }

    subscribeMC() {
        if (this.subscription) {
            return;
        }
        this.subscription = subscribe(this.context, productAddedChannel, (message) => {
            this.getProducts();
        });
    }
}
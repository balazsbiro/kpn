/**
 * Created by BalazsBiro on 14/08/2022.
 */

import { LightningElement, api, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getPricebookEntries from '@salesforce/apex/AvailableProductsController.getPricebookEntries';
import addProduct from '@salesforce/apex/AvailableProductsController.addProduct';
import { publish, createMessageContext,releaseMessageContext } from 'lightning/messageService';
import productAddedChannel from "@salesforce/messageChannel/ProductAddedChannel__c";

const columns = [
    {
        label: 'Product Name',
        fieldName: 'Name',
        type: 'text'
    },
    {
        label: 'List Price',
        fieldName: 'UnitPrice',
        type: 'currency',
        typeAttributes: { currencyCode: 'EUR', step: '0.01' },
    },
    {
        type: 'button',
        typeAttributes: {
            label: 'Add',
            name: 'Add',
            title: 'Add',
            disabled: false,
            value: 'add',
            iconPosition: 'right'
        },
        cellAttributes: {
            alignment: 'right'
        }
    }
];

export default class AvailableProducts extends LightningElement {
    @api recordId;
    recordEnd = 0;
    recordStart = 0;
    pageNumber = 1;
    totalRecords = 0;
    totalPages = 0;
    error = null;
    pageSize = 10;
    isPrev = true;
    isNext = true;
    pricebookEntries;
    columns = columns;
    context = createMessageContext();

    connectedCallback() {
        this.getPricebookEntries();
    }


    handlePageNextAction(){
        this.pageNumber = this.pageNumber+1;
        this.getPricebookEntries();
    }


    handlePagePrevAction(){
        this.pageNumber = this.pageNumber-1;
        this.getPricebookEntries();
    }


    getPricebookEntries(){
        getPricebookEntries({orderId: this.recordId, pageSize: this.pageSize, pageNumber : this.pageNumber})
        .then(result => {
            this.recordEnd = result.recordEnd;
            this.totalRecords = result.totalRecords;
            this.recordStart = result.recordStart;
            this.pricebookEntries = result.pricebookEntries;
            this.pageNumber = result.pageNumber;
            this.totalPages = Math.ceil(result.totalRecords / this.pageSize);
            this.isNext = (this.pageNumber == this.totalPages || this.totalPages == 0);
            this.isPrev = (this.pageNumber == 1 || this.totalRecords < this.pageSize);
            this.error = undefined;
        })
        .catch(error => {
            this.error = error;
            this.pricebookEntries = undefined;
        });
    }


    get isDisplayNoRecords() {
        let isDisplay = true;
        if(this.pricebookEntries){
            if(this.pricebookEntries.length == 0){
                isDisplay = true;
            }else{
                isDisplay = false;
            }
        }
        return isDisplay;
    }

    callRowAction(event) {
        if(event.detail.action.name === 'Add') {
            addProduct({orderId: this.recordId, productId: event.detail.row.Product2Id})
            .then(result => {
                this.showToast('Product added', `Successfully added ${event.detail.row.Name}`, 'success');
                publish(this.context, productAddedChannel);
            })
            .catch(error => {
                this.showToast('Error', error.body.message, 'error');
            });
        }
    }

    showToast(title, message, variant){
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(evt);
    }

    disconnectedCallback() {
        releaseMessageContext(this.context);
    }
}
/**
 * Created by BalazsBiro on 14/08/2022.
 */

import { LightningElement, api, wire, track } from 'lwc';
import getPricebookEntries from '@salesforce/apex/AvailableProductsController.getPricebookEntries';

const columns = [
    { label: 'Product Name', fieldName: 'Name', type: 'text' },
    {
        label: 'List Price',
        fieldName: 'UnitPrice',
        type: 'currency',
        typeAttributes: { currencyCode: 'EUR', step: '0.01' },
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

    connectedCallback() {
        this.getProducts();
    }


    handlePageNextAction(){
        this.pageNumber = this.pageNumber+1;
        this.getProducts();
    }


    handlePagePrevAction(){
        this.pageNumber = this.pageNumber-1;
        this.getProducts();
    }


    getProducts(){
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
        var isDisplay = true;
        if(this.pricebookEntries){
            if(this.pricebookEntries.length == 0){
                isDisplay = true;
            }else{
                isDisplay = false;
            }
        }
        return isDisplay;
    }

    getSelectedName(event) {
        const selectedRows = event.detail.selectedRows;
        // Display that fieldName of the selected rows
        for (let i = 0; i < selectedRows.length; i++) {
            alert('You selected: ' + selectedRows[i].Name);
        }
    }
}
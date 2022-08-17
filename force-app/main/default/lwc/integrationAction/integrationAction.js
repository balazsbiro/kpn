/**
 * Created by BalazsBiro on 15/08/2022.
 */

import { LightningElement, api } from 'lwc';
import integrateOrder from '@salesforce/apex/IntegrationActionController.integrateOrder';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecordNotifyChange } from 'lightning/uiRecordApi';
import { showToast } from 'c/utils';

export default class IntegrationAction extends LightningElement {
    @api recordId;
    isLoading = false;

    handleClick(event){
        this.isLoading = true;
        integrateOrder({orderId: this.recordId})
        .then(result => {
            showToast('Order Integrated', 'Successfully integrated the Order', 'success');
            getRecordNotifyChange([{recordId: this.recordId}]);
        })
        .catch(error => {
            showToast('Error', error.body.message, 'error');
        })
        .finally(() => {
            this.isLoading = false;
        });
    }
}
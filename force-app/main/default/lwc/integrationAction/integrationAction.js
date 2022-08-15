/**
 * Created by BalazsBiro on 15/08/2022.
 */

import { LightningElement, api } from 'lwc';
import integrateOrder from '@salesforce/apex/IntegrationUtil.integrateOrder';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecordNotifyChange } from 'lightning/uiRecordApi';

export default class IntegrationAction extends LightningElement {
    @api recordId;

    handleClick(event){
        integrateOrder({orderId: this.recordId})
        .then(result => {
            this.showToast('Order Integrated', 'Successfully integrated the Order', 'success');
            getRecordNotifyChange([{recordId: this.recordId}]);
        })
        .catch(error => {
            this.showToast('Error', error.body.message, 'error');
        });
    }

    showToast(title, message, variant){
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(evt);
    }

}
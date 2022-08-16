import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export function showToast(title, message, variant){
   const evt = new ShowToastEvent({
       title: title,
       message: message,
       variant: variant,
   });
   dispatchEvent(evt);
}

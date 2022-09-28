import { LightningElement, api } from 'lwc';

export default class ChildLwc extends LightningElement {
    @api progressValue = 0;
    handleChange(event){
        this.progressValue = event.target.value;
        //create the custom event
        const newEvent = new CustomEvent("progressvaluechange",{
            detail: this.progressValue
        });

        //Dispatch the Event
        this.dispatchEvent(newEvent);
    }
}
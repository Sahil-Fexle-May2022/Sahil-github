import { LightningElement ,api } from 'lwc';


export default class ChildWebComponent extends LightningElement {
    @api childName;

    @api handleChangeValue(){
       this.childName = "Hello People"
    }
}

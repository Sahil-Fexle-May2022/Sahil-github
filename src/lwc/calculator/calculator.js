import { LightningElement } from 'lwc';

export default class Calculator extends LightningElement {
    Result;
    Num1;
    Num2;
    handleNum1(event){
        this.Num1 = event.target.value;
    }
    handleNum2(event){
        this.Num2 = event.target.value;
    }
    callAdd(event){
        this.Result = parseInt(this.Num1) + parseInt(this.Num2);
    }
    callSubtract(event){
        this.Result = parseInt(this.Num1) - parseInt(this.Num2);
    }
    callMultiply(event){
        this.Result = parseInt(this.Num1) * parseInt(this.Num2);
    }
    callDivide(event){
        this.Result = parseInt(this.Num1) / parseInt(this.Num2);
    }
}

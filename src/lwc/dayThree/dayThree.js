import { LightningElement, wire } from 'lwc';
import methodOne from '@salesforce/apex/MethodList.getTextMethod1';
import methodTwo from '@salesforce/apex/MethodList.getTextMethod2';
import methodThree from '@salesforce/apex/MethodList.getTextMethod3';

export default class DayThree extends LightningElement {
    @wire(methodOne) resultOne;
    @wire(methodTwo) resultTwo;
    @wire(methodThree) resultThree;

    handleLoadOne(){
        methodOne()
            .then(result => {
                this.resultOne = result;
        })
            .catch(error => {
                this.error = error;
        });
    }
    handleLoadTwo(){
        methodOne()
            .then(result => {
                this.resultOne = result;
        })
        methodTwo()
            .then(result =>{
                this.resultTwo = result;
            })
            .catch(error => {
                this.error = error;
        });
    }
    handleLoadThree(){
        methodOne()
            .then(result => {
                this.resultOne = result;
        })
        methodTwo()
            .then(result =>{
                this.resultTwo = result;
            })
        methodThree()
            .then(result =>{
                this.resultThree = result;
            })
            
            .catch(error => {
                this.error = error;
        });
    }
}
import { LightningElement, api } from 'lwc';

export default class Paginator extends LightningElement {
    
    @api pageNumber;
    @api pageSize;
    @api totalRecords;

    handlePrevious() {
        this.dispatchEvent(new CustomEvent('previous'));
    }

    handleNext() {
        this.dispatchEvent(new CustomEvent('next'));
    }
}

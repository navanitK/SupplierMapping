import { LightningElement, api } from 'lwc';

export default class Paginator extends LightningElement {
    
    @api pageNumber;
    @api pageSize;
    @api totalRecords;
    
    @api
    get showing(){
        console.log('showing');
        return (this.pageSize < this.totalRecords) ? this.pageSize : this.totalRecords;
    }

    handlePrevious() {
        this.dispatchEvent(new CustomEvent('previous'));
    }

    handleNext() {
        this.dispatchEvent(new CustomEvent('next'));
    }
}

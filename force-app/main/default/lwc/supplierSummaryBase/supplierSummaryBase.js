import { LightningElement, api, wire, track } from 'lwc';

import getSupplierSummary from '@salesforce/apex/SupplierSummaryController.getSupplierData';
const pageSize = 5;
const initialPageNumber = 1;
const userHasAccess = true;

export default class SupplierSummaryBase extends LightningElement {
    
    drillOnSupplier;
    searchLabel = 'Search Supplier Name';
    pageNumber = initialPageNumber;
    pageSize = pageSize;
    userHasAccess = userHasAccess;
    
    @api recordId;
    city = null;
    searchKey = null;

    summary;
    error;

    connectedCallback(){
        this.totalRecords = 100;        
    }

    @wire(getSupplierSummary, { 
        accountId : '$recordId',
        accountBillingCity : '$city',
        supplierName : '$searchKey',
        pageSize : '$pageSize',
        pageNumber : '$pageNumber'
     })
     processSupplierData({ error, data }) {
        console.log('*** data ' + JSON.stringify(data));
        console.log('*** error ' + JSON.stringify(error));
        if (data) {
            this.summary = data;                                
            this.error = undefined;
            //this.processResult();
        } else if (error) {
            this.error = error;
            this.summary = undefined;
        }
    }    

    handleSearchKeyUpdated(event){
        console.log('handleSearchKeyUpdated' + JSON.stringify(event.detail));       
        this.searchKey = event.detail.searchResult;
        this.pageNumber = 3;
    }

    handleOnNext(){
        console.log('Clicked Next');        
    }

    handleOnPrevious(){
        console.log('Clicked Previous');
                
    }
}
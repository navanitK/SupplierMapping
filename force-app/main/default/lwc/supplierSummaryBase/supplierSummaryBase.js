import { LightningElement, api, wire, track } from 'lwc';

import getSupplierSummary from '@salesforce/apex/SupplierSummaryController.getSupplierData';

const pageSize = 5;
const initialPageNumber = 1;
const userHasAccess = true;

const actions = [
    { label: 'Show on Map', name: 'showOnMap' }
];

const supplierColumns = [
    { label: 'Supplier Name', fieldName: 'name', type: 'text', sortable: false },
    { label: 'City', fieldName: 'city', type: 'text', sortable: false},
    { label: 'Status', fieldName: 'latitude', type: 'text', sortable: false},
    { label: 'Status', fieldName: 'longitude', type: 'text', sortable: false},
    { type: 'action', typeAttributes: { rowActions: actions, menuAlignment: 'right' } }
];

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

    @track supplierData = [];
    supplierColumns = supplierColumns;

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
            this.processResult();
        } else if (error) {
            this.error = error;
            this.summary = undefined;
        }
    }
    
    processResult(){
        this.supplierData = [];
        if(this.summary == undefined){
            console.log('***** undefined');
            return;
        }
        let supplierSummary = [];
        this.summary.forEach(function (row) {
            var supplierItem  = { id : row.Id, name : row.Name, city : row.City__c, latitude : '' , longitude : ''};
            console.log('***** supplierItem' + JSON.stringify(supplierItem));
            supplierSummary.push(supplierItem);
            
        }); 
        console.log('***** faggot' + JSON.stringify(supplierSummary));
        this.supplierData = supplierSummary;
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

    handleShowOrders(event){
        console.log('Clicked show orders' + JSON.stringify(event.detail));
        
    }
}
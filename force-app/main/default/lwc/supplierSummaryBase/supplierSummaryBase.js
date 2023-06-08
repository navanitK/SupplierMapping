import { LightningElement, api, wire, track } from 'lwc';
import getSupplierSummary from '@salesforce/apex/SupplierSummaryController.getSupplierData';
import { getRecord } from 'lightning/uiRecordApi';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import SUPPLIER_OBJECT from '@salesforce/schema/Supplier__c';	
import MISSING_SUPPLIER_ACCESS from '@salesforce/label/c.MissingSupplierAccess';


const FIELDS = [
    'Account.BillingCity'
];
const pageSize = 5;
const initialPageNumber = 1;
const totalRecords = 0;
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
    
    label = {
        MISSING_SUPPLIER_ACCESS
    };
    
    searchLabel = 'Search Supplier Name';
    pageNumber = initialPageNumber;
    pageSize = pageSize;
    totalRecords = totalRecords;

    userHasAccess = userHasAccess;
    
    @api recordId;
    city = null;
    searchKey = null;

    summary;
    error;

    @track supplierData = [];
    supplierColumns = supplierColumns;

    mapMarkers = [];

    hasSupplierRead = false;
    noRecordsFound = true;

    connectedCallback(){
                
    }

    @wire(getObjectInfo, { objectApiName: SUPPLIER_OBJECT })
    wiredData({data, error}){
        console.log('*** getObjectInfo data ' + JSON.stringify(data));
        console.log('***  getObjectInfo error ' + JSON.stringify(error));
        if (data) {
            this.hasSupplierRead = data.queryable;
        } 
        if (error) {
            //
        }
     }

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredRecord({ error, data }) {
        if (data) {
            this.city = data.fields.BillingCity.value;                                
            this.error = undefined;            
        } else if (error) {
            this.error = error;
            this.city = undefined;
        }        
        console.log('*** data ' + JSON.stringify(data));
        console.log('*** error ' + JSON.stringify(error));
    }

    @wire(getSupplierSummary, { 
        city : '$city',
        searchKey : '$searchKey',
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
        this.summary.supplierData.forEach(function (row) {
            var supplierItem  = { id : row.Id, name : row.Name, city : row.City__c, latitude : row.SupplierLocation__c.latitude , longitude : row.SupplierLocation__c.longitude};
            
            supplierSummary.push(supplierItem);
            
        }); 
        
        this.supplierData = supplierSummary;
        this.totalRecords = this.summary.totalRecords;
        if(this.summary.totalRecords === 0){
            this.noRecordsFound = true;
        }
    }

    handleSearchKeyUpdated(event){
        console.log('handleSearchKeyUpdated' + JSON.stringify(event.detail));       
        this.searchKey = event.detail.searchResult;
        this.pageNumber = 1;
    }

    handleOnNext(){
        console.log('Clicked Next');   
        console.log('Clicked Next');
        if(this.pageNumber < 3){
            this.pageNumber = this.pageNumber + 1;
        }else {
            alert('Cant go Forwards - Admin has limited to 3 pages only');
        }     
    }

    handleOnPrevious(){
        console.log('Clicked Previous');
        if(this.pageNumber > 1){
            this.pageNumber = this.pageNumber - 1;
        }else {
            alert('Cant go Back');
        }
                
    }

    handleShowOrders(event){
        console.log('Clicked show orders' + JSON.stringify(event.detail));
        let selectedSupplier = event.detail;
        let locationArray = [];
        let locationObj = {};
        let locationRow = {};
        locationObj.Latitude = selectedSupplier.latitude;
        locationObj.Longitude = selectedSupplier.longitude;        
        locationRow.location = locationObj;
        locationArray.push(locationRow);
        console.log('*** locationArray' + JSON.stringify(locationArray));
        this.mapMarkers = locationArray;
    }
}
import { LightningElement, api } from 'lwc';

export default class supplierTable extends LightningElement {
    @api supplierColumns; 
    @api supplierData;
    
    connectedCallback(){
        console.log('*** supplierData' + JSON.stringify(this.supplierData));
        console.log('*** supplierColumns' +  JSON.stringify(this.supplierColumns));
    }

    handleDrillDown(event){
        console.log('***'+JSON.stringify(event.detail));
        this.dispatchEvent(new CustomEvent('showsupplier',{
            detail : {
                supplierId : event.detail.row.id
            }
        }));
    }

}
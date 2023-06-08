import { LightningElement, api } from 'lwc';

export default class Search extends LightningElement {
    
    @api searchLabel;
    
    handleSearch(event) {
        const searchKey = event.target.value.toLowerCase();
        this.dispatchEvent(new CustomEvent('searchkeyupdated',{
            detail : {
                searchResult : searchKey                
            }
        }));
    }
}

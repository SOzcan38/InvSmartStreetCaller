/**
 * InvSmartyStreetCaller class
 * 
 * This class makes HTTP requests to the SmartyStreet API for location details.
 * It updates Location__c records with verification status from the API.
 *
 * Usage:
 * Use with a list of location IDs. It makes asynchronous callouts and updates the location status.
 *
 * Note:
 * Set SmartyStreet API credentials in Named Credentials in the org before using this class.
 */
public with sharing class InvSmartyStreetCaller {

    @InvocableMethod(label='SmartyStreetAPI' description='Makes an HTTP GET to SmartyStreet.com' category='Location__c')
    /**
     * Processes Location__c IDs, calling the SmartyStreet API for each.
     * @param locationIds List of Location__c record IDs for API callouts.
     */
    public static void getAccountNames(List<Id> locationIds) {
        for (Id locId : locationIds) {
            makeCallout(locId);
        }
    }

    @future(callout=true)
    /**
     * Asynchronous HTTP GET call to SmartyStreet API using a location ID.
     * Handles request construction, response processing, and record updating.
     * @param locId The ID of the Location__c record for the API call.
     */
    private static void makeCallout(Id locId){
        try {
            // Query location from Location__c object
            Location__c location = [SELECT City__c, Postal_Code__c, State__c, Street__c FROM Location__c WHERE Id=:locId];

            // Get API credentials
            SmartyStreetCreds__c setting = SmartyStreetCreds__c.getOrgDefaults();

            // Prepare URL for API call
            String path = '/street-address'
                + '?auth-id=' + setting.Auth_Id__c
                + '&auth-token=' + setting.AuthToken__c
                + '&street=' + EncodingUtil.urlEncode(location.Street__c, 'UTF-8')
                + '&city=' + EncodingUtil.urlEncode(location.City__c, 'UTF-8')
                + '&state=' + EncodingUtil.urlEncode(location.State__c, 'UTF-8')
                + '&zipcode=' + location.Postal_Code__c
                + '&match=enhanced';
            System.debug('path: ' + path);

            //Prepare HttpRequest and wrap all the necessary information in it
            HttpRequest request = new HttpRequest();
            request.setEndpoint('callout:SmartStreetAPI' + path);
            request.setMethod('GET');
            //Prepare internet
            Http http = new Http();

            //Send the request over the internet in order to receive response
            HttpResponse response = http.send(request);

            //Process the response
            Integer StatusCode = response.getStatusCode();
            System.debug('StatusCode: ' + StatusCode);

            String respBody = response.getBody();
            System.debug('respBody: ' + respBody);

            // Update Location__c record
            update new Location__c(Id = locId, Verified__c = StatusCode == 200);
        } catch(Exception exc) {
            // Log exception
            String msg = exc.getMessage() + ' (Line:' + exc.getLineNumber() + ')';
            System.debug('EXC: ' + msg);
            ErrorLogHelper.createErrorLog('InvSmartyStreetCaller', 'makeCallout', msg);
        }
    }
}

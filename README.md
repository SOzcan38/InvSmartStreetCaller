# InvSmartyStreetCaller

## Overview
This Salesforce Apex code connects with the SmartyStreet API. It checks addresses in Salesforce using this API.

## Features
- **Bulk Processing**: Works with many addresses at once.
- **Asynchronous Callouts**: Makes API requests without slowing down Salesforce.
- **Error Handling**: It logs errors for troubleshooting.

## Before You Start
- You should have a Salesforce account with permissions to add Apex code.
- Set up SmartyStreet API credentials in Salesforce's Named Credentials.

## How to Set Up
1. **Named Credentials**:
   - Go to Salesforce Setup.
   - Find 'Named Credentials'.
   - Make a Named Credential named `SmartStreetAPI`. Add the SmartyStreet API details.

2. **Add the Code**:
   - Download the code from this repository.
   - Use Salesforce CLI or another tool to put the code in your Salesforce.

## How to Use
1. Get a list of Salesforce record IDs for `Location__c`.
2. Run the `processLocationUpdates` method with these IDs.

Example:
```apex
List<Id> locationIds = ['ID1', 'ID2']; // Replace with real IDs
InvSmartyStreetCaller.processLocationUpdates(locationIds);
```

## Testing the Code
I have a test class `InvSmartyStreetCallerTester`. It has two tests:
- **Negative Test**: Checks what happens if the API fails.
- **Positive Test**: Tests a successful API call using a fake API response.

To run these tests, add the test class to Salesforce and run it like any other Apex test.

## Things to Know
- The code does not retry failed API calls.
- Error handling is basic.

## Helping Out
If you want to improve this code:
- Fork this repository.
- Make changes in a new branch.
- Test your code.
- Send a pull request with details about your changes.

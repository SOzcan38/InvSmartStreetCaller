@isTest
public with sharing class InvSmartyStreetCallerTester {
    
    // Test method to simulate a negative scenario
    @isTest
    static void testNegative(){
        // Creating a new Location record with mock data
        Location__c location = new Location__c(
            Name = 'Test Address Name',
            City__c = 'TestCity',
            Postal_Code__c = '123',
            State__c = 'TestState',
            Street__c = 'TestStreet',
            Branch__c = 'Brooklyn'
        ); 

        // Start test context to monitor governor limits
        Test.startTest();

        // Inserting the location record into the database
        insert location;

        // Stop test context
        Test.stopTest();

        // Querying for the count of error logs related to the InvSmartyStreetCaller class
        Integer logCount = [SELECT COUNT() FROM Error_Log__c WHERE ApexClass__c = 'InvSmartyStreetCaller'];
        
        // Assert to verify that an error log was created (expecting 1 error log)
        System.assertEquals(1, logCount);
    }

    // Test method to simulate a positive scenario
    @isTest
    static void testPositive(){
        // Creating a new Location record with mock data
        Location__c location = new Location__c(
            Name = 'Test Address Name',
            City__c = 'TestCity',
            Postal_Code__c = '123',
            State__c = 'TestState',
            Street__c = 'TestStreet',
            Branch__c = 'Brooklyn'
        ); 
        
        // Setting a mock HTTP callout to avoid external calls in test execution
        Test.setMock(HttpCalloutMock.class, new MockSmartyStreetAPI());

        // Start test context
        Test.startTest();

        // Inserting the location record into the database
        insert location;

        // Stop test context
        Test.stopTest();

        // Retrieving the updated location record from the database
        location = [SELECT Verified__c FROM Location__c WHERE Id =: location.Id];

        // Assert to verify that the location has been verified (expecting Verified__c to be true)
        System.assert(location.Verified__c);
    }

    // Mock class to simulate HTTP callout responses
    private class MockSmartyStreetAPI implements HttpCalloutMock {
        // Method to provide a mock HTTP response
        public HTTPResponse respond(HTTPRequest req) {
            // Creating a fake HTTP response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"example":"test"}');
            res.setStatusCode(200);
            return res;
        }
    }
}

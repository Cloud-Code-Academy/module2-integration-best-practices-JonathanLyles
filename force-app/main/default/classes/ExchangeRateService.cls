/**
 * @description Service class that handles API callouts to the Exchange Rate API
 * Students will implement the methods to make callouts and process responses
 */
public class ExchangeRateService {
    
    // The named credential to use for the callout
    private static final String NAMED_CREDENTIAL = 'ExchangeRate_API';
    
    // The base currency to use for exchange rates
    private static final String BASE_CURRENCY = 'USD';
    
    /**
     * @description Makes a callout to the Exchange Rate API to get the latest exchange rates
     * @return ExchangeRateWrapper containing the response data
     */
    public static ExchangeRateWrapper getLatestRates() {
        // TODO: Implement the method to make a callout to the Exchange Rate API
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:' + NAMED_CREDENTIAL + '/latest/' + BASE_CURRENCY);
        req.setMethod('GET');
        Http http = new Http();
        HttpResponse res = http.send(req);
        System.debug(res);
        try{
            if(res.getStatusCode() >= 200 && res.getStatusCode() <= 300){
                ExchangeRateWrapper exchangeRateWrapperData = ExchangeRateWrapper.parse(res.getBody());
                return exchangeRateWrapperData;
            }else{
                throw new ExchangeRateException('Error: Something bad happened, this message is supposed to help you');
            }
        }catch(ExchangeRateException e){
            //Log Error
            Exchange_Rate_Integration_Log__c log = new Exchange_Rate_Integration_Log__c();
            log.Type__c = 'ExchangeRateException Error';
            log.Message__c = 'Error getting rates: ' + e.getMessage();
            insert log;
            throw e; //Rethrow so the test can see it
        }
        catch(Exception e){
             //Log Error
             Exchange_Rate_Integration_Log__c log = new Exchange_Rate_Integration_Log__c();
             log.Type__c = 'Exception Error';
             log.Message__c = 'Error getting rates: ' + e.getMessage();
             insert log;
        }
        return null;
    }
    
    /**
     * @description Processes the exchange rate data and creates or updates records
     * @param rateData The wrapper containing exchange rate data
     * @return List<Exchange_Rate__c> The list of records created or updated
     */
    public static List<Exchange_Rate__c> processRates(ExchangeRateWrapper rateData) {
        // TODO: Implement the method to process rates and create/update records
        List<Exchange_Rate__c> exchangeRates = rateData.toExchangeRates();
        upsert exchangeRates external_Id__c;
        return exchangeRates; 
    }
    
    /**
     * @description Combines getting and processing rates into a single operation
     * @return List<Exchange_Rate__c> The list of records created or updated
     */
    public static List<Exchange_Rate__c> updateExchangeRates() {
        // TODO: Implement the method to get and process rates
        // 1. Call getLatestRates to retrieve the data
        ExchangeRateWrapper wrapper = ExchangeRateService.getLatestRates();
        // 2. Call processRates to create/update records
        List<Exchange_Rate__c> exchangeRates = ExchangeRateService.processRates(wrapper);
        // 3. Return the processed records
        upsert exchangeRates external_Id__c;
        return exchangeRates; // Replace with actual implementation
    }
}
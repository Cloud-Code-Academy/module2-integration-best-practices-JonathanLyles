/**
 * @description Wrapper class to deserialize the JSON response from the Exchange Rate API
 * Students will implement the properties and methods to process the data
 */
public class ExchangeRateWrapper {
    public String base_code;
    public String time_last_update_unix;
    public Map<String, Decimal> conversion_rates; 
    public String externalId;
    /**
     * @description Converts the wrapper data to a list of Exchange_Rate__c records
     * @return List<Exchange_Rate__c> The list of exchange rate records
     */
    
    public List<Exchange_Rate__c> toExchangeRates() {
        //Timestamp begin
        Long unixTimestamp = Long.valueOf(time_last_update_unix); //Convert String to Numeric value
        DateTime gmtTimestamp = DateTime.newInstance(unixTimeStamp * 1000); //Convert to milliseconds
        System.TimeZone userTimeZone = UserInfo.getTimeZone();
        Integer millisecondOffsetGmt = userTimeZone.getOffset(gmtTimestamp);
        DateTime localTimestamp = Datetime.newInstance(  (unixTimestamp *1000)+ (millisecondOffsetGmt) );
        //Timestamp end
        // TODO: Implement the method to convert the wrapper data to Exchange_Rate__c records
        // 1. Create a list to hold the Exchange_Rate__c records
        List<Exchange_Rate__c> records = new List<Exchange_Rate__c>();
        // 2. Iterate through the rates map
        for(String rate : conversion_rates.keySet()){
        // 3. For each rate, create an Exchange_Rate__c record
            Exchange_Rate__c exchRecord = new Exchange_Rate__c();
            exchRecord.Base_Currency__c = base_code;
            exchRecord.Last_Updated__c = localTimestamp;
            exchRecord.external_Id__c = base_code + '_' + rate; // public String externalId; baseCurrency + '_' + targetCurrency
            exchRecord.Rate__c = conversion_rates.get(rate);
            exchRecord.Target_Currency__c = rate;
            records.add(exchRecord);
        }
        // 4. Return the list of records
        return records; // Replace with actual implementation
    }
    
    /**
     * @description Static method to parse the JSON response into the wrapper class
     * @param jsonResponse The JSON response from the API
     * @return ExchangeRateWrapper The parsed wrapper instance
     */
    public static ExchangeRateWrapper parse(String jsonResponse) {
        // TODO: Implement the method to parse the JSON response
        // Use JSON.deserialize or JSON.deserializeStrict to parse the response
        ExchangeRateWrapper exchangeRateWrapper = (ExchangeRateWrapper) JSON.deserialize(jsonResponse, ExchangeRateWrapper.class);
        return exchangeRateWrapper; // Replace with actual implementation
    }
}
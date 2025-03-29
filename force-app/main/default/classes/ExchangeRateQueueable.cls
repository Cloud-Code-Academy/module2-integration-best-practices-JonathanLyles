public with sharing class ExchangeRateQueueable implements Queueable, Database.AllowsCallouts{
    public void execute(QueueableContext context){
        try{
            ExchangeRateService.updateExchangeRates();
        }catch(Exception e){
            //Log Error
            Exchange_Rate_Integration_Log__c log = new Exchange_Rate_Integration_Log__c();
            log.type__c = 'Error';
            log.message__c = 'Error updating rates: ' + e.getMessage();
            insert log;
            
        }
    }
}
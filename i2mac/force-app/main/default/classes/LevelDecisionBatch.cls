global class LevelDecisionBatch implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        Date recentNinetyDays = System.today().addDays(-90);
        /* 
        본체 최근 90일 구매 금액, 
        주변기기 최근 90일 구매 금액 조회 및 합산 후 등급 결정 */
        return Database.getQueryLocator(
            'SELECT BodyPart_Amount__c, SubPart_Amount__c FROM Contact '
        )
    }

    global void execute(Database.BatchableContext BC, List<Contact> scope) {
        /*
        등급 결정 방법
        A등급(500만원 이상), B등급(200만원 이상), C등급(200만원 미만)
        D등급은 0원으로
        */
    }

    global void finish(Database.BatchableContext BC) {
        System.debug('Batch is done');
    }
    


}
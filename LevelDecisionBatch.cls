global class LevelDecisionBatch implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        Date recentNinetyDays = System.today().addDays(-90);
        /* 
        본체 최근 90일 구매 금액, 
        주변기기 최근 90일 구매 금액 조회 및 합산 후 등급 결정 */
        return Database.getQueryLocator(
            'SELECT BodyPart_Amount__c, SubPart_Amount__c, PhoneNumber__c FROM Contact'
        );
    }

    global void execute(Database.BatchableContext BC, List<Contact> scope) {
        for (Contact contact : scope) {
            Decimal bodyPartAmount = contact.BodyPart_Amount__c != null ? contact.BodyPart_Amount__c : 0;
            Decimal subPartAmount = contact.SubPart_Amount__c != null ? contact.SubPart_Amount__c : 0;
            Decimal totalAmount = bodyPartAmount + subPartAmount;

            if (totalAmount >= 5000000) {
                contact.Level__c = 'RatingA';
            } else if (totalAmount >= 2000000) {
                contact.Level__c = 'RatingB';
            } else if (totalAmount > 0) {
                contact.Level__c = 'RatingC';
            } else {
                contact.Level__c = 'RatingD';
            }
        }
        update scope;
    }
    global void finish(Database.BatchableContext BC) {
        System.debug('Batch is done');
    }
}
/* 실행
LevelDecisionBatch levelBatch = new LevelDecisionBatch();
Database.executeBatch(levelBatch);
*/
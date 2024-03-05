global class AmountBatch implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // 90일 전 날짜 계산
        Date ninetyDaysAgo = System.today().addDays(-90);
        // 최근 90일 동안의 주문과 환불을 포함한 OrderItem 조회 쿼리
        return Database.getQueryLocator(
            'SELECT OrderId, Product2.Family, TotalPrice, Order.Status ' +
            'FROM OrderItem ' +
            'WHERE Order.CreatedDate >= :ninetyDaysAgo ' +
            'AND (Order.Status = \'주문\' OR Order.Status = \'환불\') ' +
            'AND Product2.Family IN (\'BodyPart\', \'SubPart\')');
    }
    
    global void execute(Database.BatchableContext BC, List<OrderItem> scope) {
        // 고객별 구입금액 계산 로직
        Map<Id, Decimal> bodyPartAmounts = new Map<Id, Decimal>();
        Map<Id, Decimal> subPartAmounts = new Map<Id, Decimal>();
        
        for(OrderItem item : scope) {
            Order relatedOrder = [SELECT ContactId FROM Order WHERE Id = :item.OrderId];
            Id contactId = relatedOrder.ContactId;
            Decimal price = item.TotalPrice;
            if(item.Order.Status == '환불') {
                price = -price;
            }
            
            if(item.Product2.Family == 'BodyPart') {
                bodyPartAmounts.put(contactId, bodyPartAmounts.get(contactId) == null ? price : bodyPartAmounts.get(contactId) + price);
            } else if(item.Product2.Family == 'SubPart') {
                subPartAmounts.put(contactId, subPartAmounts.get(contactId) == null ? price : subPartAmounts.get(contactId) + price);
            }
        }
        
        // 여기에서 Contact 레코드 업데이트 로직 추가
    }
    
    global void finish(Database.BatchableContext BC) {
        // 필요한 마무리 작업 (예: 알림 발송)
    }
}

@isTest
private class AmountBatchTest {
    @TestSetup
    static void setup() {
        // 테스트 데이터 설정
        List<Contact> testContacts = new List<Contact>{
            new Contact(FirstName='Test', LastName='Contact1'),
            new Contact(FirstName='Test', LastName='Contact2')
        };
        insert testContacts;

        // Order와 OrderItem을 생성하여 테스트 데이터 준비
        // 주의: 실제 필드명과 데이터 타입은 Salesforce 설정에 따라 다를 수 있음
    }
    
    @isTest
    static void testCalculatePurchaseAmountBatch() {
        // 테스트 데이터 조회
        Contact testContact = [SELECT Id FROM Contact WHERE LastName='Contact1' LIMIT 1];
        
        // Batch 클래스 인스턴스 생성 및 실행
        Test.startTest();
        CalculatePurchaseAmountBatch batch = new CalculatePurchaseAmountBatch();
        Database.executeBatch(batch);
        Test.stopTest();

        // Batch 실행 결과 검증
        // 예: Contact의 '본체 구입금액'과 '주변기기 구입금액'이 기대하는 값으로 설정되었는지 확인
        Contact updatedContact = [SELECT BodyAmount__c, SubPartAmount__c FROM Contact WHERE Id=:testContact.Id];
        System.assertNotEquals(null, updatedContact.BodyAmount__c, '본체 구입금액이 업데이트되지 않았습니다.');
        System.assertNotEquals(null, updatedContact.SubPartAmount__c, '주변기기 구입금액이 업데이트되지 않았습니다.');
        
        // 필요한 추가 검증 로직 작성
        // 예: 구입금액이 정확히 계산되었는지 등
    }
}

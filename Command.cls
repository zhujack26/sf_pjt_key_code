String[] cho = new String[]{'김','이','박','최','정','강','조','윤','장','임','한','오','서','신','권','황'};
String[] jung = new String[]{'영','지','민','수','예','준','현','유','석','인','주','명','동','광','병'};
String[] jong = new String[]{'호','후','아','은','진','하','연','용','욱','익','지','승','우','선','학'};

String[] accountNames = new String[]{
    '강원도점', '경기도점', '광주광역시점', '대구광역시점', '대전광역시점',
    '부산광역시점', '서울특별시점', '인천광역시점', '제주도점'
};

Map<String, Id> accountMap = new Map<String, Id>();
Map<String, Id> accountOwnerMap = new Map<String, Id>();

List<Account> accounts = [SELECT Id, Name, OwnerId FROM Account WHERE Name IN :accountNames];
for(Account acc : accounts) {
    accountMap.put(acc.Name, acc.Id);
    accountOwnerMap.put(acc.Name, acc.OwnerId);
}

List<Contact> contactsToInsert = new List<Contact>();
List<Case> casesToInsert = new List<Case>();

for(String accountName : accountNames) {
    Id accountId = accountMap.get(accountName);
    Id accountOwnerId = accountOwnerMap.get(accountName);
    for(Integer i = 0; i < 30; i++) {
        String randomName = cho[Math.mod(Math.abs(Crypto.getRandomInteger()), cho.size())] +
                            jung[Math.mod(Math.abs(Crypto.getRandomInteger()), jung.size())] +
                            jong[Math.mod(Math.abs(Crypto.getRandomInteger()), jong.size())];
        String email = 'user' + Math.mod(Math.abs(Crypto.getRandomInteger()), 10000) + i + '@example.com';
        String phone = '010-' + String.valueOf(Math.mod(Math.abs(Crypto.getRandomInteger()), 10000)).leftPad(4) + '-' + 
                       String.valueOf(Math.mod(Math.abs(Crypto.getRandomInteger()), 10000)).leftPad(4);
        
        Contact newContact = new Contact(
            LastName = randomName,
            Email = email,
            PhoneNumber__c = phone,
            AccountId = accountId,
            OwnerId = accountOwnerId, // 소유자 설정
            Type__c = '상담 고객',
            Count_Cases_c__c = 0,
            Level__c = 'RatingD'
        );
        
        contactsToInsert.add(newContact);
    }
}

// 데이터베이스에 Contact 추가
if (!contactsToInsert.isEmpty()) {
    insert contactsToInsert;
    for(Contact contact : contactsToInsert) {
        // 각 Contact에 대한 Case 생성
        Case newCase = new Case(
            ContactId = contact.Id,
            Description = contact.LastName + ' : 단순 상담입니다',
            OwnerId = contact.OwnerId // Case의 소유자를 Contact의 소유자와 동일하게 설정
        );
        casesToInsert.add(newCase);
    }
    insert casesToInsert;
}



/*
// '상담 고객' 유형의 모든 Contact를 조회
List<Contact> allContacts = [SELECT Id FROM Contact WHERE Type__c = '상담 고객'];

// BillToContactId에 따라 Order가 있는 Contact의 ID를 저장하기 위한 Set
Set<Id> contactsWithOrders = new Set<Id>();

// 연결된 Order가 있는 모든 Contact의 ID를 조회
for (Order order : [SELECT BillToContactId FROM Order WHERE BillToContactId IN :allContacts]) {
    contactsWithOrders.add(order.BillToContactId);
}

// 삭제할 Contact를 저장할 리스트
List<Contact> contactsToDelete = new List<Contact>();

// 연결된 Order가 없는 Contact를 찾아 삭제 리스트에 추가
for (Contact contact : allContacts) {
    if (!contactsWithOrders.contains(contact.Id)) {
        contactsToDelete.add(contact);
    }
}

// 삭제할 Contact가 있으면 삭제 실행
if (!contactsToDelete.isEmpty()) {
    delete contactsToDelete;
}

// 삭제할 Contact가 있으면 삭제 실행
if (!contactsToDelete.isEmpty()) {
    delete contactsToDelete;
}


Date cutoffDate = Date.newInstance(2024, 3, 11);
        
        // 2024년 3월 11일 이전의 상담 레코드 조회 및 삭제
        List<Case> oldCases = [SELECT Id FROM Case WHERE CreatedDate < :cutoffDate];
        if (!oldCases.isEmpty()) {
            delete oldCases;
        }
        
        // 2024년 3월 11일 이전의 주문 레코드 조회 및 삭제
        List<Order> oldOrders = [SELECT Id FROM Order WHERE CreatedDate < :cutoffDate];
        if (!oldOrders.isEmpty()) {
            delete oldOrders;
        }
*/

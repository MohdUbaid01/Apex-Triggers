public class AccountTriggerHandler {
    public static void beforeInsert(List<Account> newList){
            for(Account acc : newList){
               if(acc.Industry!=Null && acc.Industry=='Media'){
                  acc.Rating='Hot';
                   }
                 }
              } 
// This is an trigger to insert an opportunity when an account is created   
public static void afterInsert(List<Account> newList){
       List<Opportunity> oppToBeInserted=new List<Opportunity>();
        for (Account acc: newList){
            Opportunity opp=new Opportunity();
            opp.Name=acc.Name;
            opp.AccountId=acc.Id;
            opp.StageName='Prospecting';
            opp.CloseDate=system.today();
            oppToBeInserted.add(opp);
            // Scenario to create an opportunity when an Account is Created.
            
        }
        if(!oppToBeInserted.IsEmpty()){
            insert oppToBeInserted;
        }
    }
    
    
//BeforeUpdate Trigger
public static void BeforeUpdateTrigger(Map<Id,Account> mapOfOldAcc , List<Account> newList){
    for(Account Acc: newList){
        if(MapofOldAcc!=null && acc.Industry!= mapOfOldAcc.get(acc.Id).Industry && acc.isAvailable__c==true){
            acc.AccountNumber='1020';
        }
        else{
            acc.AccountNumber='3040';
       }
    }   
  }
  //AfterUpdate Trigger 
  public static void AfterUpdateTrigger(Map<Id,Account> mapOfOldAcc , List<Account> newList){

   Map<Id,Account> accountMap=new Map<Id,Account>();
   List<Contact> ContactList=new List<Contact>();

   for(Account acc: newList){
    if(mapOfOldAcc!=null && acc.Phone!=mapOfOldAcc.get(acc.Id).Phone && acc.Rating=='Hot'){
    accountMap.put(acc.Id, acc);
    }
}

   List<Contact> conList=[Select Id, Name, AccountId from Contact where AccountId IN :accountMap.keySet()];
   
   for(Contact con: conList){
    Contact c=new Contact();

    if(accountMap.containsKey(con.AccountId)){
        c.Phone=accountMap.get(con.AccountId).Phone;

        c.Id=con.Id;
        ContactList.add(c);
    }
  }
   if(!ContactList.isEmpty()){
    update ContactList;
     }
  }
    
public static void BeforeDeleteTrigger(List<Account> oldAccountList){
        //preventAccountDeletion
    for(Account acc: oldAccountList){
        if(acc.isAvailable__c==True && acc.Phone!=Null){
            acc.addError('Account cannot be deleted');
        }
     }      	
   }
    
 public static void afterUndeleteAccount(List<Account> newAccList){
        system.debug('Undeleted Account=> '+newAccList);
     
        List<Account> accList=new list<Account>();
        
         for(Account acc : newAccList){
         Account accobj=new Account();
         accobj.Id=acc.Id;
         accobj.isUndelete__c=true;
         accList.add(accobj);
     }
     if(!accList.isEmpty()){
         update accList;
     }
    }
    
public static void AfterDeleteTrigger(List<Account> deletedAccount){
    List<Contact> contactsToDelete = new List<Contact>();

    // Loop through each deleted account
    for(Account acc : deletedAccount) {
        // Query contacts related to the deleted account
        List<Contact> relatedContacts = [SELECT Id FROM Contact WHERE AccountId = :acc.Id];
        
        // Add related contacts to the list
        contactsToDelete.addAll(relatedContacts);
    }
    
    // Delete the related contacts
    if (!contactsToDelete.isEmpty()) {
        delete contactsToDelete;
    }
    }
}
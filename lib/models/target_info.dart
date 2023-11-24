

class TargetInfo{
   String target; 
   int  balance;
   String firstName;
 TargetInfo(this.target, this.balance, this.firstName);

 void setBalanse(int textFieldBalanse, int baseBalance) {
 balance = baseBalance + textFieldBalanse;
 print(baseBalance);
 }
 void setName(String newName){
  target = newName;
 }
}
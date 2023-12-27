import 'package:telephony/telephony.dart';
import 'package:workmanager/workmanager.dart';


class WorkmanagerServices {
  var taskName = 'SMS';
  var message = 'hello';
  var phone = '';
  final Telephony telephony = Telephony.instance;
  void pushSMS() async {
   telephony.sendSms(to: phone, message: message);
  }

}

 void callbackDispatchers() {
    Workmanager().executeTask((taskName, inputData) {
   switch (taskName) {
      case 'SMS':
 print('3535353535353535353535353535353535');
      break;
      default:
   }
  return Future.value(true);
     }
    );
  }

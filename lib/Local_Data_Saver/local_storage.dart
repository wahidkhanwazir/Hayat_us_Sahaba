import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class StorageProvider extends ChangeNotifier{
   var lastPageRead = GetStorage();
   var lastPartRead = GetStorage();

   void setLast(int lastPage, String lastPart){
     lastPageRead.write('page', lastPage);
     lastPartRead.write('part', lastPart);
     notifyListeners();
   }

   String getLastPart(){
     if(lastPageRead.read('page') != null) {
       return lastPartRead.read('part');
     }
     else{
       return ' اول';
     }
   }
   int getLastPage(){
     if(lastPageRead.read('page') != null) {
       return lastPageRead.read('page');
     } else{
       return 0;
     }
   }
}
import '../../utils/app_constants/status_request.dart';

handlingData(response){
  if(response is ! StatusRequest){
    return StatusRequest.success;
    
  }else{
    return response;
  }
}
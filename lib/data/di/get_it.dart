import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:nike_shop/data/common/http_client.dart';
import 'package:nike_shop/data/repo/auth_repository.dart';
import 'package:nike_shop/data/source/authDataSource.dart';
import 'get_it.config.dart';


final getIt = GetIt.instance;

 
@InjectableInit(  
  initializerName: 'init', // default  
  preferRelativeImports: true, // default  
  asExtension: true, // default  
)  
void configureDependencies() {
  getIt.registerSingleton(httpClient);
  getIt.init();
}  
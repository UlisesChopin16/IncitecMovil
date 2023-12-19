import 'package:get/get.dart';
import 'package:incitec/Models/CantidadModel.dart';
import 'package:incitec/Components/charging_dialog_component.dart';
import 'package:http/http.dart' as http;
import 'package:incitec/Models/reportes_model.dart';

class GetDataController extends GetxController {
  // variables de tipo observables
  var isLoading = false.obs;
  var getDataModelReportes = GetDataModelReporte(reportes: [], cantidadTotal: []).obs;
  var getDataModelRepo = GetDataModelReportes(reportes: []).obs;
  

  getDataAires() async {
    isLoading.value = true;
    showLoading();
    try {
      // Cambiar ip cuando se cambie de internet
      // Sinó, se quedara en limbo para siempre UnU
      Uri url = Uri.parse('http://localhost/prueba/repoSelect.php');
      
      final response = await http.post(url);
      getDataModelReportes.value = getDataModelReporteFromJson(response.body);
      hideLoading();
      isLoading.value = false;
    } catch (e) {
      Exception(e);
    }
  }

  // getDataReportes() async {
  //   isLoading.value = true;
  //   showLoading();
  //   try {
  //     final response = await getReportes();
  //     getDataModelRepo.value = getDataModelReportesFromJson(response.toString());
  //     print(getDataModelRepo.value.toString());
  //     hideLoading();
  //     isLoading.value = false;
  //   } catch (e) {
  //     Exception(e);
  //   }
  // }

  showLoading({String? nombre}) {
    DialogsHelp.chargingLoading(nombre: nombre);
  }

  hideLoading() {
    DialogsHelp.closeDialog();
  }

}
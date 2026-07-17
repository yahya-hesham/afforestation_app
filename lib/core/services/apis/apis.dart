class Apis {
  //Base URL for the API endpoints For our Affrestation App project
  static const String baseUrl = 'https://backendtrail.runasp.net';
  static const String login = '/User/Login/login';
  static const String register = '/User/Register/register';
  static const String afforestationSearch = '/api/afforestation/search';
  static const String afforestation =
      '/api/afforestation'; // base for /{id} (GET, PUT, DELETE)
  static const String users = '/User/GetAll';
  static const String locations = '/Location/GetAll';
  static const String treeNames = '/Tree/GetAll';
  static const String afforestationExport = '/api/afforestation/export';
  static const String treeTypes = '/TreeType/GetAllTreeType';
}

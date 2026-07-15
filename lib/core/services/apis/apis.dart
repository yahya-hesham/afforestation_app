class Apis {
  //Base URL for the API endpoints For our Affrestation App project
  static const String baseUrl = 'https://backendtrail.runasp.net';
  static const String login = '/User/Login/login';
  static const String register = '/User/Register/register';
  static const String afforestationSearch = '/api/afforestation/search';
  static const String afforestation = '/api/afforestation'; // base for /{id} (GET, PUT, DELETE)
  static const String users = '/api/User/all';
  static const String locations = '/api/Location/all';
  static const String treeNames = '/api/TreeName/all';
}

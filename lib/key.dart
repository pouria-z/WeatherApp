import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

// ----------------------------- !!! DO NOT CHANGE THIS FILE !!! ----------------------------- //

String keyApplicationId = "Mv1RyWygXjiCQ6Gu8Ny2MRF7kHowhvY71VvGfwpt";
String keyClientKey = "qxpQvkhtfp1Qj1vomjIxys4b2KMOmcRMsdqnnX86";
String serverUrl = "https://newweatherapp.b4a.io";
String _dbApiKey;

Future getApiKey() async {
  QueryBuilder<ParseObject> _query =
  QueryBuilder<ParseObject>(ParseObject('ApiKey'));
  final _response = await _query.find();
  _dbApiKey = _response.single.get('apiKey');
  print("apiKey: $apiKey");
}

String apiKey = _dbApiKey;
// String apiKey = "bbdea9bfe56d427f9a8e2a35eea23d73";

Future getNotification() async {
  QueryBuilder<ParseObject> queryBuilder =
  QueryBuilder<ParseObject>(ParseObject('ApiKey'));
  final Subscription subscription =
  await LiveQuery().client.subscribe(queryBuilder);
  subscription.on(LiveQueryEvent.update, (ParseObject value) async {
    apiKey = value.get("apiKey");
    print("new api key: $apiKey");
  });
}

// ----------------------------- !!! DO NOT CHANGE THIS FILE !!! ----------------------------- //

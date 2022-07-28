import 'dart:convert';
import 'dart:developer';

import 'package:abrabar/logic/coctail.dart';
import 'package:gsheets/gsheets.dart';

class RecipesApi {
  static const credentials = r'''
  {
  "type": "service_account",
  "project_id": "abrabarrecipesjson",
  "private_key_id": "3e601401a3e91b714becd086adbba1e492c19d89",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC7SlkEr6ccB5Dr\nW9EgSd4ZfVxN9WicCIZYq5oQ0T++wQdrIGm7PIwkWcaxHRsNewEseux3d7M0cjid\n66d565d37KhfsHt4H3sOS5nbhFQlx1xAs2YWjdkL6w34VrAAJCJaIbAnU/UTa9y8\n3/w6u2e8ahnMWURDNg74L/WVa3uwMetNDnXAuLEzgo5pb3cANGBmCOVXOlFkOmC0\nitT5sQCYLGNa0RwK4huMlcbejoWtHVqubFXh3cdLYPBjhfoeTHdj9nDcy1uYOoaI\nCamRRcLFZuIHp5B67GMXLtDugfWMV2AO1HnrDznxQ5pdsBePB6tGhi8r+SQ+e4t1\ns2qCpmWxAgMBAAECggEAHiGKa7oUoOpIssytOswXerNT18jtAPlQH9DPsvfvEPG+\nD0qCKBjIFQsKb7EWipco666E/31W68+aczGX2oH/9s+wkOB0JLGv2u9nu8ywuvk1\nSsVx3ZwJeKTitPrBSuyFSEnWLKWRroOyWgKQ8iP3PvU03E7aMBPw2ZXhpR3LIt/G\nkNMW7Gs9y+dKtq57Am2IbAi/NLqkJ22Tm7njzs7tLPKrlp6JTphJVFlwyZxyV64j\nIqJGxlJs5MpNRhHDAhoCpnSkOYqVs/ofzOdncLdsHLVlfEBYmel4bszUjej9dtBR\nt7k/p7cq7vKrZVVKygm5qf7K03ie0PaM0xVJw95GhwKBgQDjkR4Xnol1Tw/1gCwJ\nJdDULaoGit8o9Epnb5sk4njVfyR1rIA6Qo5bKVCjjPkHXxnnI0m8ATI5weiOlAxE\nqGnbxaSS0CP8LUdwIC1uBh2SsDJM8Hqaez58K3yCphOvdNOp+eCRf28oSh437RpH\niKRFoyQtbJEnLmeHDRiGZhuwOwKBgQDSsPXfkmqeVWXSr9wixK5iKjw9nRkbJ3qs\npS8FuQSfHMYdmnOay7MpvKnvP4m38XgozU0hXy2X4AyctKHznxzf6GRgdG7E7rYN\nVhgftyHOZlaIpKxsnTubIpaIV/T7+xZjXqgYbG5KZLAsxJpTZeHw/XCUUmOAd1JQ\nSyysjeGvAwKBgFRgvnOriPRCOHyi5bEOoHvL4rtCSrR4wA3SSAhJINyoo/At4e24\nN+h9TTUXVE7zaDtXzkMzflgEGiKjqljayUV/5yG4o18hutdMVwvwoI5/XmdA03Ts\nNaL8zNH0ml/4RXNE/4tzYNfjg4jhFVloxOA9OXDOTJPmlORyaqGKwsF5AoGBALzN\nJwe5xSEtlZk/Th058qq0/laYOK9EqYGcZI7URXfv6PkONxo3/80e64khft/+2pZ1\novCMweafN64VkCsoIk/jiE+HBtwirbE1vVhuWzUCL/ky1/Bc1dUnIY38g+RqFJ3n\nbOq1//9aSyVS6JhjbBzwf7nqOpAcXP7m3pmiauLRAoGBAJwPHD26M/e5UxWyYt+m\noyLowM0NgTR2Pm7hdITLdMELxFt6K/ufcuc6CBeO6eikqulhXoRO0dbDf+Xgscqs\n4CVNamoc9Zp5knR2R7XrKN+eOQA4Q45yha2iF2BZp9fI3Z40A2rXHTiysGEMFRWn\nKi5yvIAM04Vb9KTsGubnobJC\n-----END PRIVATE KEY-----\n",
  "client_email": "abrabarrecipesjson@abrabarrecipesjson.iam.gserviceaccount.com",
  "client_id": "102107375093017941160",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/abrabarrecipesjson%40abrabarrecipesjson.iam.gserviceaccount.com"
}
''';
  static const spreadSheetId = '11V0Rjnbj8ZrH7hIa9DFakQmwAcW_KByVcij-PTW5bQw';

  static final gsheets = GSheets(credentials);
  static Worksheet? russianRecipes;
  static Worksheet? englishRecipes;

  static Future<List<Coctail>> fetchRecipes() async {
    List<Map<String, String>>? res;
    List<Map<String, String>>? engRes;
    // res = await recipesSheet?.values.allColumns();

    res = await russianRecipes!.values.map.allRows();
    engRes = await englishRecipes!.values.map.allRows();

    String json = jsonEncode(engRes);
    log(json);
    List<Coctail> allCocs = [];
    // await writeJson(res!);
    // if (engRes != null) {
    //   engRes.forEach((element) {
    //     allCocs.add(Coctail.fromGSheets(element));
    //   });
    //   // print(allCocs[1].categories);
    //   return allCocs;
    // } else {
    return [];
    // }
  }

  // static Future<void> writeJson(List<Map<String, dynamic>> import) async {
  //   final directory = await getApplicationDocumentsDirectory();
  //   final path = directory.path;
  //   final File file = File("${path}/recepies_ru.json");

  //   // String path =
  //   //     'C:/Users/Iaroslav/AndroidStudioProjects/Abrabar/abrabar/assets/';
  //   // final File file = File(
  //   //     'C:/Users/Iaroslav/AndroidStudioProjects/Abrabar/abrabar/assets/recepies_ru.json');
  //   // if (await file.exists() == false) {
  //   String json = jsonEncode(import);
  //   log(json);
  //   //   File anotherFile =
  //   //       await File("${path}recepes_ru.json").create(recursive: true);
  //   //   anotherFile.writeAsStringSync(json);
  //   // }
  //   print(await file.exists());
  //   file.writeAsString(json).then((value) {
  //     print('written');
  //   });
  //   // print(json);
  // }

  static Future init() async {
    final spreadsheet = await gsheets.spreadsheet(spreadSheetId);
    russianRecipes = await getSheet(spreadsheet, title: "recipes");
    englishRecipes = await getSheet(spreadsheet, title: "recipes_eng");
  }

  static Future<Worksheet> getSheet(Spreadsheet spreadsheet,
      {required String title}) async {
    try {
      return await spreadsheet.addWorksheet(title);
    } catch (e) {
      return spreadsheet.worksheetByTitle(title)!;
    }
  }
}

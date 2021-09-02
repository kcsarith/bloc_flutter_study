import 'package:gsheets/gsheets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GoogleSheetsAPI {
  final Worksheet sheet;
  final Spreadsheet spreadSheet;
  GoogleSheetsAPI(this.sheet, this.spreadSheet);
  void initializeGSheets() async {
    await dotenv.load(fileName: ".env");
    // your spreadsheet id
    String _spreadsheetId = dotenv.env['SPREADSHEET_ID'];

    var _credentials = '''{
    "type": "${dotenv.env['TYPE']}",
    "project_id": "${dotenv.env['PROJECT_ID']}",
    "private_key_id": "${dotenv.env['PRIVATE_KEY_ID']}",
    "private_key": "${dotenv.env['PRIVATE_KEY']}",
    "client_email": "${dotenv.env['CLIENT_EMAIL']}",
    "client_id": "${dotenv.env['CLIENT_ID']}",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": "${dotenv.env['CLIENT_X509_CERT_URL']}"}''';

    // init GSheets
    final gsheets = GSheets(_credentials);
    // fetch spreadsheet by its id
    final ss = await gsheets.spreadsheet(_spreadsheetId);
    // get worksheet by its title
    final sheet = await ss.worksheetByTitle('Sheet1');

    Future<void> basic() async {
      // prints - [100, Product A, 50, 100.0]
      print(await sheet.values.row(2));

      // prints - [Product A, Product B, Product C, Product D, Product F, Product G]
      // we use 'fromRow' to skip first row
      print(await sheet.values.column(2, fromRow: 2));

      // prints - Product A
      print(await sheet.values.value(row: 2, column: 2));

      // inserts passed values into second row
      await sheet.values.insertRow(
        2,
        [200, 'Ex Product A', 60, 110.0],
      );

      // updates B2 cell by inserting passed value
      await sheet.values.insertValue(
        'Product A',
        row: 2,
        column: 2,
      );

      // appends passed values to the products table
      await sheet.values.appendRow(
        [200, 'Ex Product A', 60, 110.0],
      );

      // deletes row #8
      // await sheet.deleteRow(8);
    }

    await basic();
  }
}

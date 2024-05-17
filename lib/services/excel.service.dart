part of alghwalbi_core;

/// Generate an Excel file:
/// -----------------------
/// await ExcelService.generateExcel(
///   props: [ReportProperty(name: 'Header1', dbName: 'field1')],
///   data: [{'field1': 'Value1'}],
///   fileName: 'MyReport',
///   sheetName: 'MySheet',
/// );
/// -----------------------------------------------------------------------
/// Set cell style:
/// ---------------
/// var excel = Excel.createExcel();
/// var sheet = excel.sheets[excel.getDefaultSheet()]!;
/// ExcelService.setCellStyle(sheet, CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0), CellStyle(fontColorHex: 'FFFF0000'));
class ExcelService {
  /// Method to generate an Excel file with given properties and data
  static Future<void> generateExcel({
    required List<ReportModel> props,
    required List<Map<String, dynamic>> data,
    String fileName = 'report',
    String sheetName = 'Sheet1',
  }) async {
    var excel = excel_package.Excel.createExcel();
    var sheet =
        excel.sheets[sheetName] ?? excel.sheets[excel.getDefaultSheet()]!;

    _insertColumns(sheet, props.length);
    _insertRows(sheet, data.length + 1);

    _populateHeader(sheet, props);
    _populateData(sheet, props, data);

    await _saveAndShare(excel, fileName);
  }

  /// Method to insert columns in the sheet
  static void _insertColumns(excel_package.Sheet sheet, int columnCount) {
    for (int ci = 0; ci < columnCount; ci++) {
      sheet.insertColumn(ci);
    }
  }

  /// Method to insert rows in the sheet
  static void _insertRows(excel_package.Sheet sheet, int rowCount) {
    for (int ri = 0; ri < rowCount; ri++) {
      sheet.insertRow(ri);
    }
  }

  /// Method to populate the header row
  static void _populateHeader(
      excel_package.Sheet sheet, List<ReportModel> props) {
    for (int ci = 0; ci < props.length; ci++) {
      sheet.updateCell(
        excel_package.CellIndex.indexByColumnRow(columnIndex: ci, rowIndex: 0),
        excel_package.TextCellValue(props[ci].name),
        cellStyle: excel_package.CellStyle(
          backgroundColorHex: excel_package.ExcelColor.black,
          fontColorHex: excel_package.ExcelColor.white,
        ),
      );
    }
  }

  /// Method to populate data rows
  static void _populateData(excel_package.Sheet sheet, List<ReportModel> props,
      List<Map<String, dynamic>> data) {
    for (int ri = 0; ri < data.length; ri++) {
      for (int ci = 0; ci < props.length; ci++) {
        sheet.updateCell(
          excel_package.CellIndex.indexByColumnRow(
              columnIndex: ci, rowIndex: ri + 1),
          data[ri][props[ci].dbName],
        );
      }
    }
  }

  /// Method to save and share the generated Excel file
  static Future<void> _saveAndShare(
      excel_package.Excel excel, String fileName) async {
    var fileBytes = excel.save(fileName: '$fileName.xlsx');
    if (fileBytes != null) {
      await Printing.sharePdf(
        bytes: Uint8List.fromList(fileBytes),
        filename: '$fileName.xlsx',
      );
    }
  }

  /// Method to set cell styles
  static void setCellStyle(excel_package.Sheet sheet,
      excel_package.CellIndex cellIndex, excel_package.CellStyle style) {
    sheet.updateCell(cellIndex, sheet.cell(cellIndex).value, cellStyle: style);
  }

  /// Method to add a new sheet
  static void addSheet(excel_package.Excel excel, String sheetName) {
    excel.sheets[sheetName] = excel[sheetName];
  }

  /// Method to remove a sheet
  static void removeSheet(excel_package.Excel excel, String sheetName) {
    excel.sheets.remove(sheetName);
  }

  /// Method to rename a sheet
  static void renameSheet(
      excel_package.Excel excel, String oldName, String newName) {
    if (excel.sheets.containsKey(oldName)) {
      var sheet = excel.sheets.remove(oldName);
      if (sheet != null) {
        excel.sheets[newName] = sheet;
      }
    }
  }
}

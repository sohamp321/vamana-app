import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vamana_app/components/widgets.dart';
import 'package:vamana_app/dashboard/dashboard_page.dart';
import "dart:developer" as dev;

class SamsarKramaPage extends StatefulWidget {
  const SamsarKramaPage({super.key});

  @override
  State<SamsarKramaPage> createState() => _SamsarKramaPageState();
}

class _SamsarKramaPageState extends State<SamsarKramaPage> {
  final Map<String, String> _pdfFiles = {
    'Pravar': 'assets/pdfs/pravara.pdf',
    'Madhyam': 'assets/pdfs/madhyam.pdf',
    'Avara': 'assets/pdfs/avara.pdf',
  };

  final Map<String, String> _tempPdfPaths = {};
  String _selectedPdf = 'Pravar';

  @override
  void initState() {
    super.initState();
    _initializePdfs();
  }

  Future<void> _initializePdfs() async {
    for (var entry in _pdfFiles.entries) {
      final tempPath = await _loadPdf(entry.key, entry.value);
      _tempPdfPaths[entry.key] = tempPath;
    }
    setState(() {});
  }

  Future<String> _loadPdf(String pdfName, String assetPath) async {
    dev.log("Loading PDF from: $assetPath");
    try {
      final ByteData bytes = await rootBundle.load(assetPath);
      final Uint8List byteList = bytes.buffer.asUint8List();
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/$pdfName.pdf');

      await file.writeAsBytes(byteList);
      dev.log("Written $pdfName.pdf to ${file.path}");

      return file.path;
    } catch (e) {
      dev.log('Error loading PDF: $e', error: e);
      rethrow;
    }
  }

  void _sharePdf() {
    final pdfPath = _tempPdfPaths[_selectedPdf];
    if (pdfPath != null) {
      Share.shareXFiles([XFile(pdfPath)], text: 'Check out this PDF!');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      appBar: const VamanaAppBar(),
      drawer: VamanaDrawer(
        selectedPage: "SamsarJanaKrama",
      ),
      body: Stack(
        children: [
          Image.asset(
            "assets/images/bg1.jpg",
            width: screenWidth,
            height: screenHeight,
            fit: BoxFit.cover,
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: screenHeight * 0.18,
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: AutoSizeText(
                      "Samsar Jana Krama",
                      minFontSize: 20,
                      style: TextStyle(
                          color: Color(0xff15400D),
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xffcfe1b9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    width: screenWidth * 0.95,
                    height: screenHeight * 0.75,
                    child: Column(
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: 8.0,
                              left: screenWidth * 0.025,
                              right: screenWidth * 0.025,
                              bottom: 8.0,
                            ),
                            child: SegmentedButton<String>(
                              style: SegmentedButton.styleFrom(
                                backgroundColor: const Color(0xffe9f5db),
                                foregroundColor: const Color(0xff15400d),
                                selectedForegroundColor: Colors.white,
                                selectedBackgroundColor: const Color(0xff718355),
                              ),
                              segments: _pdfFiles.keys.map((key) {
                                return ButtonSegment<String>(
                                  value: key,
                                  label: Text(key),
                                );
                              }).toList(),
                              selected: {_selectedPdf},
                              onSelectionChanged: (Set<String> newSelection) {
                                String selected = newSelection.first;
                                if (_selectedPdf != selected) {
                                  setState(() {
                                    _selectedPdf = selected;
                                    dev.log("Selected PDF: $selected");
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                        Container(
                          width: screenWidth * 0.9,
                          height: screenHeight * 0.595,
                          decoration: BoxDecoration(
                            color: const Color(0xffb5c99a),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: IndexedStack(
                            index: _pdfFiles.keys.toList().indexOf(_selectedPdf),
                            children: _pdfFiles.keys.map((pdfKey) {
                              final pdfPath = _tempPdfPaths[pdfKey];
                              return pdfPath != null
                                  ? PDFView(
                                      filePath: pdfPath,
                                    )
                                  : const Center(
                                      child: CircularProgressIndicator.adaptive(),
                                    );
                            }).toList(),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _sharePdf,
                          child: const Text("Share Pdf"),
                        ),
                        SizedBox(
                          height: screenHeight * 0.01,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:io';

import 'package:carousel_slider/carousel_controller.dart' as cs;
import 'package:dago_valley_explore/app/services/local_storage.dart';
import 'package:dago_valley_explore/domain/entities/promo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

// Model untuk Hotspot Data
class PanoramaHotspot {
  final double latitude;
  final double longitude;
  final String? toPanorama; // Nama file panorama tujuan, e.g., 'panorama_7.jpg'
  final String? externalLink; // Link eksternal (Google Maps, dll)
  final String iconPath;
  final double width;
  final double height;
  final String? label; // Optional label untuk hotspot

  PanoramaHotspot({
    required this.latitude,
    required this.longitude,
    this.toPanorama,
    this.externalLink,
    required this.iconPath,
    this.width = 700,
    this.height = 700,
    this.label,
  }) : assert(
         toPanorama != null || externalLink != null,
         'Either toPanorama or externalLink must be provided',
       );

  bool get isExternalLink => externalLink != null;
}

// Model untuk Panorama Data
class PanoramaData {
  final int id;
  final String imagePath;
  final String fileName; // Nama file untuk referensi
  final List<PanoramaHotspot> hotspots;

  PanoramaData({
    required this.id,
    required this.imagePath,
    required this.fileName,
    required this.hotspots,
  });
}

class PanoramicController extends GetxController {
  PanoramicController();

  final LocalStorageService _storage = Get.find<LocalStorageService>();

  final currentPanoramaPath = 'assets/walk1/'.obs;

  // Panorama state
  final _panoId = 0.obs;
  int get panoId => _panoId.value;

  final _lon = 0.0.obs;
  double get lon => _lon.value;

  final _lat = 0.0.obs;
  double get lat => _lat.value;

  final _tilt = 0.0.obs;
  double get tilt => _tilt.value;

  final _showDebugInfo = false.obs;
  bool get showDebugInfo => _showDebugInfo.value;

  // Data panorama dengan hotspot
  final panoramaData = <PanoramaData>[
    PanoramaData(
      id: 0,
      fileName: 'panorama_1.jpg',
      imagePath: 'assets/walkthrough/panorama_1.jpg',
      hotspots: [
        PanoramaHotspot(
          latitude: 10,
          longitude: 25.0,
          toPanorama: 'panorama_6.jpg',
          iconPath: 'assets/gifs/arrow_circle_up.gif',
          label: 'MENUJU RUMAH CONTOH',
        ),
        PanoramaHotspot(
          latitude: -12,
          longitude: 57.0,
          toPanorama: 'panorama_2.jpg',
          iconPath: 'assets/gifs/arrow_up.gif',
          label: 'GERBANG MASUK',
        ),
        PanoramaHotspot(
          latitude: -8,
          longitude: -130.0,
          externalLink:
              'https://www.google.com/maps/dir/Jl.+Situsari+III+No.14D,+Cijagra,+Kec.+Lengkong,+Kota+Bandung,+Jawa+Barat+40265,+Indonesia/Dago+Valley+Bandung,+Jl.+Cisitu+Indah+VI,+Dago,+Kecamatan+Coblong,+Kota+Bandung,+Jawa+Barat+40135/@-6.9450842,107.6291956,17.13z/data=!4m14!4m13!1m5!1m1!1s0x2e68e9f6882ae4c7:0x60742de411f123b5!2m2!1d107.630361!2d-6.9468768!1m5!1m1!1s0x2e68e73dfc944149:0x8d8c79ecd2edec19!2m2!1d107.6101281!2d-6.8761924!3e0?entry=ttu&g_ep=EgoyMDI1MTExMi4wIKXMDSoASAFQAw%3D%3D',
          iconPath: 'assets/gifs/arrow_up_left.gif',
          label: 'GERBANG TANI KOTA',
        ),
      ],
    ),
    PanoramaData(
      id: 1,
      fileName: 'panorama_2.jpg',
      imagePath: 'assets/walkthrough/panorama_2.jpg',
      hotspots: [
        PanoramaHotspot(
          latitude: -10,
          longitude: -103.0,
          toPanorama: 'panorama_1.jpg',
          iconPath: 'assets/gifs/arrow_up.gif',
          label: 'MENUJU GERBANG',
        ),
        PanoramaHotspot(
          latitude: -20,
          longitude: 75.0,
          toPanorama: 'panorama_3.jpg',
          iconPath: 'assets/gifs/arrow_up_2.gif',
          label: 'MENUJU RUMAH CONTOH',
        ),
      ],
    ),
    PanoramaData(
      id: 2,
      fileName: 'panorama_3.jpg',
      imagePath: 'assets/walkthrough/panorama_3.jpg',
      hotspots: [
        PanoramaHotspot(
          latitude: -10,
          longitude: -75.0,
          toPanorama: 'panorama_4.jpg',
          iconPath: 'assets/gifs/arrow_up.gif',
          label: 'MENUJU RUMAH CONTOH',
        ),
        PanoramaHotspot(
          latitude: -5,
          longitude: 25.0,
          toPanorama: 'panorama_2.jpg',
          iconPath: 'assets/gifs/arrow_up_right.gif',
          label: 'MENUJU GERBANG',
        ),
      ],
    ),
    PanoramaData(
      id: 3,
      fileName: 'panorama_4.jpg',
      imagePath: 'assets/walkthrough/panorama_4.jpg',
      hotspots: [
        PanoramaHotspot(
          latitude: -10,
          longitude: -123.0,
          toPanorama: 'panorama_5.jpg',
          iconPath: 'assets/gifs/arrow_up_2.gif',
          label: 'MENUJU RUMAH CONTOH',
        ),
        PanoramaHotspot(
          latitude: -10,
          longitude: 146.0,
          toPanorama: 'panorama_3.jpg',
          iconPath: 'assets/gifs/arrow_up_2.gif',
          label: 'MENUJU GERBANG',
        ),
      ],
    ),
    PanoramaData(
      id: 4,
      fileName: 'panorama_5.jpg',
      imagePath: 'assets/walkthrough/panorama_5.jpg',
      hotspots: [
        PanoramaHotspot(
          latitude: -10,
          longitude: 65.0,
          toPanorama: 'panorama_6.jpg',
          iconPath: 'assets/gifs/arrow_up_2.gif',
          label: 'MENUJU RUMAH CONTOH',
        ),
        PanoramaHotspot(
          latitude: -10,
          longitude: 156.0,
          toPanorama: 'panorama_4.jpg',
          iconPath: 'assets/gifs/arrow_up_2.gif',
          label: 'MENUJU GERBANG',
        ),
      ],
    ),
    PanoramaData(
      id: 5,
      fileName: 'panorama_6.jpg',
      imagePath: 'assets/walkthrough/panorama_6.jpg',
      hotspots: [
        PanoramaHotspot(
          latitude: -17,
          longitude: -5.0,
          toPanorama: 'panorama_7.jpg',
          iconPath: 'assets/gifs/arrow_up_2.gif',
          label: 'MASUK KE DALAM RUMAH',
        ),
        PanoramaHotspot(
          latitude: -10,
          longitude: -74.0,
          toPanorama: 'panorama_5.jpg',
          iconPath: 'assets/gifs/arrow_up_2.gif',
          label: 'MENUJU GERBANG',
        ),
        PanoramaHotspot(
          latitude: 50,
          longitude: 15.0,
          toPanorama: 'panorama_10_b_5_d_4.jpg',
          iconPath: 'assets/gifs/arrow_circle_up.gif',
          label: 'ROOFTOP',
        ),
      ],
    ),
    PanoramaData(
      id: 6,
      fileName: 'panorama_7.jpg',
      imagePath: 'assets/walkthrough/panorama_7.jpg',
      hotspots: [
        PanoramaHotspot(
          latitude: -3,
          longitude: 158.0,
          toPanorama: 'panorama_8.jpg',
          iconPath: 'assets/gifs/arrow_circle_up.gif',
          label: '',
        ),
        PanoramaHotspot(
          latitude: -23,
          longitude: -10.0,
          toPanorama: 'panorama_6.jpg',
          iconPath: 'assets/gifs/arrow_up_2.gif',
          label: '',
        ),
      ],
    ),
    PanoramaData(
      id: 7,
      fileName: 'panorama_8.jpg',
      imagePath: 'assets/walkthrough/panorama_8.jpg',
      hotspots: [
        PanoramaHotspot(
          latitude: -5,
          longitude: 2.0,
          toPanorama: 'panorama_9.jpg',
          iconPath: 'assets/gifs/door_circle.gif',
          label: '',
        ),
        PanoramaHotspot(
          latitude: -3,
          longitude: 70,
          toPanorama: 'panorama_8.jpg',
          iconPath: 'assets/gifs/arrow_circle_up.gif',
          label: '',
        ),
      ],
    ),
    PanoramaData(
      id: 8,
      fileName: 'panorama_9.jpg',
      imagePath: 'assets/walkthrough/panorama_9.jpg',
      hotspots: [
        PanoramaHotspot(
          latitude: -5,
          longitude: 45.0,
          toPanorama: 'panorama_10_a_1.jpg',
          iconPath: 'assets/gifs/arrow_circle_up.gif',
          label: '',
        ),
        PanoramaHotspot(
          latitude: -5,
          longitude: 105.0,
          toPanorama: 'panorama_10_b_1.jpg',
          iconPath: 'assets/gifs/arrow_circle_up.gif',
          label: '',
        ),
        PanoramaHotspot(
          latitude: -5,
          longitude: -36,
          toPanorama: 'panorama_9.jpg',
          iconPath: 'assets/gifs/door_circle.gif',
          label: '',
        ),
      ],
    ),
    PanoramaData(
      id: 9,
      fileName: 'panorama_10_a_1.jpg',
      imagePath: 'assets/walkthrough/panorama_10_a_1.jpg',
      hotspots: [
        PanoramaHotspot(
          latitude: -5,
          longitude: -145.0,
          toPanorama: 'panorama_10_a_2.jpg',
          iconPath: 'assets/gifs/arrow_circle_up.gif',
          label: '',
        ),
        PanoramaHotspot(
          latitude: 5,
          longitude: -86,
          toPanorama: 'panorama_9.jpg',
          iconPath: 'assets/gifs/door_circle.gif',
          label: '',
        ),
      ],
    ),
    PanoramaData(
      id: 10,
      fileName: 'panorama_10_a_2.jpg',
      imagePath: 'assets/walkthrough/panorama_10_a_2.jpg',
      hotspots: [
        PanoramaHotspot(
          latitude: -5,
          longitude: 180.0,
          toPanorama: 'panorama_10_a_3.jpg',
          iconPath: 'assets/gifs/arrow_circle_up.gif',
          label: '',
        ),
        PanoramaHotspot(
          latitude: -5,
          longitude: -146,
          toPanorama: 'panorama_10_b_1.jpg',
          iconPath: 'assets/gifs/door_circle.gif',
          label: '',
        ),
        PanoramaHotspot(
          latitude: -5,
          longitude: -55.0,
          toPanorama: 'panorama_10_a_1.jpg',
          iconPath: 'assets/gifs/arrow_circle_up.gif',
          label: '',
        ),
      ],
    ),
    PanoramaData(
      id: 11,
      fileName: 'panorama_10_a_3.jpg',
      imagePath: 'assets/walkthrough/panorama_10_a_3.jpg',
      hotspots: [
        PanoramaHotspot(
          latitude: -5,
          longitude: 190.0,
          toPanorama: 'panorama_10_a_4.jpg',
          iconPath: 'assets/gifs/arrow_circle_up.gif',
          label: 'DAPUR',
        ),
        PanoramaHotspot(
          latitude: -5,
          longitude: -75,
          toPanorama: 'panorama_10_b_1.jpg',
          iconPath: 'assets/gifs/arrow_circle_up.gif',
          label: '',
        ),
        PanoramaHotspot(
          latitude: -5,
          longitude: 10.0,
          toPanorama: 'panorama_10_a_2.jpg',
          iconPath: 'assets/gifs/arrow_circle_up.gif',
          label: '',
        ),
      ],
    ),
    PanoramaData(
      id: 12,
      fileName: 'panorama_10_a_4.jpg',
      imagePath: 'assets/walkthrough/panorama_10_a_4.jpg',
      hotspots: [
        PanoramaHotspot(
          latitude: -5,
          longitude: 92.0,
          toPanorama: 'panorama_10_a_3.jpg',
          iconPath: 'assets/gifs/arrow_circle_up.gif',
          label: '',
        ),
      ],
    ),
    PanoramaData(
      id: 13,
      fileName: 'panorama_10_b_1.jpg',
      imagePath: 'assets/walkthrough/panorama_10_b_1.jpg',
      hotspots: [
        PanoramaHotspot(
          latitude: -5,
          longitude: -92.0,
          toPanorama: 'panorama_9.jpg',
          iconPath: 'assets/gifs/arrow_circle_up.gif',
          label: '',
        ),
        PanoramaHotspot(
          latitude: -5,
          longitude: 50.0,
          toPanorama: 'panorama_10_a_3.jpg',
          iconPath: 'assets/gifs/arrow_circle_up.gif',
          label: 'MENUJU DAPUR',
        ),
        PanoramaHotspot(
          latitude: -5,
          longitude: -158.0,
          toPanorama: 'panorama_10_c_kamar.jpg',
          iconPath: 'assets/gifs/door_circle.gif',
          label: '',
        ),
        PanoramaHotspot(
          latitude: -5,
          longitude: -183.0,
          toPanorama: 'panorama_10_d_toilet.jpg',
          iconPath: 'assets/gifs/door_circle.gif',
          label: '',
        ),
        PanoramaHotspot(
          latitude: 15,
          longitude: 155.0,
          toPanorama: 'panorama_10_b_2.jpg',
          iconPath: 'assets/gifs/arrow_circle_up.gif',
          label: '',
        ),
        PanoramaHotspot(
          latitude: -5,
          longitude: -22.0,
          toPanorama: 'panorama_10_a_1.jpg',
          iconPath: 'assets/gifs/arrow_circle_up.gif',
          label: '',
        ),
      ],
    ),
    PanoramaData(
      id: 14,
      fileName: 'panorama_10_c_kamar.jpg',
      imagePath: 'assets/walkthrough/panorama_10_c_kamar.jpg',
      hotspots: [
        PanoramaHotspot(
          latitude: -20,
          longitude: -70.0,
          toPanorama: 'panorama_10_b_1.jpg',
          iconPath: 'assets/gifs/arrow_circle_up.gif',
          label: '',
        ),
      ],
    ),
    PanoramaData(
      id: 15,
      fileName: 'panorama_10_d_toilet.jpg',
      imagePath: 'assets/walkthrough/panorama_10_d_toilet.jpg',
      hotspots: [
        PanoramaHotspot(
          latitude: -20,
          longitude: -180.0,
          toPanorama: 'panorama_10_b_1.jpg',
          iconPath: 'assets/gifs/arrow_circle_up.gif',
          label: '',
        ),
      ],
    ),
    PanoramaData(
      id: 16,
      fileName: 'panorama_10_b_2.jpg',
      imagePath: 'assets/walkthrough/panorama_10_b_2.jpg',
      hotspots: [
        PanoramaHotspot(
          latitude: 30,
          longitude: 75.0,
          toPanorama: 'panorama_10_b_3.jpg',
          iconPath: 'assets/gifs/arrow_circle_up.gif',
          label: '',
        ),
        PanoramaHotspot(
          latitude: -50,
          longitude: 100.0,
          toPanorama: 'panorama_10_b_1.jpg',
          iconPath: 'assets/gifs/arrow_circle_up.gif',
          label: '',
        ),
      ],
    ),
    PanoramaData(
      id: 17,
      fileName: 'panorama_10_b_3.jpg',
      imagePath: 'assets/walkthrough/panorama_10_b_3.jpg',
      hotspots: [
        PanoramaHotspot(
          latitude: 20,
          longitude: -120.0,
          toPanorama: 'panorama_10_b_5_d_1.jpg',
          iconPath: 'assets/gifs/arrow_circle_up.gif',
          label: 'MENUJU ROOFTOP',
        ),
        PanoramaHotspot(
          latitude: -10,
          longitude: 48.0,
          toPanorama: 'panorama_10_b_4.jpg',
          iconPath: 'assets/gifs/arrow_circle_up.gif',
          label: '',
        ),
        PanoramaHotspot(
          latitude: -10,
          longitude: -13.0,
          toPanorama: 'panorama_10_b_5_a_kamar_1.jpg',
          iconPath: 'assets/gifs/door_circle.gif',
          label: 'KAMAR TIDUR',
        ),
        PanoramaHotspot(
          latitude: -10,
          longitude: -37.0,
          toPanorama: 'panorama_10_b_5_b_kamar_1.jpg',
          iconPath: 'assets/gifs/door_circle.gif',
          label: 'KAMAR TIDUR',
        ),
        PanoramaHotspot(
          latitude: -10,
          longitude: -57.0,
          toPanorama: 'panorama_10_b_5_c_toilet_1.jpg',
          iconPath: 'assets/gifs/door_circle.gif',
          label: 'KAMAR MANDI',
        ),
        PanoramaHotspot(
          latitude: -30,
          longitude: -105.0,
          toPanorama: 'panorama_10_b_2.jpg',
          iconPath: 'assets/gifs/arrow_circle_up.gif',
          label: 'MENUJU LANTAI 1',
        ),
      ],
    ),
    PanoramaData(
      id: 18,
      fileName: 'panorama_10_b_4.jpg',
      imagePath: 'assets/walkthrough/panorama_10_b_4.jpg',
      hotspots: [
        PanoramaHotspot(
          latitude: 15,
          longitude: -145.0,
          toPanorama: 'panorama_10_b_5_d_1.jpg',
          iconPath: 'assets/gifs/arrow_circle_up.gif',
          label: 'MENUJU ROOFTOP',
        ),
        PanoramaHotspot(
          latitude: -10,
          longitude: -63.0,
          toPanorama: 'panorama_10_b_5_a_kamar_1.jpg',
          iconPath: 'assets/gifs/door_circle.gif',
          label: 'KAMAR TIDUR',
        ),
        PanoramaHotspot(
          latitude: -10,
          longitude: -80.0,
          toPanorama: 'panorama_10_b_5_b_kamar_1.jpg',
          iconPath: 'assets/gifs/door_circle.gif',
          label: 'KAMAR TIDUR',
        ),
        PanoramaHotspot(
          latitude: -10,
          longitude: -97.0,
          toPanorama: 'panorama_10_b_5_c_toilet_1.jpg',
          iconPath: 'assets/gifs/door_circle.gif',
          label: 'KAMAR MANDI',
        ),
        PanoramaHotspot(
          latitude: -30,
          longitude: -140.0,
          toPanorama: 'panorama_10_b_3.jpg',
          iconPath: 'assets/gifs/arrow_circle_up.gif',
          label: 'MENUJU LANTAI 1',
        ),
      ],
    ),
    PanoramaData(
      id: 19,
      fileName: 'panorama_10_b_5_a_kamar_1.jpg',
      imagePath: 'assets/walkthrough/panorama_10_b_5_a_kamar_1.jpg',
      hotspots: [
        PanoramaHotspot(
          latitude: -10,
          longitude: -155.0,
          toPanorama: 'panorama_10_b_5_a_kamar_2.jpg',
          iconPath: 'assets/gifs/arrow_circle_up.gif',
          label: '',
        ),
        PanoramaHotspot(
          latitude: -15,
          longitude: 5.0,
          toPanorama: 'panorama_10_b_3.jpg',
          iconPath: 'assets/gifs/arrow_circle_up.gif',
          label: '',
        ),
        PanoramaHotspot(
          latitude: -15,
          longitude: -35.0,
          toPanorama: 'panorama_10_b_4.jpg',
          iconPath: 'assets/gifs/arrow_circle_up.gif',
          label: '',
        ),
      ],
    ),
    PanoramaData(
      id: 20,
      fileName: 'panorama_10_b_5_a_kamar_2.jpg',
      imagePath: 'assets/walkthrough/panorama_10_b_5_a_kamar_2.jpg',
      hotspots: [
        PanoramaHotspot(
          latitude: -10,
          longitude: -118.0,
          toPanorama: 'panorama_10_b_5_a_kamar_1.jpg',
          iconPath: 'assets/gifs/door_circle.gif',
          label: '',
        ),
      ],
    ),
    PanoramaData(
      id: 21,
      fileName: 'panorama_10_b_5_b_kamar_1.jpg',
      imagePath: 'assets/walkthrough/panorama_10_b_5_b_kamar_1.jpg',
      hotspots: [
        PanoramaHotspot(
          latitude: -10,
          longitude: -68.0,
          toPanorama: 'panorama_10_b_4.jpg',
          iconPath: 'assets/gifs/arrow_circle_up.gif',
          label: '',
        ),
        PanoramaHotspot(
          latitude: -10,
          longitude: -38.0,
          toPanorama: 'panorama_10_b_3.jpg',
          iconPath: 'assets/gifs/arrow_circle_up.gif',
          label: '',
        ),
        PanoramaHotspot(
          latitude: -10,
          longitude: 128.0,
          toPanorama: 'panorama_10_b_5_b_kamar_2.jpg',
          iconPath: 'assets/gifs/arrow_circle_up.gif',
          label: '',
        ),
        PanoramaHotspot(
          latitude: -10,
          longitude: 28.0,
          toPanorama: 'panorama_10_b_5_c_toilet_1.jpg',
          iconPath: 'assets/gifs/door_circle.gif',
          label: 'KAMAR MANDI',
        ),
      ],
    ),
    PanoramaData(
      id: 22,
      fileName: 'panorama_10_b_5_b_kamar_2.jpg',
      imagePath: 'assets/walkthrough/panorama_10_b_5_b_kamar_2.jpg',
      hotspots: [
        PanoramaHotspot(
          latitude: -10,
          longitude: 19.0,
          toPanorama: 'panorama_10_b_5_b_kamar_1.jpg',
          iconPath: 'assets/gifs/door_circle.gif',
          label: '',
        ),
      ],
    ),
    PanoramaData(
      id: 23,
      fileName: 'panorama_10_b_5_c_toilet_1.jpg',
      imagePath: 'assets/walkthrough/panorama_10_b_5_c_toilet_1.jpg',
      hotspots: [
        PanoramaHotspot(
          latitude: -10,
          longitude: 9.0,
          toPanorama: 'panorama_10_b_5_b_kamar_1.jpg',
          iconPath: 'assets/gifs/door_circle.gif',
          label: '',
        ),
      ],
    ),
    PanoramaData(
      id: 24,
      fileName: 'panorama_10_b_5_d_1.jpg',
      imagePath: 'assets/walkthrough/panorama_10_b_5_d_1.jpg',
      hotspots: [
        PanoramaHotspot(
          latitude: 30,
          longitude: 10.0,
          toPanorama: 'panorama_10_b_5_d_2.jpg',
          iconPath: 'assets/gifs/arrow_circle_up.gif',
          label: '',
        ),
        PanoramaHotspot(
          latitude: -30,
          longitude: 30.0,
          toPanorama: 'panorama_10_b_3.jpg',
          iconPath: 'assets/gifs/arrow_circle_up.gif',
          label: '',
        ),
      ],
    ),
    PanoramaData(
      id: 25,
      fileName: 'panorama_10_b_5_d_2.jpg',
      imagePath: 'assets/walkthrough/panorama_10_b_5_d_2.jpg',
      hotspots: [
        PanoramaHotspot(
          latitude: -30,
          longitude: -5.0,
          toPanorama: 'panorama_10_b_5_d_1.jpg',
          iconPath: 'assets/gifs/arrow_circle_up.gif',
          label: 'MENUJU LANTAI 2',
        ),
        PanoramaHotspot(
          latitude: -10,
          longitude: 165.0,
          toPanorama: 'panorama_10_b_5_d_3.jpg',
          iconPath: 'assets/gifs/arrow_circle_up.gif',
          label: '',
        ),
      ],
    ),
    PanoramaData(
      id: 26,
      fileName: 'panorama_10_b_5_d_3.jpg',
      imagePath: 'assets/walkthrough/panorama_10_b_5_d_3.jpg',
      hotspots: [
        PanoramaHotspot(
          latitude: -10,
          longitude: -155.0,
          toPanorama: 'panorama_10_b_5_d_2.jpg',
          iconPath: 'assets/gifs/arrow_circle_up.gif',
          label: '',
        ),
        PanoramaHotspot(
          latitude: -10,
          longitude: -85.0,
          toPanorama: 'panorama_10_b_5_d_4.jpg',
          iconPath: 'assets/gifs/arrow_circle_up.gif',
          label: '',
        ),
        PanoramaHotspot(
          latitude: 0,
          longitude: 15.0,
          toPanorama: 'panorama_1.jpg',
          iconPath: 'assets/gifs/arrow_circle_up.gif',
          label: 'MENUJU GERBANG DEPAN',
        ),
      ],
    ),
    PanoramaData(
      id: 27,
      fileName: 'panorama_10_b_5_d_4.jpg',
      imagePath: 'assets/walkthrough/panorama_10_b_5_d_4.jpg',
      hotspots: [
        PanoramaHotspot(
          latitude: -10,
          longitude: 175.0,
          toPanorama: 'panorama_10_b_5_d_3.jpg',
          iconPath: 'assets/gifs/arrow_circle_up.gif',
          label: '',
        ),
        PanoramaHotspot(
          latitude: 0,
          longitude: 40.0,
          toPanorama: 'panorama_6.jpg',
          iconPath: 'assets/gifs/arrow_circle_up.gif',
          label: 'MENUJU FASAD RUMAH',
        ),
      ],
    ),
  ];

  // Map untuk lookup cepat panorama berdasarkan fileName
  Map<String, int> get panoramaIndexMap {
    return {
      for (var i = 0; i < panoramaData.length; i++) panoramaData[i].fileName: i,
    };
  }

  // Get current panorama asset
  Image get currentPanoAsset {
    final currentData = panoramaData[_panoId.value % panoramaData.length];
    return Image.asset(currentData.imagePath, fit: BoxFit.cover);
  }

  // Get current panorama hotspots
  List<PanoramaHotspot> get currentHotspots {
    final currentData = panoramaData[_panoId.value % panoramaData.length];
    return currentData.hotspots;
  }

  // Check if running on desktop
  bool get isDesktop {
    return !kIsWeb &&
        (Platform.isWindows || Platform.isLinux || Platform.isMacOS);
  }

  // Carousel controller
  final carouselController = cs.CarouselSliderController();

  // Observable untuk index aktif
  final _currentIndex = 0.obs;
  int get currentIndex => _currentIndex.value;

  // Observable untuk list promo
  final _promos = RxList<Promo>([]);
  List<Promo> get promos => _promos;

  // Loading states untuk setiap image
  final _imageLoadingStates = <String, Rx<bool>>{}.obs;
  final _imageFiles = <String, Rx<File?>>{}.obs;

  // Current promo
  Promo get currentPromo {
    if (_promos.isEmpty) {
      return dummyPromos.first;
    }
    return _promos[_currentIndex.value];
  }

  @override
  void onInit() {
    super.onInit();
    loadPromos();
    preloadAllImages();
    _initializePanorama();
  }

  void _initializePanorama() {
    if (kDebugMode) {
      print('Initializing Siteplan Panorama');
      print('Total panoramas: ${panoramaData.length}');
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

  // Update panorama view
  void onViewChanged(double longitude, double latitude, double tilt) {
    _lon.value = longitude;
    _lat.value = latitude;
    _tilt.value = tilt;
  }

  // Handle panorama tap
  void onPanoramaTap(double longitude, double latitude, double tilt) {
    if (kDebugMode) {
      print('onTap: $longitude, $latitude, $tilt');
    }
  }

  // Handle hotspot interaction
  Future<void> handleHotspotTap(PanoramaHotspot hotspot) async {
    if (hotspot.isExternalLink) {
      // Open external link
      await openExternalLink(hotspot.externalLink!);
    } else if (hotspot.toPanorama != null) {
      // Navigate to panorama
      navigateToPanoramaByFileName(hotspot.toPanorama!);
    }
  }

  // Navigate to specific panorama by fileName
  void navigateToPanoramaByFileName(String fileName) {
    final targetIndex = panoramaIndexMap[fileName];

    if (targetIndex != null) {
      _panoId.value = targetIndex;
      if (kDebugMode) {
        print('Navigated to panorama: $fileName (index: $targetIndex)');
      }

      // Get.snackbar(
      //   'Navigation',
      //   'Moved to $fileName',
      //   snackPosition: SnackPosition.TOP,
      //   duration: const Duration(seconds: 1),
      //   backgroundColor: Colors.black54,
      //   colorText: Colors.white,
      // );
    } else {
      if (kDebugMode) {
        print('Warning: Panorama $fileName not found');
      }

      Get.snackbar(
        'Error',
        'Panorama $fileName not found',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
      );
    }
  }

  // Navigate to specific panorama (legacy method - kept for compatibility)
  void navigateToPanorama(int targetPanoramaId) {
    if (targetPanoramaId >= 0 && targetPanoramaId < panoramaData.length) {
      _panoId.value = targetPanoramaId;
      if (kDebugMode) {
        print('Navigated to panorama: $targetPanoramaId');
      }

      Get.snackbar(
        'Navigation',
        'Moved to Panorama ${targetPanoramaId + 1}',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.black54,
        colorText: Colors.white,
      );
    }
  }

  // Open external link (e.g., Google Maps)
  Future<void> openExternalLink(String url) async {
    try {
      final uri = Uri.parse(url);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);

        if (kDebugMode) {
          print('Opened external link: $url');
        }
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error opening link: $e');
      }

      Get.snackbar(
        'Error',
        'Could not open link',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
      );
    }
  }

  // Go to next panorama
  void goToNextPanorama() {
    _panoId.value = (_panoId.value + 1) % panoramaData.length;
    if (kDebugMode) {
      print('Switched to panorama: ${_panoId.value}');
    }
  }

  // Go to previous panorama
  void goToPreviousPanorama() {
    _panoId.value =
        (_panoId.value - 1 + panoramaData.length) % panoramaData.length;
    if (kDebugMode) {
      print('Switched to panorama: ${_panoId.value}');
    }
  }

  // Toggle debug info
  void toggleDebugInfo() {
    _showDebugInfo.value = !_showDebugInfo.value;
  }

  void loadPromos() {
    final cachedPromos = _storage.promos;
    if (cachedPromos != null && cachedPromos.isNotEmpty) {
      print('✅ Using cached promos: ${cachedPromos.length} items');
      _promos.assignAll(cachedPromos);
    } else {
      print('⚠️ Using dummy promos');
      _promos.assignAll(dummyPromos);
    }
  }

  // Preload all images
  Future<void> preloadAllImages() async {
    for (var promo in _promos) {
      await getLocalImage(promo.imageUrl);
    }
  }

  // Get local image file
  Future<File?> getLocalImage(String imageUrl) async {
    if (imageUrl.isEmpty) return null;

    // Initialize loading state if not exists
    if (!_imageLoadingStates.containsKey(imageUrl)) {
      _imageLoadingStates[imageUrl] = true.obs;
      _imageFiles[imageUrl] = Rx<File?>(null);
    }

    try {
      final file = await _storage.getLocalImage(imageUrl);
      _imageFiles[imageUrl]?.value = file;
      _imageLoadingStates[imageUrl]?.value = false;
      return file;
    } catch (e) {
      print('Error loading image: $e');
      _imageLoadingStates[imageUrl]?.value = false;
      return null;
    }
  }

  // Check if image is loading
  bool isImageLoading(String imageUrl) {
    return _imageLoadingStates[imageUrl]?.value ?? true;
  }

  // Get cached image file
  File? getCachedImageFile(String imageUrl) {
    return _imageFiles[imageUrl]?.value;
  }

  // Set index carousel
  void setCurrentIndex(int index) {
    _currentIndex.value = index;
  }

  // Go to specific page
  void goToPage(int index) {
    carouselController.animateToPage(index);
  }

  // Handle booking action
  void bookPromo() {
    Get.snackbar(
      'Booking',
      'Booking promo: ${currentPromo.title}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Close modal
  void closeModal() {
    Get.back();
  }

  // Helper method to check if file exists
  bool fileExists(File? file) {
    return file != null && file.existsSync();
  }
}

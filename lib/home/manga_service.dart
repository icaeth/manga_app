//Servicio o repositorio para los metodos de la api

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../environment_config.dart';
import 'manga.dart';

final mangaServiceProvider = Provider<MangaService>((ref) {
  final config = ref.read(environmentConfigProvider);
  return MangaService(config, Dio());
});

class MangaService {
  final EnvironmentConfig _environmentConfig;
  final Dio _dio;

  //constructor
  MangaService(this._environmentConfig, this._dio);

  //Método para traer los mangas

  Future<List<Manga>> getMangas() async {
    final response = await _dio
        .get("https://api.jikan.moe/v3/search/anime?q=One&Piece&page=1");

    final results = List<Map<String, dynamic>>.from(response.data['results']);

    List<Manga> mangas = results
        .map((mangaData) => Manga.fromMap(mangaData))
        .toList(growable: false);
    return mangas;
  }
}

import 'dart:convert';
import 'package:fave_films_2/data/response/api_response.dart';
import 'package:flutter/material.dart';
import 'package:fave_films_2/data/exeptions/app_exception.dart';
import 'package:fave_films_2/models/home/filter_model.dart';
import 'package:fave_films_2/models/home/movies_response_model.dart';
import 'package:fave_films_2/models/favorite/movie.dart';
import 'package:fave_films_2/repository/home/home_repository.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeViewModel extends ChangeNotifier {
  final _api = HomeRepository();

  ApiResponse<MoviesResponseModel> _moviesApiResponse = ApiResponse.loading();
  ApiResponse<MoviesResponseModel> get moviesApiResponse => _moviesApiResponse;

  final favoritesSPkey = 'fav_movies_sp';

  final List<Movie> _favMovies = [];
  List<Movie> get favMovies => _favMovies;

  final List<FilterModel> _filters = [
    FilterModel(id: 1, title: 'now_playing'.tr, value: true),
    FilterModel(id: 2, title: 'top_rated'.tr, value: false),
    FilterModel(id: 3, title: 'popular'.tr, value: false),
    FilterModel(id: 4, title: 'upcoming'.tr, value: false),
  ];
  List<FilterModel> get filters => _filters;

  void setFilterValue(int index) {
    for (var filter in _filters) {
      filter.value = (index == filter.id);
    }
    notifyListeners();
  }

  void _setMoviesApiResponse(ApiResponse<MoviesResponseModel> value) {
    _moviesApiResponse = value;
    notifyListeners();
  }

  Future<void> getMovies(String movieType) async {
    // await Future.delayed(const Duration(seconds: 1));
    _setMoviesApiResponse(ApiResponse.loading());
    await _api.getMovies(movieType).then((value) {
      _setMoviesApiResponse(ApiResponse.completed(value));
    }).onError((AppException error, stackTrace) {
      _setMoviesApiResponse(ApiResponse.error(error.toString()));
    });
    notifyListeners();
  }

  void loadFavMoviesData() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getString(favoritesSPkey) ?? '[]';
    final List<dynamic> favoritesData = json.decode(favoritesJson);
    final favorites =
        favoritesData.map((data) => Movie.fromJson(data)).toList();
    _favMovies.clear();
    _favMovies.addAll(favorites);
    notifyListeners();
  }

  void toggleFavorite(Movie movie) {
    bool isFavorite = isMovieFavorite(movie);

    if (isFavorite) {
      _removeFromFavorites(movie);
    } else {
      _addToFavorites(movie);
    }
    notifyListeners();
  }

  bool isMovieFavorite(Movie movie) {
    for (var element in _favMovies) {
      if (element.id == movie.id) {
        return true;
      }
    }
    return false;
  }

  void _addToFavorites(Movie movie) {
    _favMovies.add(movie);
    _saveFavoriteMovies();
  }

  void _removeFromFavorites(Movie movie) {
    _favMovies
        .remove(_favMovies.firstWhere((element) => element.id == movie.id));
    _saveFavoriteMovies();
  }

  void clearFavMovies() {
    _favMovies.clear();
    _saveFavoriteMovies();
    notifyListeners();
  }

  Future<void> _saveFavoriteMovies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(favoritesSPkey, json.encode(_favMovies));
  }
}

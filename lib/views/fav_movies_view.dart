import 'package:fave_films_2/models/favorite/movie.dart';
import 'package:fave_films_2/res/colors/app_colors.dart';
import 'package:fave_films_2/res/urls/app_url.dart';
import 'package:fave_films_2/res/widgets/movie_card_widget.dart';
import 'package:fave_films_2/utils/helper_functions.dart';
import 'package:fave_films_2/view_models/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class FavMoviesView extends StatelessWidget {
  const FavMoviesView({super.key});

  @override
  Widget build(BuildContext context) {
    final homeScreenController = Provider.of<HomeViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('favorites'.tr),
        actions: [
          if (homeScreenController.favMovies.isNotEmpty)
            IconButton(
              onPressed: () async {
                homeScreenController.clearFavMovies();
                HelperFunctions.showToast(
                    '${"success".tr} ${"favorites_cleared".tr}');
              },
              icon: const Icon(Icons.delete_outline_rounded),
            ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (homeScreenController.favMovies.isNotEmpty) {
            return ListView.builder(
              padding: EdgeInsets.only(left: 16.w),
              itemCount: homeScreenController.favMovies.length,
              itemBuilder: (context, index) {
                final movie = Movie(
                  id: homeScreenController.favMovies[index].id ?? 0,
                  title: homeScreenController.favMovies[index].title ?? "",
                  releaseDate:
                      homeScreenController.favMovies[index].releaseDate ?? "",
                  overview:
                      homeScreenController.favMovies[index].overview ?? "",
                  posterImageUrl:
                      homeScreenController.favMovies[index].posterImageUrl ??
                          "",
                  imdbRating:
                      (homeScreenController.favMovies[index].imdbRating ?? 0.0)
                          .toString(),
                );
                return MovieCardWidget(
                  title: homeScreenController.favMovies[index].title ?? '',
                  backgroundImage: AppUrl.tmbdImagesUrl +
                      (homeScreenController.favMovies[index].posterImageUrl ??
                          ''),
                  releasedDate:
                      homeScreenController.favMovies[index].releaseDate ?? "",
                  imdbRating:
                      homeScreenController.favMovies[index].imdbRating ?? "",
                  overlayButton: IconButton(
                    onPressed: () {
                      homeScreenController.toggleFavorite(movie);
                    },
                    color: AppColors.orange,
                    iconSize: 24.sp,
                    icon: Icon(
                      homeScreenController.isMovieFavorite(movie)
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                    ),
                  ),
                );
              },
            );
          }
          return Center(
            child: Text(
              'no_favorites_added_yet'.tr,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
          );
        },
      ),
    );
  }
}

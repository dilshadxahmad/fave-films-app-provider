import 'package:fave_films_2/data/response/request_status.dart';
import 'package:fave_films_2/models/favorite/movie.dart';
import 'package:fave_films_2/res/colors/app_colors.dart';
import 'package:fave_films_2/res/components/app_drawer.dart';
import 'package:fave_films_2/res/routes/route_name.dart';
import 'package:fave_films_2/res/urls/app_url.dart';
import 'package:fave_films_2/res/widgets/general_exception_widget.dart';
import 'package:fave_films_2/res/widgets/movie_card_widget.dart';
import 'package:fave_films_2/utils/helper_functions.dart';
import 'package:fave_films_2/view_models/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final homeViewModelListener = Provider.of<HomeViewModel>(context);
    final homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('app_name'.tr),
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed(RouteName.favMoviesView);
            },
            icon: const Icon(Icons.favorite_outline_rounded),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Text(
              'find_fav_films_home'.tr,
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ),
          SizedBox(
            height: 60.h,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: homeViewModelListener.filters.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: FilterChip(
                    label: Text(homeViewModelListener.filters[index].title),
                    selected: homeViewModelListener.filters[index].value,
                    labelStyle: TextStyle(
                      color: homeViewModelListener.filters[index].value
                          ? AppColors.black
                          : AppColors.lightGrey,
                    ),
                    onSelected: (value) {
                      homeViewModel.setFilterValue(index + 1);

                      switch (index) {
                        case 0:
                          homeViewModel.getMovies('now_playing');

                        case 1:
                          homeViewModel.getMovies('top_rated');

                        case 2:
                          homeViewModel.getMovies('popular');

                        case 3:
                          homeViewModel.getMovies('upcoming');
                      }
                    },
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: HomeViewModel().getMovies('now_playing'),
              builder: (context, snapshot) {
                switch (homeViewModelListener.moviesApiResponse.requestStatus) {
                  case RequestStatus.loading:
                    return const Center(child: CircularProgressIndicator());

                  case RequestStatus.error:
                    return Center(
                      child: GeneralExceptionWidget(
                        message: homeViewModelListener.moviesApiResponse.message
                            .toString(),
                        onPressed: () {
                          homeViewModel.setFilterValue(1);
                          homeViewModel.getMovies('now_playing');
                        },
                      ),
                    );
                  case RequestStatus.completed:
                    final results =
                        homeViewModelListener.moviesApiResponse.data?.results;
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: RawScrollbar(
                        radius: Radius.circular(10.r),
                        child: MasonryGridView.builder(
                          gridDelegate:
                              const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ),
                          itemCount: results?.length ?? 0,
                          itemBuilder: (context, index) {
                            final formatted = HelperFunctions.showYearsFromDate(
                                results?[index].releaseDate ?? '0000-00-00');
                            final movie = Movie(
                              id: results?[index].id ?? 0,
                              title: results?[index].title ?? "",
                              releaseDate: formatted,
                              overview: results?[index].overview ?? "",
                              posterImageUrl:
                                  results?[index].backdropPath ?? "",
                              imdbRating: (results?[index].voteAverage ?? 0.0)
                                  .toStringAsFixed(1),
                            );
                            return MovieCardWidget(
                              title: results?[index].title ?? '',
                              backgroundImage: AppUrl.tmbdImagesUrl +
                                  (results?[index].posterPath ?? ''),
                              releasedDate: formatted,
                              imdbRating: (results?[index].voteAverage ?? 0.0)
                                  .toStringAsFixed(1),
                              overlayButton: IconButton(
                                onPressed: () {
                                  Provider.of<HomeViewModel>(context,
                                          listen: false)
                                      .toggleFavorite(movie);
                                },
                                color: AppColors.orange,
                                iconSize: 24.sp,
                                icon: Icon(
                                  homeViewModelListener.isMovieFavorite(movie)
                                      ? Icons.favorite_rounded
                                      : Icons.favorite_border_rounded,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );

                  default:
                    return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

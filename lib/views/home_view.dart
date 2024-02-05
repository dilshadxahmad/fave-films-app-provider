import 'package:fave_films_2/data/response/request_status.dart';
import 'package:fave_films_2/models/favorite/movie.dart';
import 'package:fave_films_2/res/colors/app_colors.dart';
import 'package:fave_films_2/res/routes/route_name.dart';
import 'package:fave_films_2/res/urls/app_url.dart';
import 'package:fave_films_2/res/widgets/general_exception_widget.dart';
import 'package:fave_films_2/res/widgets/movie_card_widget.dart';
import 'package:fave_films_2/utils/helper_functions.dart';
import 'package:fave_films_2/view_models/auth_view_model.dart';
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
    HomeViewModel().getMovies('now_playing');
    final userAuth = Provider.of<AuthViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('app_name'.tr),
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed(RouteName.favMoviesScreen);
            },
            icon: const Icon(Icons.favorite_outline_rounded),
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'app_name'.tr,
              style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
            SizedBox(height: 30.h),
            Text('app_version'.tr),
            ElevatedButton(
              onPressed: () async {
                await userAuth.signOut();
                Get.offAndToNamed(RouteName.loginView);
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
      body: ChangeNotifierProvider<HomeViewModel>(
        create: (context) => HomeViewModel(),
        child: Consumer<HomeViewModel>(
          builder: (context, model, child) {
            return Column(
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
                    itemCount: model.filters.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: FilterChip(
                          label: Text(model.filters[index].title),
                          selected: model.filters[index].value,
                          labelStyle: TextStyle(
                            color: model.filters[index].value
                                ? AppColors.black
                                : AppColors.lightGrey,
                          ),
                          onSelected: (value) {
                            model.setFilterValue(index + 1);

                            switch (index) {
                              case 0:
                                model.getMovies('now_playing');

                              case 1:
                                model.getMovies('top_rated');

                              case 2:
                                model.getMovies('popular');

                              case 3:
                                model.getMovies('upcoming');
                            }
                          },
                        ),
                      );
                    },
                  ),

                  // child: Obx(() {
                  //   return ListView.builder(
                  //     padding: EdgeInsets.symmetric(horizontal: 16.w),
                  //     itemCount: homeScreenController.rxFilters.length,
                  //     scrollDirection: Axis.horizontal,
                  //     itemBuilder: (context, index) {
                  //       return Padding(
                  //         padding: EdgeInsets.only(right: 8.w),
                  //         child: FilterChip(
                  //           label: Text(homeScreenController.rxFilters[index].title),
                  //           selected: homeScreenController.rxFilters[index].value,
                  //           labelStyle: TextStyle(
                  //             color: homeScreenController.rxFilters[index].value
                  //                 ? AppColors.black
                  //                 : AppColors.lightGrey,
                  //           ),
                  //           onSelected: (value) {
                  //             homeScreenController.setRxFilterValue(index + 1);

                  //             switch (index) {
                  //               case 0:
                  //                 homeScreenController.getRxMovies('now_playing');

                  //               case 1:
                  //                 homeScreenController.getRxMovies('top_rated');

                  //               case 2:
                  //                 homeScreenController.getRxMovies('popular');

                  //               case 3:
                  //                 homeScreenController.getRxMovies('upcoming');
                  //             }
                  //           },
                  //         ),
                  //       );
                  //     },
                  //   );
                  // }),
                ),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      switch (model.moviesApiResponse.requestStatus) {
                        case RequestStatus.loading:
                          return const Center(
                              child: CircularProgressIndicator());

                        case RequestStatus.error:
                          return Center(
                            child: GeneralExceptionWidget(
                              message:
                                  model.moviesApiResponse.message.toString(),
                              onPressed: () {
                                model.setFilterValue(1);
                                model.getMovies('now_playing');
                              },
                            ),
                          );
                        case RequestStatus.completed:
                          final results = model.moviesApiResponse.data?.results;
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
                                  final formatted =
                                      HelperFunctions.showYearsFromDate(
                                          results?[index].releaseDate ??
                                              '0000-00-00');
                                  final movie = Movie(
                                    id: results?[index].id ?? 0,
                                    title: results?[index].title ?? "",
                                    releaseDate: formatted,
                                    overview: results?[index].overview ?? "",
                                    posterImageUrl:
                                        results?[index].backdropPath ?? "",
                                    imdbRating:
                                        (results?[index].voteAverage ?? 0.0)
                                            .toStringAsFixed(1),
                                  );
                                  return MovieCardWidget(
                                    title: results?[index].title ?? '',
                                    backgroundImage: AppUrl.tmbdImagesUrl +
                                        (results?[index].posterPath ?? ''),
                                    releasedDate: formatted,
                                    imdbRating:
                                        (results?[index].voteAverage ?? 0.0)
                                            .toStringAsFixed(1),
                                    overlayButton: IconButton(
                                      onPressed: () {
                                        model.toggleFavorite(movie);
                                      },
                                      color: AppColors.orange,
                                      iconSize: 24.sp,
                                      icon: Icon(
                                        model.isMovieFavorite(movie)
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
                          return const Center(
                              child: CircularProgressIndicator());
                      }
                    },
                  ),

                  // child: Obx(
                  //   () {
                  //     switch (homeScreenController.rxRequestStatus.value) {
                  //       case RequestStatus.loading:
                  //         return const Center(child: CircularProgressIndicator());

                  //       case RequestStatus.error:
                  //         return Center(
                  //           child: GeneralExceptionWidget(
                  //             message: homeScreenController.rxError.toString(),
                  //             onPressed: () {
                  //               homeScreenController.setRxFilterValue(1);
                  //               homeScreenController.getRxMovies('now_playing');
                  //             },
                  //           ),
                  //         );
                  //       case RequestStatus.completed:
                  //         final results = homeScreenController
                  //             .rxMoviesResponseModel.value.results;
                  //         return Padding(
                  //           padding: EdgeInsets.symmetric(horizontal: 16.w),
                  //           child: RawScrollbar(
                  //             radius: Radius.circular(10.r),
                  //             child: MasonryGridView.builder(
                  //               gridDelegate:
                  //                   const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  //                 crossAxisCount: 2,
                  //               ),
                  //               itemCount: results?.length ?? 0,
                  //               itemBuilder: (context, index) {
                  //                 final formatted = HelperFunctions.showYearsFromDate(
                  //                     results?[index].releaseDate ?? '0000-00-00');
                  //                 final movie = Movie(
                  //                   id: results?[index].id ?? 0,
                  //                   title: results?[index].title ?? "",
                  //                   releaseDate: formatted,
                  //                   overview: results?[index].overview ?? "",
                  //                   posterImageUrl:
                  //                       results?[index].backdropPath ?? "",
                  //                   imdbRating: (results?[index].voteAverage ?? 0.0)
                  //                       .toStringAsFixed(1),
                  //                 );
                  //                 return MovieCardWidget(
                  //                   title: results?[index].title ?? '',
                  //                   backgroundImage: AppUrl.tmbdImagesUrl +
                  //                       (results?[index].posterPath ?? ''),
                  //                   releasedDate: formatted,
                  //                   imdbRating: (results?[index].voteAverage ?? 0.0)
                  //                       .toStringAsFixed(1),
                  //                   overlayButton: IconButton(
                  //                     onPressed: () {
                  //                       homeScreenController.toggleFavorite(movie);
                  //                     },
                  //                     color: AppColors.orange,
                  //                     iconSize: 24.sp,
                  //                     icon: Obx(
                  //                       () => Icon(
                  //                         homeScreenController.isMovieFavorite(movie)
                  //                             ? Icons.favorite_rounded
                  //                             : Icons.favorite_border_rounded,
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 );
                  //               },
                  //             ),
                  //           ),
                  //         );
                  //     }
                  //   },
                  // ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

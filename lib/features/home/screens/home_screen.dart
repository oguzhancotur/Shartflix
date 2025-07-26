import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shartflix_app/features/home/bloc/home_bloc.dart';
import 'package:shartflix_app/features/home/repository/movie_remote_data_source.dart';
import 'package:shartflix_app/features/home/repository/movie_repository_impl.dart';
import 'package:shartflix_app/core/usecases/get_movies_usecase.dart';
import 'package:shartflix_app/core/usecases/toggle_favorite_usecase.dart';
import 'package:shartflix_app/features/profile/screens/profile_screen.dart';
import 'package:shartflix_app/features/home/screens/home_view.dart';
import 'package:shartflix_app/l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      const HomeView(),
      ProfileScreen(onItemTapped: _onItemTapped),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;

    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Lottie.asset(
              'assets/lottie/loading_animation.json',
              width: 100,
              height: 100,
              fit: BoxFit.contain,
            ),
          );
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final sharedPreferences = snapshot.data!;

        return BlocProvider(
          create: (context) => HomeBloc(
            getMoviesUseCase: GetMoviesUseCase(
              MovieRepositoryImpl(
                remoteDataSource: MovieRemoteDataSource(
                  client: http.Client(),
                  sharedPreferences: sharedPreferences,
                ),
              ),
            ),
            toggleFavoriteUseCase: ToggleFavoriteUseCase(
              MovieRepositoryImpl(
                remoteDataSource: MovieRemoteDataSource(
                  client: http.Client(),
                  sharedPreferences: sharedPreferences,
                ),
              ),
            ),
            sharedPreferences: sharedPreferences,
          )..add(const GetMovies()),
          child: Scaffold(
            backgroundColor: Colors.black,
            body: _widgetOptions.elementAt(_selectedIndex),
            bottomNavigationBar: Container(
              color: Colors.black,
              padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => _onItemTapped(0),
                    child: Container(
                      width: size.width * 0.38,
                      padding: EdgeInsets.symmetric(
                        vertical: size.height * 0.012,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white24),
                        borderRadius: BorderRadius.circular(
                          size.width * 0.08,
                        ), // ~32px
                        color: _selectedIndex == 0
                            ? Colors.white
                            : Colors.transparent,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/homepage.png',
                            color: _selectedIndex == 0
                                ? Colors.black
                                : Colors.white,
                            width: size.width * 0.06,
                            height: size.width * 0.06,
                          ),
                          SizedBox(width: size.width * 0.02),
                          Text(
                            loc.homePage,
                            style: TextStyle(
                              color: _selectedIndex == 0
                                  ? Colors.black
                                  : Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: size.width * 0.04),
                  GestureDetector(
                    onTap: () => _onItemTapped(1),
                    child: Container(
                      width: size.width * 0.38,
                      padding: EdgeInsets.symmetric(
                        vertical: size.height * 0.012,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white24),
                        borderRadius: BorderRadius.circular(size.width * 0.08),
                        color: _selectedIndex == 1
                            ? Colors.white
                            : Colors.transparent,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/profile.png',
                            color: _selectedIndex == 1
                                ? Colors.black
                                : Colors.white,
                            width: size.width * 0.06,
                            height: size.width * 0.06,
                          ),
                          SizedBox(width: size.width * 0.02),
                          Text(
                            loc.profilePage,
                            style: TextStyle(
                              color: _selectedIndex == 1
                                  ? Colors.black
                                  : Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

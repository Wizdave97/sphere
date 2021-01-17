import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:sphere/providers/app/app_provider.dart';
import 'package:sphere/providers/app/suggestions_data.dart';
import 'package:sphere/screens/suggestions_screen.dart';
import 'package:sphere/widgets/suggestion_button.dart';
import 'package:sphere/common/sticky_appbar.dart';

class GenreSelectors extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppService appService = Provider.of<AppService>(context, listen: false);

    return SliverPersistentHeader(
        pinned: true,
        delegate: StickyAppBar(
          minHeight: 120,
          maxHeight: 120,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 60.0,
                color: Colors.black,
                padding: EdgeInsets.only(top: 8, bottom: 8),
                child: Consumer<AppService>(
                  builder: (context, appService, child) {
                    List<dynamic> genres = appService.genres;
                    SuggestionsData suggestionsData =
                        appService.suggestionsData;
                    return Stack(
                      children: [
                        ListView(
                          children: genres != null
                              ? genres
                                  .map((genre) => GestureDetector(
                                        onTap: () {
                                          appService.setGenreId(genre['id']);
                                        },
                                        child: SuggestionButton(
                                          title: genre['name'],
                                          selected:
                                              suggestionsData.selectedGenreId ==
                                                  genre['id'],
                                        ),
                                      ))
                                  .toList()
                              : [
                                  Container(
                                    height: 60.0,
                                  )
                                ],
                          scrollDirection: Axis.horizontal,
                        ),
                        if (appService.suggestionsData.isFetching)
                          Container(
                              child: Center(
                                  child: SpinKitCubeGrid(
                            size: 20.0,
                            color: Colors.lightBlue,
                          )))
                        else
                          Container()
                      ],
                    );
                  },
                ),
              ),
              ListTile(
                tileColor: Colors.black,
                title: Text(
                  'See more',
                  style: TextStyle(color: Colors.white),
                ),
                trailing: Icon(
                  Icons.arrow_forward_sharp,
                  color: Colors.white,
                ),
                onTap: () {
                  appService.getMoreSuggestions();
                  String genre = appService.getGenreName();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SuggestionsScreen(genre: genre,)));
                },
              ),
            ],
          ),
        ));
  }
}

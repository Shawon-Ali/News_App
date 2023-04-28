import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mad43/http/custome_http.dart';
import 'package:mad43/model/news_model.dart';
import 'package:mad43/screen/news_details.dart';
import 'package:jiffy/jiffy.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  NewsModel? newsModel;
    var clr1 = Colors.amber;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
              child: Column(
            children: [
              TextField(
                style: TextStyle(color: Colors.white),
                controller: searchController,
                onEditingComplete: () async {
                  newsModel = await CustomeHttpRequest.fetchSearchData(
                      searchController.text.toString());
                  setState(() {});
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      gapPadding: 2,
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide(
                        color: clr1,
                        style: BorderStyle.solid,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2.0, color: clr1),
                      borderRadius: BorderRadius.circular(35),
                    ),
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: IconButton(
                        onPressed: () {
                          searchController.clear();
                        },
                        icon: Icon(Icons.cancel))),
              ),
              SizedBox( height: 1 ),
              MasonryGridView.count(
                itemCount: searchKeyword.length,
                shrinkWrap: true,
                crossAxisCount: 4,
                mainAxisSpacing: 10,
                crossAxisSpacing: 4,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () async {
                      searchController.text = searchKeyword[index];
                      newsModel = await CustomeHttpRequest.fetchSearchData(
                          searchKeyword[index].toString());
                      setState(() {});
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: Text("${searchKeyword[index]}"),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(),
                      ),
                    ),
                  );
                },
              ),
              newsModel?.articles == null ? 
              SizedBox( height: 0,): ListView.builder(
                      itemCount: newsModel!.articles!.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => NewsDetails(
                                      articles: newsModel!.articles![index],
                                    )));
                          },
                          child: Container(
                            color: Colors.black,
                            height: 130,
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              color: clr1,
                              child: Stack(
                                children: [
                                  Container(
                                    height: 60, width: 60, color: Colors.white,
                                  ),
                                  Positioned(
                                    right: 0, bottom: 0,
                                    child: 
                                    Container( height: 60, width: 60,color: Colors.white,),
                                  ),
                                  Container(
                                    color: clr1,
                                    padding: EdgeInsets.all(14),
                                    margin: EdgeInsets.all(14),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  "${newsModel!.articles![index].urlToImage}",
                                              placeholder: (context, url) =>
                                                  CircularProgressIndicator(),
                                              errorWidget: (context, url,
                                                      error) =>
                                                  Image.network(
                                                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTOmYqa4Vpnd-FA25EGmYMiDSWOl9QV8UN1du_duZC9mQ&s"),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Expanded(
                                          flex: 10,
                                          child: Column(
                                            children: [
                                              Text(
                                                "${newsModel!.articles![index].title}",
                                                style: TextStyle(
                                                    color: Colors.black),
                                                maxLines: 2,
                                              ),
                                              Text(
                                                "${Jiffy('${newsModel!.articles![index].publishedAt}').format('MMM do yyyy, h:mm a')};",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
            ],
          )),
        ),
      ),
    );
  }

  List<String> searchKeyword = [
    "World",
    "Health",
    "Finace",
    "Bitcoin",
    "Sports",
    "Politics"
  ];
}

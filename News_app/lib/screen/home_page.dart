import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:jiffy/jiffy.dart';
import 'package:mad43/model/news_model.dart';
import 'package:mad43/provider/news_provider.dart';
import 'package:mad43/screen/news_details.dart';
import 'package:mad43/screen/search_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String sortBy = "publishedAt";

  int pageNo = 1;
  var clr1 = Colors.amber;
 
  @override
  Widget build(BuildContext context) {
    var newsProvider = Provider.of<NewsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "News",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SearchPage()));
              },
              icon: Icon(Icons.search))
        ],
      ),
      body: Container(
          color: Colors.black,
          padding: EdgeInsets.all(12),
          width: double.infinity,
          child: ListView(
            children: [
              Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35),
                    color: Colors.white,
                    image: DecorationImage(
                        image: NetworkImage("https://img.freepik.com/free-vector/global-earth-blue-technology-digital-background-design_1017-27075.jpg?size=626&ext=jpg&ga=GA1.1.1420585480.1679851601&semt=robertav1_2_sidr"),
                        fit: BoxFit.cover)
                        ),
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("News \nof the whole \nwold",style: TextStyle(fontSize: 30,color: Colors.white),),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                height: 45,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          if (pageNo > 1) {
                            setState(() {
                              pageNo -= 1;
                            });
                          }
                        },
                        child: Text("Prev")),
                    ListView.builder(
                      itemCount: 5,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              pageNo = index + 1;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 10),
                            color: pageNo == index + 1 ? clr1 : Colors.black,
                            padding: EdgeInsets.all(12),
                            child: Text(
                              "${index + 1}",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      },
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (pageNo < 5) {
                            setState(() {
                              pageNo += 1;
                            });
                          }
                        },
                        child: Text("Next")),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: clr1,
                  ),
                  child: DropdownButton(
                    dropdownColor: clr1,
                    value: sortBy,
                    items: [
                      DropdownMenuItem(
                          child: Text("Published At"), value: "publishedAt"),
                      DropdownMenuItem(
                        child: Text("Popularity"),
                        value: "popularity",
                      ),
                      DropdownMenuItem(
                        child: Text("Relevancy"),
                        value: "relevancy",
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        sortBy = value!;
                      });
                    },
                  ),
                ),
              ),
              FutureBuilder<NewsModel>(
                future: newsProvider.getNewsData(pageNo, sortBy),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Text("Something is wrong");
                  } else if (snapshot.data == null) {
                    return Text("snapshot data are null");
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.articles!.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => NewsDetails(
                                    articles: snapshot.data!.articles![index],
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
                                  height: 60,
                                  width: 60,
                                  color: Colors.white,
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    height: 60,
                                    width: 60,
                                    color: Colors.white,
                                  ),
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
                                                "${snapshot.data!.articles![index].urlToImage}",
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
                                              "${snapshot.data!.articles![index].title}",
                                              maxLines: 2,
                                            ),
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Icon(Icons.ac_unit),
                                                  Text(
                                                      "${Jiffy('${snapshot.data!.articles![index].publishedAt}').format('MMM do yyyy, h:mm a')};"),
                                                ])
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
                  );
                },
              )
            ],
          )),
    );
  }
}

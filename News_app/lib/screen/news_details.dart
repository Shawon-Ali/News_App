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

class NewsDetails extends StatelessWidget {
  NewsDetails({Key? key, this.articles}) : super(key: key);

  Articles? articles;
  var clr1 = Colors.amber;
  var clr2 = Colors.amberAccent;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            title:
                Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                      text: '${articles!.source!.name ?? "Unknown"}',
                      style:
                          TextStyle(fontWeight: FontWeight.w800, fontSize: 23)),
                  TextSpan(
                      text: '\n${articles!.author ?? "Unknown"}',
                      style: TextStyle(fontSize: 15)),
                ],
              ),
            ),
            actions: [
             
              Text(
                  "${Jiffy('${articles!.publishedAt}').format('h:mm a\nMMMd,y')}")
            ],
          ),
          body: Container(
          color: Colors.black,
            padding: EdgeInsets.only(top: 15,bottom: 15,left: 15,right: 15),
            child: Container(
              decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(35),
                        color: clr1),
              child: Column(
                children: [
                  
                  Container(
                    
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(35),
                        color: Colors.white,
                        image: DecorationImage(
                            image: NetworkImage("${articles!.urlToImage ?? ""}"),
                            fit: BoxFit.cover)),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                        
                          child: Text(
                            "${articles!.title}",
                            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500,backgroundColor: clr2),
                          ),
                        ),
                         SizedBox(
                          height: 15,
                        ),
                        Text("${articles!.description}"),
                        SizedBox(height: 12),
                        Text("${articles!.content}"),
                      ],
                    ),
                  ),
                  
                ],
              ),
            ),
          )

         

          ),
    );
  }
}

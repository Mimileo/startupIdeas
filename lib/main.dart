// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:quotes/quotes.dart';
import 'package:random_color/random_color.dart';

import 'model/StartupIdeaModel.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(
        primaryColor: Colors.deepPurpleAccent[400],
        accentColor: Colors.purpleAccent,
      ),
      home: RandomWords(),
    );
  }
}


class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final Map _ideas = {};
  final _biggerFont = TextStyle(fontSize: 18.0);
  final _bodyText = TextStyle(fontSize: 15,color: Colors.blueGrey);
  //final _saved = <WordPair>{};
  final _saved = <StartupIdea>{};

  Widget _buildRow(StartupIdea someIdea) {
    final alreadySaved = _saved.contains(someIdea);

    return Card(
      //margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
       children: <Widget>[
         ListTile(
           title: Text(
             someIdea.pair.asPascalCase,
             style: _biggerFont,
           ),
         ),


           //padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
           ListTile(
             subtitle: Text(
                 'Company Motto:  ' + someIdea.motto,
                  style: _bodyText,
             ),
           ),

         Padding(
           padding: EdgeInsets.only(bottom: 10),
         ),

         Row(

           mainAxisAlignment: MainAxisAlignment.spaceAround,
           children: <Widget>[
            // ListTile(
               //subtitle:
           Text(
                 'Company Color:  ' + someIdea.getCompanyColorName(),
                 style: _bodyText,
               ),
            // ),


             ClipOval(
               child: Container(
                 color: someIdea.getCompanyColor(),
                 height:80,
                 width: 80,
                 child: Center(
                   child: Text( '#' +
                      someIdea.getColorHex(),
                       style: TextStyle(fontSize:14, color: Colors.white),
                  ),
                 ),
               ),
             ),
           ],
         ),




         Padding(
           padding: EdgeInsets.only(bottom: 10),
         ),

         ButtonBar(
           children: <Widget>[
             IconButton(
               icon: Icon(
                 alreadySaved ? Icons.favorite : Icons.favorite_border,
                 color: alreadySaved ? Colors.red : null,
               ),
               onPressed: () {
                 setState(() {
                   if (alreadySaved) {
                     _saved.remove(someIdea);
                   } else {
                     _saved.add(someIdea);
                   }
                 });
               },
             ),
           ],
         ),
       ],
     ),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();

          final index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
            _suggestions.forEach((pair) {
              if(!_ideas.containsKey(pair)) {
                _ideas[pair] = StartupIdea(pair, Quotes.getRandom().getContent());
              }
            });
          }
          return _buildRow(_ideas[_suggestions[index]]);
        }
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final tiles = _saved.map(
                (StartupIdea idea) {
              return Card(
                child:Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 16.0, right:16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[

                        Padding(
                          padding: EdgeInsets.only( bottom: 10.0),
                          child: Text(
                              idea.pair.asPascalCase + ' - ' + idea.motto,
                            style: _bodyText,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children:<Widget>[
                              Text(idea.getCompanyColorName() + '\n#' + idea.getColorHex(),
                                style: TextStyle(fontSize: 14, color: Colors.blueGrey),
                              ),

                              ClipOval(
                                child: Container(
                                  color: idea.getCompanyColor(),
                                  height:40,
                                  width: 40,
                                  child: Center(

                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );

          final divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          return Scaffold(
            appBar: AppBar(
              title: Text('Saved Suggestions'),
            ),
            body: ListView(children: divided,),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: [
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved,)
        ],
      ),
      body: _buildSuggestions(),
    );
  }
}

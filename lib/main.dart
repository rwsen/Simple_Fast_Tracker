// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Fast Tracker',
      home: RandomWords(),
    );
  }
}

class RandomWordsState extends State<RandomWords>
{
  // list of all generated words
  final List<WordPair> _suggestions = <WordPair>[];
  // define a singular style instance, to be used consistently
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);
  // keep track of favorites
  final Set<WordPair> _saved = Set<WordPair>();

  // build function
  @override
  Widget build(BuildContext context)
  {
    return Scaffold
    (
      appBar: AppBar
      (
        title: Text('Simple Fast Tracker'),
        actions: <Widget>[IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),],
      ),
      body: _buildSuggestions(),
    );
  }
  
  // push a new route that displays the list of saved wordpairs
  void _pushSaved()
  {
    Navigator.of(context).push
    (
      MaterialPageRoute<void>
      (
        builder: (BuildContext)
        {
          final Iterable<ListTile> tiles = _saved.map(
            (WordPair pair)
            {
              return ListTile( title: Text(pair.asPascalCase, style: _biggerFont));
            }
          );
          final List<Widget> divided = ListTile.divideTiles(context: context, tiles: tiles).toList();
          return Scaffold
          (
            appBar: AppBar(title: Text('Saved WordPairs')), 
            body: ListView(children: divided)
          );
        },
      ),
    );
  }

  _buildSuggestions()
  {
    return ListView.builder
    (
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i)
      {
        if (i.isOdd)
        {
          return Divider();
        }
        
        // add a wordpair
        final index = i ~/ 2;
        if (index >= _suggestions.length)
        {
          _suggestions.addAll(generateWordPairs().take(10));
        }
        
        return _buildRow(_suggestions[index]);
      }
    );
  }
  
  Widget _buildRow(WordPair pair)
  {
    // check for saved status
    final bool alreadySaved = _saved.contains(pair);
    return ListTile
    (
      title: Text
      (
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon
      (
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: ()
      // change state and rebuild UI
      {
        setState
        (
          ()
          {
            if (alreadySaved)
            {
              _saved.remove(pair);
            } else {
              _saved.add(pair);
            }
          }
        );
      },
    );
  }
}

class RandomWords extends StatefulWidget
{
  @override
  RandomWordsState createState() => RandomWordsState();
}
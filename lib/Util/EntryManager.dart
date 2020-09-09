import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Entry {
  String title;
  List<Entry> children;
  int generation;

  Entry(this.title, this.children, this.generation);
}

class EntryItem extends StatelessWidget {
  final Entry entry;

  EntryItem(this.entry);

  Widget _buildItem(Entry entry) {
    if (entry.children.isEmpty) {
      return ListTile(
        onTap: () => _launchStreamingLink(entry.title),
        title: Padding(
          padding: EdgeInsets.only(
            left: 10.0 * entry.generation,
          ),
          child: Text(
            entry.title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.0,
            ),
          ),
        ),
      );
    } else {
      return ExpansionTile(
        key: PageStorageKey<Entry>(entry),
        title: Padding(
          padding: EdgeInsets.only(
            left: 10.0 * entry.generation,
          ),
          child: Text(
            entry.title,
            style: TextStyle(
                color: Colors.white, fontSize: 17.0 - entry.generation),
          ),
        ),
        children: entry.children.map<Widget>(_buildItem).toList(),
      );
    }
  }

  void _launchStreamingLink(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildItem(entry);
  }
}

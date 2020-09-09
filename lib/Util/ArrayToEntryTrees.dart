import 'package:flutter/material.dart';
import 'EntryManager.dart';

Widget arrayToEntryTreeSeries(
    BuildContext context, int index, List seasonsArray) {
  return EntryItem(
    seasonsArray
        .asMap()
        .map((index, hashmap) {
          return MapEntry(
            index,
            Entry(
              "Saison " + (index + 1).toString(),
              hashmap
                  .map<String, Entry>((key, value) => MapEntry(
                      key.toString(),
                      Entry(
                        key,
                        /*
                        [
                          Entry(value, [], 2),
                        ]*/
                        value
                            .map<Entry>(
                              (element) => Entry(
                                element,
                                [],
                                2,
                              ),
                            )
                            .toList(),
                        1,
                      )))
                  .values
                  .toList(),
              0,
            ),
          );
        })
        .values
        .toList()[index],
  );
}

Widget arrayToEntryTreeLinks(
    BuildContext context, int index, Map seasonsArray) {
  return EntryItem(seasonsArray
      .map(
        (key, value) => MapEntry(
          key,
          Entry(
            key,
            value
                .map<Entry>(
                  (link) => Entry(link, [], 1),
                )
                .toList(),
            0,
          ),
        ),
      )
      .values
      .toList()[index]);
}

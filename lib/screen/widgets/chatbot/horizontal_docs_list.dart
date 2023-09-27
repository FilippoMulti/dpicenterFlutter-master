import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HorizontalDocsList extends StatelessWidget {
  final List<String> docs;

  const HorizontalDocsList({required this.docs, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: docs.length,
        itemBuilder: (BuildContext context, int index) {
          List<String> values = docs[index].split("|");
          return Column(
            children: [
              Material(
                borderRadius: BorderRadius.circular(10),
                clipBehavior: Clip.antiAlias,
                type: MaterialType.transparency,
                child: Ink(
                  // clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: Image.network(
                        values[0],
                        filterQuality: FilterQuality.medium,
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ).image,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.medium,
                    ),
                  ),
                  width: 100.0,
                  height: 100.0,
                  child: InkWell(
                    onTap: () {
                      launchUrl(Uri.parse(values[0]),
                          mode: LaunchMode.externalApplication);
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                values.length > 1 ? values[1] : "Documento",
                style: Theme.of(context).textTheme.bodySmall,
              )
            ],
          );
        },
      ),
    );
  }
}

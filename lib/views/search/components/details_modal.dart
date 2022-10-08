import 'package:bateria_mobile/views/search/components/map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsModal extends StatelessWidget {
  const DetailsModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Consumer(builder: (context, ref, _) {
        final textTheme = Theme.of(context).textTheme;
        final point = ref.watch(collectPoint);

        if (point == null) {
          throw Exception('There is no collect point selected.');
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(point.name, style: textTheme.titleLarge),
            const SizedBox(height: 16),
            Text('Endereço', style: textTheme.caption),
            Text(point.address),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () async {
                final uri = Uri.https('www.google.com', '/maps/dir/', {
                  'api': '1',
                  'destination': point.address,
                });

                if (!await launchUrl(uri)) {
                  throw 'Error when launching URI: $uri';
                }
              },
              icon: const Icon(Icons.send),
              label: const Text('Navegar'),
            ),
          ],
        );
      }),
    );
  }
}

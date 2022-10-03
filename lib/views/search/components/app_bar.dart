import 'package:bateria_mobile/views/search/components/search_delegate.dart';
import 'package:bateria_mobile/views/search/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchPageAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const SearchPageAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      title: const Text('Bateria'),
      actions: [
        IconButton(
          onPressed: () async {
            final mapsAddress = await showSearch(
              context: context,
              delegate: SearchPageSearchDelegate(),
            );

            ref.read(currentMapsAddress.state).state = mapsAddress;
          },
          icon: const Icon(Icons.search),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

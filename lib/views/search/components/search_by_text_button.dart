import 'package:bateria_mobile/views/search/components/search_delegate.dart';
import 'package:bateria_mobile/views/search/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchByTextButton extends ConsumerWidget {
  const SearchByTextButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Tooltip(
      message: 'Buscar por endereço',
      child: IconButton(
        onPressed: () async {
          final mapsAddress = await showSearch(
            context: context,
            delegate: SearchPageSearchDelegate(),
          );

          ref.read(currentMapsAddress.state).state = mapsAddress;
        },
        icon: const Icon(Icons.search),
      ),
    );
  }
}

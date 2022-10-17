import 'package:bateria_mobile/views/search/components/search_by_location_button.dart';
import 'package:bateria_mobile/views/search/components/search_by_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchPageAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const SearchPageAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      title: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 12,
        children: [
          Image.asset(
            'assets/images/battery_logo.png',
            height: 24,
          ),
          const Text('Bateria')
        ],
      ),
      actions: const [
        SearchByLocationButton(),
        SearchByTextButton(),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

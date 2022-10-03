import 'package:bateria_mobile/main.dart';
import 'package:bateria_mobile/models/google_maps/maps_address.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final addressesLoading = StateProvider((ref) => true);
final addresses = StateProvider(
  (ref) => const <MapsAddress>[],
);

class SearchPageSearchDelegate extends SearchDelegate<MapsAddress?> {
  String _lastQuery = '';

  @override
  String? get searchFieldLabel => 'Busque por endereço';

  Future<void> _fetchAddresses(String query, WidgetRef ref) async {
    // TODO: fix this await. It's only used not to run the change in the build.
    await Future.delayed(const Duration(seconds: 0));

    final loadingState = ref.read(addressesLoading.state);
    loadingState.state = true;

    final apiClient = ref.read(googleMapsApiClient);
    final results = await apiClient.fetchPlacesByText(query);

    loadingState.state = false;
    ref.read(addresses.state).state = results;
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      Tooltip(
        message: 'Limpar busca',
        child: IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear),
        ),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return Tooltip(
      message: 'Voltar ao mapa',
      child: IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back),
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final loading = ref.watch(addressesLoading);
      final items = ref.watch(addresses);

      if (_lastQuery != query) {
        _lastQuery = query;
        _fetchAddresses(_lastQuery, ref);
      }

      if (loading) {
        return Container(
          alignment: Alignment.center,
          child: const CircularProgressIndicator(),
        );
      }

      return ListView.separated(
        itemBuilder: (context, index) {
          final item = ref.read(addresses)[index];

          return ListTile(
            title: Text(item.name),
            style: ListTileStyle.drawer,
            onTap: () {
              close(context, item);
            },
          );
        },
        separatorBuilder: (context, index) => const Divider(
          height: 0,
        ),
        itemCount: items.length,
      );
    });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}

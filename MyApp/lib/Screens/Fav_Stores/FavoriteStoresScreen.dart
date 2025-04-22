// screens/favorites/favorite_stores_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/store_provider.dart';
import '../../models/store.dart';

// screens/favorites/favorite_stores_screen.dart

// Add import for DistanceScreen
import '../Dis_Screen/DistanceScreen.dart';

class FavoriteStoresScreen extends StatelessWidget {
  const FavoriteStoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Stores'),
        centerTitle: true,
      ),
      body: Consumer<StoreProvider>(
        builder: (context, storeProvider, _) {
          return _buildBody(storeProvider, context);
        },
      ),
    );
  }

  Widget _buildBody(StoreProvider storeProvider, BuildContext context) {
    // Filter out the favorite stores
    final favoriteStores = storeProvider.stores.where((store) => store.isFavorite).toList();

    if (storeProvider.isLoading && favoriteStores.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (storeProvider.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 50, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              storeProvider.error!,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => storeProvider.fetchStores(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (favoriteStores.isEmpty) {
      return const Center(child: Text('No favorite stores available'));
    }

    return ListView.builder(
      itemCount: favoriteStores.length,
      itemBuilder: (context, index) {
        final store = favoriteStores[index];
        return Card(
          margin: const EdgeInsets.all(8),
          elevation: 2,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 16,
            ),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: store.isOpen
                    ? Colors.green.withOpacity(0.1)
                    : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getStoreIcon(store.storeType),
                size: 30,
                color: store.isOpen ? Colors.green : Colors.grey,
              ),
            ),
            title: Text(
              store.storeName,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  store.storeType.toUpperCase(),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, size: 16, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      store.rating.toStringAsFixed(1),
                      style: const TextStyle(fontSize: 14),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 2,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        color: store.isOpen
                            ? Colors.green.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        store.isOpen ? 'OPEN' : 'CLOSED',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: store.isOpen ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: IconButton(
              icon: Icon(
                store.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: store.isFavorite ? Colors.red : Colors.grey,
              ),
              onPressed: () {
                Provider.of<StoreProvider>(context, listen: false)
                    .toggleFavorite(store);
              },
            ),
            onTap: () {
              // Navigate to the DistanceScreen when the store is tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DistanceScreen(store: store),
                ),
              );
            },
          ),
        );
      },
    );
  }

  IconData _getStoreIcon(String type) {
    switch (type.toLowerCase()) {
      case 'grocery':
        return Icons.shopping_basket;
      case 'electronics':
        return Icons.electrical_services;
      case 'clothing':
        return Icons.checkroom;
      case 'convenience':
        return Icons.local_convenience_store;
      case 'department':
        return Icons.store_mall_directory;
      default:
        return Icons.store;
    }
  }
}

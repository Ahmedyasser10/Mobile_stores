import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_ass/providers/store_provider.dart';
import 'package:mobile_ass/models/store.dart';

class StoresScreen extends StatefulWidget {
  const StoresScreen({super.key});

  @override
  State<StoresScreen> createState() => _StoresScreenState();
}

class _StoresScreenState extends State<StoresScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _loadInitialData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (!mounted) return;

    final provider = Provider.of<StoreProvider>(context, listen: false);
    if (provider.stores.isEmpty) {
      await provider.fetchStores();
    }
  }

  Future<void> _refreshData() async {
    final provider = Provider.of<StoreProvider>(context, listen: false);
    await provider.refresh();
    if (!mounted) return;

    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Egypt Stores'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh stores',
            onPressed: _refreshData,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Consumer<StoreProvider>(
          builder: (context, storeProvider, _) {
            return _buildBody(storeProvider, context);
          },
        ),
      ),
    );
  }

  Widget _buildBody(StoreProvider storeProvider, BuildContext context) {
    if (storeProvider.isLoading && storeProvider.stores.isEmpty) {
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
              onPressed: () => storeProvider.refresh(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (storeProvider.stores.isEmpty) {
      return const Center(child: Text('No stores available'));
    }

    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      thickness: 6,
      radius: const Radius.circular(8),
      child: ListView.builder(
        controller: _scrollController,
        itemCount: storeProvider.stores.length,
        itemBuilder: (context, index) {
          final store = storeProvider.stores[index];
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
                  storeProvider.isFavorite(store) ? Icons.favorite : Icons.favorite_border,
                  color: storeProvider.isFavorite(store) ? Colors.red : Colors.grey,
                ),
                onPressed: () {
                  storeProvider.toggleFavorite(store);
                },
              ),
              onTap: () {
                // Navigate to store details if needed
              },
            ),
          );
        },
      ),
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
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mobile_ass/models/store.dart';

class StoreProvider with ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  List<Store> _stores = [];
  Set<int> _favoriteStoreIds = {};  // Change Set<String> to Set<int>
  bool _isLoading = false;
  String? _error;

  List<Store> get stores => _stores;
  List<Store> get favoriteStores => _stores.where((store) => _favoriteStoreIds.contains(store.id)).toList();
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool isFavorite(Store store) => _favoriteStoreIds.contains(store.id);

  Future<void> fetchStores() async {
    try {
      _isLoading = true;
      notifyListeners();

      // Fetch all stores
      final storesResponse = await _supabase
          .from('stores')
          .select('*')
          .order('rating', ascending: false);

      _stores = (storesResponse as List)
          .map((storeJson) => Store.fromJson(storeJson))
          .toList();

      // Fetch user's favorites if logged in
      await _fetchFavorites();
    } on PostgrestException catch (e) {
      _error = 'Database error: ${e.message}';
      debugPrint('Supabase error: ${e.message}');
    } catch (e) {
      _error = 'Failed to load stores: ${e.toString()}';
      debugPrint('Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _fetchFavorites() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    try {
      final favoritesResponse = await _supabase
          .from('favorites')
          .select('store_id')
          .eq('user_id', userId);

      _favoriteStoreIds = (favoritesResponse as List)
          .map((fav) => fav['store_id'] as int)  // Change to cast to int
          .toSet();
    } catch (e) {
      debugPrint('Error fetching favorites: $e');
    }
  }

  Future<void> toggleFavorite(Store store) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      _error = 'You must be logged in to favorite stores';
      notifyListeners();
      return;
    }

    final isCurrentlyFavorite = _favoriteStoreIds.contains(store.id);

    try {
      // Optimistic UI update
      if (isCurrentlyFavorite) {
        _favoriteStoreIds.remove(store.id);
      } else {
        _favoriteStoreIds.add(store.id);
      }
      notifyListeners();

      // Sync with Supabase
      if (isCurrentlyFavorite) {
        await _supabase
            .from('favorites')
            .delete()
            .match({
          'user_id': userId,
          'store_id': store.id,
        });
      } else {
        await _supabase
            .from('favorites')
            .insert({
          'user_id': userId,
          'store_id': store.id,
        });
      }
    } catch (e) {
      // Revert on error
      if (isCurrentlyFavorite) {
        _favoriteStoreIds.add(store.id);
      } else {
        _favoriteStoreIds.remove(store.id);
      }
      notifyListeners();
      _error = 'Failed to update favorite: ${e.toString()}';
      debugPrint('Error toggling favorite: $e');
    }
  }

  Future<void> refresh() async {
    _error = null;
    await fetchStores();
  }
}

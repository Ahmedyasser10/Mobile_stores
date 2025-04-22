// providers/store_provider.dart
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/store.dart';

class StoreProvider with ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  List<Store> _stores = [];
  bool _isLoading = false;
  String? _error;

  List<Store> get stores => _stores;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchStores() async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _supabase
          .from('stores')
          .select('*')
          .order('rating', ascending: false);

      _stores = (response as List)
          .map((storeJson) => Store.fromJson(storeJson))
          .toList();
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

  Future<void> toggleFavorite(Store store) async {
    final index = _stores.indexWhere((s) => s.storeName == store.storeName);
    if (index == -1) return;

    try {
      // Optimistic UI update
      _stores[index].isFavorite = !_stores[index].isFavorite;
      notifyListeners();

      // Sync with Supabase (using 'isFavorite' as the DB field name)
      await _supabase
          .from('stores')
          .update({'isFavorite': _stores[index].isFavorite})
          .eq('store_name', store.storeName); // Use a unique identifier
    } catch (e) {
      // Revert on error
      _stores[index].isFavorite = !_stores[index].isFavorite;
      notifyListeners();
      _error = 'Failed to update favorite: ${e.toString()}';
      debugPrint('Error toggling favorite: $e');
    }
  }
}

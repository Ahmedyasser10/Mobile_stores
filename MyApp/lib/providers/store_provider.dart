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
      _error = null;
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
}

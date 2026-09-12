import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/logger_service.dart';
import '../../gallery/models/jewellery_item.dart';
import 'wishlist_event.dart';
import 'wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  static const String _storageKey = 'cj_saved_wishlist_items_v1';

  WishlistBloc() : super(const WishlistState()) {
    on<LoadWishlistEvent>(_onLoadWishlist);
    on<ToggleWishlistEvent>(_onToggleWishlist);
    on<RemoveFromWishlistEvent>(_onRemoveFromWishlist);
  }

  Future<void> _onLoadWishlist(
    LoadWishlistEvent event,
    Emitter<WishlistState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_storageKey);
      if (raw != null && raw.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(raw);
        final items = decoded.map((e) => JewelleryItem.fromJson(e as Map<String, dynamic>)).toList();
        emit(state.copyWith(items: items, isLoading: false));
        AppLogger.info('Loaded ${items.length} items from wishlist storage');
        return;
      }
    } catch (e, stack) {
      AppLogger.error('Failed to load wishlist from local storage', e, stack);
    }
    emit(state.copyWith(items: const [], isLoading: false));
  }

  Future<void> _onToggleWishlist(
    ToggleWishlistEvent event,
    Emitter<WishlistState> emit,
  ) async {
    final exists = state.isInWishlist(event.item.id);
    List<JewelleryItem> updated;
    if (exists) {
      updated = state.items.where((i) => i.id != event.item.id).toList();
      AppLogger.info('Removed item ${event.item.id} from wishlist');
    } else {
      updated = List<JewelleryItem>.from(state.items)..insert(0, event.item);
      AppLogger.info('Added item ${event.item.id} to wishlist');
    }
    emit(state.copyWith(items: updated));
    await _saveToStorage(updated);
  }

  Future<void> _onRemoveFromWishlist(
    RemoveFromWishlistEvent event,
    Emitter<WishlistState> emit,
  ) async {
    final updated = state.items.where((i) => i.id != event.itemId).toList();
    emit(state.copyWith(items: updated));
    await _saveToStorage(updated);
  }

  Future<void> _saveToStorage(List<JewelleryItem> items) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final serialized = jsonEncode(items.map((i) => {
        'id': i.id,
        'name': i.name,
        'image': i.image,
        'description': i.description,
        'purity': i.purity,
        'stone': i.stone,
        'category': i.category,
        'sku': i.sku,
        'dimensions': i.dimensions,
        'weight': i.weight,
        'cached_price': i.cachedPrice,
        'metal_type': i.metalType,
        'manual_price': i.manualPrice,
        'is_favourite': i.isFavourite,
        'is_sold_out': i.isSoldOut,
        'use_manual_rates': i.useManualRates,
        'created_at': i.createdAt.toIso8601String(),
      }).toList());
      await prefs.setString(_storageKey, serialized);
    } catch (e, stack) {
      AppLogger.error('Failed to persist wishlist to storage', e, stack);
    }
  }
}

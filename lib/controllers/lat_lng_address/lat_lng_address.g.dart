// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lat_lng_address.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$latLngAddressControllerHash() =>
    r'd5f7e9b95aaff98163911137b6a4860e99fb7505';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$LatLngAddressController
    extends BuildlessAsyncNotifier<LatLngAddressControllerState> {
  late final String latitude;
  late final String longitude;

  Future<LatLngAddressControllerState> build({
    required String latitude,
    required String longitude,
  });
}

/// See also [LatLngAddressController].
@ProviderFor(LatLngAddressController)
const latLngAddressControllerProvider = LatLngAddressControllerFamily();

/// See also [LatLngAddressController].
class LatLngAddressControllerFamily
    extends Family<AsyncValue<LatLngAddressControllerState>> {
  /// See also [LatLngAddressController].
  const LatLngAddressControllerFamily();

  /// See also [LatLngAddressController].
  LatLngAddressControllerProvider call({
    required String latitude,
    required String longitude,
  }) {
    return LatLngAddressControllerProvider(
      latitude: latitude,
      longitude: longitude,
    );
  }

  @override
  LatLngAddressControllerProvider getProviderOverride(
    covariant LatLngAddressControllerProvider provider,
  ) {
    return call(
      latitude: provider.latitude,
      longitude: provider.longitude,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'latLngAddressControllerProvider';
}

/// See also [LatLngAddressController].
class LatLngAddressControllerProvider extends AsyncNotifierProviderImpl<
    LatLngAddressController, LatLngAddressControllerState> {
  /// See also [LatLngAddressController].
  LatLngAddressControllerProvider({
    required String latitude,
    required String longitude,
  }) : this._internal(
          () => LatLngAddressController()
            ..latitude = latitude
            ..longitude = longitude,
          from: latLngAddressControllerProvider,
          name: r'latLngAddressControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$latLngAddressControllerHash,
          dependencies: LatLngAddressControllerFamily._dependencies,
          allTransitiveDependencies:
              LatLngAddressControllerFamily._allTransitiveDependencies,
          latitude: latitude,
          longitude: longitude,
        );

  LatLngAddressControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.latitude,
    required this.longitude,
  }) : super.internal();

  final String latitude;
  final String longitude;

  @override
  Future<LatLngAddressControllerState> runNotifierBuild(
    covariant LatLngAddressController notifier,
  ) {
    return notifier.build(
      latitude: latitude,
      longitude: longitude,
    );
  }

  @override
  Override overrideWith(LatLngAddressController Function() create) {
    return ProviderOverride(
      origin: this,
      override: LatLngAddressControllerProvider._internal(
        () => create()
          ..latitude = latitude
          ..longitude = longitude,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        latitude: latitude,
        longitude: longitude,
      ),
    );
  }

  @override
  AsyncNotifierProviderElement<LatLngAddressController,
      LatLngAddressControllerState> createElement() {
    return _LatLngAddressControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LatLngAddressControllerProvider &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, latitude.hashCode);
    hash = _SystemHash.combine(hash, longitude.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin LatLngAddressControllerRef
    on AsyncNotifierProviderRef<LatLngAddressControllerState> {
  /// The parameter `latitude` of this provider.
  String get latitude;

  /// The parameter `longitude` of this provider.
  String get longitude;
}

class _LatLngAddressControllerProviderElement
    extends AsyncNotifierProviderElement<LatLngAddressController,
        LatLngAddressControllerState> with LatLngAddressControllerRef {
  _LatLngAddressControllerProviderElement(super.provider);

  @override
  String get latitude => (origin as LatLngAddressControllerProvider).latitude;
  @override
  String get longitude => (origin as LatLngAddressControllerProvider).longitude;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

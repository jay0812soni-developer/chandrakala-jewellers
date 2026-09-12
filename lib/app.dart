import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'features/account/views/account_view.dart';
import 'features/blog/views/blog_list_view.dart';
import 'features/blog/views/blog_post_view.dart';
import 'features/cart/bloc/cart_bloc.dart';
import 'features/cart/views/cart_view.dart';
import 'features/catalogue/bloc/catalogue_bloc.dart';
import 'features/catalogue/bloc/catalogue_event.dart';
import 'features/catalogue/repository/catalogue_repository.dart';
import 'features/catalogue/views/catalogue_view.dart';
import 'features/checkout/views/buynow_view.dart';
import 'features/checkout/views/checkout_view.dart';
import 'features/gallery/bloc/gallery_bloc.dart';
import 'features/gallery/bloc/gallery_event.dart';
import 'features/gallery/models/jewellery_item.dart';
import 'features/gallery/repository/gallery_repository.dart';
import 'features/gallery/views/gallery_view.dart';
import 'features/home/views/home_view.dart';
import 'features/info/views/about_view.dart';
import 'features/info/views/contact_view.dart';
import 'features/info/views/follow_us_view.dart';
import 'features/product_detail/views/product_detail_view.dart';
import 'features/rates/bloc/rates_bloc.dart';
import 'features/rates/bloc/rates_event.dart';
import 'features/rates/repository/rates_repository.dart';
import 'features/rates_info/views/gold_rate_view.dart';
import 'features/rates_info/views/jewellers_view.dart';
import 'features/splash/views/splash_view.dart';
import 'features/wishlist/bloc/wishlist_bloc.dart';
import 'features/wishlist/bloc/wishlist_event.dart';
import 'features/wishlist/views/wishlist_view.dart';

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashView(),
    ),
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashView(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeView(),
    ),
    GoRoute(
      path: '/index1',
      builder: (context, state) => const HomeView(),
    ),
    GoRoute(
      path: '/gallery',
      builder: (context, state) => const GalleryView(),
    ),
    GoRoute(
      path: '/shop',
      builder: (context, state) => const GalleryView(),
    ),
    GoRoute(
      path: '/catalogue',
      builder: (context, state) => const CatalogueView(),
    ),
    GoRoute(
      path: '/Catalogue',
      builder: (context, state) => const CatalogueView(),
    ),
    GoRoute(
      path: '/product/:id',
      builder: (context, state) {
        final item = state.extra as JewelleryItem?;
        final idParam = int.tryParse(state.pathParameters['id'] ?? '');
        return ProductDetailView(item: item, itemId: idParam);
      },
    ),
    GoRoute(
      path: '/cart',
      builder: (context, state) => const CartView(),
    ),
    GoRoute(
      path: '/checkout',
      builder: (context, state) => const CheckoutView(),
    ),
    GoRoute(
      path: '/buynow',
      builder: (context, state) {
        final item = state.extra as JewelleryItem?;
        final idParam = int.tryParse(state.uri.queryParameters['id'] ?? '');
        return BuyNowView(item: item, itemId: idParam);
      },
    ),
    GoRoute(
      path: '/wishlist',
      builder: (context, state) => const WishlistView(),
    ),
    GoRoute(
      path: '/blog',
      builder: (context, state) => const BlogListView(),
    ),
    GoRoute(
      path: '/blog/:slug',
      builder: (context, state) {
        final slug = state.pathParameters['slug'] ?? 'jewellery-care-tips';
        return BlogPostView(slug: slug);
      },
    ),
    GoRoute(
      path: '/blog-post',
      builder: (context, state) {
        final slug = state.uri.queryParameters['slug'] ?? 'jewellery-care-tips';
        return BlogPostView(slug: slug);
      },
    ),
    GoRoute(
      path: '/about',
      builder: (context, state) => const AboutView(),
    ),
    GoRoute(
      path: '/contact',
      builder: (context, state) => const ContactView(),
    ),
    GoRoute(
      path: '/follow-us',
      builder: (context, state) => const FollowUsView(),
    ),
    GoRoute(
      path: '/gold-rate-khedbrahma',
      builder: (context, state) => const GoldRateView(),
    ),
    GoRoute(
      path: '/jewellers-in-khedbrahma',
      builder: (context, state) => const JewellersInKhedbrahmaView(),
    ),
    GoRoute(
      path: '/account',
      builder: (context, state) => const AccountView(),
    ),
  ],
);

class CJApp extends StatelessWidget {
  const CJApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => RatesRepository()),
        RepositoryProvider(create: (_) => GalleryRepository()),
        RepositoryProvider(create: (_) => CatalogueRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => RatesBloc(
              repository: context.read<RatesRepository>(),
            )..add(const FetchRatesEvent()),
          ),
          BlocProvider(
            create: (context) => GalleryBloc(
              repository: context.read<GalleryRepository>(),
            )..add(const LoadGalleryEvent()),
          ),
          BlocProvider(
            create: (context) => CatalogueBloc(
              repository: context.read<CatalogueRepository>(),
            )..add(const LoadCatalogueEvent()),
          ),
          BlocProvider(
            create: (_) => CartBloc(),
          ),
          BlocProvider(
            create: (_) => WishlistBloc()..add(const LoadWishlistEvent()),
          ),
          BlocProvider(
            create: (_) => ThemeCubit(),
          ),
        ],
        child: BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            return MaterialApp.router(
              title: 'ChandraKala Jewellers',
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeMode,
              routerConfig: _router,
              debugShowCheckedModeBanner: false,
            );
          },
        ),
      ),
    );
  }
}

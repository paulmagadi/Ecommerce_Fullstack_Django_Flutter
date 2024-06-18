// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/product_provider.dart';
// import '../widgets/product_item.dart';
// import '../models/product.dart';

// class SearchScreen extends StatefulWidget {
//   @override
//   _SearchScreenState createState() => _SearchScreenState();
// }

// class _SearchScreenState extends State<SearchScreen> {
//   TextEditingController _searchController = TextEditingController();
//   List<Product> _searchResults = [];
//   bool _isLoading = true;

//   void _searchProducts() {
//     final query = _searchController.text.toLowerCase();

//     if (query.isEmpty) {
//       setState(() {
//         _searchResults = [];
//       });
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//     });

//     final productProvider =
//         Provider.of<ProductProvider>(context, listen: false);
//     final allProducts = productProvider.products;

//     setState(() {
//       _searchResults = allProducts.where((product) {
//         return product.name.toLowerCase().contains(query) ||
//             (product.category.name.toLowerCase().contains(query)) ||
//             (product.color?.toLowerCase().contains(query) ?? false) ||
//             (product.keyWords?.toLowerCase().contains(query) ?? false) ||
//             (product.brand?.toLowerCase().contains(query) ?? false) ||
//             (product.material?.toLowerCase().contains(query) ?? false);
//       }).toList();
//       _isLoading = false;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final productProvider =
//           Provider.of<ProductProvider>(context, listen: false);
//       productProvider
//           .fetchProducts(); // Ensure products are fetched when the screen loads
//     });
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: TextField(
//           controller: _searchController,
//           decoration: InputDecoration(
//             hintText: 'Search products...',
//             suffixIcon: IconButton(
//               icon: Icon(Icons.search),
//               onPressed: _searchProducts,
//             ),
//           ),
//           onSubmitted: (value) => _searchProducts(),
//         ),
//       ),
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator())
//           : _searchResults.isEmpty
//               ? Center(child: Text('No products found.'))
//               : GridView.builder(
//                   gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
//                     maxCrossAxisExtent: 200,
//                     childAspectRatio: 2.3 / 3,
//                     crossAxisSpacing: 5,
//                     mainAxisSpacing: 5,
//                   ),
//                   itemCount: _searchResults.length,
//                   itemBuilder: (ctx, index) {
//                     final product = _searchResults[index];
//                     return ProductItem(product: product);
//                   },
//                 ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_item.dart';
import '../models/product.dart';
import 'dart:async';

class SearchScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final searchController = useTextEditingController();
    final searchQuery = useState<String>('');
    final searchResults = useState<List<Product>>([]);
    final isLoading = useState<bool>(false);
    final errorMessage = useState<String>('');

    useEffect(() {
      Timer? debounce;

      void _onSearchChanged() {
        if (debounce?.isActive ?? false) debounce?.cancel();

        debounce = Timer(const Duration(milliseconds: 300), () async {
          if (searchController.text.isEmpty) {
            searchResults.value = [];
            return;
          }

          isLoading.value = true;
          errorMessage.value = '';

          try {
            final productProvider = Provider.of<ProductProvider>(context, listen: false);
            final results = productProvider.products.where((product) {
              final query = searchController.text.toLowerCase();
              return product.name.toLowerCase().contains(query) ||
                     (product.category.name.toLowerCase().contains(query)) ||
                     (product.color?.toLowerCase().contains(query) ?? false) ||
                     (product.keyWords?.toLowerCase().contains(query) ?? false) ||
                     (product.brand?.toLowerCase().contains(query) ?? false) ||
                     (product.material?.toLowerCase().contains(query) ?? false);
            }).toList();
            searchResults.value = results;
          } catch (error) {
            errorMessage.value = 'Error searching products: $error';
          } finally {
            isLoading.value = false;
          }
        });
      }

      searchController.addListener(_onSearchChanged);

      return () => searchController.removeListener(_onSearchChanged);
    }, [searchController]);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Search products...',
            suffixIcon: IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                searchController.clear();
                searchResults.value = [];
              },
            ),
          ),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: searchResults,
        builder: (context, List<Product> results, child) {
          if (isLoading.value) {
            return Center(child: CircularProgressIndicator());
          } else if (results.isEmpty && errorMessage.value.isEmpty) {
            return Center(child: Text('No products found.'));
          } else if (errorMessage.value.isNotEmpty) {
            return Center(child: Text(errorMessage.value));
          } else {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 2.3 / 3,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
              itemCount: results.length,
              itemBuilder: (ctx, index) {
                final product = results[index];
                return ProductItem(product: product);
              },
            );
          }
        },
      ),
    );
  }
}

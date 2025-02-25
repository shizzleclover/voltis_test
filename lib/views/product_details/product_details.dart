import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/router/routes.dart';
import '../../models/product_detail_model.dart';
import '../../viewmodels/providers/product_details_provider.dart';
import '../../viewmodels/providers/theme_provider.dart';
import '../../core/utils/constants.dart';
import '../../widgets/custom_bottom_nav.dart';
import '../../core/helpers/ui_constants.dart';
import '../../core/helpers/text_styles.dart';
import '../../core/mixins/widget_helper_mixin.dart';

class ProductDetailsView extends StatefulWidget {
  const ProductDetailsView({super.key});

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> with WidgetHelperMixin {
  String selectedCategory = 'All Items';
  // ignore: unused_field
  final bool _isDropdownOpen = false;

  final List<String> categories = [
    'All Items',
    'Shirts',
    'Pants',
    'Accessories'
  ];

  bool _isMainDropdownOpen = false;
  final Map<String, bool> _subDropdownStates = {};
  String _dropdownHeaderText = 'Categories';
  final Set<String> _selectedItems = {};
  
  final Map<String, List<String>> categoryData = {
    'Men': ['T-Shirts', 'Jeans', 'Suits', 'Accessories'],
    'Women': ['Dresses', 'Tops', 'Skirts', 'Bags'],
    'Kids': ['Boys', 'Girls', 'Infants'],
    'Sports': ['Running', 'Training', 'Football'],
  };

  final List<String> brands = [
    'Nike', 'Adidas', 'Puma', 'Under Armour', 'New Balance', 
    'Reebok', 'Converse', 'Vans', 'Jordan'
  ];
  Set<String> selectedBrands = {};

  late ScrollController _scrollController;
  Timer? _scrollTimer;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _scrollTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _scrollTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_scrollController.hasClients) {
        final currentPosition = _scrollController.offset;
        final maxScroll = _scrollController.position.maxScrollExtent;
        
        if (currentPosition >= maxScroll) {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
          );
        } else {
          _scrollController.animateTo(
            currentPosition + 100.w,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;
    
    return Scaffold(
      drawer: _buildSidebar(isDarkMode),
      appBar: _buildAppBar(isDarkMode),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                SizedBox(height: 20.h),
                _userDetail(isDarkMode),
                _buildDivider(isDarkMode),
                _buildCategoryScroll(isDarkMode),
                _buildDivider(isDarkMode),
                _buildDropdownSection(isDarkMode),
                _buildDivider(isDarkMode),
                _buildTopBrandsSection(isDarkMode),
                _buildDivider(isDarkMode),
              ],
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(16.w),
            sliver: Consumer<ProductDetailsProvider>(
              builder: (context, provider, _) {
                final products = provider.products;
                
                return SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.58, // Adjusted to give more vertical space
                    crossAxisSpacing: 8.w,     // Reduced from 12.w or 16.w
                    mainAxisSpacing: 8.h,      // Reduced from 12.h or 16.h
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = products[index % products.length];
                      return _buildProductCard(product, isDarkMode);
                    },
                    childCount: products.length * 100, // Simulate infinite scrolling
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: 0,
        isDarkMode: isDarkMode,
        onItemSelected: (index) {
          if (index == 1) {
            Navigator.pushReplacementNamed(context, Routes.profilePage);
          }
        },
      ),
    );
  }

  Widget _buildDivider(bool isDarkMode) {
    return Divider(
      thickness: 1.h,
      color: isDarkMode ? AppConstants.dividerColor : AppConstants.borderLight,
    );
  }

  // Extract AppBar to a separate method for cleaner code
  PreferredSizeWidget _buildAppBar(bool isDarkMode) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: isDarkMode ? AppConstants.voltisDark : AppConstants.voltisLight,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(20.h),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 48.w),
                  Text(
                    'Wardrobe',
                    style: GoogleFonts.inter(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode ? AppConstants.voltisLight : AppConstants.voltisDark,
                    ),
                  ),
                  Builder(
                    builder: (context) => IconButton(
                      icon: Icon(
                        Icons.menu,
                        color: isDarkMode ? AppConstants.voltisLight : AppConstants.voltisDark,
                        size: 24.sp,
                      ),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                ],
              ),
            ),
            _buildDivider(isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebar(bool isDarkMode) {
    return Drawer(
      backgroundColor: isDarkMode ? AppConstants.voltisDark : AppConstants.voltisLight,
      child: Column(
        children: [
          DrawerHeader(
            child: Center(
              child: Text(
                'Categories',
                style: GoogleFonts.inter(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? AppConstants.voltisLight : AppConstants.voltisDark,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return ListTile(
                  selected: selectedCategory == category,
                  selectedColor: AppConstants.voltisAccent,
                  title: Text(
                    category,
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      color: selectedCategory == category
                          ? AppConstants.voltisAccent
                          : isDarkMode 
                              ? AppConstants.voltisLight 
                              : AppConstants.voltisDark,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      selectedCategory = category;
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          Divider(
            height: 1.h,
            thickness: 1,
            color: isDarkMode ? AppConstants.dividerColor : AppConstants.borderLight,
          ),
          // Theme Toggle
          ListTile(
            leading: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: isDarkMode ? AppConstants.voltisLight : AppConstants.voltisDark,
            ),
            title: Text(
              isDarkMode ? 'Light Mode' : 'Dark Mode',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                color: isDarkMode ? AppConstants.voltisLight : AppConstants.voltisDark,
              ),
            ),
            onTap: () {
              context.read<ThemeProvider>().toggleTheme();
            },
          ),
          // Logout Button
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: AppConstants.voltisAccent,
            ),
            title: Text(
              'Logout',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                color: AppConstants.voltisAccent,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              // Add logout logic here
              Navigator.pushNamedAndRemoveUntil(
                context,
                Routes.singIn,
                (route) => false,
              );
            },
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  Widget _userDetail(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              CircleAvatar(
                radius: 40.r,
                backgroundImage: const AssetImage('lib/core/Images/avatar.png'),
              ),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Maddison2525',
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode ? AppConstants.voltisLight : AppConstants.voltisDark,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Row(
                    children: [
                      ...List.generate(5, (index) => 
                        Icon(Icons.star, 
                          color: const Color.fromRGBO(255, 215, 0, 1), // Updated color
                          size: 16.sp
                        )
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        '(300)',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: AppConstants.voltisAccent,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    'London, United Kingdom',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Icon(
                Icons.person,
                color: isDarkMode ? AppConstants.voltisLight : AppConstants.voltisDark,
                size: 20.sp,
              ),
              SizedBox(width: 10.w),
             Icon(
                Icons.share,
                  color: isDarkMode ? AppConstants.voltisLight : AppConstants.voltisDark,
                size: 20.sp,
             ),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),
              Row(
                children: [
                  Icon(Icons.local_shipping, color: AppConstants.voltisAccent, size: 18.sp),
                  SizedBox(width: 5.w),
                  Text(
                    'Ships in 1 day',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: isDarkMode ? AppConstants.voltisLight : AppConstants.voltisDark,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5.h),
              Row(
                children: [
                  Icon(Icons.check_circle, color: AppConstants.voltisAccent, size: 18.sp),
                  SizedBox(width: 5.w),
                  Text(
                    'Email Verified',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: isDarkMode ? AppConstants.voltisLight : AppConstants.voltisDark,
                    ),
                  ),
                  SizedBox(width: 20.w),
                   Icon(Icons.check_circle, color: AppConstants.voltisAccent, size: 18.sp),
                  SizedBox(width: 5.w),
                  Text(
                    'Number Verified',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: isDarkMode ? AppConstants.voltisLight : AppConstants.voltisDark,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5.h),
              Row(
                children: [
                  Icon(Icons.access_time, color: AppConstants.voltisAccent, size: 18.sp),
                  SizedBox(width: 5.w),
                  Text(
                    'Last seen moments ago',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: isDarkMode ? AppConstants.voltisLight : AppConstants.voltisDark
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Text(
                'Welcome to my wardrobe, all items are shipped from a clean, smoke-free and reputable home. If you have any questions, please, reach out, thanks!',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 13.sp,
                  color: isDarkMode ? AppConstants.voltisLight : AppConstants.voltisDark,
                ),
                maxLines: 3, // Limit to 3 lines
                overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryScroll(bool isDarkMode) {
    final categories = [
      {'name': '2025', 'count': 'Listings'},
      {'name': '10', 'count': 'Followings'},
      {'name': '10000', 'count': 'Followers'},
      {'name': '3000', 'count': 'Retailers'},
      // Add duplicates to make the scroll seem continuous
      {'name': '2025', 'count': 'Listings'},
      {'name': '10', 'count': 'Followings'},
      {'name': '10000', 'count': 'Followers'},
      {'name': '3000', 'count': 'Retailers'},
    ];
    
    return Container(
      height: 65.h, // Increased height to accommodate both texts
      margin: EdgeInsets.only(top: 16.h),
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: categories.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final isSelected = index == 0; // For demonstration, first item is selected
          return Padding(
            padding: EdgeInsets.only(right: 24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  categories[index]['name']!,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? AppConstants.voltisAccent
                        : isDarkMode
                            ? AppConstants.voltisLight
                            : AppConstants.voltisDark,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  categories[index]['count']!,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: isSelected
                        ? AppConstants.voltisAccent
                        : isDarkMode
                            ? Colors.grey[400]
                            : Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDropdownSection(bool isDarkMode) {
    return Column(
      children: [
        _buildMainDropdownHeader(isDarkMode),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: _buildMainDropdownContent(isDarkMode),
          crossFadeState: _isMainDropdownOpen 
              ? CrossFadeState.showSecond 
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
        ),
      ],
    );
  }

  Widget _buildMainDropdownHeader(bool isDarkMode) {
    return InkWell(
      onTap: () {
        setState(() {
          _isMainDropdownOpen = !_isMainDropdownOpen;
          _dropdownHeaderText = _isMainDropdownOpen 
              ? 'Categories from this seller'
              : 'Categories';
        });
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _dropdownHeaderText,
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? AppConstants.voltisLight : AppConstants.voltisDark,
              ),
            ),
            AnimatedRotation(
              turns: _isMainDropdownOpen ? 0.25 : 0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                Icons.arrow_forward_ios,
                color: isDarkMode ? AppConstants.voltisLight : AppConstants.voltisDark,
                size: 18.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainDropdownContent(bool isDarkMode) {
    return Column(
      children: categoryData.entries.map((entry) {
        _subDropdownStates.putIfAbsent(entry.key, () => false);
        return Column(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  _subDropdownStates[entry.key] = !(_subDropdownStates[entry.key] ?? false);
                });
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      entry.key,
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: isDarkMode ? AppConstants.voltisLight : AppConstants.voltisDark,
                      ),
                    ),
                    AnimatedRotation(
                      turns: _subDropdownStates[entry.key] ?? false ? 0.25 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: isDarkMode ? AppConstants.voltisLight : AppConstants.voltisDark,
                        size: 16.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: _buildSubcategories(entry.value, isDarkMode),
              crossFadeState: _subDropdownStates[entry.key] ?? false
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 200),
            ),
            Divider(
              height: 1.h,
              thickness: 1,
              color: isDarkMode ? AppConstants.dividerColor : AppConstants.borderLight,
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildSubcategories(List<String> subcategories, bool isDarkMode) {
    return Padding(
      padding: EdgeInsets.only(left: 32.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: subcategories.map((subcategory) {
          return Column(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    if (_selectedItems.contains(subcategory)) {
                      _selectedItems.remove(subcategory);
                    } else {
                      _selectedItems.add(subcategory);
                    }
                  });
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Row(
                    children: [
                      Icon(
                        _selectedItems.contains(subcategory)
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        color: _selectedItems.contains(subcategory)
                            ? AppConstants.voltisAccent
                            : isDarkMode
                                ? AppConstants.voltisLight
                                : AppConstants.voltisDark,
                        size: 20.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        subcategory,
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: isDarkMode ? AppConstants.voltisLight : AppConstants.voltisDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (subcategories.last != subcategory)
                Divider(
                  height: 1.h,
                  thickness: 1,
                  indent: 28.w,
                  color: isDarkMode ? AppConstants.dividerColor.withOpacity(0.5) : AppConstants.borderLight,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTopBrandsSection(bool isDarkMode) {
    return Column(
      children: [
        // Header with search
        Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Top Brands',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? AppConstants.voltisLight : AppConstants.voltisDark,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: isDarkMode ? AppConstants.voltisLight : AppConstants.voltisDark,
                  size: 24.sp,
                ),
                onPressed: () {
                  // Implement search functionality
                },
              ),
            ],
          ),
        ),
        // Brands list
        SizedBox(
          height: 50.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: brands.length,
            itemBuilder: (context, index) {
              final brand = brands[index];
              final isSelected = selectedBrands.contains(brand);
              
              return Padding(
                padding: EdgeInsets.only(right: 12.w),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedBrands.remove(brand);
                      } else {
                        selectedBrands.add(brand);
                      }
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? AppConstants.filterColor
                          : Colors.transparent,
                      border: Border.all(
                        color: isSelected 
                            ? AppConstants.filterColor
                            : isDarkMode 
                                ? AppConstants.voltisLight 
                                : AppConstants.voltisDark,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Center(
                      child: Text(
                        brand,
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: isDarkMode ? AppConstants.voltisLight : AppConstants.voltisDark,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 16.h), // Add spacing
        // Filter and Sort row
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Row(
            children: [
              Icon(
                Icons.filter_list,
                color: AppConstants.voltisAccent,
                size: 20.sp,
              ),
              SizedBox(width: 4.w),
              Text(
                'Filter',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: isDarkMode ? AppConstants.voltisLight : AppConstants.voltisDark,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.sort,
                color: AppConstants.voltisAccent,
                size: 20.sp,
              ),
              SizedBox(width: 4.w),
              Text(
                'Sort',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: isDarkMode ? AppConstants.voltisLight : AppConstants.voltisDark,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(ProductDetails product, bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(UIConstants.cardBorderRadius),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Add this
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image section
          Expanded( // Wrap AspectRatio with Expanded
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(UIConstants.cardBorderRadius),
                  image: DecorationImage(
                    image: AssetImage(product.images.first),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: 4.w,              // Reduced from 8.w
                      bottom: 4.h,             // Reduced from 8.h
                      child: _buildLikesCounter(product.likes),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Product details section
          Padding(
            padding: EdgeInsets.all(UIConstants.smallPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Add this
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: AppTextStyles.subtitle.copyWith(
                    color: isDarkMode ? AppConstants.voltisLight : AppConstants.voltisDark,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded( // Wrap Column with Expanded
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min, // Add this
                        children: [
                          if (product.isOnSale)
                            Text(
                              '\$${product.originalPrice}',
                              style: AppTextStyles.small.copyWith(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey,
                              ),
                            ),
                          Text(
                            '\$${product.currentPrice}',
                            style: AppTextStyles.accent,
                          ),
                        ],
                      ),
                    ),
                    if (product.isOnSale) 
                      _buildDiscountBadge(product.discountPercentage),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLikesCounter(int likes) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 6.w,         // Reduced from 8.w
        vertical: 3.h,          // Reduced from 4.h
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12.r),  // Reduced from 16.r
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.favorite_border,
            color: Colors.white,
            size: 16.sp,
          ),
          addHorizontalSpace(4),
          Text(
            '$likes',
            style: AppTextStyles.small.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscountBadge(int percentage) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 6.w,
        vertical: 2.h,
      ),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        '-$percentage%',
        style: AppTextStyles.small.copyWith(
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}
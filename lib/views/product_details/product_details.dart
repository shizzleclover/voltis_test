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

class ProductDetailsView extends StatefulWidget {
  const ProductDetailsView({super.key});

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  String selectedCategory = 'All Items';
  bool _isDropdownOpen = false;

  final List<String> categories = [
    'All Items',
    'Shirts',
    'Pants',
    'Accessories'
  ];

  bool _isMainDropdownOpen = false;
  Map<String, bool> _subDropdownStates = {};
  String _dropdownHeaderText = 'Categories';
  Set<String> _selectedItems = {};
  
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
                    childAspectRatio: 0.7, // Adjusted for new layout
                    crossAxisSpacing: 16.w,
                    mainAxisSpacing: 16.h,
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
        preferredSize: Size.fromHeight(56.h),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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
            leading: Icon(
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
                        Icon(Icons.star, color: AppConstants.voltisAccent, size: 16.sp)
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
                color: AppConstants.voltisAccent,
                size: 20.sp,
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        Divider(color: isDarkMode ? Colors.grey[700] : Colors.grey[300], height: 2.h, thickness: 1.h),
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
                  Icon(
                    Icons.cancel,
                    color: isDarkMode ? Colors.grey[500] : Colors.grey[400],
                    size: 18.sp
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    'Number Verified',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: isDarkMode ? Colors.grey[500] : Colors.grey[400]
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
                  fontSize: 14.sp,
                  color: isDarkMode ? AppConstants.voltisLight : AppConstants.voltisDark
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryScroll(bool isDarkMode) {
    final categories = ['All', 'Shirts', 'Pants', 'Shoes', 'Accessories', 'Jackets'];
    
    return Container(
      height: 40.h,
      margin: EdgeInsets.only(top: 16.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Center(
              child: Text(
                categories[index],
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: isDarkMode ? AppConstants.voltisLight : AppConstants.voltisDark,
                ),
              ),
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
                      borderRadius: BorderRadius.circular(1),
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
    return Column(
      children: [
        // Image Container
        Container(
          height: 200.h,
          decoration: BoxDecoration(
            color: isDarkMode ? AppConstants.borderDark : AppConstants.borderLight,
            borderRadius: BorderRadius.circular(12.r),
            image: DecorationImage(
              image: AssetImage(product.images.first),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: 8.w,
                bottom: 8.h,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.favorite_border,
                        color: Colors.white,
                        size: 16.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '${product.likes}',
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // Text content
        Padding(
          padding: EdgeInsets.only(top: 8.h, left: 4.w, right: 4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? AppConstants.voltisLight : AppConstants.voltisDark,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4.h),
              Text(
                '\$${product.currentPrice}',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppConstants.voltisAccent,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
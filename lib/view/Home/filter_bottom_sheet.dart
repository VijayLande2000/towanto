import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:towanto/utils/resources/fonts.dart';
import '../../utils/common_widgets/Utils.dart';
import '../../utils/resources/colors.dart';
import '../../model/HomeModels/filters_list_model.dart';
import '../../viewModel/HomeViewModels/filter_list_view_model.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({Key? key}) : super(key: key);

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late Map<String, Set<String>> selectedFilters;
  RangeValues? selectedPriceRange;
  final Map<String, int> visibleItems = {};
  final int itemsPerPage = 10;

  @override
  void initState() {
    super.initState();
    final filterViewModel = Provider.of<FilterListViewModel>(context, listen: false);
    selectedFilters = Map.from(filterViewModel.selectedFilters);
    selectedPriceRange = filterViewModel.selectedPriceRange;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FilterListViewModel>(
      builder: (context, filterViewModel, child) {
        if (filterViewModel.loading) {
          return Center(child: Utils.loadingIndicator(context));
        }

        final filters = filterViewModel.filterList;
        if (filters == null) {
          return const Center(child: Text('No filters available'));
        }

        selectedPriceRange ??= RangeValues(
          filters.priceRange?.minPrice?.toDouble() ?? 0.0,
          filters.priceRange?.maxPrice?.toDouble() ?? 100.0,
        );

        final filterSections = _getFilterSections(filters);

        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.brightBlue.withOpacity(0.1),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Handle bar with background
                  Container(
                    padding: EdgeInsets.only(top: 12, bottom: 8),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    child: Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.lightBlue,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                  // Header
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      border: Border(
                        bottom: BorderSide(
                          color: AppColors.lightBlue,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Filters',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.brightBlue,
                            fontFamily: MyFonts.font_regular,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: AppColors.grey),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  // Filter content
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      itemCount: filterSections.length,
                      itemBuilder: (context, index) {
                        final section = filterSections[index];
                        return _buildFilterSection(
                          title: section.title,
                          items: section.items,
                          type: section.type,
                        );
                      },
                    ),
                  ),
                  // Bottom buttons
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.brightBlue.withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, -5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _clearAll,
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              side: BorderSide(color: AppColors.red),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Clear All',
                              style: TextStyle(
                                color: AppColors.red,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: MyFonts.font_regular,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _applyFilters(context),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: AppColors.brightBlue,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Apply',
                              style: TextStyle(
                                color: AppColors.whiteColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: MyFonts.font_regular,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFilterSection({
    required String title,
    required List<FilterItem> items,
    required FilterType type,
  }) {
    visibleItems[title] ??= itemsPerPage;
    final displayItems = items.take(visibleItems[title]!).toList();
    final hasMore = items.length > visibleItems[title]!;

    return Container(
      // margin: EdgeInsets.only(bottom:5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text(
              title.replaceAll('_', ' ').toUpperCase(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.brightBlue,
                letterSpacing: 0.5,
                fontFamily: MyFonts.font_regular,
              ),
            ),
          ),
          if (type == FilterType.checkbox) ...[
            ...displayItems.map((item) => _buildCheckboxItem(title, item)),
            if (hasMore)
              TextButton(
                onPressed: () {
                  setState(() {
                    visibleItems[title] = visibleItems[title]! + itemsPerPage;
                  });
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 8),
                ),
                child: Text(
                  'Show More ...',
                  style: TextStyle(
                    color: AppColors.lightBlue,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: MyFonts.font_regular,
                  ),
                ),
              ),
          ] else if (type == FilterType.range) ...[
            _buildPriceRangeSlider(),
          ],
          Divider(
            height: 16,
            thickness: 1,
            color: AppColors.lightBlue,
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxItem(String section, FilterItem item) {
    selectedFilters[section] ??= {};

    return Container(
      height: 45,
      margin: EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: selectedFilters[section]!.contains(item.value)
            ? AppColors.lightBlue.withOpacity(0.1)
            : AppColors.whiteColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: selectedFilters[section]!.contains(item.value)
              ? AppColors.lightBlue
              : Colors.transparent,
          width: 1,
        ),
      ),
      child: CheckboxListTile(
        title: Text(
          item.displayName,
          style: TextStyle(
            color: AppColors.black,
            fontSize: 14,
            fontFamily: MyFonts.font_regular,
            fontWeight: FontWeight.normal
          ),
        ),
        value: selectedFilters[section]!.contains(item.value),
        onChanged: (bool? value) {
          setState(() {
            if (value == true) {
              selectedFilters[section]!.add(item.value);
            } else {
              selectedFilters[section]!.remove(item.value);
            }
          });
        },
        contentPadding: EdgeInsets.symmetric(horizontal: 12),
        dense: true,
        controlAffinity: ListTileControlAffinity.leading,
        activeColor: AppColors.brightBlue,
        checkboxShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  Widget _buildPriceRangeSlider() {
    final filters = Provider.of<FilterListViewModel>(context, listen: false).filterList;
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          RangeSlider(
            values: selectedPriceRange!,
            min: filters!.priceRange!.minPrice.toDouble(),
            max: filters.priceRange!.maxPrice.toDouble(),
            divisions: 100,
            activeColor: AppColors.brightBlue,
            inactiveColor: AppColors.lightBlue,
            labels: RangeLabels(
              '₹ ${selectedPriceRange!.start.toStringAsFixed(2)}',
              '₹ ${selectedPriceRange!.end.toStringAsFixed(2)}',
            ),
            onChanged: (RangeValues values) {
              setState(() {
                selectedPriceRange = values;
              });
            },
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '₹ ${selectedPriceRange!.start.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 14,
                    fontFamily: MyFonts.font_regular,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '₹ ${selectedPriceRange!.end.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 14,
                    fontFamily: MyFonts.font_regular,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<FilterSection> _getFilterSections(FilterListApiModel filters) {
    final List<FilterSection> sections = [];

    if (filters.brands?.isNotEmpty == true) {
      sections.add(FilterSection(
        title: 'brands',
        items: filters.brands!.map((b) => FilterItem(b.name, b.name)).toList(),
        type: FilterType.checkbox,
      ));
    }

    if (filters.varieties?.isNotEmpty == true) {
      sections.add(FilterSection(
        title: 'varieties',
        items: filters.varieties!
            .map((v) => FilterItem(v.toString(), v.toString()))
            .toList(),
        type: FilterType.checkbox,
      ));
    }

    if (filters.packageSizes?.isNotEmpty == true) {
      sections.add(FilterSection(
        title: 'package_sizes',
        items: filters.packageSizes!
            .map((s) => FilterItem(s.toString(), s.toString()))
            .toList(),
        type: FilterType.checkbox,
      ));
    }

    if (filters.priceRange != null) {
      sections.add(FilterSection(
        title: 'price_range',
        items: [],
        type: FilterType.range,
      ));
    }

    return sections;
  }

  void _clearAll() {
    setState(() {
      selectedFilters.clear();
      final filters = Provider.of<FilterListViewModel>(context, listen: false).filterList;
      selectedPriceRange = RangeValues(
        filters!.priceRange?.minPrice?.toDouble() ?? 0.0,
        filters.priceRange?.maxPrice?.toDouble() ?? 100.0,
      );
      Provider.of<FilterListViewModel>(context, listen: false).clearSelections();
    });
  }

  void _applyFilters(BuildContext context) {
    final selectedFiltersMap = {
      ...selectedFilters,
      'priceRange': {
        'min': selectedPriceRange?.start,
        'max': selectedPriceRange?.end,
      },
    };
    Provider.of<FilterListViewModel>(context, listen: false)
        .updateSelectedFilters(selectedFilters, selectedPriceRange);
    Navigator.pop(context, selectedFiltersMap);
  }
}

class FilterSection {
  final String title;
  final List<FilterItem> items;
  final FilterType type;

  FilterSection({
    required this.title,
    required this.items,
    required this.type,
  });
}

class FilterItem {
  final String displayName;
  final String value;

  FilterItem(this.displayName, this.value);
}

enum FilterType {
  checkbox,
  range,
}
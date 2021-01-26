class CategoryData {
  CategoryData({
    this.titleTxt = '',
    this.isSelected = false,
  });

  String titleTxt;
  bool isSelected;

  static List<CategoryData> category = <CategoryData>[
    CategoryData(
      titleTxt: 'All',
      isSelected: true,
    ),
    CategoryData(
      titleTxt: 'カフェ',
      isSelected: true,
    ),
    CategoryData(
      titleTxt: 'レストラン',
      isSelected: true,
    ),
    CategoryData(
      titleTxt: 'バー',
      isSelected: true,
    ),
  ];
}

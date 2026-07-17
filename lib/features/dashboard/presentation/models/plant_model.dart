class PlantCategory {
  final String titleAr;
  final String titleEn;

  PlantCategory({required this.titleAr, required this.titleEn});
  static final List<PlantCategory> categories = [
    PlantCategory(titleAr: 'الشجيرات', titleEn: 'SHREUBS'),
    PlantCategory(titleAr: 'أشجار فرعية', titleEn: 'SUB TREE'),
    PlantCategory(titleAr: 'مغطيات التربة', titleEn: 'Green covers'),
    PlantCategory(titleAr: 'الأشجار', titleEn: 'TREES'),
    PlantCategory(titleAr: 'النجيل / الثيل', titleEn: 'GRASS'),
    PlantCategory(titleAr: 'الصبارات', titleEn: 'CACTUS'),
  ];
}

class PlantItem {
  final String id;
  final String nameAr;
  final String nameEn;

  PlantItem({required this.id, required this.nameAr, required this.nameEn});
  static final List<PlantItem> plants = [
    PlantItem(
      id: '1',
      nameAr: 'الجاردينيا - ياسمين كيب',
      nameEn: 'Gardenia jasminoides J.Ellis',
    ),
    PlantItem(
      id: '2',
      nameAr: 'التيكوماريا',
      nameEn: 'Tecomaria capensis (Thunb.) Spach',
    ),
    PlantItem(id: '3', nameAr: 'الوايتكس', nameEn: 'Vitex trifolia L.'),
    PlantItem(id: '4', nameAr: 'الحناء', nameEn: 'Lawsonia inermis'),
    PlantItem(
      id: '5',
      nameAr: 'الميرامية الفضية',
      nameEn: 'Leucophyllum frutescens',
    ),
    PlantItem(id: '6', nameAr: 'الأكاسيا جلوكا', nameEn: 'Cassia glauca'),
  ];
}

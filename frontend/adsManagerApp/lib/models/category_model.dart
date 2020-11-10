import 'package:flutter/material.dart';

class LargeCategoryItem{
  final String name;
  final IconData icon;
  final List<MediumCategoryItem> mediumItems;

  LargeCategoryItem(this.name, this.icon, this.mediumItems);
}

class MediumCategoryItem{
  final String name;
  final String mediumcode;
  final int mtid;

  MediumCategoryItem(this.name, this.mediumcode, this.mtid);
}

final List<LargeCategoryItem> largeCategoryItems = [
  LargeCategoryItem(
    '음식',
    Icons.fastfood,
    [
      MediumCategoryItem('패스트푸드', 'Q07', 67),
      MediumCategoryItem('한식', 'Q01', 68),
      MediumCategoryItem('일식/수산물', 'Q03', 69),
      MediumCategoryItem('커피점/카페', 'Q12', 70),
      MediumCategoryItem('분식', 'Q04', 71),
      MediumCategoryItem('중식', 'Q02', 72),
      MediumCategoryItem('양식', 'Q06', 73),
      MediumCategoryItem('유흥주점', 'Q09', 74),
    ]
  ),
  LargeCategoryItem(
    '학문/교육',
    Icons.menu_book,
    [
      MediumCategoryItem('학원-자격/국가고시', 'R03', 81),
      MediumCategoryItem('학원-음악미술무용', 'R05', 82),
      MediumCategoryItem('학원-어학', 'R04', 83),
      MediumCategoryItem('학원-보습교습입시', 'R01', 84),
      MediumCategoryItem('학원-예능취미체육', 'R07', 85),
      MediumCategoryItem('육아교육', 'R08', 86),
      MediumCategoryItem('학원기타', 'R09', 87),
      MediumCategoryItem('학문교육기타', 'R13', 88),
      MediumCategoryItem('도서관/독서실', 'R10', 89),
      MediumCategoryItem('학원-컴퓨터', 'R06', 90),
      MediumCategoryItem('학원-창업취업취미', 'R02', 91),
      MediumCategoryItem('학교', 'R11', 92),
      MediumCategoryItem('기타교육기관', 'R20', 93),
      MediumCategoryItem('연구소', 'R14', 94),
    ]
  ),
  LargeCategoryItem(
    '스포츠',
    Icons.sports_handball,
    [
      MediumCategoryItem('양식', 'Q06', 9),
      MediumCategoryItem('유흥주점', 'Q09', 9),
      MediumCategoryItem('패스트푸드', 'Q07', 9),
    ]
  ),
  // LargeCategoryItem('관광/여가/오락', 'PC, 오락, 연극, 영화, 요가, 전시, 경마 ...', Icons.nightlife,[]),
  // LargeCategoryItem('생활서비스', '이/미용, 주유소, 대행업, 세탁, 광고, 행사 ...', Icons.business_center,[]),
  // LargeCategoryItem('소매', '식료, 미용, 서적, 의류, 가구, 기타 판매 ...', Icons.shopping_cart,[]),
  // LargeCategoryItem('숙박', '호텔, 캠프, 펜션, 모텔, 민박 ...', Icons.night_shelter,[]),
  // LargeCategoryItem('부동산', '부동산중개, 분양, 부동산관련서비스 ...', Icons.house,[]),
];

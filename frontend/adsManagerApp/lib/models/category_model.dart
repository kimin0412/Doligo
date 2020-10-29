import 'package:flutter/material.dart';

class LargeCategoryItem{
  final String name;
  final String subject;
  final IconData icon;
  final List<MediumCategoryItem> mediumItems;

  LargeCategoryItem(this.name, this.subject, this.icon, this.mediumItems);
}

class MediumCategoryItem{
  final String name;
  final String mediumcode;

  MediumCategoryItem(this.name, this.mediumcode);
}

final List<LargeCategoryItem> largeCategoryItems = [
  LargeCategoryItem(
    '음식',
    '한식, 중식, 일식, 분식, 카페, 패스트푸드 ...',
    Icons.fastfood,
    [
      MediumCategoryItem('패스트푸드', 'Q07'),
      MediumCategoryItem('한식', 'Q01'),
      MediumCategoryItem('일식/수산물', 'Q03'),
      MediumCategoryItem('커피점/카페', 'Q12'),
      MediumCategoryItem('분식', 'Q04'),
      MediumCategoryItem('중식', 'Q02'),
      MediumCategoryItem('양식', 'Q06'),
      MediumCategoryItem('유흥주점', 'Q09'),
    ]
  ),
  LargeCategoryItem(
    '학문/교육',
    '학원, 학교, 연구소, 도서관 ...',
    Icons.menu_book,
    [

    ]
  ),
  LargeCategoryItem(
    '스포츠',
    '실내운동시설, 실외운동시설 ...',
    Icons.sports_handball,
    [

    ]
  ),
  LargeCategoryItem('관광/여가/오락', 'PC, 오락, 연극, 영화, 요가, 전시, 경마 ...', Icons.nightlife,[]),
  LargeCategoryItem('생활서비스', '이/미용, 주유소, 대행업, 세탁, 광고, 행사 ...', Icons.business_center,[]),
  LargeCategoryItem('소매', '식료, 미용, 서적, 의류, 가구, 기타 판매 ...', Icons.shopping_cart,[]),
  LargeCategoryItem('숙박', '호텔, 캠프, 펜션, 모텔, 민박 ...', Icons.night_shelter,[]),
  LargeCategoryItem('부동산', '부동산중개, 분양, 부동산관련서비스 ...', Icons.house,[]),
];

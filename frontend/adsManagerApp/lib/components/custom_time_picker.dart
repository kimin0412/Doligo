import 'dart:math';

import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';



//a date picker model
class CustomTimePicker extends CommonPickerModel {
  DateTime maxTime;
  DateTime minTime;

  List<int> _leapYearMonths = const <int>[1, 3, 5, 7, 8, 10, 12];

  int calcDateCount(int year, int month) {
    if (_leapYearMonths.contains(month)) {
      return 31;
    } else if (month == 2) {
      if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) {
        return 29;
      }
      return 28;
    }
    return 30;
  }

  String digits(int value, int length) {
    return '$value'.padLeft(length, "0");
  }

  bool isAtSameDay(DateTime day1, DateTime day2) {
    return day1 != null &&
        day2 != null &&
        day1.difference(day2).inDays == 0 &&
        day1.day == day2.day;
  }

  CustomTimePicker({DateTime currentTime, DateTime maxTime, DateTime minTime, LocaleType locale})
      : super(locale: locale) {
    this.maxTime = maxTime ?? DateTime(2049, 12, 31);
    this.minTime = minTime ?? DateTime(1970, 1, 1);

    currentTime = currentTime ?? DateTime.now();
    if (currentTime != null) {
      if (currentTime.compareTo(this.maxTime) > 0) {
        currentTime = this.maxTime;
      } else if (currentTime.compareTo(this.minTime) < 0) {
        currentTime = this.minTime;
      }
    }
    this.currentTime = currentTime;

    _fillLeftLists();
    _fillMiddleLists();
    _fillRightLists();
    int minMonth = _minMonthOfCurrentYear();
    int minDay = _minDayOfCurrentMonth();

    setRightIndex(this.currentTime.hour < 12 ? 0 : 1);
    setMiddleIndex(this.currentTime.day - minDay);
    setLeftIndex(this.currentTime.month - minMonth);
  }

  void _fillLeftLists() {
    int minMonth = _minMonthOfCurrentYear();
    int maxMonth = _maxMonthOfCurrentYear();

    this.leftList = List.generate(maxMonth - minMonth + 1, (int index) {
      return '${_localeMonth(minMonth + index)}';
    });
  }

  int _maxMonthOfCurrentYear() {
    return currentTime.year == maxTime.year ? maxTime.month : 12;
  }

  int _minMonthOfCurrentYear() {
    return currentTime.year == minTime.year ? minTime.month : 1;
  }

  int _maxDayOfCurrentMonth() {
    int dayCount = calcDateCount(currentTime.year, currentTime.month);
    return currentTime.year == maxTime.year && currentTime.month == maxTime.month
        ? maxTime.day
        : dayCount;
  }

  int _minDayOfCurrentMonth() {
    return currentTime.year == minTime.year && currentTime.month == minTime.month ? minTime.day : 1;
  }

  void _fillMiddleLists() {
    int maxDay = _maxDayOfCurrentMonth();
    int minDay = _minDayOfCurrentMonth();

    this.middleList = List.generate(maxDay - minDay + 1, (int index) {
      return '${minDay + index}${_localeDay()}';
    });
  }

  void _fillRightLists() {
    this.rightList = List.generate(24, (int index) {
      return '$index시';
    });
  }

  @override
  void setLeftIndex(int index) {
    super.setLeftIndex(index);

    //adjust right
    int minMonth = _minMonthOfCurrentYear();
    int destMonth = minMonth + index;
    DateTime newTime;
    //change date time
    int dayCount = calcDateCount(currentTime.year, destMonth);
    newTime = currentTime.isUtc
        ? DateTime.utc(
      currentTime.year,
      destMonth,
      currentTime.day <= dayCount ? currentTime.day : dayCount,
    )
        : DateTime(
      currentTime.year,
      destMonth,
      currentTime.day <= dayCount ? currentTime.day : dayCount,
    );
    //min/max check
    if (newTime.isAfter(maxTime)) {
      currentTime = maxTime;
    } else if (newTime.isBefore(minTime)) {
      currentTime = minTime;
    } else {
      currentTime = newTime;
    }

    _fillMiddleLists();
    int minDay = _minDayOfCurrentMonth();
    setMiddleIndex(currentTime.day - minDay);
  }

  @override
  void setMiddleIndex(int index) {
    super.setMiddleIndex(index);

    DateTime time = currentTime.add(Duration(days: index));
    if (isAtSameDay(minTime, time)) {
      var index = min(24 - minTime.hour - 1, currentRightIndex());
      this.setRightIndex(index);
    } else if (isAtSameDay(maxTime, time)) {
      var index = min(maxTime.hour, currentRightIndex());
      this.setRightIndex(index);
    }
    //
    // // int minDay = _minDayOfCurrentMonth();
    // //adjust right
    // int minMonth = _minMonthOfCurrentYear();
    // int destMonth = minMonth + index;
    // DateTime newTime;
    // //change date time
    // int dayCount = calcDateCount(currentTime.year, destMonth);
    // newTime = currentTime.isUtc
    //     ? DateTime.utc(
    //   currentTime.year,
    //   destMonth,
    //   currentTime.day <= dayCount ? currentTime.day : dayCount,
    // )
    //     : DateTime(
    //   currentTime.year,
    //   destMonth,
    //   currentTime.day <= dayCount ? currentTime.day : dayCount,
    // );
    // //min/max check
    // if (newTime.isAfter(maxTime)) {
    //   currentTime = maxTime;
    // } else if (newTime.isBefore(minTime)) {
    //   currentTime = minTime;
    // } else {
    //   currentTime = newTime;
    // }
    //
    // _fillRightLists();
    // int minDay = _minDayOfCurrentMonth();
    // setRightIndex(currentTime.day - minDay);
  }

  @override
  void setRightIndex(int index) {
    super.setRightIndex(index);
  }

  @override
  String leftStringAtIndex(int index) {
    if (index >= 0 && index < leftList.length) {
      return leftList[index];
    } else {
      return null;
    }
  }

  @override
  String middleStringAtIndex(int index) {
    if (index >= 0 && index < middleList.length) {
      return middleList[index];
    } else {
      return null;
    }
  }

  @override
  String rightStringAtIndex(int index) {
    if (index >= 0 && index < 24) {
      return rightList[index];
    } else {
      return null;
    }
  }

  String _localeMonth(int month) {
    if (locale == LocaleType.zh || locale == LocaleType.jp) {
      return '$month月';
    } else if (locale == LocaleType.ko) {
      return '$month월';
    } else {
      List monthStrings = i18nObjInLocale(locale)['monthLong'];
      return monthStrings[month - 1];
    }
  }

  String _localeDay() {
    if (locale == LocaleType.zh || locale == LocaleType.jp) {
      return '日';
    } else if (locale == LocaleType.ko) {
      return '일';
    } else {
      return '';
    }
  }

  // @override
  // DateTime finalTime() {
  //   return currentTime;
  // }

  @override
  DateTime finalTime() {
    DateTime time = currentTime.add(Duration(days: currentMiddleIndex(), ));
    var hour = currentRightIndex();

    // print(hour);
    // if (isAtSameDay(minTime, time)) {
    //   hour += minTime.hour;
    // }
    // print(hour);

    return currentTime.isUtc
        ? DateTime.utc(time.year, time.month, time.day, hour)
        : DateTime(time.year, time.month, time.day, hour);
  }
}

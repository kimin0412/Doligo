import 'package:dolligo_ads_manager/models/leaflet_model.dart';
import 'package:dolligo_ads_manager/models/statatics.dart';

class Dashboard {
  List<Tg> tg;
  Cg cg;
  Statistic recent;
  Ca ca;

  Dashboard({this.tg, this.cg, this.recent, this.ca});

  Dashboard.fromJson(Map<String, dynamic> json) {
    if (json['tg'] != null) {
      tg = new List<Tg>();
      json['tg'].forEach((v) {
        tg.add(new Tg.fromJson(v));
      });
    }
    cg = json['cg'] != null ? new Cg.fromJson(json['cg']) : null;
    recent =
    json['recent'] != null ? new Statistic.fromJson(json['recent']) : null;
    ca = json['ca'] != null ? new Ca.fromJson(json['ca']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.tg != null) {
      data['tg'] = this.tg.map((v) => v.toJson()).toList();
    }
    if (this.cg != null) {
      data['cg'] = this.cg.toJson();
    }
    if (this.recent != null) {
      data['recent'] = this.recent.toJson();
    }
    if (this.ca != null) {
      data['ca'] = this.ca.toJson();
    }
    return data;
  }
}

class Tg {
  int deleteCnt;
  int pointCnt;
  int visitCnt;
  int blockCnt;

  Tg({this.deleteCnt, this.pointCnt, this.visitCnt, this.blockCnt});

  Tg.fromJson(Map<String, dynamic> json) {
    deleteCnt = json['deleteCnt'];
    pointCnt = json['pointCnt'];
    visitCnt = json['visitCnt'];
    blockCnt = json['blockCnt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deleteCnt'] = this.deleteCnt;
    data['pointCnt'] = this.pointCnt;
    data['visitCnt'] = this.visitCnt;
    data['blockCnt'] = this.blockCnt;
    return data;
  }
}

class Cg {
  int a;
  int w;
  int m;

  Cg({this.a, this.w, this.m});

  Cg.fromJson(Map<String, dynamic> json) {
    a = json['a'];
    w = json['w'];
    m = json['m'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['a'] = this.a;
    data['w'] = this.w;
    data['m'] = this.m;
    return data;
  }
}
//
// class Recent {
//   int id;
//   int pid;
//   int distributed;
//   int visit;
//   int interest;
//   int disregard;
//   int block;
//   Leaflet paper;
//
//   Recent(
//       {this.id,
//         this.pid,
//         this.distributed,
//         this.visit,
//         this.interest,
//         this.disregard,
//         this.block,
//         this.paper});
//
//   Recent.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     pid = json['pid'];
//     distributed = json['distributed'];
//     visit = json['visit'];
//     interest = json['interest'];
//     disregard = json['disregard'];
//     block = json['block'];
//     paper = json['paper'] != null ? new Leaflet.fromJson(json['paper']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['pid'] = this.pid;
//     data['distributed'] = this.distributed;
//     data['visit'] = this.visit;
//     data['interest'] = this.interest;
//     data['disregard'] = this.disregard;
//     data['block'] = this.block;
//     if (this.paper != null) {
//       data['paper'] = this.paper.toJson();
//     }
//     return data;
//   }
// }

class Ca {
  int teen;
  int second;
  int third;
  int forth;
  int above;

  Ca({this.teen, this.second, this.third, this.forth, this.above});

  Ca.fromJson(Map<String, dynamic> json) {
    teen = json['teen'];
    second = json['second'];
    third = json['third'];
    forth = json['forth'];
    above = json['above'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['teen'] = this.teen;
    data['second'] = this.second;
    data['third'] = this.third;
    data['forth'] = this.forth;
    data['above'] = this.above;
    return data;
  }
}
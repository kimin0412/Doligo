import 'package:dolligo_ads_manager/models/advertiser_model.dart';

class Leaflet{
  int p_id;					//pk
  int p_aid;				//fk  광고주아이디(advertiserId)
  int p_mtid;				//fk  상권종류 아이디(marketTypeId)
  int distributed;
  int visit;
  int interest;
  int disregrad;
  int block;
  String p_image;			//이미지 url
  String p_video;			//비디오 url
  int p_point;				//포인트
  bool p_check;			//전단지 승인 여부
  String p_coupon;			//쿠폰 내용
  String condition1;			//쿠폰 조건1
  String condition2;			//쿠폰 조건2
  DateTime starttime;			//배포 시작시간
  DateTime endtime;				//배포 종료 시간
  String lat;					//배포할 위치 위도
  String lon;					//배포할 위치 경도
  int sheets;					//배포할 종이 수
  int remainsheets;			//배포 후 남은 종이 수
  int cost;					//결제 금액
  // Advertiser advertiser;

  Leaflet(
      {
        this.p_id,
        this.p_aid,
        this.p_mtid,
        this.distributed,
        this.visit,
        this.interest,
        this.disregrad,
        this.block,
        this.p_image,
        this.p_video,
        this.p_point,
        this.p_check,
        this.p_coupon,
        this.condition1,
        this.condition2,
        this.starttime,
        this.endtime,
        this.lat,
        this.lon,
        this.sheets,
        this.remainsheets,
        this.cost,
        // this.advertiser
      });

  Leaflet.fromJson(Map<String, dynamic> json) {
    p_id = json['p_id'];
    p_aid = json['p_aid'];
    p_mtid = json['p_mtid'];
    distributed = json['distributed'];
    visit = json['visit'];
    interest = json['interest'];
    disregrad = json['disregrad'];
    block = json['block'];
    p_image = json['p_image'];
    p_video = json['p_video'];
    p_point = json['p_point'];
    p_check = json['p_check'];
    p_coupon = json['p_coupon'];
    condition1 = json['condition1'];
    condition2 = json['condition2'];
    starttime = DateTime.parse(json['starttime'] ?? DateTime.now().toString()) ?? DateTime.now().toString();
    endtime = DateTime.parse(json['endtime'] ?? DateTime.now().toString()) ?? DateTime.now();
    lat = json['lat'];
    lon = json['lon'];
    sheets = json['sheets'];
    remainsheets = json['remainsheets'];
    cost = json['cost'];
    // advertiser = json['advertiser'] != null
    //     ? new Advertiser.fromJson(json['advertiser'])
    //     : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['p_id'] = this.p_id;
    data['p_aid'] = this.p_aid;
    data['p_mtid'] = this.p_mtid;
    data['distributed'] = this.distributed;
    data['visit'] = this.visit;
    data['interest'] = this.interest;
    data['disregrad'] = this.disregrad;
    data['block'] = this.block;
    data['p_image'] = this.p_image;
    data['p_video'] = this.p_video;
    data['p_point'] = this.p_point;
    data['p_check'] = this.p_check;
    data['p_coupon'] = this.p_coupon;
    data['condition1'] = this.condition1;
    data['condition2'] = this.condition2;
    data['starttime'] = this.starttime;
    data['endtime'] = this.endtime;
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    data['sheets'] = this.sheets;
    data['remainsheets'] = this.remainsheets;
    data['cost'] = this.cost;
    // if (this.advertiser != null) {
    //   data['advertiser'] = this.advertiser.toJson();
    // }

    return data;
  }
}
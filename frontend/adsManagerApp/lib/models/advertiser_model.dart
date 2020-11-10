class Advertiser{
  int id = 0;						//pk
  int mtid = 0;					//fk : 상권종류 아이디(MarketTypeId)
  String email = 'email';				//이메일
  String password = 'password';			//비밀번호
  String marketname = 'marketname';			//가게이름
  String marketbranch = 'marketbranch';	//가게지점
  String marketnumber = 'marketnumber';		//가게번호
  String marketaddress = 'marketaddress';		//가게주소
  String marketurl = 'marketurl';			//가게 url
  String lat = 'lat';					//위도
  String lon = 'lon';					//경도
  int point = 0;					//포인트
  String mediumcode = 'mediumcode';

  Advertiser();

  Advertiser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mtid = json['mtid'];
    email = json['email'];
    password = json['password'];
    marketname = json['marketname'];
    marketbranch = json['marketbranch'];
    marketnumber = json['marketnumber'];
    marketaddress = json['marketaddress'];
    marketurl = json['marketurl'];
    lat = json['lat'];
    lon = json['lon'];
    point = json['point'];
    mediumcode = json['mediumcode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['mtid'] = this.mtid;
    data['email'] = this.email;
    data['password'] = this.password;
    data['marketname'] = this.marketname;
    data['marketbranch'] = this.marketbranch;
    data['marketnumber'] = this.marketnumber;
    data['marketaddress'] = this.marketaddress;
    data['marketurl'] = this.marketurl;
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    data['point'] = this.point;
    data['mediumcode'] = this.mediumcode;
    return data;
  }
}
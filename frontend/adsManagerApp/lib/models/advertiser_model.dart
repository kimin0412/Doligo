
class Advertiser{
  int id;						//pk
  int mtid;					//fk : 상권종류 아이디(MarketTypeId)
  String email;				//이메일
  String password;			//비밀번호
  String marketname;			//가게이름
  String marketbranch;		//가게지점
  String marketnumber;		//가게번호
  String marketaddress;		//가게주소
  String marketurl;			//가게 url
  String lat;					//위도
  String lon;					//경도
  int point;					//포인트
}
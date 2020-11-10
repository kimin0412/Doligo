import 'package:dolligo_ads_manager/models/leaflet_model.dart';

class Statistic {
  int id;
  int pid;
  int distributed;
  int visit;
  int interest;
  int disregard;
  int block;
  Leaflet paper;

  Statistic(
      {this.id,
        this.pid,
        this.distributed,
        this.visit,
        this.interest,
        this.disregard,
        this.block,
        this.paper});

  Statistic.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pid = json['pid'];
    distributed = json['distributed'];
    visit = json['visit'];
    interest = json['interest'];
    disregard = json['disregard'];
    block = json['block'];
    paper = json['paper'] != null ? new Leaflet.fromJson(json['paper']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['pid'] = this.pid;
    data['distributed'] = this.distributed;
    data['visit'] = this.visit;
    data['interest'] = this.interest;
    data['disregard'] = this.disregard;
    data['block'] = this.block;
    if (this.paper != null) {
      data['paper'] = this.paper.toJson();
    }
    return data;
  }
}
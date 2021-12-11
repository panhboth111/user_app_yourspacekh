class ParkingModel {
  String? id, interval, preferredDate,spaceId;
  ParkingModel({this.id,this.interval,this.preferredDate,this.spaceId});

  factory ParkingModel.fromJson(Map<String,dynamic> json){
    return ParkingModel(id: json['id'], interval: json['interval'], preferredDate: json['prefferedDate'], spaceId: json['spaceId']);
  }

}
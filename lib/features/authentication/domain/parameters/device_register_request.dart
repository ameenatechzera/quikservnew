import 'package:equatable/equatable.dart';

class DeviceRegisterRequest extends Equatable{
  final String deviceId;

  const DeviceRegisterRequest({ required this.deviceId });



  @override
  List<Object?> get props => [  deviceId ];


  Map<String, dynamic> toJson() => {
    "deviceId": deviceId

  };
}
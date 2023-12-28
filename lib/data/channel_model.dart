class ChannelDataModel {
  int? id;
  String? text;
  String? subText;

  ChannelDataModel({
    this.id,
    this.text,
    this.subText,
  });

  static Future<ChannelDataModel> createTheDataModel() async {
    ChannelDataModel channelDataModel = ChannelDataModel(
      id: 1,
      text: "Channel",
      subText: "SubChannel",
    );

    return channelDataModel;
  }
}

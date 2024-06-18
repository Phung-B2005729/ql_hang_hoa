class HinhAnhModel {
  String? tenAnh;
  String? linkAnh;

  HinhAnhModel({
    this.tenAnh,
    this.linkAnh,
  });

  HinhAnhModel copyWith({
    String? tenAnh,
    String? linkAnh,
  }) {
    return HinhAnhModel(
      tenAnh: tenAnh ?? this.tenAnh,
      linkAnh: linkAnh ?? this.linkAnh,
    );
  }

  HinhAnhModel.fromJson(Map<String, dynamic> json) {
    linkAnh = json['link_anh'];
    tenAnh = json['ten_anh'];
  }

  Map<String, dynamic> toJson() {
    // ignore: prefer_collection_literals
    final Map<String, dynamic> data = Map<String, dynamic>();

    data['link_anh'] = linkAnh;
    data['ten_anh'] = tenAnh;

    return data;
  }
}

class AuthToken {
  String? _accessToken;
  String? _refreshToken;

  AuthToken({String? accessToken, String? refreshToken}) {
    if (accessToken != null) {
      _accessToken = accessToken;
    }
    if (refreshToken != null) {
      _refreshToken = refreshToken;
    }
  }
  //
  AuthToken copyWith({String? accessToken, String? refreshToken}) {
    return AuthToken(
        accessToken: accessToken ?? this.accessToken,
        refreshToken: refreshToken ?? this.refreshToken);
  }

  // ignore: unnecessary_getters_setters
  String? get accessToken => _accessToken;
  set accessToken(String? accessToken) => _accessToken = accessToken;

  //
  // ignore: unnecessary_getters_setters
  String? get refreshToken => _refreshToken;
  set refreshToken(String? refreshToken) => _refreshToken = refreshToken;

  AuthToken.fromJson(Map<String, dynamic> json) {
    _accessToken = json['access_token'];
    _refreshToken = json['refresh_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access_token'] = _accessToken;
    data['refresh_token'] = _refreshToken;
    return data;
  }
}

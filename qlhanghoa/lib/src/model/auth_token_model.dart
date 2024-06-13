class AuthToken {
  String? _accessToken;
  String? _refreshToken;

  AuthToken({String? accessToken, String? refreshToken}) {
    if (accessToken != null) {
      this._accessToken = accessToken;
    }
    if (refreshToken != null) {
      this._refreshToken = refreshToken;
    }
  }
  //
  AuthToken copyWith({String? accessToken, String? refreshToken}) {
    return AuthToken(
        accessToken: accessToken ?? this.accessToken,
        refreshToken: refreshToken ?? this.refreshToken);
  }

  String? get accessToken => _accessToken;
  set accessToken(String? accessToken) => _accessToken = accessToken;

  //
  String? get refreshToken => _refreshToken;
  set refreshToken(String? refreshToken) => _refreshToken = refreshToken;

  AuthToken.fromJson(Map<String, dynamic> json) {
    _accessToken = json['access_token'];
    _refreshToken = json['refresh_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access_token'] = this._accessToken;
    data['refresh_token'] = this._refreshToken;
    return data;
  }
}

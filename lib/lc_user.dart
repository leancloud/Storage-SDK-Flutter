part of leancloud_storage;

const String CurrentUserKey = 'current_user';

/// LeanCloud Status followers and followees.
class LCFollowersAndFollowees {
  List<LCObject>? followers;

  List<LCObject>? followees;

  int? followersCount;

  int? followeesCount;
}

/// LeanCloud User.
class LCUser extends LCObject {
  static const String ClassName = '_User';

  String? get username => this['username'];

  set username(String? value) => this['username'] = value!;

  String? get password => this['password'];

  set password(String? value) => this['password'] = value!;

  String? get email => this['email'];

  set email(String? value) => this["email"] = value!;

  String? get mobile => this['mobilePhoneNumber'];

  set mobile(String? value) => this['mobilePhoneNumber'] = value!;

  String? get sessionToken => this['sessionToken'];

  set sessionToken(String? value) => this['sessionToken'] = value!;

  bool? get emailVerified => this['emailVerified'];

  bool? get mobileVerified => this['mobilePhoneVerified'];

  Map? get authData => this['authData'];

  set authData(Map? value) => this['authData'] = value!;

  static LCUser? _currentUser;

  LCUser() : super(LCUser.ClassName);

  static LCUser _fromObjectData(_LCObjectData objectData) {
    LCUser user = new LCUser();
    user._merge(objectData);
    return user;
  }

  /// Signs up a new user.
  ///
  /// This will create a new user on the server,
  /// and also persist the session.
  Future<LCUser> signUp() async {
    if (isNullOrEmpty(username)) {
      throw ArgumentError.notNull('username');
    }
    if (isNullOrEmpty(password)) {
      throw ArgumentError.notNull('password');
    }
    if (objectId != null) {
      throw ArgumentError('Cannot sign up a user that already exists.');
    }
    await save();
    return this;
  }

  /// Requests a login sms code to be sent to the [mobile] number of an existing user.
  static Future requestLoginSMSCode(String mobile,
      {String? validateToken}) async {
    if (isNullOrEmpty(mobile)) {
      throw ArgumentError.notNull('mobile');
    }
    Map<String, dynamic> data = {'mobilePhoneNumber': mobile};
    if (validateToken != null) {
      data['validate_token'] = validateToken;
    }
    await LeanCloud._httpClient.post('requestLoginSmsCode', data: data);
  }

  /// Signs up or signs in a [LCUser] with their [mobile] number and verification [code].
  static Future<LCUser> signUpOrLoginByMobilePhone(
      String mobile, String code) async {
    if (isNullOrEmpty(mobile)) {
      throw ArgumentError.notNull('mobile');
    }
    if (isNullOrEmpty(code)) {
      throw ArgumentError.notNull('code');
    }
    Map<String, dynamic> response = await LeanCloud._httpClient.post(
        'usersByMobilePhone',
        data: {'mobilePhoneNumber': mobile, 'smsCode': code});
    _LCObjectData objectData = _LCObjectData.decode(response);
    _currentUser = LCUser._fromObjectData(objectData);
    await _saveToLocal();
    return _currentUser!;
  }

  /// Signs in a user with their [username] and [password].
  static Future<LCUser> login(String username, String password) {
    if (isNullOrEmpty(username)) {
      throw ArgumentError.notNull('username');
    }
    if (isNullOrEmpty(password)) {
      throw ArgumentError.notNull('password');
    }
    Map<String, dynamic> data = {'username': username, 'password': password};
    return _login(data);
  }

  /// Signs in a user with their [email] and [password].
  static Future<LCUser> loginByEmail(String email, String password) {
    if (isNullOrEmpty(email)) {
      throw ArgumentError.notNull('email');
    }
    if (isNullOrEmpty(password)) {
      throw ArgumentError.notNull('password');
    }
    Map<String, dynamic> data = {'email': email, 'password': password};
    return _login(data);
  }

  /// Signs in a user with their [mobile] number and [password].
  static Future<LCUser> loginByMobilePhoneNumber(
      String mobile, String password) {
    if (isNullOrEmpty(mobile)) {
      throw ArgumentError.notNull('mobile');
    }
    if (isNullOrEmpty(password)) {
      throw ArgumentError.notNull('password');
    }
    Map<String, dynamic> data = {
      'mobilePhoneNumber': mobile,
      'password': password
    };
    return _login(data);
  }

  /// Signs in a [LCUser] with their [mobile] number and verification [code].
  static Future<LCUser> loginBySMSCode(String mobile, String code) {
    if (isNullOrEmpty(mobile)) {
      throw ArgumentError.notNull('mobile');
    }
    if (isNullOrEmpty(code)) {
      throw ArgumentError.notNull('code');
    }
    Map<String, dynamic> data = {'mobilePhoneNumber': mobile, 'smsCode': code};
    return _login(data);
  }

  /// Signs up or signs in a user with third party [authData].
  static Future<LCUser> loginWithAuthData(
      Map<String, dynamic> authData, String platform,
      {LCUserAuthDataLoginOption? option}) {
    if (isNullOrEmpty(platform)) {
      throw ArgumentError.notNull('platform');
    }
    if (option == null) {
      option = new LCUserAuthDataLoginOption();
    }
    return _loginWithAuthData(platform, authData, option.failOnNotExist);
  }

  /// Signs up or signs in a user with third party [authData] and [unionId].
  static Future<LCUser> loginWithAuthDataAndUnionId(
      Map<String, dynamic> authData, String platform, String unionId,
      {LCUserAuthDataLoginOption? option}) {
    if (isNullOrEmpty(platform)) {
      throw ArgumentError.notNull('platform');
    }
    if (isNullOrEmpty(unionId)) {
      throw ArgumentError.notNull('unionId');
    }
    if (option == null) {
      option = new LCUserAuthDataLoginOption();
    }
    _mergeAuthData(authData, unionId, option);
    return _loginWithAuthData(platform, authData, option.failOnNotExist);
  }

  static Future<LCUser> _loginWithAuthData(
      String authType, Map<String, dynamic> data, bool failOnNotExist) async {
    Map<String, dynamic> authData = {authType: data};
    String path = failOnNotExist ? 'users?failOnNotExist=true' : 'users';
    Map<String, dynamic> response =
        await LeanCloud._httpClient.post(path, data: {'authData': authData});
    _LCObjectData objectData = _LCObjectData.decode(response);
    _currentUser = LCUser._fromObjectData(objectData);
    await _saveToLocal();
    return _currentUser!;
  }

  static void _mergeAuthData(Map<String, dynamic> authData, String unionId,
      LCUserAuthDataLoginOption option) {
    authData['platform'] = option.unionIdPlatform;
    authData['main_account'] = option.asMainAccount;
    authData['unionid'] = unionId;
  }

  /// Associates this [LCUser] with a third party [authData].
  Future associateAuthData(Map<String, dynamic> authData, String platform) {
    return _linkWithAuthData(platform, authData);
  }

  /// Associates this user with a third party [authData] and [unionId].
  Future associateAuthDataAndUnionId(
      Map<String, dynamic> authData, String platform, String unionId,
      {LCUserAuthDataLoginOption? option}) {
    if (isNullOrEmpty(platform)) {
      throw ArgumentError.notNull('platform');
    }
    if (isNullOrEmpty(unionId)) {
      throw ArgumentError.notNull('unionId');
    }
    if (option == null) {
      option = new LCUserAuthDataLoginOption();
    }
    _mergeAuthData(authData, unionId, option);
    return _linkWithAuthData(platform, authData);
  }

  /// Unlinks a user from a third party [platform].
  Future disassociateWithAuthData(String platform) {
    if (isNullOrEmpty(platform)) {
      throw ArgumentError.notNull('platform');
    }
    return _unlinkWithAuthData(platform);
  }

  Future _linkWithAuthData(String authType, Map<String, dynamic> data) async {
    Map oriAuthData = Map.from(this.authData ?? {});
    this.authData = {authType: data};
    try {
      await super.save();
      oriAuthData.addAll(this.authData!);
      _updateAuthData(oriAuthData);
      await _saveToLocal();
    } on Exception catch (e) {
      this.authData = oriAuthData;
      throw e;
    }
  }

  Future _unlinkWithAuthData(String authType) async {
    Map oriAuthData = Map.from(this.authData ?? {});
    this.authData = {authType: null};
    try {
      await super.save();
      oriAuthData.remove(authType);
      _updateAuthData(oriAuthData);
      await _saveToLocal();
    } on Exception catch (e) {
      this.authData = oriAuthData;
      throw e;
    }
  }

  void _updateAuthData(Map oriAuthData) {
    _LCObjectData objData = new _LCObjectData();
    objData.customPropertyMap['authData'] = oriAuthData;
    _merge(objData);
  }

  /// Creates an anonymous user.
  static Future<LCUser> loginAnonymously() {
    Map<String, dynamic> data = {'id': new _LCUuid().generateV4()};
    return loginWithAuthData(data, 'anonymous');
  }

  /// Requests a verification email to be sent to a user's [email] address.
  static Future requestEmailVerify(String email) async {
    if (isNullOrEmpty(email)) {
      throw ArgumentError.notNull(email);
    }
    Map<String, dynamic> data = {'email': email};
    await LeanCloud._httpClient.post('requestEmailVerify', data: data);
  }

  /// Requests a verification SMS to be sent to a user's [mobile] number.
  static Future requestMobilePhoneVerify(String mobile) async {
    if (isNullOrEmpty(mobile)) {
      throw ArgumentError.notNull('mobile');
    }
    Map<String, dynamic> data = {'mobilePhoneNumber': mobile};
    await LeanCloud._httpClient.post('requestMobilePhoneVerify', data: data);
  }

  /// Requests to verify a user's [mobile] number with sms [code] they received.
  static Future verifyMobilePhone(String mobile, String code) async {
    if (isNullOrEmpty(mobile)) {
      throw ArgumentError.notNull('mobile');
    }
    if (isNullOrEmpty(code)) {
      throw ArgumentError.notNull('code');
    }
    String path = 'verifyMobilePhone/$code';
    Map<String, dynamic> data = {'mobilePhoneNumber': mobile};
    await LeanCloud._httpClient.post(path, data: data);
  }

  /// Signs in a user with a [sessionToken].
  static Future<LCUser> becomeWithSessionToken(String sessionToken) async {
    if (isNullOrEmpty(sessionToken)) {
      throw ArgumentError.notNull('sessionToken');
    }
    Map<String, String> headers = {'X-LC-Session': sessionToken};
    Map<String, dynamic> response =
        await LeanCloud._httpClient.get('users/me', headers: headers);
    _LCObjectData objectData = _LCObjectData.decode(response);
    _currentUser = LCUser._fromObjectData(objectData);
    await _saveToLocal();
    return _currentUser!;
  }

  /// Requests a password reset email to be sent to a user's [email] address.
  static Future requestPasswordReset(String email) async {
    if (isNullOrEmpty(email)) {
      throw ArgumentError.notNull('email');
    }
    await LeanCloud._httpClient
        .post('requestPasswordReset', data: {'email': email});
  }

  /// Requests a reset password sms code to be sent to a user's [mobile] number.
  static Future requestPasswordRestBySmsCode(String mobile) async {
    if (isNullOrEmpty(mobile)) {
      throw ArgumentError.notNull('mobile');
    }
    await LeanCloud._httpClient.post('requestPasswordResetBySmsCode',
        data: {'mobilePhoneNumber': mobile});
  }

  /// Resets a user's password via [mobile] phone.
  static Future resetPasswordBySmsCode(
      String mobile, String code, String newPassword) async {
    if (isNullOrEmpty(mobile)) {
      throw ArgumentError.notNull('mobile');
    }
    if (isNullOrEmpty(code)) {
      throw ArgumentError.notNull('code');
    }
    if (isNullOrEmpty(newPassword)) {
      throw ArgumentError.notNull('newPassword');
    }
    await LeanCloud._httpClient.put('resetPasswordBySmsCode/$code',
        data: {'mobilePhoneNumber': mobile, 'password': newPassword});
  }

  /// Updates [newPassword] safely with [oldPassword].
  Future updatePassword(String oldPassword, String newPassword) async {
    if (isNullOrEmpty(oldPassword)) {
      throw ArgumentError.notNull('oldPassword');
    }
    if (isNullOrEmpty(newPassword)) {
      throw ArgumentError.notNull('newPassword');
    }
    Map<String, dynamic> response = await LeanCloud._httpClient.put(
        'users/$objectId/updatePassword',
        data: {'old_password': oldPassword, 'new_password': newPassword});
    _LCObjectData objectData = _LCObjectData.decode(response);
    _merge(objectData);
  }

  /// Logs out the currently logged in user session.
  static Future logout() async {
    _currentUser = null;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove(CurrentUserKey);
    } on Error catch (e) {
      LCLogger.error(e.toString());
    }
  }

  /// Checks whether the current sessionToken is valid.
  Future<bool> isAuthenticated() async {
    if (sessionToken == null || objectId == null) {
      return false;
    }
    try {
      await LeanCloud._httpClient.get('users/me');
      return true;
    } catch (Error) {
      return false;
    }
  }

  /// Checks whether this user is anonymous.
  bool get isAnonymous => authData?['anonymous'] != null;

  static Future<LCUser> _login(Map<String, dynamic> data) async {
    Map<String, dynamic> response =
        await LeanCloud._httpClient.post('login', data: data);
    _LCObjectData objectData = _LCObjectData.decode(response);
    _currentUser = LCUser._fromObjectData(objectData);
    await _saveToLocal();
    return _currentUser!;
  }

  static Future _saveToLocal() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userData = jsonEncode(_LCEncoder.encode(_currentUser, full: true));
      await prefs.setString(CurrentUserKey, userData);
    } on Error catch (e) {
      LCLogger.error(e.toString());
    }
  }

  /// Constructs a [LCQuery] for [LCUser].
  static LCQuery<LCUser> getQuery() {
    return new LCQuery<LCUser>(ClassName);
  }

  /// Retrieves the currently logged in [LCUser] with a valid session.
  static Future<LCUser?> getCurrent() async {
    if (_currentUser != null) {
      return _currentUser;
    }
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userData = prefs.getString(CurrentUserKey);
      if (userData != null) {
        LCLogger.debug(userData);
        _LCObjectData objectData = _LCObjectData.decode(jsonDecode(userData));
        _currentUser = LCUser._fromObjectData(objectData);
      }
    } on Error catch (e) {
      LCLogger.error(e.toString());
    }
    return _currentUser;
  }

  /// Follows a user whose objectId is [targetId].
  Future follow(String targetId, {Map<String, dynamic>? attrs}) async {
    if (isNullOrEmpty(targetId)) {
      throw ArgumentError.notNull('targetId');
    }
    String path = 'users/self/friendship/$targetId';
    await LeanCloud._httpClient.post(path, data: attrs);
  }

  /// Unfollows a user whose objectId is [targetId].
  Future unfollow(String targetId) async {
    if (isNullOrEmpty(targetId)) {
      throw ArgumentError.notNull('targetId');
    }
    String path = 'users/self/friendship/$targetId';
    await LeanCloud._httpClient.delete(path);
  }

  /// Constructs a follower query.
  LCQuery<LCObject> followerQuery() {
    LCQuery<LCObject> query = new LCQuery('_Follower');
    query.whereEqualTo('user', this);
    query.include('follower');
    return query;
  }

  /// Constructs a followee query.
  LCQuery<LCObject> followeeQuery() {
    LCQuery<LCObject> query = new LCQuery('_Followee');
    query.whereEqualTo('user', this);
    query.include('followee');
    return query;
  }

  /// Queries followers and followees at the same time.
  ///
  /// [returnCount] indicates whether to return followers/followees count.
  Future<LCFollowersAndFollowees> getFollowersAndFollowees(
      {bool includeFollower = false,
      bool includeFollowee = false,
      bool returnCount = false}) async {
    Map<String, dynamic> queryParams = {};
    if (returnCount) {
      queryParams['count'] = 1;
    }
    if (includeFollower || includeFollowee) {
      List<String> includes = <String>[];
      if (includeFollower) {
        includes.add('follower');
      }
      if (includeFollowee) {
        includes.add('followee');
      }
      queryParams['include'] = includes.join(',');
    }
    Map response = await LeanCloud._httpClient
        .get('users/$objectId/followersAndFollowees', queryParams: queryParams);
    LCFollowersAndFollowees result = new LCFollowersAndFollowees();
    if (response.containsKey('followers')) {
      result.followers = <LCObject>[];
      for (dynamic item in response['followers']) {
        _LCObjectData objectData = _LCObjectData.decode(item);
        LCObject follower = new LCObject('_Follower');
        follower._merge(objectData);
        result.followers?.add(follower);
      }
    }
    if (response.containsKey('followees')) {
      result.followees = <LCObject>[];
      for (dynamic item in response['followees']) {
        _LCObjectData objectData = _LCObjectData.decode(item);
        LCObject followee = new LCObject('_Followee');
        followee._merge(objectData);
        result.followees?.add(followee);
      }
    }
    if (response.containsKey('followers_count')) {
      result.followersCount = response['followers_count'];
    }
    if (response.containsKey('followees_count')) {
      result.followeesCount = response['followees_count'];
    }
    return result;
  }

  /// Requests an SMS code for updating phone number.
  static Future requestSMSCodeForUpdatingPhoneNumber(String mobile,
      {int ttl = 360, String? captchaToken}) async {
    String path = 'requestChangePhoneNumber';
    Map<String, dynamic> data = {'mobilePhoneNumber': mobile, 'ttl': ttl};
    if (captchaToken != null) {
      data['validate_token'] = captchaToken;
    }
    await LeanCloud._httpClient.post(path, data: data);
  }

  /// Verify code for updating phone number.
  static Future verifyCodeForUpdatingPhoneNumber(
      String mobile, String code) async {
    String path = 'changePhoneNumber';
    Map<String, dynamic> data = {'mobilePhoneNumber': mobile, 'code': code};
    await LeanCloud._httpClient.post(path, data: data);
  }

  @override
  Future<LCUser> save(
      {bool fetchWhenSave = false, LCQuery<LCObject>? query}) async {
    await super.save(fetchWhenSave: fetchWhenSave, query: query);
    _currentUser = this;
    await _saveToLocal();
    return this;
  }
}

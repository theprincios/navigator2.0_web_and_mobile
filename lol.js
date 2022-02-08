define(['dart_sdk', 'packages/asf_auth_web/app_auth_web.dart', 'packages/flutter_appauth_platform_interface/src/authorization_token_request.dart', 'packages/flutter_appauth_platform_interface/src/authorization_service_configuration.dart', 'packages/asf_auth_web/asf_token_response.dart', 'packages/flutter_appauth_platform_interface/src/token_request.dart', 'packages/asf_auth_web/asf_auth_token_request.dart'], (function load__packages__asf_auth_web__asf_auth_web_dart(dart_sdk, packages__asf_auth_web__app_auth_web$46dart, packages__flutter_appauth_platform_interface__src__authorization_token_request$46dart, packages__flutter_appauth_platform_interface__src__authorization_service_configuration$46dart, packages__asf_auth_web__asf_token_response$46dart, packages__flutter_appauth_platform_interface__src__token_request$46dart, packages__asf_auth_web__asf_auth_token_request$46dart) {
    'use strict';
    const core = dart_sdk.core;
    const html = dart_sdk.html;
    const async = dart_sdk.async;
    const dart = dart_sdk.dart;
    const dartx = dart_sdk.dartx;
    const app_auth_web = packages__asf_auth_web__app_auth_web$46dart.app_auth_web;
    const authorization_token_request = packages__flutter_appauth_platform_interface__src__authorization_token_request$46dart.src__authorization_token_request;
    const authorization_service_configuration = packages__flutter_appauth_platform_interface__src__authorization_service_configuration$46dart.src__authorization_service_configuration;
    const asf_token_response = packages__asf_auth_web__asf_token_response$46dart.asf_token_response;
    const token_request = packages__flutter_appauth_platform_interface__src__token_request$46dart.src__token_request;
    const asf_auth_token_request = packages__asf_auth_web__asf_auth_token_request$46dart.asf_auth_token_request;
    var asf_auth_web = Object.create(dart.library);
    var $onMessage = dartx.onMessage;
    var $data = dartx.data;
    var $toString = dartx.toString;
    var $contains = dartx.contains;
    var $split = dartx.split;
    var $startsWith = dartx.startsWith;
    var $firstWhere = dartx.firstWhere;
    var $substring = dartx.substring;
    var $close = dartx.close;
    var $open = dartx.open;
    dart._checkModuleNullSafetyMode(false);
    var T = {
      StringTobool: () => (T.StringTobool = dart.constFn(dart.fnType(core.bool, [core.String])))(),
      MessageEventTovoid: () => (T.MessageEventTovoid = dart.constFn(dart.fnType(dart.void, [html.MessageEvent])))(),
      AsfTokenResponseN: () => (T.AsfTokenResponseN = dart.constFn(dart.nullable(asf_token_response.AsfTokenResponse)))()
    };
    const CT = Object.create({
      _: () => (C, CT)
    });
    var I = [
      "file:///Users/mattiasimeone/development/flutter/.pub-cache/git/asf-auth-web-12c7db0fa8d3060c722b02a77262c6890df6663a/lib/asf_auth_web.dart",
      "package:asf_auth_web/asf_auth_web.dart"
    ];
    var _loginPopup = dart.privateName(asf_auth_web, "_loginPopup");
    var _appAuthWebPlugin = dart.privateName(asf_auth_web, "_appAuthWebPlugin");
    asf_auth_web.AsfAuthWeb = class AsfAuthWeb extends core.Object {
      static ['_#_privateConstructor#tearOff']() {
        return new asf_auth_web.AsfAuthWeb._privateConstructor();
      }
      static new() {
        return asf_auth_web.AsfAuthWeb.instance;
      }
      static ['_#new#tearOff']() {
        return asf_auth_web.AsfAuthWeb.new();
      }
      authenticateAndListen(request) {
        if (request == null) dart.nullFailed(I[0], 25, 45, "request");
        html.window[$onMessage].listen(dart.fn(event => {
          let t0;
          if (event == null) dart.nullFailed(I[0], 26, 35, "event");
          if (dart.toString(event[$data])[$contains]("code=")) {
            core.print(event[$data]);
            let currentUrl = core.Uri.base;
            let fragments = currentUrl.fragment[$split]("&");
            let _token = fragments[$firstWhere](dart.fn(e => {
              if (e == null) dart.nullFailed(I[0], 34, 26, "e");
              return e[$startsWith]("code=");
            }, T.StringTobool()))[$substring]("code=".length);
            t0 = this[_loginPopup];
            t0 == null ? null : t0[$close]();
          }
        }, T.MessageEventTovoid()));
        let currentUri = core.Uri.base;
        let redirectUri = core._Uri.new({host: currentUri.host, scheme: currentUri.scheme, port: currentUri.port, path: "/"});
        let authUrl = "https://accounts.google.com/o/oauth2/auth/oauthchooseaccount?client_id=23550971769-mf7kqg1k1hnh4jkdl5ibj6oqob8ss92n.apps.googleusercontent.com&redirect_uri=http%3A%2F%2Flocalhost%3A8080%2F&response_type=code&scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fcloud-platform&code_challenge_method=S256&code_challenge=HXK2xezgLHvICVBLGvPhk5T8NEFxbVAmnof8XzJxDvc&flowName=GeneralOAuthFlow";
        this[_loginPopup] = html.window[$open](authUrl, "Google Auth", "width=800, height=900, scrollbars=yes");
      }
      authenticate(request) {
        if (request == null) dart.nullFailed(I[0], 55, 62, "request");
        return async.async(T.AsfTokenResponseN(), (function* authenticate() {
          let response = (yield this[_appAuthWebPlugin].authorizeAndExchangeCode(new authorization_token_request.AuthorizationTokenRequest.new(request.clientId, request.redirectUrl, {issuer: request.issuer, serviceConfiguration: new authorization_service_configuration.AuthorizationServiceConfiguration.new(request.authorizationEndpoint, request.tokenEndpoint), scopes: request.scopes, preferEphemeralSession: false, additionalParameters: request.parameter})));
          if (response != null) {
            let asfTokenResponse = new asf_token_response.AsfTokenResponse.new({accessToken: response.accessToken, refreshToken: response.refreshToken, accessTokenExpirationDateTime: response.accessTokenExpirationDateTime, idToken: response.idToken, tokenType: response.tokenType, tokenAdditionalParameters: response.tokenAdditionalParameters});
            return asfTokenResponse;
          }
          return null;
        }).bind(this));
      }
      refresh(refreshToken, request) {
        if (refreshToken == null) dart.nullFailed(I[0], 82, 14, "refreshToken");
        if (request == null) dart.nullFailed(I[0], 82, 48, "request");
        return async.async(T.AsfTokenResponseN(), (function* refresh() {
          try {
            if (refreshToken === "") {
              dart.throw(core.Exception.new("Refresh token can't be empty"));
            }
            let response = (yield this[_appAuthWebPlugin].token(new token_request.TokenRequest.new(request.clientId, request.redirectUrl, {discoveryUrl: request.discoveryUrl, refreshToken: refreshToken, scopes: request.scopes, additionalParameters: request.parameter, grantType: "refresh_token"})));
            if (response != null) {
              let refreshTokenResponse = new asf_token_response.AsfTokenResponse.new({accessToken: response.accessToken, refreshToken: response.refreshToken, accessTokenExpirationDateTime: response.accessTokenExpirationDateTime, idToken: response.idToken});
              return refreshTokenResponse;
            } else {
              dart.throw(core.Exception.new("Refresh token request failed"));
            }
          } catch (e$) {
            let e = dart.getThrown(e$);
            if (core.Object.is(e)) {
              dart.throw(core.Exception.new("Refresh token request failed"));
            } else
              throw e$;
          }
        }).bind(this));
      }
    };
    (asf_auth_web.AsfAuthWeb._privateConstructor = function() {
      this[_loginPopup] = null;
      this[_appAuthWebPlugin] = new app_auth_web.AppAuthWebPlugin.new();
      ;
    }).prototype = asf_auth_web.AsfAuthWeb.prototype;
    dart.addTypeTests(asf_auth_web.AsfAuthWeb);
    dart.addTypeCaches(asf_auth_web.AsfAuthWeb);
    dart.setMethodSignature(asf_auth_web.AsfAuthWeb, () => ({
      __proto__: dart.getMethods(asf_auth_web.AsfAuthWeb.__proto__),
      authenticateAndListen: dart.fnType(dart.dynamic, [asf_auth_token_request.AsfAuthTokenRequest]),
      authenticate: dart.fnType(async.Future$(dart.nullable(asf_token_response.AsfTokenResponse)), [asf_auth_token_request.AsfAuthTokenRequest]),
      refresh: dart.fnType(async.Future$(dart.nullable(asf_token_response.AsfTokenResponse)), [core.String, asf_auth_token_request.AsfAuthTokenRequest])
    }));
    dart.setStaticMethodSignature(asf_auth_web.AsfAuthWeb, () => ['new']);
    dart.setLibraryUri(asf_auth_web.AsfAuthWeb, I[1]);
    dart.setFieldSignature(asf_auth_web.AsfAuthWeb, () => ({
      __proto__: dart.getFields(asf_auth_web.AsfAuthWeb.__proto__),
      [_loginPopup]: dart.fieldType(dart.nullable(html.WindowBase)),
      [_appAuthWebPlugin]: dart.finalFieldType(app_auth_web.AppAuthWebPlugin)
    }));
    dart.setStaticFieldSignature(asf_auth_web.AsfAuthWeb, () => ['instance']);
    dart.defineLazy(asf_auth_web.AsfAuthWeb, {
      /*asf_auth_web.AsfAuthWeb.instance*/get instance() {
        return new asf_auth_web.AsfAuthWeb._privateConstructor();
      }
    }, false);
    dart.trackLibraries("packages/asf_auth_web/asf_auth_web.dart", {
      "package:asf_auth_web/asf_auth_web.dart": asf_auth_web
    }, {
    }, '{"version":3,"sourceRoot":"","sources":["asf_auth_web.dart"],"names":[],"mappings":";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;AAqBI,YAAO;IACT;;;;0BAE0C;;MACnC,AAAO,AAAU,+BAAO,QAAC;;;AAE5B,YAAe,AAAW,cAAtB,AAAM,KAAD;UAEP,WAAM,AAAM,KAAD;AACL,2BAAiB;AACjB,0BAAY,AAAW,AAAS,UAAV;AACtB,uBAAS,AACV,AACA,SAFmB,cACR,QAAC;;AAAM,kBAAA,AAAE,EAAD;4CACD;eAClB;8BAAa;;;AAIhB,uBAAiB;AACjB,wBAAc,qBACZ,AAAW,UAAD,eACR,AAAW,UAAD,eACZ,AAAW,UAAD;AAGZ;MAID,oBAAmB,AACnB,mBAAK,OAAO;IACnB;iBAE2D;;AAArB;AAC9B,8BAAiB,AAAkB,iDACvC,8DAA0B,AAAQ,OAAD,WAAW,AAAQ,OAAD,uBACvC,AAAQ,OAAD,+BACO,8EACpB,AAAQ,OAAD,wBACP,AAAQ,OAAD,yBAED,AAAQ,OAAD,8DAEO,AAAQ,OAAD;AAGnC,YAAI,QAAQ;AACJ,iCAAmB,0DACR,AAAS,QAAD,4BACP,AAAS,QAAD,8CACS,AAAS,QAAD,yCAC9B,AAAS,QAAD,qBACN,AAAS,QAAD,uCACQ,AAAS,QAAD;AACvC,gBAAO,iBAAgB;;AAEzB;MACF;;YAGW,cAAkC;;;AADZ;;AAG7B,cAAI,AAAa,YAAD;YACd,WAAM;;AAGa,gCAAiB,AAAkB,8BACtD,mCACE,AAAQ,OAAD,WACP,AAAQ,OAAD,6BACO,AAAQ,OAAD,6BACP,YAAY,UAClB,AAAQ,OAAD,+BACO,AAAQ,OAAD;AAIjC,cAAI,QAAQ;AACJ,uCAAuB,0DACd,AAAS,QAAD,4BACP,AAAS,QAAD,8CACS,AAAS,QAAD,yCAC9B,AAAS,QAAD;AAEnB,kBAAO,qBAAoB;;YAE3B,WAAM;;;cAED;AAAP;YACA,WAAM;;;;MAEV;;;;IAnGiB;IACM,0BAAoB;;EAEX;;;;;;;;;;;;;;;;;;MAER,gCAAQ;YAAc","file":"../../../../../../../../packages/asf_auth_web/asf_auth_web.dart.lib.js"}');
    // Exports:
    return {
      asf_auth_web: asf_auth_web
    };
  }));
  
  //# sourceMappingURL=asf_auth_web.dart.lib.js.map
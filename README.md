# HttpSessionManager
熟悉Alamofire和Moya二个网络请求框架后，自己基于Alamofire编写的1个通用型的网络请求库，简洁方便实用。
## 语言
Swift4.2
## Cocoapods进行安装
```
pod 'HttpSessionManager'
```
## 使用说明（可以参考Example）
1.建一个网络请求配置类，实现RequestConfigProtocol协议。<br>
2.在App启动后未发起网络请求前设置HttpSessionManager.shared.config。<br>
3.网络请求接口实现TargetType协议。<br>
4.发起网络请求。
## 业务层的简单使用
```
// 1.定义网络请求接口
enum UserAPI {
    //获取用户信息
    case userInfo
    //修改用户信息
    case modifyNickname(nickname: String)
}
```
```
// 2.实现网络请求接口
extension UserAPI: TargetType {
    var path: String {
        switch self {
        case .userInfo:
            return "UserInfo"
        case .modifyNickname:
            return "modifyNickname"
        }
    }
    var parameters: [String : Any]? {
        switch self {
        case .userInfo:
            return nil
        case let .modifyNickname(nickname: nickname):
            return ["nickname": nickname]
        }
    }
    // ...每个网络请求接口，TargetType协议里的实现可不一样。
    /// Optional。比如每个接口 可以有不同的请求地址。
    var customURL: URL? {
        switch self {
        case .userInfo:
            return URL.init(string: "a地址")
        case .modifyNickname:
            return URL.init(string: "b地址")
        }
    }
} 
```
```
/// 3.发起网络请求
HttpSessionManager.shared.request(target: MultiTarget(UserAPI.userInfo)) { result in
    switch result {
    case .success(let successRes):
        print(successRes)
    case .failure(let failRes):
        print(failRes.returnMsg)
    }
}
```
## 优点
1.RequestConfigProtocol接口丰富，全局配置方便。<br>
2.TargetType接口丰富，每个网络请求可自定义度高，比如每个网络请求可以配置不同的请求地址、加解密方法、超时时间、请求头等。<br>
3.稳定性好，扩展性强。<br>


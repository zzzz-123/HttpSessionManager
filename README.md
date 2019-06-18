# HttpSessionManager

After learning 'Alamofire' and 'Moya', I packaged a general-purpose network request library based on Alamofire, which is simple, convenient and practical.

## Getting Started

Download HttpSessionManager，have a try with the example.

### Requirements

```
iOS 8.0+
Xcode 10.1+
Swift 4.2+
```

### Installing

HttpSessionManager supports multiple methods for installing the library in a project.

1.CocoaPods
```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

target 'TargetName' do
pod 'HttpSessionManager', '~> 1.0.0'
end
```
2.Manually  
you can drag the downloaded code directly into your project.

### Usage
1. Create a new class that implement protocol of 'RequestConfigProtocol'  
```
class RequestConfig: RequestConfigProtocol {
    
    /// Adding to path ,retrun URL.
    public func getBaseURL(path: String) -> URL {
        return URL(string: "https://github.com")!
    }
    
    /// request headers
    public var headers: [String: String]? {
        return nil
    }
    /// and so on.
}
```
2. Setting configuration for HttpSessionManager.shared.
```
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:[UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
     
    HttpSessionManager.shared..config = RequestConfig()
    return true
}
```
3.Network request API  
```
enum UserAPI {
    // get user info.
    case userInfo
    // modify user nickname.
    case modifyNickname(nickname: String)
}

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
    /// Optional 
    /// Each network request interface, the implementation in the TargetType protocol can be different.
    var customURL: URL? {
        switch self {
        case .userInfo:
            return URL(string: "https://xxx")
        case .modifyNickname:
            return URL(string: "https://yyy")
        }
    }
    /// and so on.
}
```
4. Call API like this  
```
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        HttpSessionManager.shared.request(target: MultiTarget(UserAPI.userInfo)) { result in
            switch result {
            case .success(let successRes):
                print(successRes)
            case .failure(let failRes):
                print(failRes.returnMsg)
            }
        }
    }
}
```

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/your/project/tags). 

## Authors

* **zhengrusong**

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Hat tip to anyone whose code was used
* Inspiration
* etc

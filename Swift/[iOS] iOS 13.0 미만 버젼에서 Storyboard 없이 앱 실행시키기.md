# [iOS] iOS 13.0 미만 버젼에서 Storyboard 없이 앱 실행시키기

Storyboard를 사용하지 않고 앱을 구성하다가, SceneDelegate를 지원하지 않는 iOS 13.0 미만 버젼에서 
Storyboard 없이 앱을 (첫 ViewController)를 실행하는 방법을 공유합니다.

## Storyboard 제거

먼저 프로젝트를 생성하고, 자동으로 만들어지는 Main.storyboard 파일을 삭제합니다.
단순히 파일만 삭제하는게 아니라 프로젝트 여러군데에 Main.storyboard와 연결되어 있는 부분을 찾아서 삭제 해줘야 합니다.

### 1. General - Deployment Info

밑의 스크린샷 부분, Main Interface에 Main을 지우고 비워두면 됩니다.

![스크린샷 2021-06-01 오후 9 17 34](https://user-images.githubusercontent.com/22260098/120321890-c961d800-c31e-11eb-99d5-8e2a958d5850.png)

### 2. Info.plist

```Info.plist```에서
Application Scene Manifest -> Scene Configuration -> Application Session Role -> Item 0
안에 Storyboard Name 프로퍼티를 - 버튼을 눌러 삭제하면 됩니다.

![](https://jamesu.dev/posts/2020/01/16/starting-swift-project-without-storyboard-and-scenedelegate-in-xcode-11/assets/figures/removing_storyboard/2_1.png)

## Appdelegate 설정

```swift
    // AppDelegate.swift
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds) // Screen 크기의 window 생성
        let homeViewController = ViewController()
        window?.rootViewController = homeViewController
        window?.makeKeyAndVisible()
        return true
    }
```

이렇게 해주면 기본적인 세팅은 끝이 났습니다.
만약 Scene을 사용하지 않을거라면 ```SceneDelegate.swift``` 파일을 삭제해줘도 됩니다.

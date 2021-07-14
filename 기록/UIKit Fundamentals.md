# UIKit Fundamentals 01

SwiftUI 2019년 출시, 멀티 플랫폼 ui 프레임워크

SwiftUI가 있지만, UIKit을 익혀야 근본적인 레벨에서 iOS 앱개발을 할 수 있고, 많은 SwiftUI가 UIKit의 요소를 따르기 때문에 중요하다.

iOS MVC
Model: data, list를 디스플레이하면 model은 array
View: UI, ex) label
Controller: between model, view, model을 변화시키거나, 변화를 감지

life cycle method

viewDidLoad: View가 생성되었을 때
viewWillAppear: View가 보이기 직전에
viewWillDisappear: 

## Contorls

UI 빌드: 하나의 Route View에 Child View를 추가

## Image View의 Scaling

Aspect Fit: 이미지의 비율을 유지하면서, View의 border와 맞춤
Aspect Fill: 이미지의 비율을 유지하면서, 크기를 키워 View에 맞춤
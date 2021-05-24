# [Swift] 간단한 날씨 앱 만들어보기 02 (Swift OpenWeatherMap)

## 원하는 정보 가져오기

이전 포스트에서 OpenWeatherMap API를 통해 서울의 현재 날씨 정보를 아래처럼 받아왔습니다.

![스크린샷 2021-05-24 오전 12 05 42](https://user-images.githubusercontent.com/22260098/119265955-c92d5280-bc23-11eb-9bb0-1d8564f9175c.png)

그럼 이 API 호출을 브라우져, 포스트맨이 아니라 우리 앱에 정보를 표시할 수 있도록 Swift로 Xcode 상에서 불러와보도록 하겠습니다.

### 데이터 모델

OpenWeatherMap이 보내주는 모든 데이터를 사용할 필요는 없기 때문에,
내가 사용하고 싶은 데이터만 골라서 날씨 데이터 모델을 만들었습니다.

```swift
// Weather.swift
import Foundation

struct WeatherResponse: Decodable {
    let weather: [Weather]
    let main: Main
    let name: String
}

struct Main: Decodable {
    let temp: Double
    let temp_min: Double
    let temp_max: Double
}

struct Weather: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}
```

### API 호출하고 리턴 받기

API로부터 받을 값을 저장한 모델도 만들었으니, 이제 API를 호출하고 리턴을 받아보겠습니다.

```swift
// WeatherService.swift
import Foundation

// 에러 정의
enum NetworkError: Error {
    case badUrl
    case noData
    case decodingError
}

class WeatherService {
    // .plist에서 API Key 가져오기
    private var apiKey: String {
        get {
            // 생성한 .plist 파일 경로 불러오기
            guard let filePath = Bundle.main.path(forResource: "KeyList", ofType: "plist") else {
                fatalError("Couldn't find file 'KeyList.plist'.")
            }
            
            // .plist를 딕셔너리로 받아오기
            let plist = NSDictionary(contentsOfFile: filePath)
            
            // 딕셔너리에서 값 찾기
            guard let value = plist?.object(forKey: "OPENWEATHERMAP_KEY") as? String else {
                fatalError("Couldn't find key 'OPENWEATHERMAP_KEY' in 'KeyList.plist'.")
            }
            return value
        }
    }
    
    func getWeather(completion: @escaping (Result<WeatherResponse, NetworkError>) -> Void) {
        
        // API 호출을 위한 URL
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=seoul&appid=\(apiKey)")
        guard let url = url else {
            return completion(.failure(.badUrl))
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                return completion(.failure(.noData))
            }
            
            // Data 타입으로 받은 리턴을 디코드
            let weatherResponse = try? JSONDecoder().decode(WeatherResponse.self, from: data)

            // 성공
            if let weatherResponse = weatherResponse {
                print(weatherResponse)
                completion(.success(weatherResponse)) // 성공한 데이터 저장
            } else {
                completion(.failure(.decodingError))
            }
        }.resume() // 이 dataTask 시작
    }
}
```

이렇게 요청을 보내고, 결과를 받는 ```WeatherService```를 만들었습니다.
이제 ```ViewController```에서 실제로 동작하게 해보겠습니다.

```swift
// ViewController.swift
import UIKit

class ViewController: UIViewController {
    // 받아온 데이터를 저장할 프로퍼티
    var weather: Weather?
    var main: Main?
    var name: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // data fetch
        WeatherService().getWeather { result in
            switch result {
            case .success(let weatherResponse):
                DispatchQueue.main.async {
                    self.weather = weatherResponse.weather.first
                    self.main = weatherResponse.main
                    self.name = weatherResponse.name
                }
            case .failure(_ ):
                print("error")
            }
        }
    }
}
```

이제 프로젝트를 빌드하고 실행해보면,
```
WeatherResponse(weather: [SampleWeatherApp.Weather(id: 801, main: "Clouds", description: "few clouds", icon: "02d")], main: SampleWeatherApp.Main(temp: 297.7, temp_min: 295.88, temp_max: 298.81), name: "Seoul")
```

정상적으로 데이터가 받아져 출력되는 것을 볼 수 있습니다.

## UI

이제 받아온 날씨 정보를 화면에 표시할 수 있게 UI를 세팅하도록 하겠습니다.

<img width="361" alt="스크린샷 2021-05-24 오후 4 37 33" src="https://user-images.githubusercontent.com/22260098/119313333-646b0a00-bcae-11eb-8887-2c82bf7a26e2.png">

저는 아이콘을 표시할 이미지뷰, 현재, 최고, 최저 기온으르 표시할 라벨만 만들어 줬습니다.

해당 View들을 IBOutlet으로 ViewController에 연결해주면 됩니다.

```swift
class ViewController: UIViewController {
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var maxTempLabel: UILabel!
    @IBOutlet var minTempLabel: UILabel!
    
    ...
```

UI를 세팅해줄 함수를 정의하고,
```swift
// ViewController.swift
private func setWeatherUI() {
    let url = URL(string: "https://openweathermap.org/img/wn/\(self.weather?.icon ?? "00")@2x.png")
    let data = try? Data(contentsOf: url!)
    if let data = data {
        iconImageView.image = UIImage(data: data)
    }
    tempLabel.text = "\(main!.temp)"
    maxTempLabel.text = "\(main!.temp_max)"
    minTempLabel.text = "\(main!.temp_min)"
}
```

success 호출해주면

```swift
// ViewController.swift
override func viewDidLoad() {
    super.viewDidLoad()
    WeatherService().getWeather { result in
        switch result {
        case .success(let weatherResponse):
            DispatchQueue.main.async {
                self.weather = weatherResponse.weather.first
                self.main = weatherResponse.main
                self.name = weatherResponse.name
                self.setWeatherUI()
            }
        case .failure(_ ):
            print("error")
        }
    }
}
```

![Simulator Screen Shot - iPhone 11 Pro - 2021-05-24 at 16 51 46](https://user-images.githubusercontent.com/22260098/119315018-56b68400-bcb0-11eb-9fed-1a5904417010.png)

시뮬레이터에 정상적으로 반영되는 것을 볼 수 있습니다.

온도가 이상하게 높게 나오는 것은 온도를 화씨단위로 받아오기 때문이고,
섭씨로 변환을 해주면 우리에게 익숙한 형태로 온도를 표시할 수 있습니다.

## 끝

저번 포스트에 이어 간단한 날씨 앱을 제작해봤습니다.

이번 튜토리얼을 통해, 
- API 를 어떻게 호출하고 받아오는지
- 받아온 값을 어떻게 가공하는지
- API Key를 어떻게 숨기는지

등을 익혀봤습니다.

다른 API를 사용하더라도 사용법은 거의 비슷하기 때문에 항상 올바른 url로 요청을 보내고,
원하는 데이터를 가공하는 것만 기억하면 문제 없이 응용할 수 있을 것 같습니다.
# [Swift] Codable을 이용해 JSON 처리하기

## Codable

우선 ```Codable``` 이란 JSON과 같은 외부표현으로 자신을 변환하거나 변환되는 타입입니다.

>참고: https://developer.apple.com/documentation/swift/codable/

이게 무슨 말이냐면, Swift ```class, struct, enum``` 타입이 ```Codable```을 채택하면 JSON 데이터를 변환 시켜 자신의 타입으로 바꿀 수 있고 자신을 JSON 형태로 바꿀 수도 있다는 뜻입니다!

```Codable``` 은 또한 

<img height="100" alt="Codable" src="https://user-images.githubusercontent.com/22260098/119133946-7a42ba00-ba77-11eb-87c3-c089637ae47e.png">

```Decodable, Encodable```을 동시에 포함하는 typealias이기 때문에 Codable만 채택해줘도, 두 프로토콜을 모두 구현할 수 있습니다.

## Example

설명만 보면 이해하기 힘드니 간단한 예시를 보겠습니다.

```swift
struct Person: Codable {
    var name: String
    var age: Int
}
```

여기 Codable을 채택하고 있는 아주 간단한 struct ```Person```이 있습니다.
그 뜻은 JSON을 받아와서 ```Person```을 만들 수도 있고, 반대도 가능하다는 뜻입니다.

### Encoding

먼저 ```JSONEncoder```를 통해 ```Person```을 JSON으로 인코딩 해보겠습니다.

```Swift
let nj = Person(name: "NJ", age: 10)

let encoder = JSONEncoder()
let encodedData = try? encoder.encode(nj)
```
```JSONEncoder```객체를 하나 만들고, ```.encode()```에 ```Person```객체를 넣어 줌으로써 간단하게 인코딩이 되었습니다.

어 그럼 바로 JSON 형태의 데이터를 쓸 수 있겠네?
```swift
print(encodedData)
// Optional(22 bytes)
```
라고 print를 해보면 이상한 결과가 나옵니다.
왜냐하면 ```.encode()```메소드는 ```Encodable```을 준수하고 있는 타입을 파라미터로 받아서 ```Data```타입으로 리턴을 해주기 때문입니다.

그렇기 때문에 한번 더, ```Data```타입을 ```JSON String```으로 바꾸는 과정을 거쳐야 합니다.

```swift
if let jsonData = encodedData, let jsonString = String(data: jsonData, encoding: .utf8){
    print(jsonString)  // {"name":"NJ","age":10}
}
```
이렇게 ```String(data:, encoding:)```메소드를 사용해 변환할 수 있습니다.
하지만 최종 String이 한줄로 출력되서 가독성이 별로 좋지 않은데,

```swift
{
  "name" : "NJ",
  "age" : 10
}
```
이런식으로 리턴을 받고 싶으면

```swift
let encoder = JSONEncoder()
encoder.outputFormatting = .prettyPrinted
```
이렇게 인코더의 아웃풋 포맷을 지정해주기만 하면 됩니다.

그래서 인코딩 과정을 요약하면,
1. ```JSONEncoder``` 객체 생성
2. ```.encode()``` 메소드를 통해 ```Data```타입 리턴 받기
3. 리턴 받은 ```Data```를 ```String```으로 변환

### Decoding

다음은 보통 API를 통해 데이터를 받는 일이 더 많기 때문에 더 자주쓰이는 ```JSON String```을 받아서 내가 원하는 타입으로 변환하는 것을 해보겠습니다.

우선 예시로 사용할 ```JSON```을 위의 인코딩 예시에서 생성한 것을 사용하겠습니다.

```swift
{
  "name" : "NJ",
  "age" : 10
}
```

Decoding을 하는 것도 어렵지 않게 위 인코딩 과정을 거꾸로 실행해주면 됩니다.
1. ```JSONDecoder``` 객체 생성
2. ```String```을 ```Data```로 변환
3. ```.decode()``` 메소드를 통해 인스턴스 리턴 받기

```swift
// JSONDecoder 객체 생성
let decoder = JSONDecoder()

// 사용할 String
let dataString = 
    """
    {
    "name" : "NJ",
    "age" : 10
    }
    """

// String 을 Data로 변환
let data = dataString.data(using: .utf8)!

// Decoding
let decodedData = try? decoder.decode(Person.self, from: data)
```

이렇게만 하면 ```Person```타입의 객체 ```decodedData```를 만들 수 있습니다.

그런데 ```.decode()```메소드의 파라미터 중 ```Person.self```가 있는 이유는,

```swift
 /// Decodes a top-level value of the given type from the given JSON representation.
    ///
    /// - parameter type: The type of the value to decode.
    /// - parameter data: The data to decode from.
    /// - returns: A value of the requested type.
    /// - throws: `DecodingError.dataCorrupted` if values requested from the payload are corrupted, or if the given data is not valid JSON.
    /// - throws: An error if any value throws an error during decoding.
    open func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable
```

```.decode()```메소드의 원형을 봤을 때, 첫번째 파라미터로 decode할 값의 타입을 받기 때문입니다.

이상으로 Codable을 이용해 간단하게 JSON을 처리하는 방법에 대해 알아보았습니다.

> 참고: https://zeddios.tistory.com/373, https://medium.com/@Lukaz32/swift-4s-codable-protocol-b851b5b5cbd9
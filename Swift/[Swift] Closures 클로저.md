# Swift - Closure

## Closure - 클로저
Swift 공식 문서:
> Closures are self-contained blocks of functionality that can be passed around and used in your code. Closures in Swift are similar to blocks in C and Objective-C and to lambdas in other programming languages.

번역 해보자면 Swift의 Closure (클로저)란 C, Objective-C의 블럭, 다른 언어의 람다와 비슷한 코드블럭으로, 코드 안에서 전달되거나, 사용될 수 있다고 합니다.

또한 클로저는 상수나 변수의 참조를 캡쳐, 저장할 수 있고 이 때 모든 메모리를 알아서 처리합니다.

클로저는 어떤 기능을 하는 코드 블럭인데, 비슷하게 어떤 기능을 하는 코드 블럭인 함수와는 무슨 관련이 있을까요?

<img height="200" src="https://user-images.githubusercontent.com/22260098/114351942-36ba7d80-9ba6-11eb-8906-d5032a8685f1.png">

바로 함수는 클로저의 특정한 형태로 클로저에 포함되는 관계 입니다.
위 문서에서 설명하는 조건 중 1개의 조건을 가지는 클로저를 함수라고 합니다.

## Closure Expression - 클로저 표현

클로저 표현은 코드의 명확성과 의도를 잃지 않으면서 문법을 축약해 사용할 수 있는 다양한 문법의 최적화 방법을 제공하기 때문에 처음 Swift로 작성된 코드를 봤을 때, 여러 형태로 축약된 클로저를 보고 당황했던 기억이 있습니다.
이처럼 다양한 클로저 표현 방법을 sorted(by:) 함수의 파라미터 클로저를 통해 알아보겠습니다.

### sorted(by:)

```sorted(by:)``` 함수는 Swift의 표준 라이브러리에 정의 되어있는 함수로 주어진 어레이를 사용자가 넘긴 클로저에 맞게 정렬하고 리턴해주는 함수 입니다.

```swift
let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
```
정렬을 해볼 예시로 String 타입의 원소를 가지는 어레이 'names'를 사용하겠습니다.

```sorted(by:)``` 함수가 파라미터로 받는 클로저는 어레이의 원소와 같은 타입의 두 개의 인자를 가지고 Bool을 리턴하는 클로저입니다.
이 클로저의 리턴 값의 의미는 첫 번째 인자가 두 번째 인자보다 앞으로 와야하는지를 나타냅니다.

```swift
func backward(_ s1: String, _ s2: String) -> Bool {
    return s1 > s2
}
var reversedNames = names.sorted(by: backward)
// reversedNames is equal to ["Ewa", "Daniella", "Chris", "Barry", "Alex"]
```

```sorted(by:)``` 함수는 인자로 전달받은 ```backward(_:_:)```의 규칙을 따라 내림차순으로 어레이를 정렬 하고 리턴합니다.
위처럼 함수를 정의해서 전달할 수도 있지만 더 간결하게 클로저를 인라인으로 사용하는 방법을 알아보겠습니다.

#### Closure Expression Syntax - 클로저 표현 문법

<img height="100" src="https://user-images.githubusercontent.com/22260098/114356463-99fade80-9bab-11eb-8ca9-062141883f71.png">

클로저의 파라미터는 default 값을 가질 수 없고, 0...10과 같은 형태, 튜플 형태가 될 수 있습니다.

```swift
reversedNames = names.sorted(by: { (s1: String, s2: String) -> Bool in
    return s1 > s2
})

```

위 코드는 ```backward(_:_: )``` 함수를 인라인 클로저로 표현한 예시 입니다.

위 클로저와 ```backward(_:_: )``` 함수는 동일한 파라미터와 리턴 타입을 가지지만 클로저의 파라미터 정의는 중괄호 ```{}``` 안에 있다는 것을 알 수 있습니다.

```in```은 클로저의 파라미터와 리턴타입의 정의가 끝났다는 것을 알려주고, 바디 부분이 시작된다는 것을 알려줍니다.

위의 코드는 클로저의 바디부분이 짧기 때문에 ```in```뒤에 공백 없이 한줄로 표현할 수 있습니다.

```swift
reversedNames = names.sorted(by: { (s1: String, s2: String) -> Bool in return s1 > s2 } )
```

#### Inferring Type From Context - 문맥에서 타입 추론

```sorted(by:)```는 파라미터로 전달받는 클로저의 타입을 ```(String, String) -> Bool```로 이미알고 있기 때문에 클로저의 정의에서 ```(String, String)``` 과 ```Bool```는 생략될 수 있습니다.
클로저에서 사용되는 모든 타입에 대한 추론이 가능하기 때문에, 파라미터의 타입과 파라미터를 감싸고 있는 괄호, 리턴 화살표 (->)도 생략할 수 있습니다.
```swift
reversedNames = names.sorted(by: {s1, s2 in return s1 > s2})
```
이처럼 파라미터, 리턴 타입은 함수혹은 메소드의 파라미터로 인라인 클로저가 사용될 때 언제나 생략할 수 있습니다.

#### Implicit Returns from Single-Expression Closures - 단일 표현 클로저에서의 암시적 반환

단일 표현 클로저에서는 반환 키워드 ```return```을 생략할 수 있습니다.
```swift
reversedNames = names.sorted(by: { s1, s2 in s1 > s2 } )
```

```sorted(by:)```의 파라미터 클로저가 ```Bool```을 리턴해야 하는 것이 자명하므로 ```return```을 생략할 수 있습니다.

#### Shorthand Argument Names - 인자 이름 축약

Swift는 인라인 클로저에게 자동 축약 이름을 제공합니다.
축약 이름은 인자의 순서대로 ```$0, $1, $2, ...```로 사용됩니다.

축약 이름을 사용하면 클로저 정의에서 인자 정의를 생략할 수 있고, 축약 인자의 수와 타입은 자동으로 참조 됩니다.
인자 정의가 생략되면 클로저 표현에 바디 부분만 있기 때문에 ```in```역시 생략될 수 있습니다.

```swift
reversedNames = names.sorted(by: { $0 > $1 })
```

#### Operator Methods - 연산자 메소드

지금까지의 방법으로도 충분히 간결하고 누군가는 못 알아볼 수 있을만큼 클로저 표현을 축약했지만 여기서 더 생략을 할 수도 있습니다.

```String```의 비교 연산자 ```>, <, ==```는 두개의 파라미터를 받고, ```Bool```을 리턴한다고 이미 정의 되어 있기 때문에 클로저 대신 단순히 연산자를 넘겨주기만 해도 됩니다!

```swift
reversedNames = names.sorted(by: >)
```
> Too much 생략? or 간결?

## Trailing Closures - 후위 클로저

만약 어떤 함수의 마지막 인자로 클로저를 넘겨야 하고, 클로저 표현이 길다면 후위 클로저를 쓰는게 좋은 방법일 수 있습니다.

후위 클로저는 함수의 마지막인자가 클로저일 때, 함수 호출 괄호 이후에 인자명 없이 클로저를 정의하는 것을 말합니다.

```swift
func someFunctionThatTakesAClosure(closure: () -> Void) {
    // function body goes here
}

// 위 함수를 후위 클로저를 사용하지 않고 호출

someFunctionThatTakesAClosure(closure: {
    // closure's body goes here
})

// 후위 클로저 사용

someFunctionThatTakesAClosure() {
    // trailing closure's body goes here
}
```

위 섹션에서 살펴본 ```sorted(by:)```도 후위 클로저를 사용해 표현될 수 있습니다.

```swift
reversedNames = names.sorted() { $0 > $1 }
```

위처럼 함수의 유일한 파라미터가 클로저이고, 후위 클로저를 사용한다면 함수 호출 부분의 ```()```괄호는 생략될 수 있습니다.

```swift
reversedNames = names.sorted { $0 > $1 }
```

## Capturing Values - 값 캡쳐

클로저는 정의되었는 문맥의 상수나 변수를 캡쳐하여 클로저의 바디안에서 참조하거나 수정할 수 있습니다.

Swift에서 가장 간단한 예시는 함수안에 다른 함수가 있는 nested function입니다.

```swift
func makeIncrementer(forIncrement amount: Int) -> () -> Int {
    var runningTotal = 0
    func incrementer() -> Int {
        runningTotal += amount
        return runningTotal
    }
    return incrementer
}
```

```makeIncrementer(forIncrement:)``` 함수의 리턴 타입은 ```() -> Int```로 단순한 값을 리턴하는 것이 아니라 함수를 리턴합니다.
```makeIncrementer(forIncrement:)``` 함수는 ```runningTotal```이라는 변수를 정의 하고, 하나의 ```Int``` 인자 ```amount```를 받습니다.

```swift
func incrementer() -> Int {
    runningTotal += amount
    return runningTotal
}
```

```incrementer()```함수만 따로 봤을 때, 이 함수는 아무 인자도 없고 ```runningTotal```과 ```amount```는 정의가 안되어 있지만 정상적으로 동작합니다.
그 이유는 이 함수를 포함하고 있는 함수에서 ```runningTotal```과 ```amount```캡쳐하기 때문입니다.

사용 예시를 보겠습니다.
```swift
let incrementByTen = makeIncrementer(forIncrement: 10)
```
이렇게 만들어진 함수는
```swift
incrementByTen()
// returns a value of 10
incrementByTen()
// returns a value of 20
incrementByTen()
// returns a value of 30
```
정상적으로 작동 합니다.
```swift
let incrementBySeven = makeIncrementer(forIncrement: 7)
incrementBySeven()
// returns a value of 7
```
위 처럼 다른 인자로 정의를 하게되면 새로운 값은 캡쳐해서 다른 결과를 나타냅니다.

## Closures Are Reference Types

위의 예시에서 ```incrementByTen()```은 상수지만 ```runningTotal```변수의 값을 계속 변화 시킬 수 있었습니다.

그 이유는 Swift에서 함수와 클로저는 참조 타입이기 때문에 상수나 변수에 할당될 때 실제 값이 아니라 참조가 할당되기 때문입니다.

## Escaping Closure

비동기로 실행되거나 ```completionHandler```로 사용되는 되는 것처럼 함수 밖(함수가 종료되고) 실행되는 클로저는 파라미터 타입 앞에 ```@escaping```키워드를 명시해야 합니다.

```swift
var completionHandlers = [() -> Void]()
func someFunctionWithEscapingClosure(completionHandler: @escaping () -> Void) {
    completionHandlers.append(completionHandler)
}
```
위 함수에서 인자로 전달된 ```completionHandler```는 함수 안에서 실행되지 않고 나중에 처리 되기 때문에 ```@escaping``` 키워드를 명시해야 하고, 명시하지 않으면 컴파일 에러가 발생합니다.

또한 ```@escaping```키워드를 사용하는 클로저에서는 self를 명시적으로 언급해야 합니다.

```swift
func someFunctionWithNonescapingClosure(closure: () -> Void) {
    closure()
}

class SomeClass {
    var x = 10
    func doSomething() {
        someFunctionWithEscapingClosure { self.x = 100 }
        someFunctionWithNonescapingClosure { x = 200 }
    }
}

let instance = SomeClass()
instance.doSomething()
print(instance.x)
// Prints "200"

completionHandlers.first?()
print(instance.x)
// Prints "100"
```

## Auto Closure - 자동 클로저

자동 클로저는 인자 값이 없고, 특정 표현을 감싸 다른 함수에 전달 인자로 사용할 수 있는 클로저 입니다.

```swift
var customersInLine = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
print(customersInLine.count)
// Prints "5"

let customerProvider = { customersInLine.remove(at: 0) }
print(customersInLine.count)
// 정의 될때 실행되지 않음
// Prints "5"

print("Now serving \(customerProvider())!")
// Prints "Now serving Chris!"
print(customersInLine.count)
// Prints "4"
```

```swift
// () -> String 인자가 없는 클로저를 인자로 받는 함수 serve
func serve(customer customerProvider: () -> String) {
    print("Now serving \(customerProvider())!")
}
serve(customer: { customersInLine.remove(at: 0) } )
// Prints "Now serving Alex!"
```

아래 처럼 ```@autoclosure```키워드를 사용하면 자동으로 인자 값을 클로저로 변환합니다.
```swift
// customersInLine is ["Ewa", "Barry", "Daniella"]
func serve(customer customerProvider: @autoclosure () -> String) {
    print("Now serving \(customerProvider())!")
}
// {} 중괄호 없이 표현 전달
serve(customer: customersInLine.remove(at: 0))
// Prints "Now serving Ewa!"
```

# Swift Hacks

## String 반대로 뒤집기

```swift
let str = "Hello, world!"
let reversed = String(str.reversed())
```

## n 진법

```swift
// 정수 n을 3진법 string으로
let str = String(n, radix: 3)

// 3진법 string을 10진법으로
let n = Int(str, radix: 3)
```

## String 이 숫자로만 이루어져 있는지

```swift
let str = "123"
let isAllNumbers = (Int(str) != nil)
```

## String 반복

```swift
String(repeating: String, count: Int)

// 어레이도 가능
let arr = Array(repeating: 1, count: 10)
```

## 알파벳 어레이 만들기

```swift
let aScalars = "a".unicodeScalars
let aCode = aScalars[aScalars.startIndex].value

let letters: [Character] = (0..<26).map {
    i in Character(UnicodeScalar(aCode + i)!)
}
```

## 최대공약수와 최소공배수

```swift
// 최대공약수
func gcd(_ min: Int, _ max: Int) -> Int {
    let remain = min % max
    if remain == 0 {
        return max
    }
    return gcd(max, remain)
}

// 최소공배수
func lcm(_ min: Int, _ max: Int) -> Int {
    return (min * max) / gcd(min, max) 
}
```

## String 자르기

```swift
let str = "abcdef"
str.prefix(3) // 앞에서 3개 -> "abc"
str.suffix(3) // 뒤에서 3개 -> "def"
```

## 두 값을 교환 하기 Swap

```swift
// 배열
var arr = [1, 2, 3]
arr.swapAt(1, 2) // [1, 3, 2] : 인덱스로 스왑

// 노말 변수
var val1 = 1
var val2 = 2
swap(&val1, &val2) // 2, 1
```

## Array 값 제거

```swift
// removeAll() 제외 하고 모두 제거한 값 리턴
var arr = [1, 2, 3]
arr.remove(at: 0) // [2, 3]
arr.removeFirst() // [3]

arr = [1, 2, 3]
arr.removeLast()
arr.removeAll()

var arr2 = [1, 2, 3, 4]

// arr2의 값은 변하지 않음
let arr3 = arr2.dropFirst() // [2, 3, 4]
let arr4 = arr2.dropLast()  // [1, 2, 3]
```
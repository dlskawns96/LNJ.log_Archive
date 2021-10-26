# [Swift] 유용한 Swift Code들

# 1. TextView에 Placeholder 넣기

## 1. UITextViewDelegate 사용
```swift
func setPlaceholder() {
    textView.delegate = self
    textView.text = "내용을 입력하세요."
    textView.textColor = .gray
}

func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.textColor == .gray {
        textView.text = nil
        textView.textColor = UIColor.black
    }
    
}

func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.isEmpty {
        textView.text = "내용을 입력하세요."
        textView.textColor = .gray
    }
}
```

## 2. RxSwift 사용

```swift
textView.rx.didBeginEditing
        .subscribe(onNext: { [self] in
                    if (textView.text == "내용을 입력하세요." ) {
                        textView.text = nil
                        textView.textColor = .black
                        }
                    })
                    .disposed(by: disposeBag)
        
textView.rx.didEndEditing
        .subscribe(onNext: { [self] in
                    if (textView.text == nil || textView.text == "") {
                        textView.text = "내용을 입력하세요."
                        textView.textColor = .gray
                        }
                    })
                    .disposed(by: disposeBag)
```

# 2. TextView padding 없애기

```swift
textView.textContainer.lineFragmentPadding = 0
textView.textContainerInset = .zero
```

# 3. Navigation Bar Underline 밑줄 삭제

```swift
navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
navigationController.navigationBar.shadowImage = UIImage()
```

# 4. UISearchBar 돋보기 오른쪽으로

```swift
override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    searchBar.leftView = nil
    let imageView = UIImageView(image: .searchImage)
    searchBar.searchTextField.rightView = imageView
    searchBar.searchTextField.rightViewMode = .always
}
```

# 5. Image Tint Color 적용 안될 때

```swift
let image = UIImage(named: "image_name")?.withRenderingMode(.alwaysTemplate)
```

# 6. ScrollView Scroll to Bottom 

```swift
let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.size.height)
scrollView.setContentOffset(bottomOffset, animated: true)
```


# 7. Table View frame을 contents에 맞게 (size to fit)

```swift
final class ContentSizedTableView: UITableView {
    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}

```


# 8. UIButton Alignment 정렬

```swift
button.contentHorizontalAlignment = .left
```
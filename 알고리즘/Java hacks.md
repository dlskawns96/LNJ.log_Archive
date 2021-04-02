# Java hacks

# Converting

[Convert](https://www.notion.so/Convert-21af07ef3e71495baee9106fc1511c50)

# Sorting

## String Sort

```java
String str = "java"; 
char[] arr = str.toCharArray();
Arrays.sort(arr);
String SortedString = new String(arr);
```

## array Sort

```java
int arr[] = {2, 1, 3, 5, 7};
Arrays.sort(arr);
```

## List Sort

```java
ArrayList<Integer> integerList = new ArrayList();
Collections.sort(integerList);

// 역순
Collections.sort(integerList, Collections.reverseOrder());
```
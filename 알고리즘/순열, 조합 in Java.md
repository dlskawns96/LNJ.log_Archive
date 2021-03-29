# 자바로 구현하는 순열과 조합

순열이란 서로 다른 N개에서 중복을 허락하지 않고, R개를 뽑아서 나열하는 경우를 말하고, 뽑은 항목의 순서를 고려해야 한다.
```java
public class Main {
    // 뽑은 경우를 저장하는 객체
    static List<ArrayList<Integer>> results = new ArrayList<>();
    
    public static void main(String[] args) {
        int n = 3;
        int[] arr = {1, 2, 3};
        ArrayList<Integer> output = new ArrayList<>();
        boolean[] visited = new boolean[n];
        perm(arr, output, visited, n, 3, 0);
        
        System.out.println(results);
    }

    static void perm(int[] arr, ArrayList<Integer> output, boolean[] visited, int n, int r, int depth) {

        if (depth == r) {
            // 여기서 결과를 저장하면 nPr의 결과 저장
            return;
        }

        for (int i = 0; i < n; i++) {
            if (!visited[i]) {
                output.add(arr[i]);
                visited[i] = true;
                
                //여기서 결과를 저장하면 nP1 ~ nPn 까지 모두 저장
                results.add(new ArrayList<>(output));
                
                perm(arr, output, visited, n, r, depth+1);
                visited[i] = false;
                output.remove(output.size()-1);
            }
        }
    }
}
```

조합이란 순열이란 서로 다른 N개에서 중복을 허락하지 않고, R개를 뽑아서 나열하는 경우를 말하고, 뽑은 항목의 순서를 고려할 필요 없다.

```java
static ArrayList<ArrayList<Integer>> results = new ArrayList<>();

static void combination(int[] arr, ArrayList<Integer> output, boolean[] visited, int start, int r) {
	if (r == 0) {
		return;
	}

	for (int i = start; i < arr.length; i++) {
		visited[i] = true;
		output.add(arr[i));
		results.add(output);  // r: 0부터 모든 경우의 수 넣기
		
		combination(arr, output, visited, i+1, r-1);
		visited[i] = false;
		output.remove(output.size()-1):
	}
}
```
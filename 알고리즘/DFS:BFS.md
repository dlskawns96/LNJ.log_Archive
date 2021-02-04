# DFS / BFS

> 하나의 노드에서 시작하여 그래프의 모든 노드를 탐색(방문)하는 방법

## DFS (Depth-First Search) - 깊이 우선 탐색

탐색을 시작한 노드에서 해당 분기의 가장 깊숙한 곳까지 탐색을 한 후 다음 분기로 넘어가는 방식으로 탐색하는 방법


<img width="500" src="https://upload.wikimedia.org/wikipedia/commons/7/7f/Depth-First-Search.gif">

> DFS 동작 순서

### DFS 구현

1. 스택에 탐색을 시작할 노드(루트 노드)를 넣고 방문 처리를 한다.
2. 스택의 최상단 노드에 방문하지 않은 인접 노드가 있으면 해당 인접 노드를 스택에 넣고 방문 처리를 한다.
3. 방문하지 않은 인접 노드가 없다면 스택에서 최상단 노드를 꺼낸다.
4. 모든 노드를 방문할 때 까지 2, 3을 반복한다.

<img width="725" alt="스크린샷 2021-02-04 오후 2 17 31" src="https://user-images.githubusercontent.com/22260098/106848154-b8e47c80-66f3-11eb-8e5e-cfd067c03c68.png">

### DFS 파이썬 코드

```python
graph = [
    [],
    [2, 5, 9],
    [1, 3],
    [2, 4],
    [3],
    [1, 6, 8],
    [5, 7],
    [6],
    [5],
    [1, 10],
    [9]]

visited = [False] * len(graph)

def dfs(graph, vertex, visited):
    visited[vertex] = True  # 현재 노드 방문 처리
    print(vertex, end=' ')

    for v in graph[vertex]: # 인접 노드 탐색
        if not visited[v]:
            dfs(graph, v, visited) # 재귀 호출 (스택)

dfs(graph, 1, visited) # 1 2 3 4 5 6 7 8 9 10
```

<hr>

## BFS (Breadth-First Search) - 너비 우선 탐색

현재 노드에서 가까운 노드부터 탐색하는 방법

<img height="500" src="https://blog.kakaocdn.net/dn/bLMK90/btqKrJ9aUXI/hvWf1krFJb6R0WlIKx1Vk0/img.gif">

> BFS 동작 순서

### BFS 구현

1. 큐에 탐색을 시작할 노드(루트 노드)를 삽입하고 방문 처리 한다.
2. 큐에서 노드를 꺼내, 해당 노드의 인접 노드 중에서 방문하지 않은 노드를 모두 큐에 삽입하고 방문 처리 한다.
3. 모든 노드를 탐색할 때까지 2를 반복 한다.

### BFS 파이썬 코드

```python
from collections import deque

graph = [
    [],
    [2, 3, 4],
    [1, 5],
    [1, 6, 7],
    [1, 8],
    [2, 9],
    [3, 10],
    [3],
    [4],
    [5],
    [6]
]

visited = [False] * len(graph)

def bfs(graph, vertex, visited):
    queue = deque([vertex])
    visited[vertex] = True
    
    while queue:  # 큐가 빌 때까지 반복
        current_vertex = queue.popleft() # 가장 앞에 있는 노드 제거
        print(current_vertex, end=' ')  
        
        for v in graph[current_vertex]:  # 해당 노드의 인접 노드 검사
            if not visited[v]:           # 방문하지 않은 인접 노드는 큐에 추가
                queue.append(v)
                visited[v] = True
        
bfs(graph, 1, visited)  # 1 2 3 4 5 6 7 8 9 10
```
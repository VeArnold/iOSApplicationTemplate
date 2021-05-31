# AppTemplate

이 프로젝트는 Tuist를 이용하여 각 프로젝트를 모듈로 구성하는 형태입니다.

## 사용법

1. [Tuist 설치](https://github.com/tuist/tuist) - 버전 1.43.0 이

2. [Carthage 설치](https://github.com/Carthage/Carthage) - 버전 0.38.0 이상

3. `tuist dependencies`를 실행하여 XCFramework 생성

```
$ tuist dependencies fetch
Resolving and fetching dependencies.
Resolving and fetching Carthage dependencies.
...
Carthage dependencies resolved and fetched successfully.
Dependencies resolved and fetched successfully.
```

4. `tuist generate`를 실행하여 프로젝트 파일 생성

```
$ tuist generate
```
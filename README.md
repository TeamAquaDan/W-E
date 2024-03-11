# Git

- ssafy git lab

## Branch Convention

- `master` : 배포할 완성 프로젝트 브랜치

- `develop` : 개발 완료한 기능(feature)을 통합하는 브랜치

- `deploy/~~` : 배포, CI/CD 파일을 업로드 하는 브랜치

- `feature/~~` : 기능 단위로 개발을 진행하는 브랜치

  - `be/feature/~~` : 백엔드
  - `fe/feature/~~` : 프론트엔드

- `document`: 개발 외 산출물 등을 업로드 하는 브랜치

## Commit Convention

### 정의

- commit message에 대한 약속

### 구조

[commit type]: [commit message]
[description]

ex)
Init: 스프링 프로젝트 설정
스프링부트 프로젝트 생성 및 의존성 설정

```
commit type -> 커밋의 성격

commit message -> 작업한 내용의 제목

jira issue number -> 지라에 등록한 이슈의 번호

description(생략 가능) -> 추가적인 설명

cmd) git commit -m "Init: 스프링 프로젝트 설정 #1" -m "스프링부트 프로젝트 생성 및 의존성 설정"
```

### Commit Type

- `Init: ` : 프로젝트 초기 생성

- `Feat: ` : 새로운 기능 추가

- `Fix: ` : 버그 수정 또는 typo

- `Design: ` : CSS 등 사용자 UI 디자인 변경

- `Comment: ` : 필요한 주석 추가 및 변경

- `Refactor: ` : 리팩토링

- `Rename: ` : 파일 혹은 폴더명 수정하거나 이동

- `Remove: ` : 파일 삭제

- `Style: ` : 코드 포맷팅, 세미콜론 누락, 코드 변경이 없는 경우

- `Test: ` : 테스트(테스트 코드 추가, 수정, 삭제, 비즈니스 로직에 변경이 없는 경우)

- `Chore: `: 위와 일치하지 않는 기타 변경사항(빌드 스크립트 수정, assets image, 패키지 매니저 등)

- `Document: `: 산출물 및 자료

### Commit Message

- 작업한 내용을 간결하게 설명
- 마침표와 특수 문자를 사용하지 않는다.
- Type 제외 한국어로 작성

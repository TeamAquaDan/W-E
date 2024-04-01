# 🐳 WhaleBank: W-E
<img src="./docs/img/whale1.png" alt="whale1" width="200" height="200">
<img src="./docs/img/whale2.png" alt="whale2" width="200" height="200">

#### 10대 청소년을 위한 금융 관리 앱

</br>

## 🕞 프로젝트 진행 기간
**2024.02.26 ~ 2024.04.04** (6주)

<br>

# 🐋 W-E
10대들의 금융 이해력이 낮다는 기사를 접한 적이 있으신가요?
전문가들은 입을 모아 금융 교육의 필요성을 강조하고 있습니다.

다소 딱딱하고 지루할 수 있는 자산 관리, 조금 더 **쉽게** 다가가겠습니다.
W-E와 함께 **자산 관리를 시작해볼까요?** 

고객님들의 첫 자산 관리 경험을 돕고, 앞으로 모든 금융 생활에 **Whale Bank**가 함께하겠습니다.

<br>

## 💬 주요 기능


<br>

## 📱 서비스 화면

<br>
<br>

## 👩‍💻 개발 환경

<a name="item-three"></a>

|일정관리|형상관리|커뮤니케이션|디자인|
|:---:|:---:|:---:|:---:|
| ![JIRA](https://img.shields.io/badge/jira-0052CC?style=for-the-badge&logo=jirasoftware&logoColor=white) | ![GITLAB](https://img.shields.io/badge/gitlab-FC6D26?style=for-the-badge&logo=gitlab&logoColor=white) | ![EXCEL](https://img.shields.io/badge/googlesheets-34A853?style=for-the-badge&logo=notion&logoColor=white) | ![Figma](https://img.shields.io/badge/figma-%23F24E1E.svg?style=for-the-badge&logo=figma&logoColor=white) |



<br>


#### IDE

![VSCode](https://img.shields.io/badge/VisualStudioCode-007ACC?style=for-the-badge&logo=VisualStudioCode&logoColor=white) ![IntelliJ](https://img.shields.io/badge/intellijidea-000000?style=for-the-badge&logo=intellijidea&logoColor=white)

<br>


#### Frontend



<br>


#### Backend

![Java](https://img.shields.io/badge/java-%23ED8B00.svg?style=for-the-badge&logo=openjdk&logoColor=white)  
![SpringBoot](https://img.shields.io/badge/springboot-6DB33F?style=for-the-badge&logo=springboot&logoColor=white) ![JWT](https://img.shields.io/badge/JWT-black?style=for-the-badge&logo=JSON%20web%20tokens) ![SpringSecurity](https://img.shields.io/badge/springsecurity-6DB33F?style=for-the-badge&logo=springsecurity&logoColor=white)  
![AmazonS3](https://img.shields.io/badge/AmazonS3-569A31?style=for-the-badge&logo=AmazonS3&logoColor=white) ![mysql](https://img.shields.io/badge/mysql-4479A1?style=for-the-badge&logo=mysql&logoColor=white)  

<br>

#### DevOPS

![docker](https://img.shields.io/badge/docker-2496ED?style=for-the-badge&logo=docker&logoColor=white) ![Jenkins](https://img.shields.io/badge/Jenkins-D24939?style=for-the-badge&logo=Jenkins&logoColor=white) ![nginx](https://img.shields.io/badge/nginx-009639?style=for-the-badge&logo=nginx&logoColor=white) ![amazonec2](https://img.shields.io/badge/amazonec2-FF9900?style=for-the-badge&logo=amazonec2&logoColor=white)

<br>

## 🏢 아키텍처


## 📂 프로젝트 파일 구조

<details>
<summary><b>FrontEnd</b></summary>

```

```

</details>

<details>
<summary><b>BackEnd</b></summary>

```
📦backend
 ┣ 📂domain
 ┃ ┣ 📂account
 ┃ ┃ ┣ 📂controller
 ┃ ┃ ┃ ┗ 📜AccountController.java
 ┃ ┃ ┣ 📂dto
 ┃ ┃ ┃ ┣ 📂request
 ┃ ┃ ┃ ┃ ┣ 📜InquiryRequestDto.java
 ┃ ┃ ┃ ┃ ┣ 📜TransactionHistoryRequestDto.java
 ┃ ┃ ┃ ┃ ┗ 📜WithdrawRequestDto.java
 ┃ ┃ ┃ ┗ 📂response
 ┃ ┃ ┃ ┃ ┣ 📜AccountDetailResponseDto.java
 ┃ ┃ ┃ ┃ ┣ 📜AccountInfoResponseDto.java
 ┃ ┃ ┃ ┃ ┣ 📜InquiryResponseDto.java
 ┃ ┃ ┃ ┃ ┗ 📜TransactionHistoryResponseDto.java
 ┃ ┃ ┗ 📂service
 ┃ ┃ ┃ ┣ 📜AccountService.java
 ┃ ┃ ┃ ┗ 📜AccountServiceImpl.java
 ┃ ┣ 📂accountbook
 ┃ ┃ ┣ 📂controller
 ┃ ┃ ┃ ┗ 📜AccountBookController.java
 ┃ ┃ ┣ 📂dto
 ┃ ┃ ┃ ┣ 📂request
 ┃ ┃ ┃ ┃ ┗ 📜AccountBookEntryRequestDto.java
 ┃ ┃ ┃ ┗ 📂response
 ┃ ┃ ┃ ┃ ┣ 📜AccountBookEntryResponseDto.java
 ┃ ┃ ┃ ┃ ┗ 📜MonthlyHistoryResponseDto.java
 ┃ ┃ ┣ 📂repository
 ┃ ┃ ┃ ┣ 📜AccountBookBulkRepository.java
 ┃ ┃ ┃ ┗ 📜AccountBookRepository.java
 ┃ ┃ ┣ 📂service
 ┃ ┃ ┃ ┣ 📜AccountBookService.java
 ┃ ┃ ┃ ┗ 📜AccountBookServiceImpl.java
 ┃ ┃ ┗ 📜AccountBookEntity.java
 ┃ ┣ 📂allowance
 ┃ ┃ ┣ 📂controller
 ┃ ┃ ┃ ┗ 📜AllowanceController.java
 ┃ ┃ ┣ 📂dto
 ┃ ┃ ┃ ┣ 📂request
 ┃ ┃ ┃ ┃ ┣ 📜AddGroupRequestDto.java
 ┃ ┃ ┃ ┃ ┣ 📜UpdateAllowanceRequestDto.java
 ┃ ┃ ┃ ┃ ┗ 📜UpdateNicknameRequestDto.java
 ┃ ┃ ┃ ┗ 📂response
 ┃ ┃ ┃ ┃ ┣ 📜AllowanceInfoResponseDto.java
 ┃ ┃ ┃ ┃ ┣ 📜ChildrenDetailResponseDto.java
 ┃ ┃ ┃ ┃ ┣ 📜ChildrenInfoResponseDto.java
 ┃ ┃ ┃ ┃ ┗ 📜GroupInfoResponseDto.java
 ┃ ┃ ┣ 📂repository
 ┃ ┃ ┃ ┣ 📜AutoPaymentRepository.java
 ┃ ┃ ┃ ┣ 📜GroupRepository.java
 ┃ ┃ ┃ ┗ 📜RoleRepository.java
 ┃ ┃ ┣ 📂service
 ┃ ┃ ┃ ┣ 📜AllowanceService.java
 ┃ ┃ ┃ ┣ 📜AllowanceServiceImpl.java
 ┃ ┃ ┃ ┗ 📜AutoPaymentUtils.java
 ┃ ┃ ┣ 📜AutoPaymentEntity.java
 ┃ ┃ ┣ 📜GroupEntity.java
 ┃ ┃ ┗ 📜RoleEntity.java
 ┃ ┣ 📂dutchpay
 ┃ ┃ ┣ 📂controller
 ┃ ┃ ┃ ┗ 📜DutchpayController.java
 ┃ ┃ ┣ 📂dto
 ┃ ┃ ┃ ┣ 📂request
 ┃ ┃ ┃ ┃ ┣ 📜DutchpayRoomRequestDto.java
 ┃ ┃ ┃ ┃ ┣ 📜PaymentRequestDto.java
 ┃ ┃ ┃ ┃ ┣ 📜RegisterPaymentRequestDto.java
 ┃ ┃ ┃ ┃ ┗ 📜SelfDutchpayRequestDto.java
 ┃ ┃ ┃ ┗ 📂response
 ┃ ┃ ┃ ┃ ┣ 📜DutchpayDetailResponseDto.java
 ┃ ┃ ┃ ┃ ┣ 📜DutchpayRoomResponseDto.java
 ┃ ┃ ┃ ┃ ┗ 📜PaymentResponseDto.java
 ┃ ┃ ┣ 📂repository
 ┃ ┃ ┃ ┣ 📜CategoryCalculateRepository.java
 ┃ ┃ ┃ ┣ 📜DutchpayRepository.java
 ┃ ┃ ┃ ┣ 📜DutchpayRoomRepository.java
 ┃ ┃ ┃ ┗ 📜SelectedPaymentRepository.java
 ┃ ┃ ┣ 📂service
 ┃ ┃ ┃ ┣ 📜DutchpayService.java
 ┃ ┃ ┃ ┗ 📜DutchpayServiceImpl.java
 ┃ ┃ ┣ 📜CategoryCalculateEntity.java
 ┃ ┃ ┣ 📜DutchpayEntity.java
 ┃ ┃ ┣ 📜DutchpayRoomEntity.java
 ┃ ┃ ┗ 📜SelectedPaymentEntity.java
 ┃ ┣ 📂friend
 ┃ ┃ ┣ 📂controller
 ┃ ┃ ┃ ┗ 📜FriendController.java
 ┃ ┃ ┣ 📂dto
 ┃ ┃ ┃ ┣ 📂request
 ┃ ┃ ┃ ┃ ┣ 📜FriendManageRequestDto.java
 ┃ ┃ ┃ ┃ ┗ 📜UpdateFriendNicknameRequestDto.java
 ┃ ┃ ┃ ┗ 📂response
 ┃ ┃ ┃ ┃ ┣ 📜FriendManageResponseDto.java
 ┃ ┃ ┃ ┃ ┣ 📜FriendResponseDto.java
 ┃ ┃ ┃ ┃ ┣ 📜PendingRequestDto.java
 ┃ ┃ ┃ ┃ ┗ 📜UpdateFriendNicknameResponseDto.java
 ┃ ┃ ┣ 📂repository
 ┃ ┃ ┃ ┣ 📜FriendRepository.java
 ┃ ┃ ┃ ┗ 📜FriendshipRepository.java
 ┃ ┃ ┣ 📂service
 ┃ ┃ ┃ ┣ 📜FriendService.java
 ┃ ┃ ┃ ┗ 📜FriendServiceImpl.java
 ┃ ┃ ┣ 📜FriendEntity.java
 ┃ ┃ ┣ 📜FriendId.java
 ┃ ┃ ┗ 📜FriendshipEntity.java
 ┃ ┣ 📂goal
 ┃ ┃ ┣ 📂controller
 ┃ ┃ ┃ ┗ 📜GoalController.java
 ┃ ┃ ┣ 📂dto
 ┃ ┃ ┃ ┣ 📂request
 ┃ ┃ ┃ ┃ ┣ 📜GoalRequestDto.java
 ┃ ┃ ┃ ┃ ┣ 📜GoalSaveRequestDto.java
 ┃ ┃ ┃ ┃ ┗ 📜GoalStatusRequestDto.java
 ┃ ┃ ┃ ┗ 📂response
 ┃ ┃ ┃ ┃ ┣ 📜GoalDetailResponseDto.java
 ┃ ┃ ┃ ┃ ┣ 📜GoalListResponseDto.java
 ┃ ┃ ┃ ┃ ┣ 📜GoalResponseDto.java
 ┃ ┃ ┃ ┃ ┣ 📜GoalSaveResponseDto.java
 ┃ ┃ ┃ ┃ ┗ 📜GoalStatusResponseDto.java
 ┃ ┃ ┣ 📂repository
 ┃ ┃ ┃ ┗ 📜GoalRepository.java
 ┃ ┃ ┣ 📂service
 ┃ ┃ ┃ ┣ 📜GoalService.java
 ┃ ┃ ┃ ┗ 📜GoalServiceImpl.java
 ┃ ┃ ┗ 📜GoalEntity.java
 ┃ ┣ 📂mission
 ┃ ┃ ┣ 📂controller
 ┃ ┃ ┃ ┗ 📜MissionController.java
 ┃ ┃ ┣ 📂dto
 ┃ ┃ ┃ ┣ 📂request
 ┃ ┃ ┃ ┃ ┣ 📜MissionCreateRequestDto.java
 ┃ ┃ ┃ ┃ ┗ 📜MissionManageRequestDto.java
 ┃ ┃ ┃ ┗ 📂response
 ┃ ┃ ┃ ┃ ┗ 📜MissionInfoResponseDto.java
 ┃ ┃ ┣ 📂repository
 ┃ ┃ ┃ ┗ 📜MissionRepository.java
 ┃ ┃ ┣ 📂service
 ┃ ┃ ┃ ┣ 📜MissionService.java
 ┃ ┃ ┃ ┗ 📜MissionServiceImpl.java
 ┃ ┃ ┗ 📜MissionEntity.java
 ┃ ┣ 📂negotiation
 ┃ ┃ ┣ 📂controller
 ┃ ┃ ┃ ┗ 📜NegotiationController.java
 ┃ ┃ ┣ 📂dto
 ┃ ┃ ┃ ┣ 📂request
 ┃ ┃ ┃ ┃ ┣ 📜NegoManageRequestDto.java
 ┃ ┃ ┃ ┃ ┗ 📜NegoRequestDto.java
 ┃ ┃ ┃ ┗ 📂response
 ┃ ┃ ┃ ┃ ┣ 📜NegoInfoResponseDto.java
 ┃ ┃ ┃ ┃ ┣ 📜NegoListResponseDto.java
 ┃ ┃ ┃ ┃ ┗ 📜NegoResponseDto.java
 ┃ ┃ ┣ 📂repository
 ┃ ┃ ┃ ┗ 📜NegotiationRepository.java
 ┃ ┃ ┣ 📂service
 ┃ ┃ ┃ ┣ 📜NegotiationService.java
 ┃ ┃ ┃ ┗ 📜NegotiationServiceImpl.java
 ┃ ┃ ┗ 📜NegotiationEntity.java
 ┃ ┣ 📂notification
 ┃ ┃ ┣ 📂controller
 ┃ ┃ ┃ ┗ 📜NotiController.java
 ┃ ┃ ┣ 📂dto
 ┃ ┃ ┃ ┣ 📂request
 ┃ ┃ ┃ ┃ ┗ 📜FCMRequestDto.java
 ┃ ┃ ┃ ┗ 📂response
 ┃ ┃ ┃ ┃ ┗ 📜NotiResponseDto.java
 ┃ ┃ ┣ 📂repository
 ┃ ┃ ┃ ┗ 📜NotiRepository.java
 ┃ ┃ ┣ 📂service
 ┃ ┃ ┃ ┣ 📜FcmUtils.java
 ┃ ┃ ┃ ┣ 📜NotiService.java
 ┃ ┃ ┃ ┗ 📜NotiServiceimpl.java
 ┃ ┃ ┣ 📜FCMCategory.java
 ┃ ┃ ┗ 📜NotificationEntity.java
 ┃ ┗ 📂user
 ┃ ┃ ┣ 📂controller
 ┃ ┃ ┃ ┣ 📜AuthController.java
 ┃ ┃ ┃ ┗ 📜UserController.java
 ┃ ┃ ┣ 📂dto
 ┃ ┃ ┃ ┣ 📂request
 ┃ ┃ ┃ ┃ ┣ 📜GuestBookRequestDto.java
 ┃ ┃ ┃ ┃ ┣ 📜LoginRequestDto.java
 ┃ ┃ ┃ ┃ ┣ 📜RegisterMainAccountRequestDto.java
 ┃ ┃ ┃ ┃ ┣ 📜SignUpRequestDto.java
 ┃ ┃ ┃ ┃ ┣ 📜UpdatePasswordRequestDto.java
 ┃ ┃ ┃ ┃ ┗ 📜VerifyRequestDto.java
 ┃ ┃ ┃ ┗ 📂response
 ┃ ┃ ┃ ┃ ┣ 📜LoginResponseDto.java
 ┃ ┃ ┃ ┃ ┣ 📜ProfileImageResponseDto.java
 ┃ ┃ ┃ ┃ ┣ 📜ProfileImgResponseDto.java
 ┃ ┃ ┃ ┃ ┣ 📜ProfileResponseDto.java
 ┃ ┃ ┃ ┃ ┣ 📜ReissueResponseDto.java
 ┃ ┃ ┃ ┃ ┣ 📜StatisticsResponseDto.java
 ┃ ┃ ┃ ┃ ┣ 📜TokenResponseDto.java
 ┃ ┃ ┃ ┃ ┗ 📜VerifyResponseDto.java
 ┃ ┃ ┣ 📂repository
 ┃ ┃ ┃ ┣ 📜AuthRepository.java
 ┃ ┃ ┃ ┣ 📜GuestBookRepository.java
 ┃ ┃ ┃ ┗ 📜ProfileRepository.java
 ┃ ┃ ┣ 📂security
 ┃ ┃ ┃ ┣ 📜CustomUserDetailsService.java
 ┃ ┃ ┃ ┣ 📜JwtAuthenticationFilter.java
 ┃ ┃ ┃ ┣ 📜JwtExceptionFilter.java
 ┃ ┃ ┃ ┗ 📜JwtService.java
 ┃ ┃ ┣ 📂service
 ┃ ┃ ┃ ┣ 📜AuthService.java
 ┃ ┃ ┃ ┣ 📜AuthServiceImpl.java
 ┃ ┃ ┃ ┣ 📜UserService.java
 ┃ ┃ ┃ ┗ 📜UserServiceImpl.java
 ┃ ┃ ┣ 📜GuestBookEntity.java
 ┃ ┃ ┣ 📜ProfileEntity.java
 ┃ ┃ ┣ 📜Role.java
 ┃ ┃ ┗ 📜UserEntity.java
 ┣ 📂global
 ┃ ┣ 📂config
 ┃ ┃ ┣ 📜FirebaseConfig.java
 ┃ ┃ ┣ 📜OpenFeignConfig.java
 ┃ ┃ ┣ 📜RedisConfig.java
 ┃ ┃ ┣ 📜S3Config.java
 ┃ ┃ ┣ 📜SecurityConfig.java
 ┃ ┃ ┣ 📜SwaggerConfig.java
 ┃ ┃ ┗ 📜WebConfig.java
 ┃ ┣ 📂exception
 ┃ ┃ ┣ 📜CustomException.java
 ┃ ┃ ┣ 📜GlobalExceptionHandler.java
 ┃ ┃ ┗ 📜JwtException.java
 ┃ ┣ 📂openfeign
 ┃ ┃ ┣ 📂bank
 ┃ ┃ ┃ ┣ 📂request
 ┃ ┃ ┃ ┃ ┣ 📜AccountIdRequestDto.java
 ┃ ┃ ┃ ┃ ┣ 📜CheckUserRequestDto.java
 ┃ ┃ ┃ ┃ ┣ 📜DepositRequest.java
 ┃ ┃ ┃ ┃ ┣ 📜InquiryRequest.java
 ┃ ┃ ┃ ┃ ┣ 📜ParkingRequest.java
 ┃ ┃ ┃ ┃ ┣ 📜ReissueRequestDto.java
 ┃ ┃ ┃ ┃ ┣ 📜TransactionRequest.java
 ┃ ┃ ┃ ┃ ┣ 📜VerifyRequestDto.java
 ┃ ┃ ┃ ┃ ┗ 📜WithdrawRequest.java
 ┃ ┃ ┃ ┣ 📂response
 ┃ ┃ ┃ ┃ ┣ 📜AccessTokenResponseDto.java
 ┃ ┃ ┃ ┃ ┣ 📜AccountDetailResponse.java
 ┃ ┃ ┃ ┃ ┣ 📜AccountListResponseDto.java
 ┃ ┃ ┃ ┃ ┣ 📜CheckUserResponseDto.java
 ┃ ┃ ┃ ┃ ┣ 📜DepositResponse.java
 ┃ ┃ ┃ ┃ ┣ 📜InquiryResponse.java
 ┃ ┃ ┃ ┃ ┣ 📜ParkingBalanceResponse.java
 ┃ ┃ ┃ ┃ ┣ 📜ReissueResponseDto.java
 ┃ ┃ ┃ ┃ ┣ 📜TransactionResponse.java
 ┃ ┃ ┃ ┃ ┣ 📜VerifyResponseDto.java
 ┃ ┃ ┃ ┃ ┗ 📜WithdrawResponse.java
 ┃ ┃ ┃ ┣ 📜BankAccessUtil.java
 ┃ ┃ ┃ ┗ 📜BankClient.java
 ┃ ┃ ┗ 📂card
 ┃ ┃ ┃ ┣ 📂request
 ┃ ┃ ┃ ┃ ┗ 📜CardHistoryRequest.java
 ┃ ┃ ┃ ┣ 📂response
 ┃ ┃ ┃ ┃ ┗ 📜CardHistoryResponse.java
 ┃ ┃ ┃ ┣ 📜CardAccessUtil.java
 ┃ ┃ ┃ ┗ 📜CardClient.java
 ┃ ┣ 📂response
 ┃ ┃ ┣ 📜ApiResponse.java
 ┃ ┃ ┗ 📜ResponseCode.java
 ┃ ┗ 📂utils
 ┃ ┃ ┗ 📜EncryptionUtils.java
 ┣ 📂test
 ┃ ┣ 📜TestController.java
 ┃ ┣ 📜TestEntity.java
 ┃ ┣ 📜TestRepository.java
 ┃ ┗ 📜TestService.java
 ┣ 📜.DS_Store
 ┗ 📜BackendApplication.java
```

</details>

## 📑 프로젝트 산출물
- [기능 명세서](./document/기능명세서.pdf)
- [API 명세서](./docs/API명세서.pdf)
- [와이어프레임](./docs/와이어프레임.pdf)
- [ER Diagram](./docs/erd.png)
- [UCC](./docs/ploud_ucc.mp4)
- [포팅메뉴얼](./PortingManual.md)


## 👨‍👨‍👧👨‍👨‍👧 팀원
|박나린|김가영|신현중|유영준|윤태우|이재진|
|:---:|:---:|:---:|:---:|:---:|:---:|
| <img src="./docs/member/rin.jpg" style="height: 100px"> | <img src="./docs/member/kky.jpg" style="height: 100px"> | <img src="./docs/member/kky.jpg" style="height: 100px"> | <img src="./docs/member/yyj.jpg" style="height: 100px"> | <img src="./docs/member/ytw.jpg" style="height: 100px"> | <img src="./docs/member/kky.jpg" style="height: 100px"> |
| Backend <br/>| BankEnd <br/> | FrontEnd <br/>  | FrontEnd <br/>  | Frontend <br/>  | CI/CD <br/> 챗봇 |
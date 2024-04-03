## 1. 개발환경

|Tech|Stack|Version|
|:---:|:---:|:---:|
|웹 서버|Nginx|1.18.0(Ubuntu)|
|WAS|Tomcat||
|**FrontEnd**|Flutter|3.19.2|
||Firebase|10.4.10|
|**BackEnd**|OpenJDK|17|
||SpringBoot|3.2.2|
||Gradle|8.5|


## 2. 설정파일 및 환경 변수
**W-E**
```bash
spring.application.name=Backend
# DB
# jdbc Driver / url / username / password
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
spring.datasource.url=jdbc:mysql://j10e103.p.ssafy.io:59152/we?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Seoul&zeroDateTimeBehavior=convertToNull&rewriteBatchedStatements=true&useSSL=false&allowPublicKeyRetrieval=true
spring.datasource.username=root
spring.datasource.password=*******
# JPA
spring.jpa.hibernate.ddl-auto=update
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQL8Dialect
#spring.jpa.properties.hibernate.show_sql=true
#spring.jpa.properties.hibernate.format_sql=true
logging.level.org.hibernate.type.descriptor.sql=trace
# JWT
spring.jwt.secret=bmiiofjnawesdiokjlvpqmzrmoserdlkjlaeitejmpoaegdfxjgifmog
spring.jwt.refreshTokenExpiration=1209600000
spring.jwt.accessTokenExpiration=3600000
# Redis
spring.data.redis.host=j10e103.p.ssafy.io
spring.data.redis.port={port}
spring.data.redis.password=*******
whale.bank.url=http://j10e103.p.ssafy.io:{port}
whale.card.url=http://j10e103.p.ssafy.io:{port}
# S3
cloud.aws.credentials.accessKey=AKIA6GBMGSEIOHCUT3JG
cloud.aws.credentials.secretKey=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
cloud.aws.region.static=ap-northeast-2
cloud.aws.s3.bucket=whale-we
spring.servlet.multipart.max-file-size=500MB
spring.servlet.multipart.max-request-size=500MB
```
**WhaleBank**
```bash
spring.application.name=WhaleBank
# DB
# jdbc Driver / url / username / password
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
spring.datasource.url=jdbc:mysql://j10e103.p.ssafy.io:59153/whalebank?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Seoul&zeroDateTimeBehavior=convertToNull&rewriteBatchedStatements=true&useSSL=false&allowPublicKeyRetrieval=true
spring.datasource.username=root
spring.datasource.password=*******
# JPA
spring.jpa.hibernate.ddl-auto=update
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQL8Dialect
spring.jpa.properties.hibernate.show_sql=true
spring.jpa.properties.hibernate.format_sql=true
logging.level.org.hibernate.type.descriptor.sql=trace
# JWT
spring.jwt.secret=bmiiofjnawesdiokjlvmoisopdefkjrmsbixdfojmpoaegdfxjgifmogjfioga
spring.jwt.refreshTokenExperation=60480000000
spring.jwt.accessTokenExperation=8640000000
```

**WhaleCard**
```bash
spring.application.name=WhaleCard

# DB
# jdbc Driver / url / username / password
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
spring.datasource.url=jdbc:mysql://j10e103.p.ssafy.io:59154/whalecard?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Seoul&zeroDateTimeBehavior=convertToNull&rewriteBatchedStatements=true&useSSL=false&allowPublicKeyRetrieval=true
spring.datasource.username=root
spring.datasource.password=*******
# JPA
spring.jpa.hibernate.ddl-auto=update
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQL8Dialect
spring.jpa.properties.hibernate.show_sql=true
spring.jpa.properties.hibernate.format_sql=true
logging.level.org.hibernate.type.descriptor.sql=trace
# JWT
spring.jwt.secret=bmiiofjnawesdiokjlvmoisopdefkjrmsbixdfojmpoaegdfxjgifmogjfioga
spring.jwt.refreshTokenExperation=604800000
spring.jwt.accessTokenExperation=86400000
```

## 3. 배포 시 특이사항 기재

### A. Letsencrypt 인증서 발급

### B. Nginx conf 

**nginx.conf**
```bash
server {
        server_name     j10e103.p.ssafy.io;

        listen          443 ssl;

        ssl_certificate         /etc/letsencrypt/live/j10e103.p.ssafy.io/fullchain.pem;
        ssl_certificate_key     /etc/letsencrypt/live/j10e103.p.ssafy.io/privkey.pem;

        location /api {
                proxy_pass      http://localhost:{port};
        }
        
        location /fastapi {
                proxy_pass      http://localhost:{port};
        }
        error_page      500 502 503 504         /50x.html;
        location =      /50x.html {
                root    /usr/share/nginx/html;
        }
    }

```


### C. Docker

✅ EC2에 Docker 설치

✅ Docker Hub Login

### D. MySQL Container

✅ Docker Hub에서 MySQL 이미지 pull  
```$ docker pull mysql:8.0.35```

✅ MySQL Container 실행  
```$ docker run -d -p {외부포트}:{내부포트} --name mysql_we mysql:8.0.35```  
```$ docker run -d -p {외부포트}:{내부포트} --name mysql_bank mysql:8.0.35```  
```$ docker run -d -p {외부포트}:{내부포트} --name mysql_card mysql:8.0.35```  


### E. Jenkins Container

✅ Docker Hub에서 Jenkins 이미지 pull  
```$ docker pull jenkins/jenkins:latest```

✅ Jenkins Container 실행  
```$ docker run -d -p {외부포트}:{내부포트} -v /jenkins:/var/jenkins_home -v /usr/bin/docker:/usr/bin/docker -v /var/run/docker.sock:/var/run/docker.sock jenkin/jenkins:latest```

젠킨스 컨테이너가 도커를 사용할 수 있도록 볼륨 설정

### F. CI/CD

Docker Image를 build 할 때, BE 실행

- **W-E**
```Docker
# w-e Docker file
# 1단계: 애플리케이션 빌드
FROM gradle:8.6-jdk17 AS build
WORKDIR /app

# Gradle 빌드에 필요한 파일들 복사
COPY build.gradle settings.gradle /app/
COPY src /app/src

# 빌드 수행
RUN gradle build -x test --parallel --continue

# 2단계: 실행 가능한 JAR 파일 빌드
FROM openjdk:17

# 서울 시간대로 설정
ENV TZ=Asia/Seoul

# 이전 단계에서 빌드된 JAR 파일을 복사
COPY --from=build /app/build/libs/*.jar /app/
RUN ls -al /app

# 애플리케이션 실행
ENTRYPOINT ["java","-jar","/app/Backend-0.0.1-SNAPSHOT.jar"]
```
- **WhaleBank**
```Docker
# WhaleBank Docker file
# 1단계: 애플리케이션 빌드
FROM gradle:8.6-jdk17 AS build
WORKDIR /app

# Gradle 빌드에 필요한 파일들 복사
COPY build.gradle settings.gradle /app/
COPY src /app/src

# 빌드 수행
RUN gradle build -x test --parallel --continue

# 2단계: 실행 가능한 JAR 파일 빌드
FROM openjdk:17

# 서울 시간대로 설정
ENV TZ=Asia/Seoul

# 이전 단계에서 빌드된 JAR 파일을 복사
COPY --from=build /app/build/libs/*.jar /app/
RUN ls -al /app

# 애플리케이션 실행
ENTRYPOINT ["java","-jar","/app/WhaleBank-0.0.1-SNAPSHOT.jar"]
```
- **WhaleCard**
```Docker
# WhaleCard Docker file
# 1단계: 애플리케이션 빌드
FROM gradle:8.6-jdk17 AS build
WORKDIR /app

# Gradle 빌드에 필요한 파일들 복사
COPY build.gradle settings.gradle /app/
COPY src /app/src

# 빌드 수행
RUN gradle build -x test --parallel --continue

# 2단계: 실행 가능한 JAR 파일 빌드
FROM openjdk:17

# 이전 단계에서 빌드된 JAR 파일을 복사
COPY --from=build /app/build/libs/*.jar /app/
RUN ls -al /app

# 애플리케이션 실행
ENTRYPOINT ["java","-jar","/app/WhaleCard-0.0.1-SNAPSHOT.jar"]
```
- **WhaleChat**
```Docker
# Python 이미지를 기반으로 설정
FROM python:3.10.10

# 작업 디렉토리 설정
WORKDIR /app

# 필요한 패키지 설치 (OpenCV 의존성 포함)
RUN apt-get update

# 의존성 파일 복사 및 설치
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 애플리케이션 코드 복사
COPY . .

# 컨테이너가 시작될 때 실행될 명령
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "port"]

```



Jenkins PipeLine을 이용해 자동배포  
EC2에 설치한 ffmpeg 실행파일 사용을 위해 볼륨 설정 

```Jenkinsfile
pipeline {
    agent any

    environment {
        HOME_PATH = '/home/ubuntu'
    }

    stages {
        // 빌드
        stage('Build Service') {
            steps {
                echo 'Building Service'
                // 백엔드 소스코드가 있는 경로로 이동
                dir('Backend') {
                    // Docker 이미지 빌드 명령어
                    sh 'docker build -t service .'
                }
            }
        }
        stage('Build WhaleBank') {
            steps {
                echo 'Building WhaleBank'
                // 백엔드 소스코드가 있는 경로로 이동
                dir('WhaleBank') {
                    // Docker 이미지 빌드 명령어
                    sh 'docker build -t bank .'
                }
            }
        }
        stage('Build WhaleCard') {
            steps {
                echo 'Building WhaleCard'
                // 백엔드 소스코드가 있는 경로로 이동
                dir('WhaleCard') {
                    // Docker 이미지 빌드 명령어
                    sh 'docker build -t card .'
                }
            }
        }
        stage('Build WhaleChat'){
            steps {
                echo 'Building WhaleChat'
                dir('WhaleChat') {
                    sh 'docker build -t chat .'
                }
            }
        }

        // 테스트
        stage('Test') {
            steps {
                // 테스트 관련 작업을 여기에 추가
                echo 'Test는 일단 패스'
            }
        }


        // 배포
        stage('Deploy Service') {
            steps {
                // 배포 관련 작업을 여기에 추가
                echo 'Deploying Service...'
                // 빌드가 진행되면 기존의 컨테이너 중지 및 제거 & 컨테이너가 없어도 실패하지 않고계속 수행
                sh 'docker stop service || true'
                sh 'docker rm service || true'
                // 백엔드 이미지 실행
                sh 'docker run -d -p 외부포트:내부포트 --name service service'
            }
        }
        stage('Deploy Bank') {
            steps {
                // 배포 관련 작업을 여기에 추가
                echo 'Deploying Bank...'
                // 빌드가 진행되면 기존의 컨테이너 중지 및 제거 & 컨테이너가 없어도 실패하지 않고계속 수행
                sh 'docker stop bank || true'
                sh 'docker rm bank || true'
                // 백엔드 이미지 실행
                sh 'docker run -d -p 외부포트:내부포트 --name bank bank'
            }
        }
        stage('Deploy Card') {
            steps {
                // 배포 관련 작업을 여기에 추가
                echo 'Deploying Card...'
                // 빌드가 진행되면 기존의 컨테이너 중지 및 제거 & 컨테이너가 없어도 실패하지 않고계속 수행
                sh 'docker stop card || true'
                sh 'docker rm card || true'
                // 백엔드 이미지 실행
                sh 'docker run -d -p 외부포트:내부포트 --name card card'
            }
        }
        stage('Deploy WhaleChat') {
            steps {
                // 배포 관련 작업을 여기에 추가
                echo 'Deploying WhaleChat...'
                // 빌드가 진행되면 기존의 컨테이너 중지 및 제거 & 컨테이너가 없어도 실패하지 않고계속 수행
                sh 'docker stop chat || true'
                sh 'docker rm chat || true'
                // 백엔드 이미지 실행
                sh 'docker run -d -p 외부포트:내부포트 -v /home/ubuntu/we_model/we_model:/app/model --name chat chat'
            }
        }
    }
}

```
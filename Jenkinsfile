pipeline {
    agent any

    environment {
        HOME_PATH = '/home/ubuntu'
    }

    stages {
        // stage('Build WhaleChat'){
        //     steps {
        //         echo 'Building WhaleChat'
        //         dir('WhaleChat') {
        //             sh 'docker build -t chat .'
        //         }
        //     }
        // }

        // stage('Deploy WhaleChat') {
        //     steps {
        //         // 배포 관련 작업을 여기에 추가
        //         echo 'Deploying WhaleChat...'
        //         // 빌드가 진행되면 기존의 컨테이너 중지 및 제거 & 컨테이너가 없어도 실패하지 않고계속 수행
        //         sh 'docker stop chat || true'
        //         sh 'docker rm chat || true'
        //         // 백엔드 이미지 실행
        //         sh 'docker run -d -p 8000:8000 -v /home/ubuntu/we_model/we_model:/app/model --name chat chat'
        //     }
        // }
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
                sh 'docker run -d -p 56143:8080 --name service service'
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
                sh 'docker run -d -p 58938:8080 --name bank bank'
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
                sh 'docker run -d -p 62347:8080 --name card card'
            }
        }
    }
}

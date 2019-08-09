# Sonarqube
ここでは、Sonarqubeの環境構築を行うための構築手順を記載する。

## run docker-compose
```
docker-compose up -d
```

## Install sonar scanner for mac
ソースコードの解析を行うツール
以下のページにあるURLから対応するOSのものを落としましょう。
https://docs.sonarqube.org/display/SCAN/Analyzing+with+SonarQube+Scanner

```
$ wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-3.3.0.1492-macosx.zip
$ unzip sonar-scanner-cli-3.3.0.1492-macosx.zip
$ mv sonar-scanner-3.3.0.1492-macosx /etc/sonar-scanner
$ rm sonar-scanner-cli-3.3.0.1492-macosx.zip
```

## Edit sonar-scanner.properties

## Install plugin list
* Japanese Pack  
日本語翻訳用のプラグイン。英語が難しい方はどうぞ。

## Edit sonar-project.properties
```
sonar.projectKey=lambda_sample
sonar.projectName=lambda_sample
sonar.projectVersion=1.0

sonar.sources=.
sonar.exclusions=**/*_test.go,**/vendor/**
sonar.tests=.
sonar.test.inclusions=**/*_test.go
sonar.test.exclusions=**/vendor/**
```

## Run sonar-scanner
```
$ /etc/sonar-scanner/bin/sonar-scanner 
```

## docker push image to AWS ECS
vscode-remote-docker-aws用に作成しています。ない場合は、以下の内容が必要になります。

- install aws cli  
https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/cli-chap-install.html
- aws configure command
```bash
$ make build
$ make upload-aws
```

## docker push image to GCP Container Registry
vscode-remote-docker-gcp用に作成しています。ない場合は、以下の内容が必要になります。

- install Cloud SDK  
https://cloud.google.com/sdk/downloads?hl=JA
- export PROJECT_ID
```bash
$ make build
$ make upload-gcp
```

## Required
- docker  
- mac or linux

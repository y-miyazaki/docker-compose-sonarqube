# Sonarqube
ここでは、Sonarqubeの環境構築を行うための構築手順を記載する。

## run docker-compose
```
docker-compose up -d
```

## install sonar scanner for mac
ソースコードの解析を行うツール
以下のページにあるURLから対応するOSのものを落としましょう。
https://docs.sonarqube.org/display/SCAN/Analyzing+with+SonarQube+Scanner

```
$ wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-3.3.0.1492-macosx.zip
$ unzip sonar-scanner-cli-3.3.0.1492-macosx.zip
$ mv sonar-scanner-3.3.0.1492-macosx /etc/sonar-scanner
$ rm sonar-scanner-cli-3.3.0.1492-macosx.zip
```

## edit sonar-scanner.properties

## install plugin list
* Japanese Pack  
日本語翻訳用のプラグイン。英語が難しい方はどうぞ。

## edit sonar-project.properties
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

## run sonar-scanner
```
$ /etc/sonar-scanner/bin/sonar-scanner 
```

## docker push
```
$ make build env={environment}
$ make upload env={environment} profile={aws profile}
```

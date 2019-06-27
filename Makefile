#--------------------------------------------------------------
# get argument
#--------------------------------------------------------------
ifdef profile
	PROFILE=--profile $(profile)
	AWS_ID=$$( \
			aws sts get-caller-identity \
			--query 'Account' \
			--output text \
			$(PROFILE))
else
endif

ifdef region
	REGION=$(region)
else
	ifdef profile
		REGION=$$(aws configure get region $(PROFILE))
	endif
endif

#--------------------------------------------------------------
# ECR repository
#--------------------------------------------------------------
ECR_REPOSITORY=$(env)-hana-sonarqube

#--------------------------------------------------------------
# image and container name
#--------------------------------------------------------------
env:
ifdef env
	ENV=$(env)
else
	$(error env must add for make)
endif
APP_IMAGE=$(env)-hana-sonarqube
DB_IMAGE=$(env)-hana-sonarqube-db
APP_CONT=$(env)-hana-sonarqube
DB_CONT=$(env)-hana-sonarqube-db
TAG=latest

build: env
	docker build --rm -f Dockerfile -t $(APP_IMAGE) .
	docker build --rm -f DB.Dockerfile -t $(DB_IMAGE) .

run-db: env
	docker run -d -p 5432:5432 -v /var/lib/postgresql/data --env-file=config/db.env --name $(DB_CONT) $(DB_IMAGE):$(TAG)

run: env
	docker run -d -p 9000:9000 --link $(DB_CONT):db --env-file=config/local.env --name $(APP_CONT) $(APP_IMAGE):$(TAG)

upload: env
	@$$(aws ecr get-login --no-include-email --region $(REGION) $(PROFILE))
	@docker tag development-hana-sonarqube:$(TAG) $(AWS_ID).dkr.ecr.$(REGION).amazonaws.com/$(ECR_REPOSITORY):$(TAG)
	@docker push $(AWS_ID).dkr.ecr.$(REGION).amazonaws.com/$(ECR_REPOSITORY):$(TAG)

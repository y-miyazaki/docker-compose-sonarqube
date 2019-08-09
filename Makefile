#--------------------------------------------------------------
# ECR repository
#--------------------------------------------------------------
GCP_REPOSITORY=sonarqube
AWS_REPOSITORY=sonarqube

#--------------------------------------------------------------
# image and container name
#--------------------------------------------------------------
APP_IMAGE=sonarqube
DB_IMAGE=sonarqube-db
APP_CONT=sonarqube
DB_CONT=sonarqube-db
TAG=latest
EMPTY=

build:
	docker build --rm -f Dockerfile -t $(APP_IMAGE) .
	docker build --rm -f DB.Dockerfile -t $(DB_IMAGE) .

run-db:
	docker run -d -p 5432:5432 -v /var/lib/postgresql/data --env-file=config/db.env --name $(DB_CONT) $(DB_IMAGE):$(TAG)

run:
	docker run -d -p 9000:9000 --link $(DB_CONT):db --env-file=config/local.env --name $(APP_CONT) $(APP_IMAGE):$(TAG)

export-aws:
	PROFILE=--profile $(PROFILE)
	AWS_ID=$$( \
			aws sts get-caller-identity \
			--query 'Account' \
			--output text \
			$(PROFILE))
	REGION=$$(aws configure get region $(PROFILE))

upload-aws: export-aws
	@$$(aws ecr get-login --no-include-email --region $(REGION) $(PROFILE))
	@docker tag development-sonarqube:$(TAG) $(AWS_ID).dkr.ecr.$(REGION).amazonaws.com/$(AWS_REPOSITORY):$(TAG)
	@docker push $(AWS_ID).dkr.ecr.$(REGION).amazonaws.com/$(AWS_REPOSITORY):$(TAG)

upload-gcp:
# see https://cloud.google.com/container-registry/docs/pushing-and-pulling
	@gcloud auth configure-docker --quiet
	@docker tag $(APP_IMAGE) gcr.io/$(PROJECT_ID)/$(GCP_REPOSITORY)
	@docker push gcr.io/$(PROJECT_ID)/$(GCP_REPOSITORY):latest

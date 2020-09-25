#!/bin/bash
set -e

# un-comment if there are no namespaces created
oc create -f ../openshift/projects/projects.yml

# un-comment if there is no Jenkins master provisioned on the cicd ns
oc process openshift//jenkins-ephemeral | oc apply -f- -n api-cicd


oc process -f create-api.yml \
-p=SERVICE_NAME="api-versioning-service-dev" \
-p=SYSTEM_MASTER_NAMESPACE="3scale-apimanager" \
-p=SECRET_TOKEN=<CREATEONE> \
-p=PRIVATE_BASE_URL=http://api-versioning-service-web.api-dev.svc.cluster.local:8162 \
-p=PUBLIC_BASE_URL=https://dev-api-dev.apps.cluster-nyc-6b8f.nyc-6b8f.example.opentlc.com:443 \
-p=TENANT_TOKEN_SECRET=tenant-dev \
-p=SECRET_NAMESPACE=api-dev | oc apply -f -

# DEV:

oc process -f ../openshift/templates/deployment.yml \
-p=APPLICATION_NAME=api-versioning-service \
-p=APP_NAMESPACE=api-dev \
-p=BUILD_NAMESPACE=api-cicd \
-p=SA_NAMESPACE=api-cicd \
-p=READINESS_PATH="/health" \
-p=READINESS_RESPONSE=“\”status\”:\”UP\”” | oc apply -f -

# UAT:

oc process -f ../openshift/templates/deployment.yml \
-p=APPLICATION_NAME=api-versioning-service \
-p=APP_NAMESPACE=api-uat \
-p=BUILD_NAMESPACE=api-cicd \
-p=SA_NAMESPACE=api-cicd \
-p=READINESS_PATH="/health" \
-p=READINESS_RESPONSE=“\”status\”:\”UP\”” | oc apply -f -

# PROD:

oc process -f ../openshift/templates/deployment.yml \
-p=APPLICATION_NAME=api-versioning-service \
-p=APP_NAMESPACE=api-prod \
-p=BUILD_NAMESPACE=api-cicd \
-p=SA_NAMESPACE=api-cicd \
-p=READINESS_PATH="/health" \
-p=READINESS_RESPONSE=“\”status\”:\”UP\”” | oc apply -f -

# BUILD:

oc process -f ../openshift/templates/build.yml \
-p=APPLICATION_NAME=api-versioning-service \
-p=APP_NAMESPACE=api-dev \
-p=BUILD_NAMESPACE=api-cicd \
-p=SOURCE_REPOSITORY_URL="https://github.com/nauticalmike/api-versioning-operators.git" \
-p=GITLAB_TOKEN=<CREATEONE> \
-p=GITLAB_TOKEN_USERNAME=<CREATEONE> \
-p=SOURCE_REPOSITORY_REF="master" \
-p=APPLICATION_SOURCE_REPO="https://github.com/nauticalmike/api-versioning-operators.git" | oc apply -f -

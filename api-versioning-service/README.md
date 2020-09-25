# api-versioning-operators

## Assumptions
* 3scale already deployed
* Operator already deployed

## Action Items

### Operator
* Should be able to promote api through environments
* Environments should be separated by namespace
* look at https://github.com/3scale/3scale-operator

### Deploy 3scale on OpenShift 4.x
* Speak to Nicholas Masse
* See https://developers.redhat.com/blog/2019/02/25/full-api-lifecycle-management-a-primer/

### Use Cases (on 3scale)
* Create API in lower environment
* Promote API to higher environment within the same cluster
* Upgrade API through environments within the same cluster (i.e. create new minor version)
* Deploy new version of API through environments within the same cluster (i.e. create new major version)
* Rollback API
* Deprecate API
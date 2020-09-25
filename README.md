# api-versioning-operators

- Operator Changes (https://github.com/monkey1016/3scale-operator/tree/3scale-2.7-summit-operator-code-changes)
- Slides: https://docs.google.com/presentation/d/1bcB8GisAvlLE91g-QMN0c5DgLJoxcjwVVuAi9S0diDA/edit?usp=sharing

## Instructions:
* Run 3scale-operator/summit/summit-setup.sh to provision:
  - 3scale Apimanager
  - 3scale Operator
  - Namespaces
  - DEV, UAT and PROD tenants

* When the apimanager is ready run:
  - Modify the file: api-versioning-operators/playbook-cicd/applier/hosts and add your cluster hostname
  - Generate an access token to the repo where you fork this one and replace it on the file next
  - Modify the file: api-versioning-operators/playbook-cicd/applier/group_vars/seed-hosts.yml and add your token and repos
  - run the playbook: ansible-playbook -i applier/ galaxy/openshift-applier/playbooks/openshift-cluster-seed.yml --connection=local -e 'skip_version_checks=True'
  - The playbook provisions the versioned service and the cicd pipeline for it

## Action Items
* Troubleshoot further the creation of user key secrets for API usage
* Clean up the way you can create/delete API defs on 3scale using the modified operator
* Enhance the 3scale operator for day 2 or day 3 operations related to the app lifecycle taking OpenAPI specifications and providing the ability to generate mapping and error response configurations from your service to the API product specification for CICD usage following: https://github.com/3scale/3scale-operator/issues/119
* Research the apicast operator and it the feasibility to be adjusted to the same vision
* Complete more Custom Resource Definitions
* Increase flexibility of deployment options, but provide sane defaults

### TODO: Use Cases (on 3scale)
* Create API in lower environment
* Promote API to higher environment within the same cluster
* Upgrade API through environments within the same cluster (i.e. create new minor version)
* Deploy new version of API through environments within the same cluster (i.e. create new major version)
* Rollback API
* Deprecate API
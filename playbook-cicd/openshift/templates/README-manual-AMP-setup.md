# api-versioning-operators

Steps for manual APICAST setup

PRE-REQS:
* Your service deployed
* 3scale API manager (AMP) deployed in multitenant mode
* Know your cluster SDN in order to be able to access the AMP backend and for your apicast to access your service

STEPS:

1. In the master admin portal create the tenants: dev, uat and prod
2. Access the admin portal for each tenant by using the URL provided in the corresponding tenant account details :
    1. admin domain: prod-admin.apps.cluster-nyc-6b8f.nyc-6b8f.example.opentlc.com
    2. use the credentials to login when the account was created
3. In the upper right corner hit the gear button for account settings and on the left side menu expand the personal section and click in tokens
    1. create an access token just for your self-managed apicast and copy the token to be used for later
4. go to the ns where the apicast is going to be deployed and create the secret needed using the token and the tenant account domain, like:
    1. oc create secret generic apicast-configuration-url-secret --from-literal=password=https://<TOKEN>@dev-admin.apps.cluster-nyc-6b8f.nyc-6b8f.example.opentlc.com
5. In the same admin portal create a backend using the local IP of the service exposed hosting your service like:
    1. 172.30.130.119:8162
    2. make sure you include the port your service is using
6. Map the methods you want from your service and corresponding mapping rules
7. Create a product, an application plan, a developer and account for your service
8. In the integration section of your API product configure the product by using the backend, methods and metrics specified before
9. before publishing the configuration you need to deploy your apicast:
    1. go to the ns desired and run the template with parameters:
    2. oc new-app \
    3. -f apicast-gateway-template.yml \
    4. --param CONFIGURATION_URL_SECRET=apicast-configuration-url-secret \
    5. --param BACKEND_ENDPOINT_OVERRIDE=https://backend-3scale.apps.cluster-nyc-6b8f.nyc-6b8f.example.opentlc.com \
    6. --param APICAST_NAME=dev-apicast \
    7. --param DEPLOYMENT_ENVIRONMENT=production \
    8. --param CONFIGURATION_LOADER=boot \
    9. --param MANAGEMENT_API=debug \
    10. --param AMP_APICAST_IMAGE=registry.access.redhat.com/3scale-amp25/apicast-gateway
10. The template can be found in the git repo for the apicast: https://github.com/3scale/APIcast/blob/3scale-2.8.0-GA/openshift/apicast-template.yml
11. the backend URL can be found in the AMP namespace’s routes
12. For other params look for the documentation
13. if the apicast deployment is successful then you should have a new dc and service, expose the service using a route in the same apicast namespace using a secure route with at least EDGE and unsecured traffic passthrough allowed.
14. Go back to the tenant admin portal and use the exposed route URL as the apicast:
    1. In the Integration -> settings of your API select the radio button that corresponds to APIcast self-managed and use the exposed route URL from the previous step for both the staging and production URLs
15. Go to Integration -> configuration of your API/Product and promote to staging and prod.
16. test your integration by doing a curl to the apicast route using the method/mapping like:
    1. curl https://uat-apicast-api-versioning-service-uat.apps.cluster-nyc-6b8f.nyc-6b8f.example.opentlc.com/person/v1.0/1?user_key=<USER-KEY>
    2. You can obtain the user-key from the developer account linked to your application plan under audience for your tenant's admin portal.
    3. Validate the hit got tracked as a metric under Product -> Analytics -> Usage

Troubleshooting:

If the integration is not working, validate the accessibility of the components of your integration like:
* Expose a route for your service in the same ns and test you can access the service directly. Do not leave the route up because it defeats the purpose of having an apicast proxy
* Go to your apicast pod’s terminal tab (or rsh into the pod) and try to curl the IP:PORT of your service from there, this way you can test if the apicast can access your service.
* Do similar steps like before for the backend.

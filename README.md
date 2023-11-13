# nuvolar-test

In order to deploy this app, I wanted first to really understand how microservices talk each other and I first created a Dockerfile ( wanted to have some tools to debug such as ping, curl..) and a docker-compose to build all them in the same network. 

Once I saw everything was working and I received a 200 OK, I googled a bit on how would be the best fit for this test. I have ACG account so I could have an account to get hands cloudy and to reproduce this environment in a bit limited but correct GCP account. 

The terraform files are not complex and it only creates a VPC network and a GKE cluster with the things needed to make the app work. An impersonation to a GCP's service account is needed in order to build infrastructure in GCP and we let two files in order to do so ( sa.json / provider.tf ).

Once everything is created, we'd need to login to GCP through "gcloud auth login" and proceed to get the "kubeconfig" file in order to connect to our cluster. The command is like the following:

```
gcloud container clusters get-credentials gke-nuvolar --region us-central1 --project $PROJECT
```

Having got the kubeconfig and ready to connect, we'd apply the files in k8s/ directory. This would create a deployment with 1 replica of each microservice, a service per microservice to expose them within the cluster and a Ingress to have a external IP. Once everything is deployed, we could send traffic to the exposed Ingress and the path receiving a 200 OK.

```
➜  ~ k get ingress
NAME          CLASS    HOSTS   ADDRESS         PORTS   AGE
nuv-ingress   <none>   *       34.128.165.88   80      85m
➜  ~ curl 34.128.165.88:80/order
{"id":1,"customerId":1,"amount":80.0}%

```

To expose the app through SSL/TLS, we shall create an autosigned certificate and mount it to the exposed Ingress as a Secret in the **ingress.yaml** file itself. If we don't want Ingress to serve the traffic directly we could create a Cloud Load Balancer and this service would be the one serving traffic through :443. I couldn't do this part because as mentioned before, I was limited in my GCP environment. I wanted to create this environment as real as possible with a Google account and with services that would be used in production but I couldn't for example create a DNS zone with a test domain to serve traffic through a CLB and a Google managed certificate

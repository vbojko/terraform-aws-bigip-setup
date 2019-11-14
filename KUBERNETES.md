# go to one of the jumphosts
get the hosts that will become the kubernetes cluster and copy the output for later use on the jumphost
```bash
$ terraform output --json |jq -r '.dockerhost_ip.value'
[
  "10.0.20.186",
  "10.0.21.132",
  "10.0.20.55",
  "10.0.21.70",
  "10.0.20.132",
  "10.0.21.244"
]
```
get the information to connect to the jumphosts

```bash
$ ./findthehosts.sh

** AVAILABILITY ZONE 1 **
connect to BIG-IP at https://1.2.3.4:443 with VlJA2FY4CB1xO6qu
connect to jumphost at with
scp -i key.pem f5uberdemo.pem ubuntu@1.2.3.4:~/key.pem
ssh -i key.pem ubuntu@1.2.3.4
when the ansible run is complete Juiceshop and Grafana should be available at
Juice Shop http://1.2.3.4.147
Grafana http://1.2.3.4.218
you can run the load test from the jumphost with the following:
./run-load.sh 1.2.3.4 10
and the attack with
./run-attack.sh http://1.2.3.4.147


** AVAILABILITY ZONE 2 **
connect to BIG-IP at https://2.3.4.5:443 with VlJA2FY4CB1xO6qu
connect to jumphost at with
scp -i key.pem key.pem ubuntu@2.3.4.5:~/key.pem
ssh -i key.pem ubuntu@2.3.4.5
when the ansible run is complete Juiceshop and Grafana should be available at
Juice Shop http://2.3.4.5
Grafana http://2.3.4.5
you can run the load test from the jumphost with the following:
./run-load.sh 2.3.4.5 10
and the attack with
./run-attack.sh http://2.3.4.5
``` 
copy the scp command to copy the private key to the jump and run it
```bash
$ scp -i key.pem key.pem ubuntu@2.3.4.5:~/key.pem
```
copy the ssh command and run it to ssh into the jumphost
```bash
$ ssh -i key.pem ubuntu@2.3.4.5
```

# technical remediation
```bash
$ sudo apt install python3-pip -y
```
# get the kubespray repo
```bash
$ git clone https://github.com/kubernetes-sigs/kubespray.git
$ cd kubespray
```
# Install dependencies 
```bash
$ sudo pip3 install -r requirements.txt
```
# Copy ``inventory/sample`` as ``inventory/mycluster``
```bash
$ cp -rfp inventory/sample inventory/mycluster
```

# Update Ansible inventory file with inventory builder
using the list of ip addresses copied earlier, create a space delimited list and update the command below with that list before executing it
```bash
$ declare -a IPS=(10.0.20.186 10.0.21.132 10.0.20.55 10.0.21.70 10.0.20.132 10.0.21.244 )
$ CONFIG_FILE=inventory/mycluster/hosts.yml python3 contrib/inventory_builder/inventory.py ${IPS[@]}
```

# some minor but necesssary edits
```bash
$ vi group_vars/k8s-cluster/k8s-cluster.yml
```
find and make certain that ```kubeconfig_localhost: true```

```bash
$ vi group_vars/k8s-cluster/addons.yml
```
find and make certain that ```local_volume_provisioner_enabled: true``` and ```cert_manager_enabled: true```

# execute the ansible playbook to build the cluster
It's time!
```bash
$ ansible-playbook -i inventory/mycluster/hosts.yml cluster.yml -b -v --private-key=~/key.pem
```
you can now take a coffee break as this playbook takes around ten minutes to complete

# simple test of the cluster

```bash
$ sudo snap install kubectl --classic
$ export KUBECONFIG=/home/ubuntu/kubespray/inventory/mycluster/artifacts/admin.conf
$ kubectl get nodes
```

# let's deploy nginx 

```bash
$ kubectl apply -f https://k8s.io/examples/application/deployment.yaml

$ kubectl describe deployment nginx-deployment
```
keep describing the deployment until ```Available: true```
```bash
$ kubectl expose deployment/nginx-deployment --type="NodePort" --port 80

$ kubectl get service nginx-deployment
NAME               TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
nginx-deployment   NodePort   10.233.39.115   <none>        80:30281/TCP   15s
$ curl http:(one of the worker nodes):(the port identified by get service)
```
when that no longer amuses you

```bash

$ kubectl delete service nginx-deployment

$ kubectl delete deployment nginx-deployment
```


# About kubernates

**1. الـ Auto-scaling (بيزود ويقلل لوحده)**  
تخيل معايا، عندك تطبيق وفجأة زحمة رهيبة عليه (زي بلاك فرايداي مثلاً)، كوبرنيتس بيحس بالضغط ده لوحده وبيزود عدد الـ containers علشان يستحمل الزحمة، وبعد ما الزحمة تخف بيقلل تاني. يعني مش محتاج تقعد قدام الشاشة تراقب وتزود يدوي.

**2. الـ Self-healing 
 لو container وقع أو مات لأي سبب، كوبرنيتس بيلاحظ ده فورًا وبيشغلّك واحد جديد بدل منه من غير ما تتدخل انت خالص. حرفيًا زي ما يكون عنده حياة خاصة بيه وبيحافظ على نفسه.

**3.الـ  Load balancing (توزيع الحمل)**  
لو عندك أكتر من نسخة من التطبيق شغالة، كوبرنيتس بيوزع الطلبات (requests) بينهم بالتساوي، فمفيش container واحد هيتضغط عليه أكتر من غيره وهما كلهم فاضيين.

**4.الـ  Rolling updates & Rollback (تحديث من غير ما توقف الخدمة)**  
لو عايز تعمل update لنسخة جديدة من التطبيق، كوبرنيتس بيعمل الـ update تدريجي (شوية شوية) من غير ما يوقف الموقع أو السيرفيس خالص. ولو حصل خطأ في النسخة الجديدة، تقدر ترجع (rollback) للنسخة اللي قبلها بسهولة وبسرعة.

**5. بيشتغل على أي مكان (Cloud-agnostic)**  
سواء AWS ولا Azure ولا Google Cloud ولا حتى على جهازك الخاص (on-premise)، كوبرنيتس بيشتغل بنفس الطريقة تقريبًا. يعني مش هتتقفل مع شركة سحابية معينة، وده بيديك مرونة كبيرة.

**6. الـ Service discovery (الـ services بتلاقي بعض لوحدها)**  
لو عندك ميكروسيرفيسز كتير بتتكلم مع بعض، كوبرنيتس بيسهّل عليهم يلاقوا بعض ويتواصلوا من غير ما تعمل إعدادات معقدة يدوي كل مرة.

**7. إدارة الموارد بكفاءة**  
كوبرنيتس بيوزع الـ CPU والـ RAM على الـ containers بشكل ذكي حسب اللي محتاجينه فعليًا، فمش بتحس إن السيرفر بتاعك بيضيع موارد من غير فايدة.


---
---

# Kubernetes Architecture
- فهم الـ Architecture مهم جدا علشان اول لما تحصل مشكله  تعرف المشكله دى فين بالظبط

- فى kubernates فيه سرفر كبير اسمه master node  وهنا Node يعنى سرفر  هنا الـ master  هوا اهم حاجه لانه زى مثلا الـ daemon فى  docker  ده الى هوا الـ master بيكون فيه الـ resources المسئوله عن الـ creation  والحجات الى زى دى 

---
---
## basic components

- الـ kubernates بيتقسم لـ one brain الى هوا الـ master واكثر من worker node 
- هنا الـ master بياخد الاوامر من اليوزر وبيبدا ينفذها فى الـ worker nodes

- وبيكون فيه حاجه اسمها worker node وهنا بتحط فيها الشغل بتاعك او الابليكيشن بتاعك
- 
![[Pasted image 20260922191520.png]]
- هنا الـ master node بيكون فيه كذا ريسورس واهم ريسورس فيه هى الـ kube-apiserver  ده اهم عنصر تقدر م

## kube-apiserver  

- الـ cluster يعنى الـ master node and worker node يعنى Kubernates بتاعى اسمه cluster
- الـ kube-apiserver لو مثلا حاجه فى الماستر عايزه تكلم حاجه فى الـ worker node لازم تعدى من على الـ kube-apiserver  ولو حاجه فى الـ worker عايزه تكلم حاجه فى الـ master لازم تعدى من على الـ kube-apiserver
- الـ kube-apiserver  هوا الـ primary management component  فى الـ cluster 

- اليوزر بيكتب فى ملف هوا عايز يعمل سرفر كذا ويعمل كذا وكذا وكذا الـ kube-apiserver بياخد الاوامر دى من اليوزر ويبدا انه ينفذها 
![[Pasted image 20260922192351.png]]

## Etcd

هنا الـ etcd بيتكون عباره عن data base بيتخزن فيها كل حاجه  بتخص الـ cluster
يعنى اى ابليكيشن جديد هيتعمل الداتا بتاعته هتتكتب هنا وكل التفاصيل بتاعتها هتكون هنا  ولو حصل تعديل الـ kube-apiserver هيبدا يروح للـ etcd ويقولها انه حصل تعديل علشان تحدث الداتا الى عندها 

## kube - controller - manger

![[Pasted image 20260922193036.png]]

مثلا لو انا كنت عامل كذا deployment وانا كنت عامل تلاته ومسحت واحد والـ desire كانت 3 هوا ممكن يعمل واحد علشان يكون زى الـ desire
كل خمس ثوانى الـ kube-controller manager بيبعت للـ kube-apiserver وبيقوله انا عايز اتطمن على node 1 and node 2  الى هى الـ nodes بتاعتى  فيقوم ال kube-apiserver يبعت ريكوست على كل node  ويشوفهم شغالين ولا لا  وبيبعتلهم كل خمس ثوانى 

- لو افرتضنا ان الـ kube-apiserver بعت لكل node تمن مرات ومردوش عليه يعنى عدى 40 ثانيه  كده هيحطهم بعد 40 ثانيه unreachable
- وبعد كده بيسبهم لمده خمس دقايق علشان ممكن يكون فيه مشكله فى النتورك  ولو بعد الخمس دقايق مشتغلتش بيبدا يخليها unhealthy
- بعدها بيبدا انه يكرييت node جديده ويحط الشغل الى كان موجود فى القديمه يحطه فى الجديده
- بس هنا الداتا القديمه طارت ازاى هيحط الداتا فى الـ node الجديده ؟؟؟
- عن طريق الـ etcd بيكون فيه كل الـ معلومات عن الـ cluster بتاعك 


## Node

![[Pasted image 20260922193712.png]]

- ده عباره عن سرفر كبير جدا بحط فيه الابليكيشن بتاعى  هنا الـ pod بيكون فيه الابليكشن بتاعى  وده عامل زى الكونتينر  الـ node  دى بيكون فيها كل الابليكشن بتاعك ممكن تقسم الابليكيشن بتاعك على اكثر من node علشان علشان لو الابليكيشن وقع ميقكعش كله 


---
---
## kube - scheduler
- ده بيكون جدوله مثلا الابليكشين ده هيتعمل فى اى node وهتديله CPU قد ايه وميمورى قد ايه ومساحه قد ايه  وممكن برضه تقوله ان اكبر عدد من الـ pods ممكن يكون 2 يعنى لو جه يعمل اكتر من كده هيديه ايرور 
- لو هوا لقى ان مفيش اى قيود على node 1 and 2   هيبدا انه مثلا يشوف منها الى عندها CPU اكثر ويديها هى الاولويه


## Kubelet
- لو عملت systemctl status kubelet هتلاقى انه موجود كـ service  ولكن الباقى موجود كملف 
- الـ kublet هوا الى مسئول عن انه يعمل creation for nodes


- اليوزر عايز يعمل ابليكيشن فبيروح للـ apiserver وبعدها الـ apiserver بيروح للـ scheduler  مثلا الاوال الـ scheduler هيسال هل اليوزر ليه الحق انه يعمل pod ولا لا وهل فيه ريسورسز انه يقدر يعمل واحد جديد ولا لا  فالـ apiserver هيروح يسال اليوزر هل فعلا كده ولا لا لو هوا تمام هيرجع ويعرفه الرد  وبعد كده الـ schedulerهيبعت للـ api server انه هاتلى بيانات الـ nodes الى عندك علشان اعرف هتعامل مع ايه  وبعد كده الـ scheduler بيقول للـ apiserver انا مثلا اخترت node 1  يبدا الـ apiserver يبعت للـ etcd فى template انه هيكريت فى الـ node 1   بعد كده الـ apiserver بيبعت للـ node بيقوله سجل عند الريسورس دى وبعدها بيقوله يعمل apply وبعد كده يبدا الـ kubelet يسطب  وبعد لما تتسطب يبدا الـ apiserver يقول للـ etcd خزنى الـ templateالى كنت بعتهولك
- 


## Kube-proxy

- ده مسئول انه بيعمل شبكه بين كل component وبيربطبهم كلهم وبيدى لكل واحد ip

----
---
## Load balancer
 - كل ابليكيشن بيتكريت بيتعمله load balancer يعنى لو حد كتب www.ahmed كده هيحوله على الـ load balancer وبعدها الـ  load balancer  هيحولك على السرفر بتاعك الى عليه الخدمه

----
## pod
- الـ pod الواحده ممكن تعمل فيها اكثر من كونتينر  ولكن الـ recommended هى انك تعمل كونتينر واحد بس   
- الـ pod الواحده بتاخد ip واحد بس فلو انته عملت فيها اتنين كونتينر  nginx وكل واحد فيهم شغال على بورت 80 لو الاتنين شغالين فى نفس الوقت واحد هيشتغل وواحد هيضرب 


----
---
- فى حاله ان الماستر وقع ساعتها  كده الـ working node هتظل شغاله عادى والابليكيشن هيشتغل عادى  لان الـ load balancer ملهوش علاقه بالـ master

- فى حاله ان الـ node 1 وقعت ومع وقوع الـ master كده هينقل على node 2 ومش هيعمل node جديده لان الـ master متعطل

---
---
## Container Runtime
هوا البرنامج (software) المسؤول عن إنه فعليًا **يشغّل الـ containers** على مستوى الـ node. يعني هوا الطبقة اللي بتاخد الـ container image وتحولها لعملية (process) شغالة فعلاً على السيرفر.

#### فين بيكون؟

موجود على **كل worker node** (بيتسطب عليها كـ software منفصل، مش جزء من الـ kubernetes نفسه).

- فى حاله ان الـ container runtime اتعطل  ؟؟؟؟
- هيمسح كل الريسورسز الى هوا عملها



----
----
# How to create kubernates cluster

هتكتب على جوجل cluster =  install mini kube

![[Pasted image 20260923140420.png]]

- المفروض الاول بتحمل دوكر وبعدها kubernates
- بعدها هتكتب install kubectl on linux 


```bash
   curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
```

```bash
   curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
```
- بعد كده هتعمل الاتى وهتشوف هل هيطلع ok ولا لا 

```bash
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
```

```console
kubectl: OK
```

```bash
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
```

```bash
chmod +x kubectl
mkdir -p ~/.local/bin
mv ./kubectl ~/.local/bin/kubectl
# and then append (or prepend) ~/.local/bin to $PATH
```

```bash
mostafaÉMY-Home:ü/Documents$ kubectl version --client
Client Version: v1.37.0
Kustomize Version: v5.8.1

```

---
---

```bash
mostafaÉMY-Home:ü/Documents$ curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64

mostafaÉMY-Home:ü/Documents$ sudo install minikube-linux-amd64 /usr/local/bin/minikube

mostafaÉMY-Home:ü/Documents$ minikube version
minikube version: v1.39.0
commit: 7a9f6a841470a207de8cf4bafcccee0969d8ba10
```

- هنا كده علشان تحمل الـ mini kube
```bash
minikube start --driver=docker
```
- ده علشان تكمل التحميل 

---
----
----
- يبقى كده بتحمل docker and kubectl and mini kube

# Start and what is the meaning of Resource and pod and namespace
### تخيل إن الـ Cluster هوا "شركة"
الشركة الكبيرة دي (الـ cluster) فيها **مباني (nodes)** - كل مبنى فيه مكاتب.

الشركة دي عايزة تقسم نفسها لأقسام: قسم الباك اند، قسم الفرونت اند، قسم المونيتورينج. القسم ده هوا الـ **namespace** - مجرد **اسم/تصنيف إداري**، مش مكان فيزيائي. يعني موظف من "قسم الباك اند" ممكن يقعد في مبنى 1، وزميله في نفس القسم يقعد في مبنى 2 - الاتنين لسه في نفس القسم لأن القسم ده تصنيف بس، مش مكان.

### الـ Pod هوا "الموظف"

كل موظف (pod) هوا الوحدة الأساسية اللي بتشتغل فعليًا. جوه الموظف ده فيه "أداة الشغل بتاعته" وهي الـ **container** (الابليكيشن بتاعتك).

- كل pod بياخد **بطاقة هوية واحدة (IP واحد)**
- كل pod بيتبع **قسم واحد (namespace واحد)**
- ممكن يكون جوه الـ pod أكتر من container، بس الأفضل واحد بس (زي ما اتكلمنا قبل كده)

### الـ Resource هوا "المصطلح العام لأي حاجة بتعملها"

كلمة "resource" في Kubernetes مش حاجة واحدة معينة - هي **اسم عام** لأي "شيء" تقدر تعمله/تديره في الـ cluster. يعني:

- الـ **Pod** نفسه = resource
- الـ **Deployment** (اللي بيدير عدد نسخ من الـ pod) = resource
- الـ **Service** = resource
- الـ **Namespace** نفسه = resource

---
---


```bash
mostafa@MY-Home:~/Documents$ kubectl get pod
No resources found in default namespace.
```
- هنا هيقلك ايه الـ pods الى عندك ولو مش عندك هيقلك انك مفيش اى ريسورسز 
- هنا لما بتكرييت  resource بتتعمل فى الـ namespace

![[Pasted image 20260923144635.png]]

- مثلا بيبقى فيه worker node وممكن يكون فيها  اكثر من namespace 
- ممكن اول namespace تحط فيه كل حاجه تخص الباك اند والتانى تحط فيه الفرونت اند
- هوا مجرد اطار بتحط فيه الـ resource ممكن تحط للـ namespace تحطلها cpu معين او ميمورى معينه  وممكن تحط constrain لكل    namespace 

---
---
- بعد كل ده انته بتكريت الريسورس فى الـ namespace 
```bash
mostafa@MY-Home:~/Documents$ kubectl get namespaces
NAME              STATUS   AGE
default           Active   13m
kube-node-lease   Active   13m
kube-public       Active   13m
kube-system       Active   13m
```
- علشان تعرف ايه  الـ namespaces الى عندكkubectl get namespaces
- الـ default namespace ده اى ريسورس بيتعمل بيتحط فى الـ default
- يعنى بمعنى اصح اى pod بيتعمل الـ default بتاعه انه بيتحط كانه resource فى الـ default namespace

---
---
---

```bash
mostafa@MY-Home:~/Documents$ kubectl get pod
No resources found in default namespace.
```
- هنا بيقولك مفيش pods فى الـ default namespace 

---
```bash
mostafa@MY-Home:~/Documents$ kubectl get pod --namespace kube-system
NAME                               READY   STATUS    RESTARTS        AGE
coredns-559f6c778d-v7hvg           1/1     Running   0               17m
etcd-minikube                      1/1     Running   0               18m
kindnet-w9z8h                      1/1     Running   0               17m
kube-apiserver-minikube            1/1     Running   0               18m
kube-controller-manager-minikube   1/1     Running   0               18m
kube-proxy-grrdd                   1/1     Running   0               17m
kube-scheduler-minikube            1/1     Running   0               18m
storage-provisioner                1/1     Running   1 (4m49s ago)   17m
```
 - هنا لو انته عايز تجيب عدد الـ pods الى فى namespace معينه هتحدد الـ namespace عن طريق -- namespace  هنا جابلك انك عندك 8 pods 

---
---

- اى namespace بيتعمل بيكون موجود فى كل الـ cluster يعنى بيكون موجود فى الـ worker node and master 
- وبرضه الريسورسز بتكون معموله فى الماستر 


- لو انته عايز تعرف الـ resources دى موجوده فين الاول هتشوف الـ nodes والـ nodes دى يعنى السرفرات 

```bash
mostafa@MY-Home:~/Documents$ kubectl get nodes
NAME       STATUS   ROLES           AGE   VERSION
minikube   Ready    control-plane   73m   v1.37.0
```
- ده الماستر  فاكيد كل الرسورسز الى فاتت موجوده فى الماستر 

```bash
mostafa@MY-Home:~/Documents$ kubectl describe pod kube-apiserver-minikube -n kube-system
Name:                 kube-apiserver-minikube
Namespace:            kube-system
Priority:             2000001000
Priority Class Name:  system-node-critical
Node:                 minikube/192.168.49.2
Start Time:           Wed, 23 Sep 2026 07:37:50 -0400
Labels:               component=kube-apiserver
                      tier=control-plane
Annotations:          kubeadm.kubernetes.io/kube-apiserver.advertise-address.endpoint: 192.168.49.2:8443
                      kubernetes.io/config.hash: f029d000c220d1bf9553ea5af5038d7f
                      kubernetes.io/config.mirror: f029d000c220d1bf9553ea5af5038d7f
                      kubernetes.io/config.seen: 2026-09-23T11:37:49.800413769Z
                      kubernetes.io/config.source: file
Status:               Running
SeccompProfile:       RuntimeDefault
IP:                   192.168.49.2
IPs:
  IP:           192.168.49.2
Controlled By:  Node/minikube
Containers:
  kube-apiserver:
    Container ID:  containerd://c8684f3a9663b280636bfe511a889977ec901243ff2d379e45f52e8107b860b7
    Image:         registry.k8s.io/kube-apiserver:v1.37.0
    Image ID:      registry.k8s.io/kube-apiserver@sha256:d1045e5c6d2f016797d22143eba7502e1bb712a4681836a7c35763a9c192dd70
    Port:          8443/TCP (probe-port)
    Host Port:     8443/TCP (probe-port)
    Command:
      kube-apiserver
      --advertise-address=192.168.49.2
      --allow-privileged=true
      --authorization-mode=Node,RBAC
      --client-ca-file=/var/lib/minikube/certs/ca.crt
      --enable-bootstrap-token-auth=true
      --etcd-cafile=/var/lib/minikube/certs/etcd/ca.crt
      --etcd-certfile=/var/lib/minikube/certs/apiserver-etcd-client.crt
      --etcd-keyfile=/var/lib/minikube/certs/apiserver-etcd-client.key
      --etcd-servers=https://127.0.0.1:2379
      --kubelet-client-certificate=/var/lib/minikube/certs/apiserver-kubelet-client.crt
      --kubelet-client-key=/var/lib/minikube/certs/apiserver-kubelet-client.key
      --kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname
      --proxy-client-cert-file=/var/lib/minikube/certs/front-proxy-client.crt
      --proxy-client-key-file=/var/lib/minikube/certs/front-proxy-client.key
      --requestheader-allowed-names=front-proxy-client
      --requestheader-client-ca-file=/var/lib/minikube/certs/front-proxy-ca.crt
      --requestheader-extra-headers-prefix=X-Remote-Extra-
      --requestheader-group-headers=X-Remote-Group
      --requestheader-username-headers=X-Remote-User
      --secure-port=8443
      --service-account-issuer=https://kubernetes.default.svc.cluster.local
      --service-account-key-file=/var/lib/minikube/certs/sa.pub
      --service-account-signing-key-file=/var/lib/minikube/certs/sa.key
      --service-cluster-ip-range=10.96.0.0/12
      --tls-cert-file=/var/lib/minikube/certs/apiserver.crt
      --tls-private-key-file=/var/lib/minikube/certs/apiserver.key
      --enable-admission-plugins=NamespaceLifecycle,LimitRanger,ServiceAccount,DefaultStorageClass,DefaultTolerationSeconds,NodeRestriction,MutatingAdmissionWebhook,ValidatingAdmissionWebhook,ResourceQuota
    State:          Running
      Started:      Wed, 23 Sep 2026 07:37:53 -0400
    Ready:          True
    Restart Count:  0
    Requests:
      cpu:        250m
    Liveness:     http-get https://192.168.49.2:probe-port/livez delay=10s timeout=15s period=10s successThreshold=1 failureThreshold=8
    Readiness:    http-get https://192.168.49.2:probe-port/readyz delay=0s timeout=15s period=1s successThreshold=1 failureThreshold=3
    Startup:      http-get https://192.168.49.2:probe-port/livez delay=10s timeout=15s period=10s successThreshold=1 failureThreshold=24
    Environment:  <none>
    Mounts:
      /etc/ca-certificates from etc-ca-certificates (ro)
      /etc/ssl/certs from ca-certs (ro)
      /usr/local/share/ca-certificates from usr-local-share-ca-certificates (ro)
      /usr/share/ca-certificates from usr-share-ca-certificates (ro)
      /var/lib/minikube/certs from k8s-certs (ro)
Conditions:
  Type                        Status
  PodReadyToStartContainers   True 
  Initialized                 True 
  Ready                       True 
  ContainersReady             True 
  PodScheduled                True 
Volumes:
  ca-certs:
    Type:          HostPath (bare host directory volume)
    Path:          /etc/ssl/certs
    HostPathType:  DirectoryOrCreate
  etc-ca-certificates:
    Type:          HostPath (bare host directory volume)
    Path:          /etc/ca-certificates
    HostPathType:  DirectoryOrCreate
  k8s-certs:
    Type:          HostPath (bare host directory volume)
    Path:          /var/lib/minikube/certs
    HostPathType:  DirectoryOrCreate
  usr-local-share-ca-certificates:
    Type:          HostPath (bare host directory volume)
    Path:          /usr/local/share/ca-certificates
    HostPathType:  DirectoryOrCreate
  usr-share-ca-certificates:
    Type:          HostPath (bare host directory volume)
    Path:          /usr/share/ca-certificates
    HostPathType:  DirectoryOrCreate
QoS Class:         Burstable
Node-Selectors:    <none>
Tolerations:       :NoExecute op=Exists
Events:
  Type     Reason     Age                From     Message
  ----     ------     ----               ----     -------
  Warning  Unhealthy  46m (x2 over 75m)  kubelet  spec.containers{kube-apiserver}: Readiness probe failed: HTTP probe failed with statuscode: 500
  Warning  Unhealthy  10m (x2 over 70m)  kubelet  spec.containers{kube-apiserver}: Liveness probe failed: Get "https://192.168.49.2:8443/livez": context deadline exceeded
  Warning  Unhealthy  10m                kubelet  spec.containers{kube-apiserver}: Readiness probe failed: Get "https://192.168.49.2:8443/readyz": net/http: request canceled while waiting for connection (Client.Timeout exceeded while awaiting headers)
  Warning  Unhealthy  10m (x3 over 75m)  kubelet  spec.containers{kube-apiserver}: Liveness probe failed: HTTP probe failed with statuscode: 500
```

```bash
mostafa@MY-Home:~/Documents$ kubectl describe pod kube-apiserver-minikube -n kube-system
```
- هنا جابلك كل المعلومات دى  عن الـ pod دى 
- kubectl describe pod 
- هنا الاول بتكتب دول علشان تجيب تفاصيل pod معينه 
- هنا الـ pod دى اسمها kube-apiserver-minikube والـ workspace اسمها kube-system

---
---
- علشان تعرف كل الاختصارات هتعمل الاتى  
```bash
mostafa@MY-Home:~/Documents$ kubectl api-resources
NAME                                SHORTNAMES   APIVERSION                        NAMESPACED   KIND
bindings                                         v1                                true         Binding
componentstatuses                   cs           v1                                false        ComponentStatus
configmaps                          cm           v1                                true         ConfigMap
endpoints                           ep           v1                                true         Endpoints
events                              ev           v1                                true         Event
limitranges                         limits       v1                                true         LimitRange
namespaces                          ns           v1                                false        Namespace
nodes                               no           v1                                false        Node
persistentvolumeclaims              pvc          v1                                true         PersistentVolumeClaim
persistentvolumes                   pv           v1                                false        PersistentVolume
pods                                po           v1                                true         Pod
podtemplates                                     v1                                true         PodTemplate
replicationcontrollers              rc           v1                                true         ReplicationController
resourcequotas                      quota        v1                                true         ResourceQuota
secrets                                          v1                                true         Secret
serviceaccounts                     sa           v1                                true         ServiceAccount
services                            svc          v1                                true         Service
mutatingadmissionpolicies                        admissionregistration.k8s.io/v1   false        MutatingAdmissionPolicy
mutatingadmissionpolicybindings                  admissionregistration.k8s.io/v1   false        MutatingAdmissionPolicyBinding
mutatingwebhookconfigurations                    admissionregistration.k8s.io/v1   false        MutatingWebhookConfiguration
validatingadmissionpolicies                      admissionregistration.k8s.io/v1   false        ValidatingAdmissionPolicy
validatingadmissionpolicybindings                admissionregistration.k8s.io/v1   false        ValidatingAdmissionPolicyBinding
validatingwebhookconfigurations                  admissionregistration.k8s.io/v1   false        ValidatingWebhookConfiguration
customresourcedefinitions           crd,crds     apiextensions.k8s.io/v1           false        CustomResourceDefinition
apiservices                                      apiregistration.k8s.io/v1         false        APIService
controllerrevisions                              apps/v1                           true         ControllerRevision
daemonsets                          ds           apps/v1                           true         DaemonSet
deployments                         deploy       apps/v1                           true         Deployment
replicasets                         rs           apps/v1                           true         ReplicaSet
statefulsets                        sts          apps/v1                           true         StatefulSet
selfsubjectreviews                               authentication.k8s.io/v1          false        SelfSubjectReview
tokenreviews                                     authentication.k8s.io/v1          false        TokenReview
localsubjectaccessreviews                        authorization.k8s.io/v1           true         LocalSubjectAccessReview
selfsubjectaccessreviews                         authorization.k8s.io/v1           false        SelfSubjectAccessReview
selfsubjectrulesreviews                          authorization.k8s.io/v1           false        SelfSubjectRulesReview
subjectaccessreviews                             authorization.k8s.io/v1           false        SubjectAccessReview
horizontalpodautoscalers            hpa          autoscaling/v2                    true         HorizontalPodAutoscaler
cronjobs                            cj           batch/v1                          true         CronJob
jobs                                             batch/v1                          true         Job
certificatesigningrequests          csr          certificates.k8s.io/v1            false        CertificateSigningRequest
clustertrustbundles                              certificates.k8s.io/v1            false        ClusterTrustBundle
podcertificaterequests                           certificates.k8s.io/v1            true         PodCertificateRequest
leases                                           coordination.k8s.io/v1            true         Lease
endpointslices                                   discovery.k8s.io/v1               true         EndpointSlice
events                              ev           events.k8s.io/v1                  true         Event
flowschemas                                      flowcontrol.apiserver.k8s.io/v1   false        FlowSchema
prioritylevelconfigurations                      flowcontrol.apiserver.k8s.io/v1   false        PriorityLevelConfiguration
ingressclasses                                   networking.k8s.io/v1              false        IngressClass
ingresses                           ing          networking.k8s.io/v1              true         Ingress
ipaddresses                         ip           networking.k8s.io/v1              false        IPAddress
networkpolicies                     netpol       networking.k8s.io/v1              true         NetworkPolicy
servicecidrs                                     networking.k8s.io/v1              false        ServiceCIDR
runtimeclasses                                   node.k8s.io/v1                    false        RuntimeClass
poddisruptionbudgets                pdb          policy/v1                         true         PodDisruptionBudget
clusterrolebindings                              rbac.authorization.k8s.io/v1      false        ClusterRoleBinding
clusterroles                                     rbac.authorization.k8s.io/v1      false        ClusterRole
rolebindings                                     rbac.authorization.k8s.io/v1      true         RoleBinding
roles                                            rbac.authorization.k8s.io/v1      true         Role
deviceclasses                                    resource.k8s.io/v1                false        DeviceClass
devicetaintrules                                 resource.k8s.io/v1                false        DeviceTaintRule
resourceclaims                                   resource.k8s.io/v1                true         ResourceClaim
resourceclaimtemplates                           resource.k8s.io/v1                true         ResourceClaimTemplate
resourceslices                                   resource.k8s.io/v1                false        ResourceSlice
priorityclasses                     pc           scheduling.k8s.io/v1              false        PriorityClass
csidrivers                                       storage.k8s.io/v1                 false        CSIDriver
csinodes                                         storage.k8s.io/v1                 false        CSINode
csistoragecapacities                             storage.k8s.io/v1                 true         CSIStorageCapacity
storageclasses                      sc           storage.k8s.io/v1                 false        StorageClass
volumeattachments                                storage.k8s.io/v1                 false        VolumeAttachment
volumeattributesclasses             vac          storage.k8s.io/v1                 false        VolumeAttributesClass
storageversionmigrations                         storagemigration.k8s.io/v1        false        StorageVersionMigration
```
![[Pasted image 20260923161451.png]]


---
---

```bash
kubectl get ns
```
 - دى الى هى الـ namespace 

---
---
```bash
kubectl get no
```
- دى الـ nodes

----
```bash
kubectl get po
```
- الـ pods
---
---

# Create pod

```bash
mostafa@MY-Home:~/Documents$ kubectl run mostafa --image alpine
pod/mostafa created
mostafa@MY-Home:~/Documents$ 
```
- كده دى الطريقه الى تقدر تعمل بيها pod 


```bash
mostafa@MY-Home:~/Documents$ kubectl run myserver --image nginx
pod/myserver created


mostafa@MY-Home:~/Documents$ kubectl get pods
NAME       READY   STATUS             RESTARTS        AGE
mostafa    0/1     CrashLoopBackOff   6 (2m47s ago)   8m53s
myserver   1/1     Running            0               93s
```

- هنا هوا عنده كونتينر واحد بس فى الـ pod وهوا مستخدمه وتقدر تشوفه فى الـ ready

- لو انته عايزه يجبلك معلومات عن الـ pod الى انته لسه عامله هتعمل الاتى 
- kubectl describe pod myserver

```bash
mostafa@MY-Home:~/Documents$ kubectl describe pod myserver
Name:             myserver
Namespace:        default
Priority:         0
Service Account:  default
Node:             minikube/192.168.49.2
Start Time:       Wed, 23 Sep 2026 09:32:39 -0400
Labels:           run=myserver
Annotations:      <none>
Status:           Running
IP:               10.244.0.4
IPs:
  IP:  10.244.0.4
Containers:
  myserver:
    Container ID:   containerd://d3e9fcbe352fd5c41bef2b44b5554b4049c0199e4bf29b579634149570bd1420
    Image:          nginx
    Image ID:       docker.io/library/nginx@sha256:abe47724e466aeab9a345d8e46a221c2fa8953c7848bb4a3bd9976a7199f8cf2
    Port:           <none>
    Host Port:      <none>
    State:          Running
      Started:      Wed, 23 Sep 2026 09:33:33 -0400
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-zp8nv (ro)
Conditions:
  Type                        Status
  PodReadyToStartContainers   True 
  Initialized                 True 
  Ready                       True 
  ContainersReady             True 
  PodScheduled                True 
Volumes:
  kube-api-access-zp8nv:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    Optional:                false
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type    Reason     Age    From               Message
  ----    ------     ----   ----               -------
  Normal  Scheduled  5m25s  default-scheduler  Successfully assigned default/myserver to minikube
  Normal  Pulling    5m24s  kubelet            spec.containers{myserver}: Pulling image "nginx"
  Normal  Pulled     4m32s  kubelet            spec.containers{myserver}: Successfully pulled image "nginx" in 51.132s (51.132s including waiting). Image size: 63422407 bytes.
  Normal  Created    4m32s  kubelet            spec.containers{myserver}: Container created
  Normal  Started    4m31s  kubelet            spec.containers{myserver}: Container started
```

```bash
Name:             myserver
Namespace:        default
Priority:         0
Service Account:  default
Node:             minikube/192.168.49.2
Start Time:       Wed, 23 Sep 2026 09:32:39 -0400
Labels:           run=myserver
Annotations:      <none>
Status:           Running
IP:               10.244.0.4
```
- هنا مثلا جابلك الـ ip بتاع الـ pod وكمان بيقولك هى شغاله ولا لا وهى تبع namespace ايه  واتعملت امته واسمها ايه  وايه الـ node الى هى فيها 

---
- لو نزلت لقسم الـ containers هتلاقى الاتى 
```bash
Containers:
  myserver:
    Container ID:   containerd://d3e9fcbe352fd5c41bef2b44b5554b4049c0199e4bf29b579634149570bd1420
    Image:          nginx
    Image ID:       docker.io/library/nginx@sha256:abe47724e466aeab9a345d8e46a221c2fa8953c7848bb4a3bd9976a7199f8cf2
    Port:           <none>
    Host Port:      <none>
    State:          Running
      Started:      Wed, 23 Sep 2026 09:33:33 -0400
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-zp8nv (ro)
```
- هنا بيقولك الـ id بتاع الـ container  وايه الـ image الى بيستخدمها وايه الحاله بتاعه الكونتينر واتعمل اممته 
---
---
هنا علشان اعمل الـ pod دى حصل شويه خطوات 
```bash
mostafa@MY-Home:~/Documents$ kubectl describe pod myserver
```
- الاول اليوزر بيقول انا عايز اعمل pod الكلام ده بيوصل للـ kube-apiserver وبعدها الـ apiserver بيتواصل مع الـ scheduler   وبيساله المفروض اعمل الـ pod دى فى اى node هنا الـ scheduler هيقوله هتعمله فى الـ default namespace 
- دلوقتى بعد لما الـ scheduler اختار الـ node هنا جه دور الـ kubelet   
- الـ kubelet هيبدا يعمل pull for image nginx
- وبعد كده الـ kubelet هيدا انه يكرييت الـ container وبعدها هيبدا برضه انه يعمل start للـ container

```bash
Events:
  Type    Reason     Age    From               Message
  ----    ------     ----   ----               -------
  Normal  Scheduled  5m25s  default-scheduler  Successfully assigned default/myserver to minikube
  
  Normal  Pulling    5m24s  kubelet            spec.containers{myserver}: Pulling image "nginx"
  
  Normal  Pulled     4m32s  kubelet            spec.containers{myserver}: Successfully pulled image "nginx" in 51.132s (51.132s including waiting). Image size: 63422407 bytes.
  
  Normal  Created    4m32s  kubelet            spec.containers{myserver}: Container created
  
  Normal  Started    4m31s  kubelet            spec.containers{myserver}: Container started
```

----
- لو جالك فى الامتحان انه لما كان عايز يعمل pod وقف عند scheduling فهتبدا تشوف ايه الى شغال وايه الى مش شغال 

```bash
mostafa@MY-Home:~/Documents$ minikube ssh
Linux minikube 6.12.101+deb13-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.12.101-1 (2026-08-05) x86_64

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
```
- هنا بتشوف اسم الـ node الى عندك علشان تتصل عليه من خلال الـ ssh  وبعد لما تدخل 
```bash
docker@minikube:~$ systemctl status kubelet
● kubelet.service - kubelet: The Kubernetes Node Agent
     Loaded: loaded (/lib/systemd/system/kubelet.service; disabled; preset: enabled)
    Drop-In: /etc/systemd/system/kubelet.service.d
             └─10-kubeadm.conf
     Active: active (running) since Wed 2026-09-23 11:38:16 UTC; 2h 15min ago
       Docs: http://kubernetes.io/docs/
   Main PID: 1302 (kubelet)
      Tasks: 12 (limit: 861)
     Memory: 55.8M
        CPU: 12min 22.999s
     CGroup: /system.slice/kubelet.service
             └─1302 /var/lib/minikube/binaries/v1.37.0/kubelet --bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --config=/var/lib/kubelet/config.yaml --hostname-override=minikube --kubeconfig=/etc/kubernetes/kubelet.conf --node-ip=192.168.49.2
```
- هنا بتشوف الـ kubelet هل هوا شغال ولا لا وهنا فعلا شغال يعنى المشكله مش فيه 

---
---

# Create Namespace
- علشان تعمل namespace جديده هتعمل الاتى 

```bash
mostafa@MY-Home:~/Documents$ kubectl create namespace fronend
namespace/fronend created


mostafa@MY-Home:~/Documents$ kubectl get namespace
NAME              STATUS   AGE
default           Active   3h
fronend           Active   11s
kube-node-lease   Active   3h
kube-public       Active   3h
kube-system       Active   3h
```

----
---
- لو انته عايز تعمل pod جوه الـ frontend namespace
```bash
mostafa@MY-Home:~/Documents$ kubectl run newpod --image nginx -n fronend 
pod/newpod created
```

---
---

```bash
mostafa@MY-Home:~/Documents$ kubectl describe pods  newpod -n fronend 
Name:             newpod
Namespace:        fronend
Priority:         0
Service Account:  default
Node:             minikube/192.168.49.2
Start Time:       Wed, 23 Sep 2026 10:41:28 -0400
Labels:           run=newpod
Annotations:      <none>
Status:           Running
IP:               10.244.0.5
IPs:
  IP:  10.244.0.5
```


```bash
mostafa@MY-Home:~/Documents$ kubectl get pod --namespace fronend 
NAME     READY   STATUS    RESTARTS   AGE
newpod   1/1     Running   0          3m56s
```


---
---
# Dealing with yaml and Kubernates documentation
هنا انته علشان تجيب اى ملف yaml هتتعامل مع الـ documentation كما يلى 
- هنفترض انى عايز اعمل yaml للـ pod الى عايز اعملها هعمل الاتى 
![[Pasted image 20260926133950.png]]
هتدخل على الينك ده 
![[Pasted image 20260926134015.png]]

- هتلاقى هنا ده طيب لو انته عايز تعمل yaml للـ replicaset هتعمل الاتى 
![[Pasted image 20260926134115.png]]

# pod with yaml file

```bash
mostafa@MY-Home:~/Documents/Kubernates$ vim pod1.yml
```
- هتعمل الملف وتحطفيه الاتى 
```yml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
  - name: nginx
    image: nginx:1.14.2
    ports:
    - containerPort: 80

```
- الـ pod بتتكون من 4 سكشن  كم يلى 
-  apiversion 
- kind
- metadata
- spec

---
---
- هنا فى الـ kind انته بتكتب انته عايز تكمل ايه يعنى مثلا عايز تكرييت pod ولا حاجه تانيه 
- اما فى الـ metadata بتكتب مثلا اسمها  او مثلا اسم الـ namespace الى انته عايزها كما يلى 
```yml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  namespace:frontend
spec:
  containers:
  - name: nginx
    image: nginx:1.14.2
    ports:
    - containerPort: 80
```
- اما فى الـ spec دى خاصه بالكونتينر  الى هيتعمل 

- انته بعد لما عملت الملف ده علشان تنفذه هتعمل الاتى 

```shell
mostafa@MY-Home:~/Documents/Kubernates$ kubectl apply -f pod1.yml 
pod/nginx created
```


```bash
mostafa@MY-Home:~/Documents/Kubernates$ kubectl get pod --namespace fronend
NAME     READY   STATUS    RESTARTS      AGE
newpod   1/1     Running   0             26m
nginx    1/2     Error     1 (17s ago)   43s
```
- هنا الـ pod الى اتعملت جديد اتعملت عادى بس اداك ايرور علشان فيه اتنين nginx شغالين على نفس البورت فمينفعش فاداك ايرور 

```bash
mostafa@MY-Home:~/Documents/Kubernates$ kubectl describe pod nginx -n fronend
Name:             nginx
Namespace:        fronend
Priority:         0
Service Account:  default
Node:             minikube/192.168.49.2
Start Time:       Wed, 23 Sep 2026 11:07:23 -0400
Labels:           <none>
Annotations:      <none>
Status:           Running
IP:               10.244.0.6
IPs:
  IP:  10.244.0.6
Containers:
  nginx:
    Container ID:   containerd://7dca80098856625d0e0149a6104647e52f84a04a9ce05d63e16ab2c4d8c45ac3
    Image:          nginx:1.14.2
    Image ID:       docker.io/library/nginx@sha256:f7988fb6c02e0ce69257d9bd9cf37ae20a60f1df7563c3a2a6abe24160306b8d
    Port:           80/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Wed, 23 Sep 2026 11:07:46 -0400
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-2kgj4 (ro)
  nginx1:
    Container ID:   containerd://7f09f14196467e77e3c585699989b03d2ddde31ee9a29f9f77ea8fbae0ac96fb
    Image:          nginx:1.14.2
    Image ID:       docker.io/library/nginx@sha256:f7988fb6c02e0ce69257d9bd9cf37ae20a60f1df7563c3a2a6abe24160306b8d
    Port:           <none>
    Host Port:      <none>
    State:          Terminated
      Reason:       Error
      Exit Code:    1
      Started:      Wed, 23 Sep 2026 11:10:54 -0400
      Finished:     Wed, 23 Sep 2026 11:10:56 -0400
    Last State:     Terminated
      Reason:       Error
      Exit Code:    1
      Started:      Wed, 23 Sep 2026 11:09:27 -0400
      Finished:     Wed, 23 Sep 2026 11:09:29 -0400
```
- هنا فى اول كونتينر قالك انه شغال انا التانى اداك ايرور 

- طيب لو انته عايز تشوف الـ logs هتعمل الاتى 
```bash
mostafa@MY-Home:~/Documents/Kubernates$ kubectl logs nginx -c nginx1 -n fronend
```
- هنا بيقول انه عايز يعرف الـ logs بتاعه الكونتينر الى اسمه nginx1 

```bash
mostafa@MY-Home:~/Documents/Kubernates$ kubectl logs nginx -c nginx1 -n fronend
2026/09/23 15:13:41 [emerg] 1#1: bind() to 0.0.0.0:80 failed (98: Address already in use)
nginx: [emerg] bind() to 0.0.0.0:80 failed (98: Address already in use)
2026/09/23 15:13:41 [emerg] 1#1: bind() to 0.0.0.0:80 failed (98: Address already in use)
nginx: [emerg] bind() to 0.0.0.0:80 failed (98: Address already in use)
2026/09/23 15:13:41 [emerg] 1#1: bind() to 0.0.0.0:80 failed (98: Address already in use)
nginx: [emerg] bind() to 0.0.0.0:80 failed (98: Address already in use)
2026/09/23 15:13:41 [emerg] 1#1: bind() to 0.0.0.0:80 failed (98: Address already in use)
nginx: [emerg] bind() to 0.0.0.0:80 failed (98: Address already in use)
2026/09/23 15:13:41 [emerg] 1#1: bind() to 0.0.0.0:80 failed (98: Address already in use)
nginx: [emerg] bind() to 0.0.0.0:80 failed (98: Address already in use)
2026/09/23 15:13:41 [emerg] 1#1: still could not bind()
nginx: [emerg] still could not bind()
```
Address already in use) 
- هنا وهوا بيحاول يشغله على بورت 80 بيقولك ان فيه حد تانى بيستخدم البورت 
![[Pasted image 20260923182040.png]]


---
---
```bash
mostafa@MY-Home:~/Documents/Kubernates$ kubectl get pod -A
NAMESPACE     NAME                               READY   STATUS             RESTARTS         AGE
default       mostafa                            0/1     CrashLoopBackOff   34 (2m34s ago)   126m
default       myserver                           1/1     Running            1 (5m52s ago)    118m
fronend       newpod                             1/1     Running            1 (5m52s ago)    49m
fronend       nginx                              1/2     CrashLoopBackOff   13 (2m40s ago)   23m
kube-system   coredns-559f6c778d-v7hvg           1/1     Running            1 (5m52s ago)    3h52m
kube-system   etcd-minikube                      1/1     Running            1 (5m52s ago)    3h53m
kube-system   kindnet-w9z8h                      1/1     Running            1 (5m52s ago)    3h52m
kube-system   kube-apiserver-minikube            1/1     Running            1 (5m52s ago)    3h53m
kube-system   kube-controller-manager-minikube   1/1     Running            1 (5m52s ago)    3h53m
kube-system   kube-proxy-grrdd                   1/1     Running            1 (5m52s ago)    3h52m
kube-system   kube-scheduler-minikube            1/1     Running            1 (5m52s ago)    3h53m
kube-system   storage-provisioner                1/1     Running            8 (5m21s ago)    3h52m
```

- هنا هيجبلك اسم كل pod وهى موجوده فى اى namespace  وايه حالتها 

---

# Replicasets


```yml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: frontend
  labels:
    app: guestbook
    tier: frontend
spec:
  # modify replicas according to your case
  replicas: 3
  selector:
    matchLabels:
      tier: frontend
  template:
    metadata:
      labels:
        tier: frontend
    spec:
      containers:
      - name: php-redis
        image: us-docker.pkg.dev/google-samples/containers/gke/gb-frontend:v5

```

- لو دخلت على الـ documentation هتلاقى ملف الـ yml ده 
- هنا اول حاجه apivertion هنا apps/v1  
- هنا الـ kind هوا  replicaset 
- هنا الـ metadata الاسم هوا frontend ده ايم الـ pod 
- هنا الـ spec هنا فيه جزء الـ template ده الجزء الجديد

```bash
  replicas: 3
  selector:
    matchLabels:
      tier: frontend
```
- هنا فى الـ spec ده الجزء الخاص بالـ Replicaset   انته عايز تعمل pod والـ pod دى عباره عن سرفر واحد بس انته عايز تعمل duplication من السرفر بتاعك  يعنى انته عايز تخلى الـ nginx server عايز تعمله duplicate مثلا خمس مرات او تاخدله مثلا نسخه اربع مرات 
-  وبعد كده هتحط load balancer يشغللك الاربع سرفرات او الخمسه 

- هنا فى اول جزء الى هوا ده 
```bash
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: frontend
  labels:
    app: guestbook
    tier: frontend
spec:
  # modify replicas according to your case
  replicas: 3
  selector:
    matchLabels:
      tier: frontend
```
- ده خاص بالـ Replicaset   هنا بيقوله كرر تلت مرات من الـ pod الى تحت 

---
---
---


- اما الجزء التالى خاص بالـ pod 
```bash
  template:
    metadata:
      labels:
        tier: frontend
    spec:
      containers:
      - name: php-redis
        image: us-docker.pkg.dev/google-samples/containers/gke/gb-frontend:v5

```


---
---
- هنا انته قولتله   replicas: 3  يعنى بتقوله روح اعملى create 3 مرات  من الـ pod دى  كما يلى 
![[Pasted image 20260923195901.png]]
- فى حاله انك حذفت pod من دول  هيظهر حاجه اسمها replication controller    وظيفته انه يخلى الـ current pods الى هما دلوقتى 2 بعد الحذف يكونوا عددهم بيساوى الـ desire pods الى انته عايزهم فلو الـ current بقى 2 هنا الـ replicaset هيقوم هيعمل pod تالته بدل الى اتمسحت 

----
---
```yml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: frontend
  labels:
    app: guestbook
    tier: frontend
spec:
  # modify replicas according to your case
  replicas: 3
  selector:
    matchLabels:
      tier: frontend
  template:
    metadata:
      labels:
        tier: frontend
    spec:
      containers:
      - name: php-redis
        image: us-docker.pkg.dev/google-samples/containers/gke/gb-frontend:v5

```

وانته بتكتب الـ replicaset لازم الـ selector يكون زى الـ labels كما يلى 

```
  selector:
    matchLabels:
      tier: frontend
      
      ------------------------
     labels:
        tier: frontend
```
- دى الطريقه الى تربط بيها الـ replicaset ب الـ pod 

---

```bash
mostafa@MY-Home:~/Documents/Kubernates$ kubectl apply -f replicasets.yml 
replicaset.apps/frontend created
```
 - ده علشان تنفذ الحجات الى فى ملف الـ yml


```bash
mostafa@MY-Home:~/Documents/Kubernates$ kubectl get pod
NAME             READY   STATUS             RESTARTS         AGE
frontend-4rqq7   1/1     Running            0                8m37s
frontend-kkjxd   1/1     Running            0                8m37s
frontend-mrp72   1/1     Running            0                8m37s
mostafa          0/1     CrashLoopBackOff   49 (3m59s ago)   3h53m
myserver         1/1     Running            1 (113m ago)     3h45m
```
- هنا عملك تلاته من الـ pod

---
---
- علشان تجيب كل الـ replicaset الى عندك هتعمل الاتى
```bash
mostafa@MY-Home:~/Documents/Kubernates$ kubectl get rs
NAME       DESIRED   CURRENT   READY   AGE
frontend   3         3         3       9m55s
```
- هنا الـ current 3   وهنا الـ desire 3    يعنى مظبوطين

----
```bash
mostafa@MY-Home:~/Documents/Kubernates$ kubectl delete pod  frontend-4rqq7
pod "frontend-4rqq7" deleted from default namespace
mostafa@MY-Home:~/Documents/Kubernates$ 
```
- انته كده مسحت الـ pod دى  فلما تيجى تشوف الـ replicaset تانى هتلاقى الاتى 
```bash
mostafa@MY-Home:~/Documents/Kubernates$ kubectl get rs
NAME       DESIRED   CURRENT   READY   AGE
frontend   3         3         3       12m
mostafa@MY-Home:~/Documents/Kubernates$ kubectl get pod
NAME             READY   STATUS             RESTARTS       AGE
frontend-cbjcw   1/1     Running            0              77s
frontend-kkjxd   1/1     Running            0              12m
frontend-mrp72   1/1     Running            0              12m
mostafa          0/1     CrashLoopBackOff   50 (3m ago)    3h57m
myserver         1/1     Running            1 (117m ago)   3h50m
```
- هنا لما جيت اشوفهم بعد لما مسحت واحده لقيت عددهم زى ما هما 

```bash
mostafa@MY-Home:~/Documents/Kubernates$ kubectl describe rs frontend
Name:         frontend
Namespace:    default
Selector:     tier=frontend
Labels:       app=guestbook
              tier=frontend
Annotations:  <none>
Replicas:     3 current / 3 desired
Pods Status:  3 Running / 0 Waiting / 0 Succeeded / 0 Failed
Pod Template:
  Labels:  tier=frontend
  Containers:
   php-redis:
    Image:         us-docker.pkg.dev/google-samples/containers/gke/gb-frontend:v5
    Port:          <none>
    Host Port:     <none>
    Environment:   <none>
    Mounts:        <none>
  Volumes:         <none>
  Node-Selectors:  <none>
  Tolerations:     <none>
Events:
  Type    Reason            Age    From                   Message
  ----    ------            ----   ----                   -------
  Normal  SuccessfulCreate  13m    replicaset-controller  Created pod: frontend-4rqq7
  Normal  SuccessfulCreate  13m    replicaset-controller  Created pod: frontend-kkjxd
  Normal  SuccessfulCreate  13m    replicaset-controller  Created pod: frontend-mrp72
  Normal  SuccessfulCreate  2m26s  replicaset-controller  Created pod: frontend-cbjcw
```

```bash
 kubectl describe rs frontend
```
- ده امر علشان يجبلك كل تفاصيل الـ replicaset 

---
---
- فى حاله انك عايز تعدل على الـ replicaset وتخليها تكن اربعه هتعمل الاتى 
- هتكتب الامر الاتى 
```bash
mostafa@MY-Home:~/Documents/Kubernates$ kubectl edit rs frontend
```
![[Pasted image 20260923202823.png]]
- هيدخلك على الملف ده علشان تعدل فيه 

---
![[Pasted image 20260923202958.png]]
- هنا هتعدل على الجزء ده وتخليه 4 وكده هتعمل اربع نسخ
```bash
mostafa@MY-Home:~/Documents/Kubernates$ kubectl get rs
NAME       DESIRED   CURRENT   READY   AGE
frontend   4         4         4       20m
mostafa@MY-Home:~/Documents/Kubernates$ kubectl get po
NAME             READY   STATUS      RESTARTS        AGE
frontend-cbjcw   1/1     Running     0               9m28s
frontend-kkjxd   1/1     Running     0               20m
frontend-mrp72   1/1     Running     0               20m
frontend-zb6hj   1/1     Running     0               56s
mostafa          0/1     Completed   52 (6m5s ago)   4h5m
myserver         1/1     Running     1 (125m ago)    3h58m
```
- هنا عدلها علطول 

# Deployment
- هنا الـ deployment قايم على الـ replicaset
- انته كنت شغال على nginx 1 وبعدها عملت فيتشر جديده وبقيت شغال على nginx2 
- الـ deployment strategy  لما اجى اعمل update علشان  استخدم فيتشر جديده انا بقوله استخدم الـ rolling update 
- يعنى انا عندى 3 pod المفروض يعمل delete للقديم ويحط 3pod ويكونوا معمولين مع الـتحديثات الجديده هنا الـ rolling update بيعمل الاتى 
- بيقولك انا هحذف pod من القديمه واحطلك واحده جديده  وبعد كده اعملك واحده جديده واحطها مكان القديمه وهكذا لحد لما يبقى كله جديد الطريقه دى بتضمن انه ميحصلش down time للابليكشيشن يعنى الابليكشن ميقفش خالص 
- وفيه انواع من الـ deployment زى الـ canary and blue deployment


- لو انا عملت فيشر غلط وعايز ارجع للـ roll القديمه  يعنى عايز ارجع للـ version القديمه 
- فانته هتبدا انك تحفذف واحده من الى فيهم الفيتشر وتحط واحده من القديمه وبعد كده تعمل كده برضه مع الـ pod الى بعدها وهكذا لحد لما تعملهم كلهم 

- لو دخلت على الـ documentation هتلاقى ملف yml فيه ازاى تعمل deployment كما يلى 

```bash
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80

```
- هنا طبعا الـ replicaset موجوده اكيد 
- هنا قالك ان الـ kind هوا الـ deployment وبعد كده ندخل على الـ spec فى الـ spec فيه الـ selector وده هنا nginx ولازم يكون زى الـ labels وبرضه فى الـ labels هنا nginx 


---
---

```yml
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80
```
- ده خاص بالـ pod

----
---
```yml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
```
- ده خاص بالـ deployment

---
---

```bash
mostafa@MY-Home:~/Documents/Kubernates$ kubectl apply -f dep.yml 
deployment.apps/nginx-deployment created
```
- هنا علشان انك تطبق الى فى الملف ده 
---
----
```bash

  
mostafa@MY-Home:~/Documents/Kubernates$ kubectl get pods
NAME                                READY   STATUS             RESTARTS         AGE
frontend-cbjcw                      1/1     Running            1 (8m52s ago)    17h
frontend-kkjxd                      1/1     Running            1 (8m52s ago)    17h
frontend-mrp72                      1/1     Running            1 (8m52s ago)    17h
frontend-zb6hj                      1/1     Running            1 (8m52s ago)    17h
mostafa                             0/1     CrashLoopBackOff   58 (2m19s ago)   21h
myserver                            1/1     Running            2 (8m52s ago)    20h
nginx-deployment-54fd4d6d4c-hmqlb   1/1     Running            0                62s
nginx-deployment-54fd4d6d4c-pqs5c   1/1     Running            0                61s
nginx-deployment-54fd4d6d4c-vzwkz   1/1     Running            0                61s

```


---
---

- هنا علشان تعرف ايه الـ deployments الى عندك 

```bash
mostafa@MY-Home:~/Documents/Kubernates$ kubectl get deployment
NAME               READY   UP-TO-DATE   AVAILABLE   AGE
nginx-deployment   3/3     3            3           81s
```

---
---

```bash
mostafa@MY-Home:~/Documents/Kubernates$ kubectl describe deployment nginx-deployment 
Name:                   nginx-deployment
Namespace:              default
CreationTimestamp:      Thu, 24 Sep 2026 06:30:46 -0400
Labels:                 app=nginx
Annotations:            deployment.kubernetes.io/revision: 1
Selector:               app=nginx
Replicas:               3 desired | 3 updated | 3 total | 3 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:  app=nginx
  Containers:
   nginx:
    Image:         nginx:1.14.2
    Port:          80/TCP
    Host Port:     0/TCP
    Environment:   <none>
    Mounts:        <none>
  Volumes:         <none>
  Node-Selectors:  <none>
  Tolerations:     <none>
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Available      True    MinimumReplicasAvailable
  Progressing    True    NewReplicaSetAvailable
OldReplicaSets:  <none>
NewReplicaSet:   nginx-deployment-54fd4d6d4c (3/3 replicas created)
Events:
  Type    Reason             Age    From                   Message
  ----    ------             ----   ----                   -------
  Normal  ScalingReplicaSet  5m49s  deployment-controller  Scaled up replica set nginx-deployment-54fd4d6d4c from 0 to 3
```
- هنا ده وصف الـ deployment

```bash
deployment 
Name:                   nginx-deployment
Namespace:              default
CreationTimestamp:      Thu, 24 Sep 2026 06:30:46 -0400
Labels:                 app=nginx
Annotations:            deployment.kubernetes.io/revision: 1
Selector:               app=nginx
Replicas:               3 desired | 3 updated | 3 total | 3 available | 0 unavailable
StrategyType:           RollingUpdate
RollingUpdateStrategy:  25% max unavailable, 25% max surge

```
- هنا قالك على اسم الـ deployment وهنا الـ StrategyType  هنا الـ RollingUpdate ودى الطريقه الى انته لما تيجى تحدث بتحذف مثلا واحده من القديمه وتضيف واحده متحدثه 
	-  هنا RollingUpdateStrategy:  25% max unavailable, 25% max surge  بيقولك انه لما يحصل تحديث هيعمل delete للربع القديم ويضيف ربع جديد وهيظل يعمل كده لحد لما يخلصهم كلهم 

- هنا الـ max surge  معناهامثلا لو 50% max surge  معناها انك لما يكون مثلا عندك اربعه هوا هيعمل نصهم متحدث يعنى هيعمل اتنين متحدثين 
-  هنا   25% max unavailable  يعنى لما يجى يحذف هيحذف الربع يعنى لو عندك اربعه هيحذف واحده بس 

----
---

- لو انته عايز تعمل تحديث ممكن انك مثلا لو انته عايز تغير الـ image 
- ممكن تعمل الامر الاتى 
```bash
mostafa@MY-Home:~/Documents/Kubernates$ kubectl edit deployments.apps nginx-deployment 
```

![[Pasted image 20260924135300.png]]
- هنا انته ممكن تغير الـ image من هنا 

---
---

- او ممكن تستخدم طريقه تانيه كما يلى 
```bash
mostafa@MY-Home:~/Documents/Kubernates$ kubectl set image deployments/nginx-deployment nginx=nginx:latest
deployment.apps/nginx-deployment image updated
```
- علشان تعدل مباشره فى الـ image 
---
```bash
mostafa@MY-Home:~/Documents/Kubernates$ kubectl describe deployments.apps nginx-deployment 
Name:                   nginx-deployment
Namespace:              default
CreationTimestamp:      Thu, 24 Sep 2026 06:30:46 -0400
Labels:                 app=nginx
Annotations:            deployment.kubernetes.io/revision: 2
Selector:               app=nginx
Replicas:               3 desired | 3 updated | 3 total | 3 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:  app=nginx
  Containers:
   nginx:
    Image:         nginx:latest
    Port:          80/TCP
    Host Port:     0/TCP
    Environment:   <none>
    Mounts:        <none>
  Volumes:         <none>
  Node-Selectors:  <none>
  Tolerations:     <none>
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Available      True    MinimumReplicasAvailable
  Progressing    True    NewReplicaSetAvailable
OldReplicaSets:  nginx-deployment-54fd4d6d4c (0/0 replicas created)
NewReplicaSet:   nginx-deployment-86b876f474 (3/3 replicas created)
Events:
  Type    Reason             Age   From                   Message
  ----    ------             ----  ----                   -------
  Normal  ScalingReplicaSet  35m   deployment-controller  Scaled up replica set nginx-deployment-54fd4d6d4c from 0 to 3
  Normal  ScalingReplicaSet  72s   deployment-controller  Scaled up replica set nginx-deployment-86b876f474 from 0 to 1
  Normal  ScalingReplicaSet  70s   deployment-controller  Scaled down replica set nginx-deployment-54fd4d6d4c from 3 to 2
  Normal  ScalingReplicaSet  70s   deployment-controller  Scaled up replica set nginx-deployment-86b876f474 from 1 to 2
  Normal  ScalingReplicaSet  68s   deployment-controller  Scaled down replica set nginx-deployment-54fd4d6d4c from 2 to 1
  Normal  ScalingReplicaSet  68s   deployment-controller  Scaled up replica set nginx-deployment-86b876f474 from 2 to 3
  Normal  ScalingReplicaSet  66s   deployment-controller  Scaled down replica set nginx-deployment-54fd4d6d4c from 1 to 0
```
- هنا علشان توصف الـ deployment هتعمل الامر ده هنا عدل الـ image خلالها lateest 
-

```bash
  Labels:  app=nginx
  Containers:
   nginx:
    Image:         nginx:latest
    Port:          80/TCP
    Host Port:     0/TCP
    Environment:   <none>
    Mounts:        <none>
  Volumes:         <none>
  Node-Selectors:  <none>
  Tolerations:     <none>
```
- اما هنا التحديثات الى حصلت انه بيشيل pod ويحط واحده من الى حصلها التحديث 
```bash
  Type    Reason             Age   From                   Message
  ----    ------             ----  ----                   -------
  Normal  ScalingReplicaSet  35m   deployment-controller  Scaled up replica set nginx-deployment-54fd4d6d4c from 0 to 3
  Normal  ScalingReplicaSet  72s   deployment-controller  Scaled up replica set nginx-deployment-86b876f474 from 0 to 1
  Normal  ScalingReplicaSet  70s   deployment-controller  Scaled down replica set nginx-deployment-54fd4d6d4c from 3 to 2
  Normal  ScalingReplicaSet  70s   deployment-controller  Scaled up replica set nginx-deployment-86b876f474 from 1 to 2
  Normal  ScalingReplicaSet  68s   deployment-controller  Scaled down replica set nginx-deployment-54fd4d6d4c from 2 to 1
  Normal  ScalingReplicaSet  68s   deployment-controller  Scaled up replica set nginx-deployment-86b876f474 from 2 to 3
  Normal  ScalingReplicaSet  66s   deployment-controller  Scaled down replica set nginx-deployment-54fd4d6d4c from 1 to 0
```

---
---

```bash
mostafa@MY-Home:~/Documents/Kubernates$ kubectl set image deployments/nginx-deployment nginx=nginx:hello
deployment.apps/nginx-deployment image updated
```
- هنا انته عملت update وخليتها nginx نسخه hello ودى مش موجوده علشان كده هيحصل ايرور 

```bash
mostafa@MY-Home:~/Documents/Kubernates$ kubectl get pods --watch
NAME                                READY   STATUS             RESTARTS         AGE
frontend-cbjcw                      1/1     Running            2 (14m ago)      17h
frontend-kkjxd                      1/1     Running            2 (14m ago)      18h
frontend-mrp72                      1/1     Running            2 (14m ago)      18h
frontend-zb6hj                      1/1     Running            2 (14m ago)      17h
mostafa                             0/1     CrashLoopBackOff   69 (2m52s ago)   21h
myserver                            1/1     Running            3 (14m ago)      21h
nginx-deployment-659c4c8869-lnmkw   0/1     ImagePullBackOff   0                79s
nginx-deployment-86b876f474-qxhxk   1/1     Running            0                10m
nginx-deployment-86b876f474-wrhgq   1/1     Running            0                10m
nginx-deployment-86b876f474-zpf9c   1/1     Running            0                10m
nginx-deployment-659c4c8869-lnmkw   0/1     ErrImagePull       0                80s
nginx-deployment-659c4c8869-lnmkw   0/1     ImagePullBackOff   0                96s
```
- هنا بيقولك انه وهوا بيجيب الـ image دى وبيعملها pull بيديه ايرور فكده الـ update ده فيه مشكله ازاى ارجع تانى للنسخه القديمه 

----
---
- دلوقتى عايز ترجع للنسحه القديمه تانى بعد لما التحديث كان بايظ 
```bash
mostafa@MY-Home:~/Documents/Kubernates$ kubectl rollout undo deployment/nginx-deployment
```
- هنا الامر ده بيرجعك للى كنت عليه قبل التحديث
```bash
mostafa@MY-Home:~/Documents/Kubernates$ kubectl rollout undo deployment/nginx-deployment


Warning: resource deployments/nginx-deployment was previously managed with 'kubectl apply'. Rolling back will not update the kubectl.kubernetes.io/last-applied-configuration annotation, which may cause unexpected behavior on future 'kubectl apply' operations. Consider using 'kubectl apply' with your previous configuration file instead.
deployment.apps/nginx-deployment rolled back

```


```bash
mostafa@MY-Home:~/Documents/Kubernates$ kubectl get pod
NAME                                READY   STATUS             RESTARTS        AGE
frontend-cbjcw                      1/1     Running            2 (21m ago)     18h
frontend-kkjxd                      1/1     Running            2 (21m ago)     18h
frontend-mrp72                      1/1     Running            2 (21m ago)     18h
frontend-zb6hj                      1/1     Running            2 (21m ago)     17h
mostafa                             0/1     CrashLoopBackOff   70 (5m5s ago)   21h
myserver                            1/1     Running            3 (21m ago)     21h
nginx-deployment-86b876f474-qxhxk   1/1     Running            0               17m
nginx-deployment-86b876f474-wrhgq   1/1     Running            0               17m
nginx-deployment-86b876f474-zpf9c   1/1     Running            0               17m
```
- هنا بيقولك ان كله شغال عادى يعنى رجع اشتغل 

---
---

```bash
mostafa@MY-Home:~/Documents/Kubernates$ kubectl delete deployments.apps/nginx-deployment 
deployment.apps "nginx-deployment" deleted from default namespace
```

- علشان تحذف deployment

---
---
```yml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 1
      maxSerge:1
```
- هنا فى الجزء الاخير الى اتضاف ده 
```yml
 strategy:
   type: RollingUpdate
   rollingUpdate:
     maxUnavailable: 1
     maxSerge:1
```
- هنا انته هتحدد عدد الى هيتمسح والى هيتضاف فى التحديث فى ملف yml

```bash
mostafa@MY-Home:~/Documents/Kubernates$ kubectl apply -f dep.yml 
deployment.apps/nginx-deployment created
```
  - هنا بعد البناء 
```bash
mostafa@MY-Home:~/Documents/Kubernates$ kubectl get pods
NAME                                READY   STATUS             RESTARTS         AGE
frontend-cbjcw                      1/1     Running            2 (52m ago)      18h
frontend-kkjxd                      1/1     Running            2 (52m ago)      18h
frontend-mrp72                      1/1     Running            2 (52m ago)      18h
frontend-zb6hj                      1/1     Running            2 (52m ago)      18h
mostafa                             0/1     CrashLoopBackOff   79 (3m23s ago)   22h
myserver                            1/1     Running            3 (52m ago)      22h
nginx-deployment-54fd4d6d4c-bstzx   1/1     Running            0                34s
nginx-deployment-54fd4d6d4c-dqxj2   1/1     Running            0                34s
nginx-deployment-54fd4d6d4c-pmcj9   1/1     Running            0                34s
mostafa@MY-Home:~/Documents/Kubernates$ 
```

---
---
---
```bash
mostafa@MY-Home:~/Documents/Kubernates$ kubectl describe deployments.apps/nginx-deployment 
Name:                   nginx-deployment
Namespace:              default
CreationTimestamp:      Thu, 24 Sep 2026 07:52:46 -0400
Labels:                 app=nginx
Annotations:            deployment.kubernetes.io/revision: 1
Selector:               app=nginx
Replicas:               3 desired | 3 updated | 3 total | 3 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  1 max unavailable, 1 max surge
Pod Template:
  Labels:  app=nginx
  Containers:
   nginx:
    Image:         nginx:1.14.2
    Port:          80/TCP
    Host Port:     0/TCP
    Environment:   <none>
    Mounts:        <none>
  Volumes:         <none>
  Node-Selectors:  <none>
  Tolerations:     <none>
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Available      True    MinimumReplicasAvailable
  Progressing    True    NewReplicaSetAvailable
OldReplicaSets:  <none>
NewReplicaSet:   nginx-deployment-54fd4d6d4c (3/3 replicas created)
Events:
  Type    Reason             Age    From                   Message
  ----    ------             ----   ----                   -------
  Normal  ScalingReplicaSet  3m14s  deployment-controller  Scaled up replica set nginx-deployment-54fd4d6d4c from 0 to 3
```
- هنا مكتبش ايه الـ cpu ولا حتى الميمورى يعنى هيقعد يستهلك من الريسورسز لحد  لما يوصل لكل الريسورسز بتاعه الـ node  المفروض تديها ريسورس علشان متكترش عنه 

---
----

# Resources

- انته هتعمل سيرش عادى على جوجل مش لازم تحفظ اى حاجه هتلاقى ده ظهرلك 

![[Pasted image 20260924150204.png]]
- هنا هيظهرلك ده هتدخل عليه هتلاقى الـ documentation 

## Resource pods

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: frontend
spec:
  containers:
  - name: app
    image: images.my-company.example/app:v4
    resources:
      requests:
        memory: "64Mi"
        cpu: "250m"
      limits:
        memory: "128Mi"
        cpu: "500m"
  - name: log-aggregator
    image: images.my-company.example/log-aggregator:v6
    resources:
      requests:
        memory: "64Mi"
        cpu: "250m"
      limits:
        memory: "128Mi"
        cpu: "500m
```

- هنا بيقولك ازاى تتكم فى الريسورسز بتاعه الـ pod الى انته هتعملها 
- بيكون عامل حاجه اسمها request and limits
-  اول لما الـ pod تشتغل هتبدا من عند الـ requests وهتبدا ب memory = 64 mi    والـ cpu = 250m   
- وفى الـ limits يعنى اخرها فى الميمورى لحد 128 ميجا فى الـ cpu اخرها لحد 500 ميجا


- طبعا هنا عندك ,واحد pod بس فيه اتنين كونتينر 
```bash
mostafa@MY-Home:~/Documents/Kubernates$ kubectl apply -f resourcePod.yml 
pod/frontend created
```


```bash
mostafa@MY-Home:~/Documents/Kubernates$ kubectl describe pods frontend
Name:             frontend
Namespace:        default
Priority:         0
Service Account:  default
Node:             minikube/192.168.49.2
Start Time:       Thu, 24 Sep 2026 08:16:47 -0400
Labels:           <none>
Annotations:      <none>
Status:           Running
IP:               10.244.0.21
IPs:
  IP:  10.244.0.21
Containers:
  app:
    Container ID:   containerd://cf30f8912ddc7acff8f65ebbed32bc0440d5f2d5163b2f78a0801c32c9a30288
    Image:          nginx
    Image ID:       docker.io/library/nginx@sha256:abe47724e466aeab9a345d8e46a221c2fa8953c7848bb4a3bd9976a7199f8cf2
    Port:           <none>
    Host Port:      <none>
    State:          Running
      Started:      Thu, 24 Sep 2026 08:16:51 -0400
    Ready:          True
    Restart Count:  0
    Limits:
      cpu:     500m
      memory:  128Mi
    Requests:
      cpu:        250m
      memory:     64Mi
    Environment:  <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-pfrwl (ro)
Conditions:
  Type                        Status
  PodReadyToStartContainers   True 
  Initialized                 True 
  Ready                       True 
  ContainersReady             True 
  PodScheduled                True 
Volumes:
  kube-api-access-pfrwl:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    Optional:                false
    DownwardAPI:             true
QoS Class:                   Burstable
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  101s  default-scheduler  Successfully assigned default/frontend to minikube
  Normal  Pulling    100s  kubelet            spec.containers{app}: Pulling image "nginx"
  Normal  Pulled     98s   kubelet            spec.containers{app}: Successfully pulled image "nginx" in 1.531s (1.531s including waiting). Image size: 63422407 bytes.
  Normal  Created    98s   kubelet            spec.containers{app}: Container created
  Normal  Started    97s   kubelet            spec.containers{app}: Container started
```
- هنا المره دى ظهرلك الـ resources



----

## Resource namespace and Resource Quotas 

- هنا ممكن تحدد ايه حجم الـ cpu and memory وايه عدد الـ pods الى ممكن تعملها ولو جه يعمل اكثر من الى متحدد متتعملش
- علشان تعمل الـ limits دى للـ namespace هتبحث عن الـ  Resource Quotas 
```shell
cat <<EOF > object-counts.yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: object-counts
spec:
  hard:
    configmaps: "10"
    persistentvolumeclaims: "4"
    pods: "4"
    replicationcontrollers: "20"
    secrets: "10"
    services: "10"
    services.loadbalancers: "2"
EOF
```
- هنا بيقولك ان اقصى عدد من الـ pods هوا 4   وان هنا عند اخرك اتنين load balancer

---
- انته الاول بتعمل الـ namespace وبتعدها بتعدل على الاعدادت الى فاتتت دى 

- فى الـ documentation لقيت الاتى 
```shell
cat <<EOF > compute-resources.yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: compute-resources
spec:
  hard:
    requests.cpu: "1"
    requests.memory: "1Gi"
    limits.cpu: "2"
    limits.memory: "2Gi"
    requests.nvidia.com/gpu: 4
EOF
```
- هاخد منها بس الاتى 
```bash
    requests.cpu: "1"
    requests.memory: "1Gi"
    limits.cpu: "2"
    limits.memory: "2Gi"
    requests.nvidia.com/gpu: 4
```

---
---
```yml
apiVersion: v1
kind: Namespace
metadata:
  name: mynamespacemostafa

---
apiVersion: v1
kind: ResourceQuota
metadata:
  name: object-counts
  namespace: mynamespacemostafa
spec:
  hard:
    pods: "3"
    requests.cpu: "1"
    requests.memory: "1Gi"
    limits.cpu: "2"
    limits.memory: "2Gi"
    requests.nvidia.com/gpu: 4
    
```
- ده شكل الملف النهائى بعد لما خلص الاول فوق عملت الـ namespace الجديده وطبعا الرسورسز بتكون فى ملف منفصل فانته علشان عايز تعملهم فى نفس الملف عملت الاتى 
- الاول حطيت الـ --- التلت شرط دول معناهم ان الى جاى تحتى ده اعتبره ملف جديد وتحت دول --- عملت الاعدادت الى تخليك تحط الريسورسز بتاعه الـ namespace

---
```bash
mostafa@MY-Home:~/Documents/Kubernates$ kubectl apply -f ns.yml 
namespace/mynamespacemostafa created
resourcequota/object-counts created
```
 - هوا هنا عمل حاجتين عمل الـ namespace وعمل الـ resource quota

```bash
mostafa@MY-Home:~/Documents/Kubernates$ kubectl describe namespaces mynamespacemostafa 
Name:         mynamespacemostafa
Labels:       kubernetes.io/metadata.name=mynamespacemostafa
Annotations:  <none>
Status:       Active

Resource Quotas
  Name:                    object-counts
  Resource                 Used  Hard
  --------                 ---   ---
  limits.cpu               0     2
  limits.memory            0     2Gi
  pods                     0     3
  requests.cpu             0     1
  requests.memory          0     1Gi
  requests.nvidia.com/gpu  0     4

No LimitRange resource.
```

---
```bash
mostafa@MY-Home:~/Documents/Kubernates$ kubectl get resourcequotas -n mynamespacemostafa 
NAME            REQUEST                                                                              LIMIT                                   AGE
object-counts   pods: 0/3, requests.cpu: 0/1, requests.memory: 0/1Gi, requests.nvidia.com/gpu: 0/4   limits.cpu: 0/2, limits.memory: 0/2Gi   3m57s
```
- هنا بيقولك ايه عدد الـ cpu المستخدم وايه الـ pods المستخدمه وهكذا 

---
---
```bash
mostafa@MY-Home:~/Documents/Kubernates$ kubectl apply -f resourcePod.yml  -n mynamespacemostafa   
pod/frontend created
```
- هنا انته عملت الـ pod دى فى الـ name space الى انته لسه عاملها ومحدد الـ limits بتاعتها 
```yml
apiVersion: v1
kind: Pod
metadata:
  name: frontend
spec:
  containers:
  - name: app
    image: nginx
    resources:
      requests:
        memory: "64Mi"
        cpu: "250m"
      limits:
        memory: "128Mi"
        cpu: "500m"
```
- ده ملف الـ pod الى انته هتعمله 

```bash
mostafa@MY-Home:~/Documents/Kubernates$ kubectl get resourcequotas -n mynamespacemostafa 
NAME            REQUEST                                                                                    LIMIT                                          AGE
object-counts   pods: 1/3, requests.cpu: 250m/1, requests.memory: 64Mi/1Gi, requests.nvidia.com/gpu: 0/4   limits.cpu: 500m/2, limits.memory: 128Mi/2Gi   9m44s
```
- هنا بيقولك ان الـ pods الى اتعملت هى واحده بس وقد ايه استخدمت من الـ memory and cpu
---
---

- لو عملنا كمان واحده زى الـ pod الى فاتت دى بس هنغير بس اسم الـ pod هيحصل الاتى 

```bash
mostafa@MY-Home:~/Documents/Kubernates$ kubectl apply -f resourcePod.yml  -n mynamespacemostafa   
pod/backend created
```

---
```bash
mostafa@MY-Home:~/Documents/Kubernates$ kubectl get resourcequotas -n mynamespacemostafa 
NAME            REQUEST                                                                                     LIMIT                                       AGE
object-counts   pods: 2/3, requests.cpu: 500m/1, requests.memory: 128Mi/1Gi, requests.nvidia.com/gpu: 0/4   limits.cpu: 1/2, limits.memory: 256Mi/2Gi   12m
```
- هنا بيقولك ان فيه 2 pods وبيقولك على الموارد المستخدمه 

- وبعد لما عملت كمان pod بقوا تلاته ولكن لما عملت الرابعه حصل الاتى 
```bash
mostafa@MY-Home:~/Documents/Kubernates$ kubectl apply -f resourcePod.yml  -n mynamespacemostafa   
Error from server (Forbidden): error when creating "resourcePod.yml": pods "backend2" is forbidden: exceeded quota: object-counts, requested: pods=1, used: pods=3, limited: pods=3
```
- هنا ادام ايرور بيقولك المستخدم هما 3 واليميت بتاعك هوا 3 علشان كده مينفعش تعمل واحد جديد

---
----
----
```bash
mostafa@MY-Home:~/Documents/Kubernates$ kubectl get pods -n mynamespacemostafa 
NAME       READY   STATUS    RESTARTS   AGE
backend    1/1     Running   0          4m37s
backend1   1/1     Running   0          2m12s
frontend   1/1     Running   0          9m24s
```

---
---
- لو انته عايز تحذف pod من دول هتعمل الاتى 
```bash
mostafa@MY-Home:~/Documents/Kubernates$ kubectl delete pod backend -n 
mynamespacemostafa 
pod "backend" deleted from mynamespacemostafa namespace
```
----
```bash
mostafa@MY-Home:~/Documents/Kubernates$ kubectl get resourcequotas -n mynamespacemostafa 
NAME            REQUEST                                                                                     LIMIT                                       AGE
object-counts   pods: 2/3, requests.cpu: 500m/1, requests.memory: 128Mi/1Gi, requests.nvidia.com/gpu: 0/4   limits.cpu: 1/2, limits.memory: 256Mi/2Gi   20m
```

- دلوقتى لو انته جيت تخلى الـ cpu request اكثر من 500 ميجا  مش هيرضى اصلا لان حاطط ليميت 

# Limit range
- ده بيتطبق على الكونتينر نفسه 
```yml
apiVersion: v1
kind: LimitRange
metadata:
  name: cpu-resource-constraint
  namespace: limit
spec:
  limits:
    - type: "Container"
      default:
        cpu: "300m"
        memory: "200Mi"
      defaultRequest:
        cpu: "200m"
        memory: "100Mi"
```
- هنا فى الـ limits انته بتقول فى حاله انك عملت pod ومدتهاش اى limits كده الـ default request هيكون 200  واخرك 300 والميمورى هتكون 100 واخرك 200

---
```yml
apiVersion: v1
kind: Namespace
metadata:
  name: limit
---
apiVersion: v1
kind: LimitRange
metadata:
  name: cpu-resource-constraint
  namespace: limit
spec:
  limits:
    - type: "Container"
      default:
        cpu: "300m"
        memory: "200Mi"
      defaultRequest:
        cpu: "200m"
        memory: "100Mi"
---
apiVersion: v1
kind: ResourceQuota
metadata:
  name: object-counts
  namespace: limit
spec:
  hard:
    pods: "3"
    requests.cpu: "1"
    requests.memory: "1Gi"
    limits.cpu: "2"
    limits.memory: "2Gi"
    requests.nvidia.com/gpu: 4
    
    
```
- هنا الملف ده فيه كل حاجه يعنى فيه انه يعمل namespace وبعدها يعمل برضه الـ limit range وبعدها يعمل الـ resource quota 
- هنا الـ limit range فى حاله ان الـ pod الى انته بتعملها مش محدد الريسورس هنا بيعملك ريسورس افترضى للـ container الى هتعمل من غير ما تحددله الريسورس 

```yml
apiVersion: v1
kind: Namespace
metadata:
  name: limit
---
apiVersion: v1
kind: LimitRange
metadata:
  name: cpu-resource-constraint
  namespace: limit
spec:
  limits:
    - type: "Container"
      default:
        cpu: "300m"
        memory: "200Mi"
      defaultRequest:
        cpu: "200m"
        memory: "100Mi"
---
apiVersion: v1
kind: ResourceQuota
metadata:
  name: object-counts
  namespace: limit
spec:
  hard:
    pods: "3"
    requests.cpu: "1"
    requests.memory: "1Gi"
    limits.cpu: "2"
    limits.memory: "2Gi"
    requests.nvidia.com/gpu: 4
    
```
- خلى بالك لازم اسم الـ nameapace يكون فى البدايه وبعدها يكون فى resource quote  ويكون فى الـ limit range
- يكون نفس الاسم 

----
---
```bash
mostafa@MY-Home:~/Documents/Kubernates$ kubectl apply -f ns.yml 
namespace/limit created
limitrange/cpu-resource-constraint created
resourcequota/object-counts created
```
- هنا عمل التلت حجات 

- علشان تجيب الـ limit range هتعمل الاتى 
```bash
mostafa@MY-Home:~/Documents/Kubernates$ kubectl get limitranges -n limit 
NAME                      CREATED AT
cpu-resource-constraint   2026-09-24T13:38:57Z
```

---
---
- فى حاله انك هتعمل pod والـ pod دى انته اديتلها recourses  زى الـ CPU and memory كده هوا مش هيستخدم الـ limit range الى بتتعمل للكونيتنر لما متكونش محدد اى ريسورسز 

---
---
```yml
apiVersion: v1
kind: LimitRange
metadata:
  name: cpu-resource-constraint
  namespace: limit
spec:
  limits:
    - type: "Container"
      max:
        cpu: "2"
        memory: "1Gi"
      min:
        cpu: "100m"
        memory: "4Mi"
```
- هنا لما تيجى تكريت دى هنا اليميت ده بيخليك انك متقلش عن 4  ميجا ومتزدش عن 1 جيجا

---
---

# Network K8S Service
- لما بتعمل pod كل pod بتاخد ip  لو خد مثلا 172.168.5.20  هنا الـ kubernates  لما يجى يعمل record dns للـ pod دى بياخد الـ ip وبيكمل عليه 
- I 172-168-5-20.pod.namespace.cluster.local 
- ده الـ internal dns  لو افترضنا ان حصل مشكله والـ pod وقعت وقامت دلوقتى الـ ip هيتغير اول لما تقوم كده الـ dns بتاعها هيتغير فكده مش هتعرف تكلمه 
- فعلشان نلاقى حل للموضوع ده عملوا service  علشان يحل المشكله دى  


-  هنا الـ service حلت المشكله عن طريق انها بتسجل الـ dns record عن طريق انها بتسجله عن طريق اسم الـ service نفسها 
- يعنى لو كان اسمها nginx-one  يبقى الـ dns record هيكون كما يلى 
- nginx-one.svc.namespace.cluster.local 
- هنا حتى لو الخدمه وقعت هترجع تشتغل تانى لانها بنفش الاسم 
-  انته بتربط الـ service ب الـ pod عن طريق حاجه اسمها الـ labels

----
---
## kind of services
-  هنا الـ cluster ip هنا الترافيك  بيكون جوه الـ kubernates هنا بيتكلموا جوه الcluster بس  
- الـ node port ده بيخلى الابليكشنز الى بره تكلمك عادى  بحيث انه بيديك بورت زياده تكلم الناس الى بره عادى 
- الـ loadbalace  لما بيكون عندك load balancer خارجيه انته بتكون عايز الترافيك يجيلك من الـ load balancer للـ جهاز بتاعك علشان كده بتحط الـ ip بتاع  الـ load balancer عندك علشان تعرف تتعامل معاها

![[Pasted image 20260924185137.png]]

# How to create a service

- الاول عملت namespace وعملت ملف للـ pod 

```bash
mostafa@MY-Home:~/Documents$ kubectl create namespace nginx
namespace/nginx created
  
mostafa@MY-Home:~/Documents/Kubernates$ touch podWithConfig.yml
```

- بعد كده دخلت على الدوكيومينتيشن على الجزء الخاص بالـ service k8s  
- لقيت الاتى 

![[Pasted image 20260926155044.png]]
- هنا جابيبلك الـ service مع الـ pod علشان يعملهم فى نفس الملف  
```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  selector:
    apps: nginx
  ports:
  - name: name-of-service-port
    protocol: TCP
    port: 80
    targetPort: http-web-svc

---
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  labels:
    apps: nginx
spec:
  containers:
  - name: nginx
    image: nginx:stable
    ports:
      - containerPort: 80
        name: http-web-svc
```

- ممكن تعمل كل واحد من دول فى ملف لوحده عادى اهم حاجه علشان تربط الـ service والـ pod ببعض تخلى الـ labels الى فى الـ pod زى الـ selector الى فى الـ service   كما يلى 
```yml
  labels:
    apps: nginx
```

```yml
  selector:
    apps: nginx
```

- هنا اسم الـ pod هنا اسمه nginx اما اسم الـ service هنا اسمه nginx-service  
---
```yml
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
```
- من هنا تقدر تعرف اسم الـ service 

```yml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
```
- من هنا تقدر تعرف اسم الـ pod
----
----
```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  selector:
    apps: nginx
  ports:
  - name: name-of-service-port
    protocol: TCP
    port: 80
    targetPort: http-web-svc

---
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  labels:
    apps: nginx
spec:
  containers:
  - name: nginx
    image: nginx:stable
    ports:
      - containerPort: 80
        name: http-web-svc
```
- هنا فى الـ pod هنا الـ ports هنا كاتبلك رقم البورت الى بيشتغل جوه الكونتينر اما فى الاسم فده اسم مستعار للبورت 
- اما فى الـ service عند الـ port  يعنى لما حد يحب  يكلم الـ service هيكلمها من على بورت 80  اما الـ target port ده الـ pod الى انته عايز تكلمه ممكن هنا تكتب رقم البورت بتاع الـ pod الى انته عايز تكلمه او ممكن تكتب اسمه المستعار الى فى الـ pod زى دى http-web-svc وهيشتغل عادى 

- وبعدها ولنفترض مثلا انى عملت ملفات pod and service للـ httpd  وعملتهم apply 
----
- بعد لما تعمل للملفات دى  apply
```bash
kubectl apply -f blabla.yml
```
- اول لما تعملهم apply ومثلا عايز تدخل على اى pod فيهم كما يلى 
```bash
mostafa@MY-Home:~/Documents/Kubernates$ kubectl get all -n nginx 
NAME        READY   STATUS    RESTARTS   AGE
pod/httpd   1/1     Running   0          58s
pod/nginx   1/1     Running   0          48m

NAME                TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)   AGE
service/httpd       ClusterIP   10.96.250.6   <none>        80/TCP    48s
service/nginx-svc   ClusterIP   10.98.79.52   <none>        80/TCP    21m
```

- هنا دول الـ pods والـ services 
- لو عايز تدخل عليهم هتعمل الاتى 

```bash
mostafa@MY-Home:~/Documents/Kubernates$ kubectl exec -it pod/nginx -n nginx -- bash
root@nginx:/# ls
bin   docker-entrypoint.d   home   media  proc  sbin  tmp
boot  docker-entrypoint.sh  lib    mnt    root  srv   usr
dev   etc                   lib64  opt    run   sys   var
root@nginx:/# 
```


-  لو انته عايز تكلم  الـ service  هتعمل  curl من على الـ pod بعد لما تدخلها  
```bash
root@nginx:/# curl nginx-svc.nginx.svc.cluster.local
```

- القاعده الى بتعمل من خلالها الـ curl على الـ dns 
```
<service-name>.<namespace>.svc.cluster.local
```


```bash
mostafa@MY-Home:~/Documents$ kubectl exec -it nginx -n nginx -- bash
root@nginx:/# curl httpd.nginx.svc.cluster.local
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
<title>It works! Apache httpd</title>
</head>
<body>
<p>It works!</p>
</body>
</html>
```
- هنا دخلت على السرفيس بتاعه الـ httpd اشتغلت عادى 
---
```bash
root@nginx:/# curl nginx-svc.nginx.svc.cluster.local
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, nginx is successfully installed and working.
Further configuration is required for the web server, reverse proxy, 
API gateway, load balancer, content cache, or other features.</p>

<p>For online documentation and support please refer to
<a href="https://nginx.org/">nginx.org</a>.<br/>
To engage with the community please visit
<a href="https://community.nginx.org/">community.nginx.org</a>.<br/>
For enterprise grade support, professional services, additional 
security features and capabilities please refer to
<a href="https://f5.com/nginx">f5.com/nginx</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```
- هنا السرفيس بتاعه الـ nginx شغاله 

---
---
# Define Environment Variables 
## basic env



- لو دخلت على الـ documentation هتلاقى 
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
  - name: nginx
    image: nginx
    ports:
    - containerPort: 80
    env:
    - name: depi
      value: "Hello from the environment"
```
- هنا بيعرف المتغيرات من خلال الـ env الى فى الـ pod  علطول يعنى انته مش محتاج تدخل جوه الـ container وتكتب الاتى 
```bash
export depi="Hello from the environment"
```
#### مين اللي بيستفاد من المتغير ده؟

**البرنامج اللي شغال جوه الـ container** (في المثال ده nginx)، أو أي **سكريبت/كود** انت كاتبه، هو اللي بيقرا القيمة دي وقت التشغيل.

يعني لو دخلت جوه الـ container وكتبت:
```bash
kubectl exec -it nginx -- printenv depi
```
- ده الى هيظهر 
```
Hello from the environment
```

----


- هنا انته بتعرف المتغيرات 
```yml
    - name: depi
      value: "Hello from the environment"
```
- هنا المتغير والقيمه بتاعته 
```bash
mostafa@MY-Home:~/Documents/Kubernates$ kubectl exec -it  nginx  -- bash
root@nginx:/# env
HOSTNAME=nginx
NJS_VERSION=1.14.2.0.2.6-1~stretch
NGINX_VERSION=1.14.2-1~stretch
KUBERNETES_PORT_443_TCP_PROTO=tcp
KUBERNETES_PORT_443_TCP_ADDR=10.96.0.1
KUBERNETES_PORT=tcp://10.96.0.1:443
PWD=/
HOME=/root
KUBERNETES_SERVICE_PORT_HTTPS=443
KUBERNETES_PORT_443_TCP_PORT=443

depi=Hello from the environment

KUBERNETES_PORT_443_TCP=tcp://10.96.0.1:443
TERM=xterm
SHLVL=1
KUBERNETES_SERVICE_PORT=443
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
KUBERNETES_SERVICE_HOST=10.96.0.1
_=/usr/bin/env
```
- هنا الـ env ظهرت 
- مثلا لو فيه pod للـ frontend and pod for backend and pod for database
- وطبعا هتعمل لكل واحده service علشان يتكلموا مع بعض 
- علشان تعرف الـ environment variables مع بعض  المفروض انك لما تيجى تكريت pod هتتعامل مع ملف الـ yml بتاع الـ pod  بيكون فيه جزء خاص بالـ  env بداخل الـ pod  


- بس لو حبيت انك تغير فى الـ env كده هتضطر انك تحذف الـ pod وتكتب من الاول تانى الـ env
   لانك كده غيرت فى الـ pod فهتضطر تحذفه وتنزله تانى الى هوا الـ pod
- اما بالنسبه للـ deployment ممكن تعدل فى الملف بتاعها  وبعدها تبدا الـ deployment تحدث 

---
---
- علشان تحل المشكله الى فاتت دى عملت حاجه اسمها config map علشان تحط فيه كل الـ environment variables   وبعد كده هتقول للـ pod   ان الـ config map موجود فيها كل الـ variables الى انته عايزها    بس برضه هتكون عايز تمسح الـ pod وتنزلها تانى 


- علشان تحل المشكله دى هتحط الـ configuration فى volume

---
---
## Config map

```yml
apiVersion: v1
kind: ConfigMap
metadata:
  name: nginx-env
  namespace: nginx
data:
  DEPI: "hello"
  GROUP: "NHA"
```
انته علشان تعمل الـ config map بالشكل الصحيح الاول لازم هتبحث مثلا الاول فى الـ documentation  هتلاقى ملف الـ yml الى هنا ده الى الـ kind بتاعه هوا الـ configmap لازم الاول تحط الملف ده وبعدها تحط الداتا بتاعته الى هى دى 
- هنا اسم الـ config map اسمها nginx-env 

```yml
data:
  DEPI: "hello"
  GROUP: "NHA"
```
- بعد لما تعمل دول هتعمل بعدها الـ pod وتحط فى الـ pod الاتى علشان تعرف تربط بن الـ config map  والـ pod   فلازم تعمل الاتى 
```yml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  namespace: nginx
spec:
  containers:
    - name: nginx
      image: nginx:stable
      env:
        - name: DEPI
          valueFrom:
            configMapKeyRef:
              name: nginx-env
              key: DEPI
```

- هنا انا ضيفت الاتى 
```yml
      env:
        - name: DEPI
          valueFrom:
            configMapKeyRef:
              name: nginx-env
              key: DEPI
```

- انته هنا  سميت الـ env اسمها depi  وهنا  انته هتقوله انته هتجيب المعلومات من الـ config map الى اسمها ايه فهنا 
```yml
          valueFrom:
            configMapKeyRef:
              name: nginx-env
              key: DEPI
```
- هنا اسم الـ config map اسمها nginx-env  والـ key الى جواها اسمه DEPI    كده هيقدر يعرف البيانات الى جواه 

- بس لو انته مثلا غيرت فى قيمه الـ DEPI  او عايز تضيف متغير جديد كده لازم تحذف الـ pod وتنزلها تانى 
---


## Volumes

- قبل ما تعمل الـ volume ممكن انك الاول تعمل حاجه اسمها config map  او ممكن تعمل secret   ممكن تعمل كذا حاجه علشان بعد كده تقدر تاخد منها البيانات فى الـ volume    ومن ضمن الحجات الى ممكن تاخد منها البيانات فى الـ volume هى الـ config map and secret


## Volume with config map


```yml
# config-map.yml
apiVersion: v1
kind: ConfigMap
metadata:
  name: nginx
  namespace: nginx
data:
  log_level: "warn"
```
- الاول عملت config map وهنا اسمها هوا nginx وهى موجوده فى الـ namespace الى اسمها nginx
-  بعد كده هتعمل الـ pod مع الـ volume وهتربطه بالـ config map كما يلى 
```yaml
# pod.yml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  namespace: nginx
spec:
  containers:
    - name: server
      image: nginx
      volumeMounts:
        - name: depi
          mountPath: /etc/config
  volumes:
    - name: depi
      configMap:
        name: nginx
        items:
          - key: log_level
            path: log_level.conf
```

```yml
  volumes:
    - name: depi
      configMap:
        name: nginx
        items:
          - key: log_level
            path: log_level.conf
```
- اول سطر ده بيقول  او بيعرف الملف انى هعمل  volumes 
- ممكن يبقى تحته أكتر من volume (احنا هنا عندنا واحد بس).
- بعد كده اول name هنا هوا اسم الـ volume  الى هيكون اسمه depi  
- بعد كده الـ config map  ده  الى انته هتاخد الداتا  ممكن تحط هنا الحاجه الى هتاخد منها الداتا ممكن تكون secret او حاجه تانيه 
- وبعد كده تانى name الى هوا اسم الـ config map الى انته هتاخد منها الدتا 

-  السطر 5: `items:` معناها: **"أنا مش عايز آخد كل الـ ConfigMap زي ما هو، أنا عايز أختار keys معينة بس 
- بعد كده اخترت الـ key الى انا عايزه بس كما يلى  key: log_level 
-  كده هيروح يجيب القيمه الى موجوده فى الـ config map والى المفتاح بتاعه هوا الـ log_level  
   ويحطها فى الملف الى اسمه log_level.conf

```yml
      volumeMounts:
        - name: depi
          mountPath: /etc/config
```
- هنا الاسم name ده اسم الـ volume  والـ mountPath   يعنى المسار ده /etc/config   يعنى اول لما لما تعمل الكونتينر هتدخل جواه وهتعمل المسار ده وبعدها تعمل الملف ده log_level.conf  وهيكون جواه القيمه بتاعه المفتاح الى فى الـ config map الى اسمه nginx
```bash
kubectl apply -f pod.yml -n nginx
```

- بعد لما تبنى الملف وتعمل الاتى 
```bash
kubectl exec -it nginx -n nginx -- cat /etc/config/log_level.conf
```

```result
warn
```
---
---

- هل لو انا غيرت القيمه الى جوه الـ config map  هل لازم احذف الـ pod  وعملها من الاول تانى ؟
- لا مش لازم 

- هتعمل الاتى 
```bash
kubectl edit configmap nginx -n nginx
```

غيّر `log_level` من `warn` لـ `debug` مثلًا، واحفظ.
استنى دقيقة لدقيقتين، وبعدين اعمل:

```bash
kubectl exec -it nginx -n nginx -- cat /etc/config/log_level.conf
```
هتلاقي القيمة اتغيرت لـ `debug` **من غير ما تلمس الـ Pod خالص**، لا حذف ولا إعادة تشغيل.

----
---
- طيب لو انته ضيفت  مفتاح جديد وانته مكنتش ضايفه فى ملف الـ pod  لما عملت الـ volume  كده لازم تحذف الـ pod وتعملها تانى علشان يتضاف 

- بس لو انته مكنتش محدد items معينه كده هياخد كل الى فى الملف يعنى لو ضيفت keys جديده فى الـ config map كده كده هتظهر فى الملف الى على الكونتينر علشان وانته بتعمل volume محددتش عناصر معنيه كما يلى 
```yml
volumes:
  - name: depi
    configMap:
      name: nginx
```
- هنا انته محددتش اى عناصر علشان كده لو ضيفت اى keys مش لازم تحذف الـ pod وتنزلها تانى لانها تانى لانها  بتتحدث بشكل تلقائى  وهيتعمل ملف بشكل تلقائى فى الفولدر ده /etc/config 


- يبقى هتعمل الاتى 

```yml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  namespace: nginx
spec:
  containers:
    - name: server
      image: nginx
      volumeMounts:
        - name: depi
          mountPath: /etc/config
  volumes:
    - name: depi
      configMap:
        name: nginx

```

## Volume with secret

### how to create secret
- ادخل على الـ documentation وابحث عنها  secret k8s

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: dotfile-secret
data:
  .secret-file: dmFsdWUtMg0KDQo=
---
apiVersion: v1
kind: Pod
metadata:
  name: secret-dotfiles-pod
spec:
  volumes:
    - name: secret-volume
      secret:
        secretName: dotfile-secret
  containers:
    - name: dotfile-test-container
      image: registry.k8s.io/busybox
      command:
        - ls
        - "-l"
        - "/etc/secret-volume"
      volumeMounts:
        - name: secret-volume
          readOnly: true
          mountPath: "/etc/secret-volume"
```
- هنا هوا حطلك الاتنين فى نفس الملف بس فصلهم من خلالل --- 
- الاول هنا هوا حطلك دى 
```yml
apiVersion: v1
kind: Secret
metadata:
  name: dotfile-secret
  namespace: nginx
data:
  admin-path: 
```
- هنا الـ kind اسمه secret واسمه هوا dotfile-secret  والداتا الى فيه اسمها admin-path 
-  هنا المفروض انك لما تيجى تحط القيمه بتاعه الـ admin-path المفروض بتكون base 64 علشان تعملها base 64هتعملها الاتى 
```bash
mostafa@MY-Home:~/Documents/Kubernates$ echo "mostafamoeed" | base64
bW9zdGFmYW1vZWVkCg==
```
- بعد كده هتاخد base 64 وهتحطه كما يلى 
```yml
apiVersion: v1
kind: Secret
metadata:
  name: dotfile-secret
  namespace: nginx
data:
  admin-path:bW9zdGFmYW1vZWVkCg==
```

وبعد كده هتعمله apply 

```bash
mostafa@MY-Home:~/Documents/Kubernates$ echo "bW9zdGFmYW1vZWVkCg==" | base64 -d
mostafamoeed
```
- هنا لو انته عايز تعمل decode


---
---
### Volume and secret
```yml
apiVersion: v1
kind: Secret
metadata:
  name: secret1
  namespace: nginx
data:
  admin-path: bW9zdGFmYW1vZWVkCg==
```
- الاول هتعمل الـ secret وبعد كده 
- هتعمل الـ pod وجواه هتعمل الـ volume  كما يلى 

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-server
  namespace: nginx
spec:
  containers:
  - name: nginx
    image: nginx
    volumeMounts:
    - name: volA
      mountPath: /mnt/volA
    - name: volB
      mountPath: /mnt/volB
  volumes:
  - name: volA
    configMap:
      defaultUser: 1000
      name: cm1
      items:
      - key: foo 
        path: foo
      - key: bar 
        path: bar
        user: 1001
  - name: volB
    secret: 
      defaultUser: 1000
      secretName: secret1
```
- خلى بالك انته هنا بتتعامل مع اتنين volumes واحدconfig map والتانى الى هوا الـ secret  

- هنا انته علشان تتعامل مع الـ secret  بتكتب كما يلى تحت الـ volumes
```yml
  volumes:
  - name: volA
    configMap:
      defaultUser: 1000
      name: cm1
      items:
      - key: foo 
        path: foo
      - key: bar 
        path: bar
        user: 1001
  - name: volB
    secret: 
      defaultUser: 1000
      secretName: secret1
```

```yml
  - name: volB
    secret: 
      defaultUser: 1000
      secretName: secret1
```
 - هنا اول name هنا اسم الـ volume الى انته  هتحط فيه الداتا 
 - وبعدها هتكتب secret 
 - وهنا الـ secretname ده اسم الـ secret file الى انته عملته ب yml 
---
---

```bash
kubectl exec -it nginx-server -n nginx -- cat /mnt/volB/admin-path
```
- المفروض بعد لما تعمله apply وتكتب الامر ده هيظهر الاتى 
```
mostafamoeed
```


---
---


# Microservices


### Monolith (الـ Monolithic Service)

التطبيق كله بيتبني كوحدة واحدة متكاملة (codebase واحد)، كل الأجزاء (الـ UI، الـ business logic، الـ database layer) شغالة مع بعض في نفس الـ process.

**مميزاته:**

- أسهل في البداية (development و testing و deployment)
- مفيش تعقيد في التواصل بين الأجزاء (كله في نفس الـ memory space)
- أسهل في الـ debugging لأن كل حاجة في مكان واحد

**عيوبه:**

- لما التطبيق يكبر، بيبقى صعب تتعامل معاه (codebase ضخم)
- لو عايز تعمل deploy لتعديل بسيط، لازم تعمل deploy للتطبيق كله
- صعب تستخدم تقنيات مختلفة (languages/frameworks) لأجزاء مختلفة
- لو جزء واحد وقع، ممكن يأثر على التطبيق كله

### Microservices

التطبيق بيتقسم لخدمات صغيرة مستقلة، كل خدمة بتعمل وظيفة معينة (زي: خدمة الـ users، خدمة الـ payments، خدمة الـ notifications)، وكل خدمة ليها الـ database والـ deployment الخاص بيها، وبتتواصل مع بعض عن طريق APIs (زي REST أو gRPC).

**مميزاته:**

- كل خدمة تقدر تتعمل لها deploy لوحدها من غير ما تأثر على الباقي
- تقدر تستخدم تقنيات مختلفة لكل خدمة حسب احتياجها
- لو خدمة وقعت، الباقي ممكن يفضل شغال (Fault Isolation)
- كل team يقدر يشتغل على خدمة لوحده بشكل مستقل

**عيوبه:**

- تعقيد أكبر (distributed system) — network latency، data consistency
- أصعب في الـ testing والـ debugging (بتتبع request عبر خدمات كتير)
- محتاج infrastructure أقوى (service discovery, load balancing, monitoring...)
- overhead إداري وعملياتي أكبر

----
![[Pasted image 20260926145601.png]]
- هنا الخدمات متقسمه وكل واحد بيتواصل مع التانى عن طريق api  دى كده هتكون micro service


---
---


# Taint and Toleration

## Taint
- nodes = vm = worker = server
- وظيفه الماستر انه ينسق ويدير وينظم باقى الـ workers
-  الماستر مش وظيفته انه يشيل اى ابليكيشن عليه وظيفته انه يدير الـ workers التانيه 
- علشان تمنع الـ pods انها تتكرييت على الماستر اتعمل حاجه اسمها taint  يعنى كانك بتغطي الماستر علشان محدش يشوفها علشان ميتكريتش عليها pods
- يعنى الـ taint بيبقى label مع الـ special effect  والـ  special effect  بيحدد الغرض الى هيتم على الـ node
-  هنا الـ  special effect  ليها تلت انواع  والوحيد الى بياخد باله منهم هوا الـ scheduler 
- اول نوع للـ  special effect    هوا 
- الـ no scheduler   اول لما تتحط على node يعنى متحطش على الـ node دى اى pods 
- لو الـ no scheduler    اتحط على node والـ node كان فيها pods قبل ما تتحط كده الـ pods دى مش هتتمسح
- تانى effect  هوا prefer no scheduler وهو لو ملقتش مكان تحط فيه الـ pods تعالى فى الـ node الى عندى وحط فيها الـ pods 
- تالت نوع الـ no execute  هى  لو اتحطت على node وعليها pods هتتمسح الـ pods دى  علشان الـ scheduler يروح يعملها فى node تانيه والـ node الى اتعمل عليها الـ no execute بيتمنع انه يتعمل عليها pods

- ولو انا عايز اتغاضى عن التاثر بتاع الـ taint بستخدم حاجه اسمها toleration 
- الماستر بيبقى عليه taint بكون no scheduling 

---
---

```bash
mostafa@MY-Home:~/Documents$ minikube node add
😄  Adding node m02 to cluster minikube as [worker]
👍  Starting "minikube-m02" worker node in "minikube" cluster
🚜  Pulling base image v0.0.51 ...
🔥  Creating docker container (CPUs=2, Memory=3072MB) ...
📦  Preparing Kubernetes v1.37.0 on containerd 2.3.4 ...
🔎  Verifying Kubernetes components...
🏄  Successfully added m02 to minikube!
```


- هنا علشان تضيف node جديده فى الـ cluster

---
---


```bash
kubectl get nodes
```
- ده علشان تعرف اسماء الـ nodes الى عندك 
```bash
mostafa@MY-Home:~/Documents$ kubectl get nodes
NAME       STATUS   ROLES           AGE     VERSION
minikube   Ready    control-plane   4d23h   v1.37.0
```
- هنا معنها ان فيه node واحده بس واكيد دى هى الماستر وبيتعمل فيها Pods برضه لانها الوحيده 
```bash
mostafa@MY-Home:~/Documents$ kubectl describe node minikube
```
- الامر ده علشان توصف الـ node 


```bash
mostafa@MY-Home:~/Documents$ kubectl describe node minikube
Name:               minikube
Roles:              control-plane
Labels:             beta.kubernetes.io/arch=amd64
                    beta.kubernetes.io/os=linux
                    kubernetes.io/arch=amd64
                    kubernetes.io/hostname=minikube
                    kubernetes.io/os=linux
                    minikube.k8s.io/commit=7a9f6a841470a207de8cf4bafcccee0969d8ba10
                    minikube.k8s.io/name=minikube
                    minikube.k8s.io/primary=true
                    minikube.k8s.io/updated_at=2026_09_23T07_38_21_0700
                    minikube.k8s.io/version=v1.39.0
                    node-role.kubernetes.io/control-plane=
                    node.kubernetes.io/exclude-from-external-load-balancers=
Annotations:        node.alpha.kubernetes.io/ttl: 0
                    volumes.kubernetes.io/controller-managed-attach-detach: true
CreationTimestamp:  Wed, 23 Sep 2026 07:38:05 -0400
Taints:             <none>
Unschedulable:      false
Lease:
  HolderIdentity:  minikube
  AcquireTime:     <unset>
  RenewTime:       Mon, 28 Sep 2026 07:13:30 -0400
Conditions:
  Type             Status  LastHeartbeatTime                 LastTransitionTime                Reason                       Message
  ----             ------  -----------------                 ------------------                ------                       -------
  MemoryPressure   False   Mon, 28 Sep 2026 07:12:27 -0400   Sun, 27 Sep 2026 10:08:53 -0400   KubeletHasSufficientMemory   kubelet has sufficient memory available
  DiskPressure     False   Mon, 28 Sep 2026 07:12:27 -0400   Sun, 27 Sep 2026 10:08:53 -0400   KubeletHasNoDiskPressure     kubelet has no disk pressure
  PIDPressure      False   Mon, 28 Sep 2026 07:12:27 -0400   Sun, 27 Sep 2026 10:08:53 -0400   KubeletHasSufficientPID      kubelet has sufficient PID available
  Ready            True    Mon, 28 Sep 2026 07:12:27 -0400   Sun, 27 Sep 2026 12:19:56 -0400   KubeletReady                 kubelet is posting ready status
Addresses:
  InternalIP:  192.168.49.2
  Hostname:    minikube
Capacity:
  cpu:                2
  ephemeral-storage:  34731646976
  hugepages-1Gi:      0
  hugepages-2Mi:      0
  memory:             7030628Ki
  pods:               110
Allocatable:
  cpu:                2
  ephemeral-storage:  34731646976
  hugepages-1Gi:      0
  hugepages-2Mi:      0
  memory:             7030628Ki
  pods:               110
System Info:
  Machine ID:                 b7566eefbea02b7ce85821e86a97158b
  System UUID:                857f3360-0d5a-4b1b-8ed5-a383ac3c0df7
  Boot ID:                    1dcc8aab-e5cd-4f8b-b28c-d353ac96a63b
  Kernel Version:             6.12.101+deb13-amd64
  OS Image:                   Debian GNU/Linux 12 (bookworm)
  Operating System:           linux
  Architecture:               amd64
  Container Runtime Version:  containerd://2.3.4
  Kubelet Version:            v1.37.0
PodCIDR:                      10.244.0.0/24
PodCIDRs:                     10.244.0.0/24
Non-terminated Pods:          (8 in total)
  Namespace                   Name                                CPU Requests  CPU Limits  Memory Requests  Memory Limits  Age
  ---------                   ----                                ------------  ----------  ---------------  -------------  ---
  kube-system                 coredns-559f6c778d-v7hvg            100m (5%)     0 (0%)      70Mi (1%)        170Mi (2%)     4d23h
  kube-system                 etcd-minikube                       100m (5%)     0 (0%)      100Mi (1%)       0 (0%)         4d23h
  kube-system                 kindnet-w9z8h                       100m (5%)     100m (5%)   50Mi (0%)        50Mi (0%)      4d23h
  kube-system                 kube-apiserver-minikube             250m (12%)    0 (0%)      0 (0%)           0 (0%)         4d23h
  kube-system                 kube-controller-manager-minikube    200m (10%)    0 (0%)      0 (0%)           0 (0%)         4d23h
  kube-system                 kube-proxy-grrdd                    0 (0%)        0 (0%)      0 (0%)           0 (0%)         4d23h
  kube-system                 kube-scheduler-minikube             100m (5%)     0 (0%)      0 (0%)           0 (0%)         4d23h
  kube-system                 storage-provisioner                 0 (0%)        0 (0%)      0 (0%)           0 (0%)         4d23h
Allocated resources:
  (Total limits may be over 100 percent, i.e., overcommitted.)
  Resource           Requests    Limits
  --------           --------    ------
  cpu                850m (42%)  100m (5%)
  memory             220Mi (3%)  220Mi (3%)
  ephemeral-storage  0 (0%)      0 (0%)
  hugepages-1Gi      0 (0%)      0 (0%)
  hugepages-2Mi      0 (0%)      0 (0%)
Events:
  Type     Reason          Age                 From             Message
  ----     ------          ----                ----             -------
  Normal   NodeReady       20h (x34 over 22h)  kubelet          Node minikube status is now: NodeReady
  Normal   NodeNotReady    19h (x38 over 22h)  kubelet          Node minikube status is now: NodeNotReady
  Warning  Rebooted        18h                 kubelet          Node minikube has been rebooted, boot id: c0d15e46-96a7-4a6e-8251-a843ac1f0e74
  Normal   NodeReady       18h                 kubelet          Node minikube status is now: NodeReady
  Normal   RegisteredNode  18h                 node-controller  Node minikube event: Registered Node minikube in Controller
  Warning  Rebooted        18h                 kubelet          Node minikube has been rebooted, boot id: 65b14213-b551-4bb2-983a-536578cb6ef2
  Normal   RegisteredNode  18h                 node-controller  Node minikube event: Registered Node minikube in Controller
  Warning  Rebooted        5m8s                kubelet          Node minikube has been rebooted, boot id: 1dcc8aab-e5cd-4f8b-b28c-d353ac96a63b
  Normal   RegisteredNode  5m3s                node-controller  Node minikube event: Registered Node minikube in Controller
```

```bash
minikube.k8s.io/commit=7a9f6a841470a207de8cf4bafcccee0969d8ba10
                    minikube.k8s.io/name=minikube
                    minikube.k8s.io/primary=true
                    minikube.k8s.io/updated_at=2026_09_23T07_38_21_0700
                    minikube.k8s.io/version=v1.39.0
                    node-role.kubernetes.io/control-plane=
                    node.kubernetes.io/exclude-from-external-load-balancers=
Annotations:        node.alpha.kubernetes.io/ttl: 0
                    volumes.kubernetes.io/controller-managed-attach-detach: true
CreationTimestamp:  Wed, 23 Sep 2026 07:38:05 -0400
Taints:             <none>
```
- هنا الـ taints هنا بيقولك none

- لو عايز مثلا تضيفلها taint هتعمل الاتى 
```bash
mostafa@MY-Home:~/Documents/zexerices$ kubectl taint nodes minikube key=depi:NoSchedule
node/minikube tainted
```
- كده انته خليت الماستر مينفعش تعمل فيه اى pods 
ده معناه إن الـ Node عليها taint بالـ **key** اسمه `key` والـ **value** هو `depi` والـ **effect** هو `NoSchedule`. يعني غالبًا إنت كتبت الأمر كده:

- لو دخلت على الـ documentation هتلاقى بيعرفك ازاى تعمل taint

```bash
kubectl taint nodes minikube key=value:NoExecute
```

---
---

```bash
kubectl taint nodes minikube key=value:NoExecute-
```

هنا الامر ده لو انته عايز تشيل الـ no execute الى انته عملته  يعنى بتضيف داش فى الاخر بس

---
---

## Toleration

- لو انته مثلا عايز تعمل no scheduling على الماستر وفيه pod معينه انته عايز تشغلها فى الماستر لازم تعملها toleration 
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  labels:
    env: test
spec:
  containers:
  - name: nginx
    image: nginx
    imagePullPolicy: IfNotPresent
  tolerations:
  - key: "example-key"
    operator: "Exists"
    effect: "NoSchedule"
```
- ده مثال من الـ documentation علشان تعمل toleration كويسه 
- انا كنت عامل فى الماستر زى كده 
```bash
mostafa@MY-Home:~/Documents/zexerices$ kubectl taint nodes minikube key=depi:NoSchedule
node/minikube tainted
```

- هنا الـ key اسمه key وهنا الـ value اسمها depi وهنا الـ effect هوا NoSchedule فيكون شكل الـ toleration كما يلى 
```yml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  labels:
    env: test
spec:
  containers:
  - name: nginx
    image: nginx
    imagePullPolicy: IfNotPresent
tolerations:
- key: "key"
  operator: "Equal"
  value: "depi"
  effect: "NoSchedule"
```
- هنا الـ key اسمه key  وهنا الـ operation اسمها equal يعنى بتعمل مساواه والقيمه بتاعه الـ value بتاعه الـ key هى depi وهنا الـ effect هى NoSchedule
- وبعد كده تعملها apply
![[Pasted image 20260928190553.png]]
هنا اتعملت فى node 1 علشان هى واخده نفس الـ taint

---
---
- فى حاله انك عملت toleration فى pod ولكن حطيت قيمه taint غلط فى الـ toleration فكده مش هتروح على الاولى وهتروح مثلا على التانيه وتتعمل فى الـ node التانيه اما لو مكنش فيه غير الـ node الاولى بس كده هيحصلها pending على الـ node الاولى ومش هتتعمل هتظل pending
![[Pasted image 20260928190947.png]]
- هنا لما اديتها قيمه taint غلط راحت على node 2


---
---


# Assigning Pods to Nodes && Node selector && Node affinity


- فى حاله ان فيه deployment وفيه 3 pods الى هيتحكم فى ان هى هتتعمل فين هو الـ scheduler   اما لو انته عايز تتحكم فى ان هى تتعمل فين هستخدم الـ node selector و هتستخدم الـ node affinity

- هنا انا عايز اختار الـ node الى  الـ pod هتروح تتعمل فيها 
- لو عندى node 1 و node 2   الاتنين واخدين label اسمه 
- name= front
-  وبعد كده عملت برضه name فى اول node اسمه 
- name = welcome
- وفى الـ node التانيه 
- name = hello

- فهنا لو جيت اكتب للـ pod تروح للـ node الى label بتاعها هوا  front مش هتعرف تختار لان الاتنين عندهم label اسمه front 


- فعلشان الـ pod تروح على الـ node الصح هتكتب للـ pod انها تروح على الـ node الى عندها label اسمه name وقيمته hello and front 
- علشان تروح للمكان الصح 

### node Affinity
- هى نفسها الـ node selector  يعنى دى بتديها اكثر من label  ولكن الـ node selector بتاخد label واحد بس

---
- مثال بسيط كما يلى 
![[Pasted image 20260928151632.png]]
- هنا انا اديت label للـ node بتاعتى من خلال الامر الاتى  وسميته size=larg 
```bash
kubectl label nodes <node-name> <key>=<value>
```

```bash
kubectl label nodes Node1 size=large
```

---
![[Pasted image 20260928151852.png]]
- بعد كده علشان الـ pod دى تروح على الـ size large ضيفت السطرين دول فى الاخر 

- لما تيجى تتعامل مع الـ node selector لو انته اديت للـ node اتنين label لما تيجى تكتب الـ label علشان تحط فيهم الـ nodes هتكتب اما large or medium مينفعش تكتب large and medium
- اما لما تتعامل مع الـ node affinity  ممكن تحط and عادى


---
---
## **Node Affinity Types**

Available:

- 1- هنا`requiredDuringSchedulingIgnoredDuringExecution`
- شرح اول واحده
- هنا بيقول انه لما يجى يعمل pod لازم  يكون فيها الـ label بتاع الـ node الى هيروح يكريت فيها اما لما يتشال الـ label من الـ node ساعتها هنا بيقولك ignored يعنى هيحذف الـ pod علشان الـ label اتشالت 


- 2- هنا `preferredDuringSchedulingIgnoredDuringExecution`
- شرح تانى واحده
- هنا بيقولك preferred  يعنى لو فيه label موجود فى الـ pod هيتعمل عادى ولو مفيش label هيتعمل فى اى node اما يتشال الـ label من الـ node ساعتها هنا بيقولك ignored يعنى هيحذف الـ pod علشان الـ label اتشالت 


---
----
## Usage node selector
- فيه طريقيتن علشان انك تستخدم الـ node selector
- اول طريقه 
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
  - name: nginx
    image: nginx
  nodeName: kube-01
```
- هنا ممكن انك تحط  اسم الـ node الى انته عايز الـ pod دى تروحلها  زى هنا 
-   nodeName: kube-01
---

```bash
mostafa@MY-Home:~/Documents$ kubectl get nodes
NAME           STATUS     ROLES           AGE     VERSION
minikube       Ready      control-plane   5d1h    v1.37.0
minikube-m02   Ready      <none>          2m28s   v1.37.0
minikube-m03   NotReady   <none>          12s     v1.37.0
```
- هنا دلوقتى دى الـ nodes الى عندك 

```bash
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
  - name: nginx
    image: nginx
  nodeName: minikube-m02
```
- هنا اخترت اسم الـ node الى انته عايز الـ pod تروح تتعمل فيها  بعد كده هتعمل apply ليها
```bash
mostafa@MY-Home:~/Documents/zexerices$ kubectl describe pods nginx 
Name:             nginx
Namespace:        default
Priority:         0
Service Account:  default
Node:             minikube-m02/192.168.49.3
Start Time:       Mon, 28 Sep 2026 08:59:30 -0400
```
- هنا  اهو بيقولك انها اتعملت فى الـ node التانيه 

```bash
mostafa@MY-Home:~/Documents/zexerices$ kubectl get pod -o wide
NAME    READY   STATUS    RESTARTS   AGE     IP           NODE           NOMINATED NODE   READINESS GATES
nginx   1/1     Running   0          3m12s   10.244.1.2   minikube-m02   <none>           <none>
```
- هنا برضه بيقولك هيا اتعملت فين 

``
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
  - name: nginx
    image: nginx
    imagePullPolicy: IfNotPresent
  nodeSelector:
    disktype: ssd
```
- هنا دى برضه طريقه تانيه علشان انك تعمل الـ node selector وبتحط الـ key and value   

```yml
  nodeSelector:
    disktype: ssd
```
- هنا الـ key هوا disktype 
- هنا الـ value هوا الـ ssd

----
```bash
mostafa@MY-Home:~/Documents/zexerices$ kubectl get nodes --show-labels 
NAME           STATUS   ROLES           AGE    VERSION   LABELS
minikube       Ready    control-plane   5d1h   v1.37.0   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=minikube,kubernetes.io/os=linux,minikube.k8s.io/commit=7a9f6a841470a207de8cf4bafcccee0969d8ba10,minikube.k8s.io/name=minikube,minikube.k8s.io/primary=true,minikube.k8s.io/updated_at=2026_09_23T07_38_21_0700,minikube.k8s.io/version=v1.39.0,node-role.kubernetes.io/control-plane=,node.kubernetes.io/exclude-from-external-load-balancers=
minikube-m02   Ready    <none>          43m    v1.37.0   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=minikube-m02,kubernetes.io/os=linux,minikube.k8s.io/commit=7a9f6a841470a207de8cf4bafcccee0969d8ba10,minikube.k8s.io/name=minikube,minikube.k8s.io/primary=false,minikube.k8s.io/updated_at=2026_09_28T08_52_46_0700,minikube.k8s.io/version=v1.39.0
minikube-m03   Ready    <none>          41m    v1.37.0   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=minikube-m03,kubernetes.io/os=linux,minikube.k8s.io/commit=7a9f6a841470a207de8cf4bafcccee0969d8ba10,minikube.k8s.io/name=minikube,minikube.k8s.io/primary=false,minikube.k8s.io/updated_at=2026_09_28T08_55_01_0700,minikube.k8s.io/version=v1.39.0
```


```bash
mostafa@MY-Home:~/Documents/zexerices$ kubectl get nodes --show-labels 
```
- الامر ده علشان يجبلك كل الـ labels الى فى كل الـ nodes

```bash
mostafa@MY-Home:~/Documents/zexerices$ kubectl describe nodes minikube-m03 
Name:               minikube-m03
Roles:              <none>
Labels:             beta.kubernetes.io/arch=amd64
                    beta.kubernetes.io/os=linux
                    kubernetes.io/arch=amd64
                    kubernetes.io/hostname=minikube-m03
                    kubernetes.io/os=linux
                    minikube.k8s.io/commit=7a9f6a841470a207de8cf4bafcccee0969d8ba10
                    minikube.k8s.io/name=minikube
                    minikube.k8s.io/primary=false
                    minikube.k8s.io/updated_at=2026_09_28T08_55_01_0700
                    minikube.k8s.io/version=v1.39.0
Annotations:        node.alpha.kubernetes.io/ttl: 0
                    volumes.kubernetes.io/controller-managed-attach-detach: true
```
- هنا جابلك كل الـ labels الى تخص الـ node التالته
```bash
Labels:             beta.kubernetes.io/arch=amd64
                    beta.kubernetes.io/os=linux
                    kubernetes.io/arch=amd64
                    kubernetes.io/hostname=minikube-m03
                    kubernetes.io/os=linux
```
- هنا الـ key على الشمال والـ value على اليمين 

---

- الاول هعمل labels لكل node كما يلى 
```bash
mostafa@MY-Home:~/Documents/zexerices$ kubectl label node minikube-m02 name=mostafa
node/minikube-m02 labeled
```
- كده انته عملت للـ node دى label وهنا الـ key اسمه name والـ value اسمها mostafa

- لما تيجى تعمل وصف للـ node دى هتلاقى الاتى 
```bash
mostafa@MY-Home:~/Documents/zexerices$ kubectl describe no minikube-m02
Name:               minikube-m02
Roles:              <none>
Labels:             beta.kubernetes.io/arch=amd64
                    beta.kubernetes.io/os=linux
                    kubernetes.io/arch=amd64
                    kubernetes.io/hostname=minikube-m02
                    kubernetes.io/os=linux
                    minikube.k8s.io/commit=7a9f6a841470a207de8cf4bafcccee0969d8ba10
                    minikube.k8s.io/name=minikube
                    minikube.k8s.io/primary=false
                    minikube.k8s.io/updated_at=2026_09_28T08_52_46_0700
                    minikube.k8s.io/version=v1.39.0
                    name=mostafa
```
- هنا الـ label ده اتضاف 

- بعد كده هنروح نعمل الـ pod 

```yml
apiVersion: v1
kind: Pod
metadata:
  name: nginx2
spec:
  containers:
  - name: nginx
    image: nginx
    imagePullPolicy: IfNotPresent
  nodeSelector:
    name: mostafa 
```

```bash
mostafa@MY-Home:~/Documents/zexerices$ kubectl apply -f pod_selector_node.yml 
pod/nginx2 created
mostafa@MY-Home:~/Documents/zexerices$ kubectl get pod -o wide
NAME     READY   STATUS    RESTARTS   AGE   IP           NODE           NOMINATED NODE   READINESS GATES
nginx    1/1     Running   0          98m   10.244.1.2   minikube-m02   <none>           <none>
nginx2   1/1     Running   0          21s   10.244.1.3   minikube-m02   <none>           <none>
```

- هنا الـ pod دى اتعملت فى الـ node 2

## Usage node affinity

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
        - matchExpressions:
          - key: disktype
            operator: In
            values:
            - ssd            
  containers:
  - name: nginx
    image: nginx
    imagePullPolicy: IfNotPresent
```

- لو دخلت على الـ documentation هتلاقى دول وعلشان تضيف الـ node affinity هتعمل الاتى 
```yml
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
        - matchExpressions:
          - key: disktype
            operator: In
            values:
            - ssd 
```
- هنا 
```yml
  affinity:
    nodeAffinity:
```
 - بتكتب دول الاول 
- هنا الطريقه الى هتمشى عليها requiredDuringSchedulingIgnoredDuringExecution يعنى لازم تكتب الـ label ولو شيلت الـ label كده الـ pod هتتسمح تلقائى 
- بعد كده هنا هتعمل الاتى 
```yml
          - key: name
            operator: In
            values:
            - mostafa
```
- هنا الـ key اسمه name 
- وهنا الـ value بتساوى mostafa

---
---

```bash
mostafa@MY-Home:~/Documents/zexerices$ kubectl apply -f pod_affinity_node.yml 
pod/nginx3 created
mostafa@MY-Home:~/Documents/zexerices$ kubectl get pod -o wide
NAME     READY   STATUS    RESTARTS   AGE    IP           NODE           NOMINATED NODE   READINESS GATES
nginx    1/1     Running   0          119m   10.244.1.2   minikube-m02   <none>           <none>
nginx2   1/1     Running   0          21m    10.244.1.3   minikube-m02   <none>           <none>
nginx3   1/1     Running   0          9s     10.244.1.4   minikube-m02   <none>           <none>
```
- اتعملت برضه فى الـ node 2

---
---
```bash
mostafa@MY-Home:~/Documents/zexerices$ kubectl label node minikube-m03 name=mostafa
node/minikube-m03 labeled
```
- هنا بقوا الاتنين عندهم نفس الـ label 
- فى حاله ان فيه اتنين label زى بعض  هنا الـ node selector مش هتنفع   لان الاتنين واخدين نفس الـ label 
- الصح المفروض تديهم كمان label زياده  ويكونوا مختلفين فيه هما الاتنين
هضيف كمان label :ما يلى 

```bash
mostafa@MY-Home:~/Documents/zexerices$ kubectl label node minikube-m03 
env=prod
node/minikube-m03 labeled

mostafa@MY-Home:~/Documents/zexerices$ kubectl describe nodes minikube-m03
Name:               minikube-m03
Roles:              <none>
Labels:             beta.kubernetes.io/arch=amd64
                    beta.kubernetes.io/os=linux
                    env=prod
                    kubernetes.io/arch=amd64
                    kubernetes.io/hostname=minikube-m03
                    kubernetes.io/os=linux
                    minikube.k8s.io/commit=7a9f6a841470a207de8cf4bafcccee0969d8ba10
                    minikube.k8s.io/name=minikube
                    minikube.k8s.io/primary=false
                    minikube.k8s.io/updated_at=2026_09_28T08_55_01_0700
                    minikube.k8s.io/version=v1.39.0
                    name=mostafa
```

- هنا بقى فيه الاتنين env=prod   و name=mostafa 


- علشان تعمل الاتنين labels هتعمل الاتى 
```yml
apiVersion: v1
kind: Pod
metadata:
  name: nginx4
spec:
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
        - matchExpressions:
          - key: name
            operator: In
            values:
            - mostafa  

          - key: env
            operator: In
            values:
            - prod          
  containers:
  - name: nginx
    image: nginx
    imagePullPolicy: IfNotPresent
```

- هنا ضيفت الاتنين labels

```bash
mostafa@MY-Home:~/Documents/zexerices$ kubectl apply -f pod_affinity2_node.yml 
pod/nginx4 created
mostafa@MY-Home:~/Documents/zexerices$ kubectl get pods -o wide
NAME     READY   STATUS              RESTARTS   AGE    IP           NODE           NOMINATED NODE   READINESS GATES
nginx    1/1     Running             0          134m   10.244.1.2   minikube-m02   <none>           <none>
nginx2   1/1     Running             0          36m    10.244.1.3   minikube-m02   <none>           <none>
nginx3   1/1     Running             0          15m    10.244.1.4   minikube-m02   <none>           <none>
nginx4   0/1     ContainerCreating   0          24s    <none>       minikube-m03   <none>           <none>
```

- فعلا اتعملت فى node 3

---
---
```bash
mostafa@MY-Home:~/Documents/zexerices$ kubectl label node minikube-m02 env1=new_value_label
node/minikube-m02 labeled
```
- هنا انا ضيفت label للـ node 2

---
---
---
- لو انته ضيفت label غلط  هتكون الـ pod متعلقه  هتبقى pending
![[Pasted image 20260928182434.png]]

-  بس لما انته تحط الـ label كما يلى 
![[Pasted image 20260928182648.png]]
- بعد كده بدل ما هى pending هتشتغل عادى 
![[Pasted image 20260928182723.png]]

---
---


# User and Application Permission

- الـ user permission هوا انك مثلا تعمل يوزر جديد يكون مثلا عنده صلاحيات انه ممكن يعمل pod جديده او يحذفها  او انه يعمل describe  فقط ده الى يقدر يعمله

### Start to understand
- علشان تلاقى كل المعلومات بتاعه الـ service account and pods  هتدخل تبحث على جوجل configure service account  for pods 
- هتلاقى الاتى 
![[Pasted image 20260930173813.png]]


- الـ Application Permission 
- بتكريتت حاجه اسمها service account جوه name space معين 

```bash
mostafa@MY-Home:~/Documents$ kubectl describe pods nginx
Name:             nginx
Namespace:        default
Priority:         0
Service Account:  default
Node:             minikube-m02/192.168.49.3
Start Time:       Mon, 28 Sep 2026 08:59:30 -0400
Labels:           <none>
Annotations:      <none>
Status:           Running
IP:               10.244.1.3
IPs:
```
- هنا  بيقولك ان الـ service account هنا default  ومفيهاش اى permission

- الاول هتدخل على الـ pod دى  كما يلى 
```bash
mostafa@MY-Home:~/Documents$ kubectl exec -it nginx -- bash
root@nginx:/# 
```
- بعد كده لو جيت مثلا تشغل الامر الاتى هتلاقيه مش شغال لانك مش محمله
```bash
root@nginx:/# kubectl get pod
bash: kubectl: command not found
```

---
- بعد لما حملت الـ kubectl وجيت اعمل kubectl get pod جابلى الامر الى جاى ده 

```bash
root@nginx:/# kubectl get pod
Error from server (Forbidden): pods is forbidden: User "system:serviceaccount:default:default" cannot list resource "pods" in API group "" in the namespace "default"
```

- انا كنت واقف بره كنت انا الـ service account كان default  فلما دخلت جوه الـ pod هوا بيقولك ان الـ service account ده ملهوش الصلاحيه انه يعمل pod جوه الـ pod دى 

- كده الـ jenkins مش هيعرف يعمل pod جوه الـ pod دى فلازم تدى الـ service account تديه permission 


---
---

- يبقى الاول هتعمل service account ده مش بيكون human account 
-  الـ service account دى بتدى identity للـ cluster بتاعك  او الـ pod 

- هتدخل على الـ documentation وهتدور على الـ service account وتدور ازاى تعمل واحد من خلال الـ yml

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: action
  namespace: default
```

- هنا اسمه action وهوا فى الـ namespace الى هى الـ default   هتعملها apply دلوقتى 

```bash
mostafa@MY-Home:~/Documents/zexerices$ kubectl apply -f service_account.yml
serviceaccount/action created
```

```bash
mostafa@MY-Home:~/Documents/zexerices$ kubectl get serviceaccounts
NAME      AGE
action    45s
default   7d2h
```
- كده فيه اتنين فى الـ default namespace الى هما default and action
المفروض الاول تعمل الـ service account

وكدها عملنها وهى اسمها action 
- كده بعد لما عملنا الـ service account كده بتتعمل مبيكنش فيها اى حاجه 
```yml
apiVersion: v1
kind: Pod
metadata:
  name: nginx2
spec:
  ServiceAccountName: action
  containers:
  - name: nginx
    image: nginx:1.14.2
    ports:
    - containerPort: 80
```
- هنا انته بتحط الـ service account فى الـ spec  بتحط اسمه 
- هتعمل apply
```bash
mostafa@MY-Home:~/Documents/zexerices$ kubectl describe pod nginx2
Name:             nginx2
Namespace:        default
Priority:         0
Service Account:  action
Node:             minikube-m03/192.168.49.4
Start Time:       Wed, 30 Sep 2026 10:43:01 -0400
Labels:           <none>
Annotations:      <none>
Status:           Pending
```
- هنا الـ service account هنا اسمه action

---
---
- بعد كده هتدخل جوه الـ pod وهتحاول تشغل الـ kubectl وتشوف الـ pods ,تشوف هيقلك ايه
![[Pasted image 20260930174640.png]]
- هنا برضه مشتغلتش 
- حتى برضه لما جيت اعمل run لـ image مشتغلتش  لانه ملكش اكشن انك تعمل ده 
---
- هنا المفروض تدى permission لليوزر او الـ non user الى هوا الـ service account

---
---
---

### Role

```bash
mostafa@MY-Home:~/Documents/zexerices$ kubectl api-resources 
NAME                                SHORTNAMES   APIVERSION                        NAMESPACED   KIND
bindings                                         v1                                true         Binding
componentstatuses                   cs           v1                                false        ComponentStatus
configmaps                          cm           v1                                true         ConfigMap
endpoints                           ep           v1                                true         Endpoints
events                              ev           v1                                true         Event
limitranges                         limits       v1                                true         LimitRange
namespaces                          ns           v1                                false        Namespace
nodes                               no           v1                                false        Node
persistentvolumeclaims              pvc          v1                                true         PersistentVolumeClaim
persistentvolumes                   pv           v1                                false        PersistentVolume
pods                                po           v1                                true         Pod
podtemplates                                     v1                                true         PodTemplate
replicationcontrollers              rc           v1                                true         ReplicationController
resourcequotas                      quota        v1                                true         ResourceQuota
secrets                                          v1                                true         Secret
serviceaccounts                     sa           v1                                true         ServiceAccount
services                            svc          v1                                true         Service
```
- هنا انته بتشوف هل الحاجه دى موجوده فى الـ namespace scoop ولا لا 
- يعنى مثلا الـ pod هتكون فى الـ namespace سكوب  ولكن الـ namespace نفسها هتكون مش فى نطاق الـ namespace سكوب وبرضه الـ nodes مش فى الـ namespace scoop فانته لما بتكتب الامر ده 
- kubectl api-resources
- بيظهرلك كل حاجه الى تلاقى قصاده true يبقى هوا فى الـ namespace scoop والى تلاقى قصاده false يبقى ده الـ namespace scoop


- من خلال الامر ده هتعرف هل ده namespace scoop  ولا cluster scoop

- فى الـ role  انته عايز تدى permission للـ deployment او مثلا للـ replicaset عايز تديهم permission انهم يكون عندهم view  
- يبقى فى الـ role انته بتدى permission لحجات بتكون موجوده فى الـ namespace scoop 

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: default
  name: pod-reader
rules:
- apiGroups: [""] # "" indicates the core API group
  resources: ["pods"]
  verbs: ["get", "watch", "list"]
```
- هنا الـ kind : role وهنا الـ rules  فى الـ resources  هنا حط الـ pods  وهنا حط الـ verbs يعنى الحجات الى يقدر الـ pod ده يعملها وهنا بيقولك انه يقدر يعمل get and watch and list

- هنا علشان تعرف الـ pods موجوده فى اى group هتعمل الامر الاتى 
```bash
mostafa@MY-Home:~/Documents/zexerices$ kubectl api-resources 
NAME                                SHORTNAMES   APIVERSION                        NAMESPACED   KIND
bindings                                         v1                                true         Binding
componentstatuses                   cs           v1                                false        ComponentStatus
configmaps                          cm           v1                                true         ConfigMap
endpoints                           ep           v1                                true         Endpoints
events                              ev           v1                                true         Event
limitranges                         limits       v1                                true         LimitRange
namespaces                          ns           v1                                false        Namespace
nodes                               no           v1                                false        Node
persistentvolumeclaims              pvc          v1                                true         PersistentVolumeClaim
persistentvolumes                   pv           v1                                false        PersistentVolume
pods                                po           v1                                true         Pod
podtemplates                                     v1                                true         PodTemplate
replicationcontrollers              rc           v1                                true         ReplicationController
resourcequotas                      quota        v1                                true         ResourceQuota
secrets                                          v1                                true         Secret
serviceaccounts                     sa           v1                                true         ServiceAccount
services                            svc          v1                                true         Service
```
- هنا فى العمود بتاع الـ api version هنا هتلقى انه  v1 
![[Pasted image 20260930182331.png]]

- يبقى كده الـ v1 هوا الجروب يعنى هتكتب الاتى 
```bash
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: default
  name: pod-reader
rules:
- apiGroups: ["v1"] # "" indicates the core API group
  resources: ["pods"]
  verbs: ["get", "watch", "list"]

```

- لو انته عايز nodes هتلاقى  قصادها اسم الجروب الى المفروض انته تحطه لو عايز namespace هتلاقى اسم الجروب الى انته عايز تحطه وهكذا 

```bash
mostafa@MY-Home:~/Documents/zexerices$ kubectl apply -f roll_pod.yml 
role.rbac.authorization.k8s.io/pod-reader created
```
بعد كده هنعمل الـ role binding


### Role Binding

- اما الـ roll binding انته بتربط الـ roll بالـ service account
-  كده لما انته تربط الى واخد الـ roll بالـ service account الى اسمه action كده اى حد معاه الـ service account ده هيكون معاه الـ permission
```yml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: default
  name: action
rules:
- apiGroups: [""] # "" indicates the core API group
  resources: ["pods"]
  verbs: ["get", "watch", "list","create"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: read-pods
  namespace: default
subjects:
# You can specify more than one "subject"
- kind: ServiceAccount
  name: action
  namespace: default
roleRef:
  # "roleRef" specifies the binding to a Role / ClusterRole
  kind: Role #this must be Role or ClusterRole
  name: action # this must match the name of the Role or ClusterRole you wish to bind to
  apiGroup: rbac.authorization.k8s.io
```

- هنا فى النص التانى بتاع الـ role binding 
```yml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: read-pods
  namespace: default
subjects:
# You can specify more than one "subject"
- kind: ServiceAccount
  name: action
  namespace: default
roleRef:
  # "roleRef" specifies the binding to a Role / ClusterRole
  kind: Role #this must be Role or ClusterRole
  name: action # this must match the name of the Role or ClusterRole you wish to bind to
  apiGroup: rbac.authorization.k8s.io

```
- هنا فى الـ subject بتحط الـ kind الى انته عايز تعمله binding يعنى ممكن تحط الـ User او ممكن تحط الـ service account  وبعدها فى الـ name بتحط اما الـاسم بتاع اليوزر او الاسم بتاع الـ service account 
- هنا فى الـ roleref بتحط فى الـ name بيكون اسم الـ role وهى اسمها action اما فى الـ object بتحط اسم الـ service account

```bash
mostafa@MY-Home:~/Documents/zexerices$ kubectl apply -f roll_pod.yml
role.rbac.authorization.k8s.io/action unchanged
rolebinding.rbac.authorization.k8s.io/read-pods created
```

```bash
mostafa@MY-Home:~/Documents/zexerices$ kubectl get rolebindings.rbac.authorization.k8s.io
NAME        ROLE          AGE
read-pods   Role/action   9m31s
```
- هنا اتعملت 
```bash
mostafa@MY-Home:~/Documents/zexerices$ kubectl describe rolebindings.rbac.authorization.k8s.io read-pods
Name:         read-pods
Labels:       <none>
Annotations:  <none>
Role:
  Kind:  Role
  Name:  action
Subjects:
  Kind            Name    Namespace
  ----            ----    ---------
  ServiceAccount  action  default
```
- هنا بيقولك ان فيه role اسمها action وفيه service account اسمه action

- دلوقتى اى pod شغاله بالـ service account الى اسمه action هيقدر يتعامل عادى مع الـ pods 
```bash
mostafa@MY-Home:~/Documents/zexerices$ kubectl describe pod nginx2
Name:             nginx2
Namespace:        default
Priority:         0
Service Account:  action
Node:             minikube-m03/192.168.49.4
Start Time:       Wed, 30 Sep 2026 10:43:01 -0400
Labels:           <none>
Annotations:      <none>
Status:           Running
IP:               10.244.2.3
```
- يعنى دلوقتى هنا الـ pod دى تقدر جواها تتعامل مع pod تانيه 
![[Pasted image 20260930192917.png]]


### Cluster Role

- دى بتتعمل للحجات الى هى فى الـ cluster scoop زى مثلا الـ namespace 

### Cluster Role Binding
- اما دى بتستخدم علشان تربط الـ cluster role  بالـ service account علشان يكون عنده permission 
- وممكن برضه تربطها ب user يكون عنده permission برضه 


----
---
- الـ namespace موجوده فى الـ cluster scoop الاول هتعمل service account جوه الـ namespace الى عايز تاخد عليها permission وهتعمل cluster role للـ name space دى وبعدها هتربط الـ service account  بالـ cluster role عن طريق الـ cluster role binding  علشان الـ namespace تقدر انها تعمل namespace تانيه عادى 

---

# Volume

## PV
- كنا خدنا الـ config and secrets وازاى نتعامل بيهم مع الـ volume   
- لكن دلوقتى ازاى اننا نخزن الداتا فى الـ volume  
- عندك نوعين من الـ volume اول نوع هو الـ pv =  presentient volume    تانى نوع الـ pvc   =  presentient volume clean 
-  وبرضه فيه cloud provider service    عن طريق انك بتخزن الداتا على كلاود


- اول حاجه الـ pv   علشان تكريت volume بتعمل ليه physicals volume   بتقوله مثلا انك عايز تعمل allocate 10 gb  على السرفر بتاعك  وبرضه بياخد access mode    وبيكون فى الاكسيس مود بيكون read , write , once    ولازم الـ pod تكون على node واحده بس يعنى لو انا عاندى deployment وكان فيه 3 pod وكل واحده فى node مختلفه كده مش هينفع

- وفيه برضه فى الـ pv   انه ممكن يكون الـ access mode يكون read , write , many  يعنى انك تقدر تتعامل مع الـ pods الى هى فى deployment وكل واحده فيهم فى node مختلفه 

- لو هما فى node واحده بس هتروح على الـ node دى وتعمل الفولدر بتاعك اما لو فى اكتر من node هتروح على كل node وتعمل الفولدر بتاعك 

- الـ host path  هنا انته بتقوله الفولدر بتاعك على الـ node بيكون فين 
- الـ retain policy  لما الـ pod بيحصلها killed الداتا الى جوه الـ pv  بيكون عندك اختيارين اما retain او deleted    الـ retain يعنى خلى الداتا الى هنا اما الـ deleted احذفها 


- الـ storage class  دى بتقول الـ volume ده انا هكريته فين  ممكن تقوله كما يلى 
- storage class : aws  كده هيروح يعمله فى امازون 
- storage class : manual
-  يعنى انى عمله مانويل فى السرفر بتاعى 


---

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv0003
spec:
  capacity:
    storage: 5Gi
  volumeMode: Filesystem
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Recycle
  storageClassName: slow
  mountOptions:
    - hard
    - nfsvers=4.1
  nfs:
    path: /tmp
    server: 172.17.0.2
```
- هنا ده مثال من yml ازاى تعمل PersistentVolume من الدوكيومينتيشن 

- هنا فى الـ spec فيه تحتها الـ capacity بتحط storage مثلا زى هنا 5Gi 
- وهنا الـ volumeMode   هنا file system    
- وهنا الـ access mode    هنا ReadWriteOnce هنا  يعنى هيتعامل مع سرفر واحد بس وكل الـ pods هتكون على سرفر واحد 
- هنا ممكن تخليها   persistentVolumeReclaimPolicy: Recycle  ,   ممكن تخليها retain او delete  لان recycle مبقتش شغاله
-  هنا ده مجرد اسم الى هوا الـ slow     storageClassName:   // slow  وده من خلاله بتربط الـ pvc 
---
- اما الجزء الاخير ده بتستخدمه لو هوا سرفر external 

```yml
  mountOptions:
    - hard
    - nfsvers=4.1
  nfs:
    path: /tmp
    server: 172.17.0.2
```

---
- اما هنا لو انته عايز تشاور على مكان لوكال  بتستخدم الـ hostpath
```yml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv
spec:
  capacity:
    storage: 5Gi
  volumeMode: Filesystem
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: retain
  storageClassName: manual

  hostPath:
    path: /hello/data
```

---

## PVC

- الـ pod لما بتكون عايزه ترتبط بالـ volume مش هتروح ترتبط مباشره بالـ pv  لازم الاول تربط الـ pvc بالـ pv وبعدها بتربط الـ pod بالـ pvc 



```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-1
spec:
  capacity:
    storage: 5Gi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: manual

  hostPath:
    path: /hello/data
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: myclaim
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
  storageClassName: manual 

```

- هنا الجزء الخاص بالـ pvc
```yml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: myclaim
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
  storageClassName: manual 
```
-  علشان تربط الـ pv بالـ pvc  المفروض المساحه تكون زى بعضها والـ accessmode يكونوا زى بعض  وبرضه الـ storageclass  يكونوا نفس الاسم 


```bash
mostafa@MY-Home:~/Documents/pv && pvc$ kubectl apply -f pv.yml 
persistentvolume/pv-1 created
persistentvolumeclaim/myclaim unchanged
```
- كده الاتنينن اتعملوا دلوقتى فاضل ازاى نربط بين الـ pod والـ pvc

```bash
mostafa@MY-Home:~/Documents/pv && pvc$ kubectl get pv
NAME   CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM             STORAGECLASS   VOLUMEATTRIBUTESCLASS   REASON   AGE
pv-1   5Gi        RWO            Retain           Bound    default/myclaim   manual         <unset>                          3m45s


mostafa@MY-Home:~/Documents/pv && pvc$ kubectl get pvc
NAME      STATUS   VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
myclaim   Bound    pv-1     5Gi        RWO            manual         <unset>                 4m53s
mostafa@MY-Home:~/Documents/pv && pvc$ 
```

- هنا فى الـ pv and pvc لو لقيت الـ status عندك بقت bound يبقى كده اتعملت صح

---
## POD with pvc

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx123
spec:
  containers:
    - name: nginx
      image: nginx
      volumeMounts:
        - name: data
          mountPath: "/usr/share/nginx/html/"

  volumes:
    - name: data
      persistentVolumeClaim:
        claimName: myclaim
```
- لازم الـ `name` اللي بتستخدمه في `volumeMounts` أو `volumeDevices` يكون **نفس الاسم**
- هنا الـ `devicePath`  الى جوه الـ volumeDevices ده بيكون جوه الـ container  وهنا اى حاجه فى الفولدر ده هتروح على المسار الى انته عامل عليه الـ volume الى هوا على السرفر بتاعك 

- هنا بتكتب volumes وبيكون تحتها دول وبتكتب فى الـ claim name اسم الـ pvc الى انته عملته الى كان اسمه myclaim   

```bash
mostafa@MY-Home:~/Documents/pv && pvc$ kubectl apply -f podWithPVC.yml 
pod/nginx123 created
```
- هنا انته عملت الـ pod دى 

---
```bash
mostafa@MY-Home:~/Documents/pv && pvc$ kubectl get pod -o wide
NAME       READY   STATUS    RESTARTS       AGE    IP           NODE           NOMINATED NODE   READINESS GATES
nginx      1/1     Running   2 (108m ago)   5d2h   10.244.1.2   minikube-m02   <none>           <none>
nginx123   1/1     Running   0              8s     10.244.2.3   minikube-m03   <none>           <none>
nginx2     1/1     Running   1 (108m ago)   3d     10.244.2.2   minikube-m03   <none>           <none>
```
- هنا الـ pod بتاعه nginx123 اتعملت فى node 3

---
- كده هدخل على node 3 
```bash
mostafa@MY-Home:~/Documents/pv && pvc$ minikube ssh -n minikube-m03
Linux minikube-m03 6.12.101+deb13-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.12.101-1 (2026-08-05) x86_64

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
```
- كده انته دخلت على الـ node دى 
- علشان تلاقى الفولدر الى انته عملته هتعمل الاتى 
```bash
docker@minikube-m03:~$ ls /
CHANGELOG  core.109   core.1377  core.2407  etc      kind   mnt   run   tmp
bin        core.1201  core.1711  core.2409  hello    lib    opt   sbin  usr
boot       core.1226  core.2084  data       home     lib64  proc  srv   var
core.101   core.1316  core.2248  dev        kic.txt  media  root  sys   version.json
```

- هنا فعلا لقيت الفولدر الى اسمه hello الى انا عملته 
```bash
docker@minikube-m03:~$ cd /hello/
docker@minikube-m03:/hello$ ls
data
```
- فعلا هنا موجود

```bash
docker@minikube-m03:/hello/data$ ls
index.html
```
- هنا حطيت الملف ده فى الفولدر ده 


- لما تدخل على الـمسار الى انته محدده على الـ pod كما يلى هتلاقى الملف الى انته عملته 
```bash
root@nginx123:/# cat  /usr/share/nginx/html/index.html
hello man
```

---
---
# Kube Config 

## basic understand

```bash
mostafa@MY-Home:~/Documents$ cat ~/.kube/config
apiVersion: v1
clusters:
- cluster:
    certificate-authority: /home/mostafa/.minikube/ca.crt
    extensions:
    - extension:
        last-update: Sat, 03 Oct 2026 11:20:45 EDT
        provider: minikube.sigs.k8s.io
        version: v1.39.0
      name: cluster_info
    server: https://192.168.49.2:8443
  name: minikube
contexts:
- context:
    cluster: minikube
    extensions:
    - extension:
        last-update: Sat, 03 Oct 2026 11:20:45 EDT
        provider: minikube.sigs.k8s.io
        version: v1.39.0
      name: context_info
    namespace: default
    user: minikube
  name: minikube
current-context: minikube
kind: Config
users:
- name: minikube
  user:
    client-certificate: /home/mostafa/.minikube/profiles/minikube/client.crt
    client-key: /home/mostafa/.minikube/profiles/minikube/client.key
```

ده اسمه **kubeconfig**، وبيحتوي على المعلومات اللي `kubectl` محتاجها علشان يعرف:

1. يتصل بأي Kubernetes cluster.
2. يستخدم أنهي credentials.
3. يستخدم أنهي context.
4. يشتغل في أنهي namespace افتراضي.

خلينا نفك الملف بتاعك جزء جزء.

---


1. `apiVersion`
```yml
apiVersion: v1
```

دي بتحدد إصدار الـ API الخاص بتنسيق ملف الـ kubeconfig.

---

2. `clusters`

```yml
clusters:
```
هنا Kubernetes بيحط **الـ clusters اللي `kubectl` يعرف يتصل بيها**.

عندك:
```yml
- cluster:
    certificate-authority: /home/mostafa/.minikube/ca.crt
    server: https://192.168.49.2:8443
  name: minikube
```
يعني عندك Cluster اسمها:

```yml
minikube
```

server
```bash
server: https://192.168.49.2:8443
```
دي أهم حاجة هنا. دي **عنوان Kubernetes API Server**. يعني لما تكتب:
```yml
kubectl get pods
```

> أروح أكلم مين فيقول:

```
https://192.168.49.2:8443
```
والـ API Server هو نقطة الدخول الرئيسية اللي `kubectl` بيتواصل معاها.

تقريبًا:

```
kubectl
   │
   │ HTTPS
   ▼
192.168.49.2:8443
   │
   ▼
Kubernetes API Server
```

---

3. `certificate-authority`

```yml
certificate-authority: /home/mostafa/.minikube/ca.crt
```
ده مكان **CA certificate** الخاص بالـ Kubernetes cluster. ليه `kubectl` محتاجه؟ لأن الاتصال بين:  kubectl ↔ Kubernetes API Server  بيكون HTTPS.

فالـ certificate دي بتساعد `kubectl` يتأكد إن الـ API Server اللي بيتكلم معاه **هو السيرفر الموثوق بتاع الـ cluster**.

---

4. `extensions`

```yml
extensions:
  - extension:
      last-update: Sat, 03 Oct 2026 11:20:45 EDT
      provider: minikube.sigs.k8s.io
      version: v1.39.0
      name: cluster_info
```

دي معلومات إضافية حاططها **Minikube** في الـ kubeconfig. مش هي الأساس اللي `kubectl` محتاجه عشان يتصل.
مثلاً:

```yml
provider: minikube.sigs.k8s.io
```
يعني الـ cluster ده تم إنشاؤه/إدارته بواسطة Minikube.

---

5. `contexts`
دي من أهم أجزاء الملف:

```yml
contexts:
```
الـ **Context** بيجمع 3 حاجات مع بعض
```yml
Context
 ├── Cluster
 ├── User
 └── Namespace
```

عندك:

```yml
- context:
    cluster: minikube
    namespace: default
    user: minikube
  name: minikube
```

يعني الـ context اسمه: 

```yml
minikube
```
وبيقول لـ `kubectl`:

> لما تستخدم الـ context ده، اتصل بالـ cluster اللي اسمها `minikube`، باستخدام user اسمه `minikube`، والـ namespace الافتراضي هو `default`.

---
6. `current-context`
معناها:

> الـ Context اللي `kubectl` بيستخدمه حاليًا هو `minikube`.

لذلك لما تكتب: kubectl get pods  الـ `kubectl` تلقائيًا يستخدم:  الـ Context: minikube 


---
7. `users`

```yml
users:
- name: minikube
  user:
    client-certificate: /home/mostafa/.minikube/profiles/minikube/client.crt
    client-key: /home/mostafa/.minikube/profiles/minikube/client.key
```
هنا الـ **User** مش المقصود بيه Linux user زي: mostafa root docker
لأ. ده **Kubernetes authentication identity**. يعني الـ credentials اللي `kubectl` هيستخدمها عشان يثبت للـ API Server: أنا مين ومسموحلي أعمل إيه؟


----


## Certificate and authority

- هنا عندك الـ client وبيكون عندك الـ server
الـ server بيعمل public and private key 
والـ client بيعمل  public and private key  
- وبعد كده الـسرفر بيبعت للـكلاينت public key of server 
- والـكلاينت بيبعت للسرفر الـ public key of client 

- الكلاينت لما دخل على السرفر بيسجل اليوزر والباسورد بعدها عمل encrypt لليوزر والباسورد من خلال الـ public key server كده الوحيد الى هيقدر يفك التشفير هو السرفر لانه الوحيد الى معاه الـ private key  بتاع السرفر 

- لو السرفر عايز يعرف الـ balance هيعملها تشفير من خلال الـ public key of client  والوحيد الى هيقدر يفكها هوا الـ client private key

---
---
الـ Certificate  authority دى بتكون شركه زى google CA   
- الاول السرفر بيعمل private key وبعدها بيعمل من خلال الـ private key وبيعمل من tool تانيه بيعمل certificate وبعدها   والـ certificate بيكون فيها الـ CNAME
- هنا الـ CNAME بيكون فيها انا اسمى كذا وعامل الموقع كذا والعنوان وهتفتح الموقع لكذا 
- بعد كده بتطلع على google CA بيتقولك ارفع شويه حجات علشان يعملك trust وبعد كده بيبقى عندهم بابليك certificate بيدمجوها مع الـ certificate الى انا عاملها  وبيطلعوا certificate جديده وبيسموها certificate public و بياخدوا الـ certificate بتاعتى وبيدخلوها على الـ private certificate وبيطلعوا certificate private   وبيديوك الـ public certificate وبيدوهالك وبيحطوا الـ private certificate على كل موقع تدخل عليه 
- لو انته الموقع جه يبعتلك داتا كده الـ public certificate هوا الى هيفكها اما 
- لو حاجه بتتبعت من السرفر وبتعدى من على المتصفح لو ليها فى الـ browser  الـ certificate authority هيعديها  لو ملقهاش هيقولك الموقع مش امن 

---
---
- الـ Certificate Authority (CA) دي بتكون جهة موثوقة زي Google Trust Services أو Let's Encrypt أو DigiCert.
    
- الأول الـ Server بيعمل **Private Key**، وبعدها بيستخدم الـ Private Key علشان يعمل **Public Key**، وبعد كده بيعمل **CSR (Certificate Signing Request)** باستخدام Tool، والـ CSR بيكون فيه معلومات عن الـ Domain والـ Public Key.
    
- الـ Certificate بيكون فيها الـ Domain Name، وده بيحدد إن الـ Certificate دي صالحة للموقع ده، زي `example.com`. والـ Domain ممكن يكون موجود في الـ **SAN (Subject Alternative Name)**.
    
- بعد كده بتطلع على الـ CA، والـ CA بتطلب منك تثبت إنك فعلًا بتملك أو بتتحكم في الـ Domain، وبعد ما تتأكد، بتعمل **Digital Signature** على الـ Certificate باستخدام الـ Private Key بتاع الـ CA.
    
- الـ CA مش بتاخد الـ Private Key بتاع السيرفر، ومش بتدمج الـ Public Certificate مع الـ Private Certificate. أصلًا مفيش حاجة اسمها Private Certificate بالشكل ده. عندنا **Private Key** عند السيرفر، و**Certificate** فيها الـ Public Key بتاع السيرفر وتوقيع الـ CA.
    
- بعد كده الـ CA بتديك الـ Certificate، وإنت بتحط الـ Certificate والـ Private Key على الـ Server.
    
- لما تدخل على الموقع، الـ Server بيبعت للـ Browser الـ Certificate بتاعته، والـ Browser بيتأكد إن الـ Certificate موثوقة وإن الـ Domain مطابق وإن الـ Certificate لسه سارية، وإن الـ Certificate Chain بتوصل لـ **Trusted CA** موجودة عند الـ Browser.
    
- لو الـ Browser لقى إن الـ Certificate موثوقة، بيكمل الـ **TLS Handshake** وبيتم إنشاء **Session Key** لاستخدامه في تشفير البيانات بين الـ Browser والـ Server.
    
- لو الـ Browser ملقاش إن الـ Certificate موثوقة، أو فيها مشكلة، ممكن يقولك إن الموقع **Not Secure** أو إن الاتصال مش Private.
    
- والـ Certificate نفسها مش هي اللي بتفك البيانات. هي بتساعد الـ Browser يتأكد من هوية الـ Server وبتحتوي على الـ Public Key. أما تشفير البيانات الفعلي بعد الـ TLS Handshake فبيستخدم **Symmetric Session Key**.

---
----

## How do you can create user with a permission in kube config 


```bash
mostafa@MY-Home:~/Documents$ cat ~/.kube/config
apiVersion: v1
clusters:
- cluster:
    certificate-authority: /home/mostafa/.minikube/ca.crt
    extensions:
    - extension:
        last-update: Sat, 03 Oct 2026 11:20:45 EDT
        provider: minikube.sigs.k8s.io
        version: v1.39.0
      name: cluster_info
    server: https://192.168.49.2:8443
  name: minikube
contexts:
- context:
    cluster: minikube
    extensions:
    - extension:
        last-update: Sat, 03 Oct 2026 11:20:45 EDT
        provider: minikube.sigs.k8s.io
        version: v1.39.0
      name: context_info
    namespace: default
    user: minikube
  name: minikube
current-context: minikube
kind: Config
users:
- name: minikube
  user:
    client-certificate: /home/mostafa/.minikube/profiles/minikube/client.crt
    client-key: /home/mostafa/.minikube/profiles/minikube/client.key
mostafa@MY-Home:~/Documents$ 
```
- هنا فى الاول فى الـ cluster
```bash
clusters:
- cluster:
    certificate-authority: /home/mostafa/.minikube/ca.crt
    extensions:
    - extension:
```
- دى الـ certificate بتاعه الـ cluster 

```bash
	users:
- name: minikube
  user:
    client-certificate: /home/mostafa/.minikube/profiles/minikube/client.crt
    client-key: /home/mostafa/.minikube/profiles/minikube/client.key
```
- اما هنا دى الـ certificate بتاعه اليوزر ودى بتكون مختلفه  بكل يوزر 
- بس هنا فى الـ certificate دى مفيش حاجه بتبصيها علشان تقوله ان ده يوزر الـ minikube  بس لو انته خدت الـ certificate دى وعملت يوزر جديد اسمه مثلا  على وحطيت عنده الـ certificate دى هيشتغل عادى 

---
---


```
Step-1 Generare x509 Certs (or Credentials)
We will be using OpenSSL for the generation and analysis of the certificates.

# 1.1 Create a private key for our user.
    Private keys are meant to be kept private and used in encryption, so only ones who have this private key can decrypt the data. but here, it is used only to identify a user.
----------------------------------
openssl genrsa -out /etc/kubernetes/pki/aly.key 2048
----------------------------------
# 1.2 Create a certificate sign request
We will create a CSR for our user with our private key. Basically, it's encoded info requesting a certificate. Later we will use our Certificate Authority's credentials to create a valid certificate. Read more about CSRs here.
--------------------------------------------------------------------------------------
openssl req -new -key /etc/kubernetes/pki/aly.key -out /etc/kubernetes/pki/aly.csr -subj "/CN=aly/O=XYZ-Technologies"
---------------------------------------------------------------------------------------
# 1.3 Use CA Credentials and approve the CSR to generate the final Certificate
  !Important - Locate your CA Credentials - the CA Cert and CA Key. Depending on your installation procedure, it may be stored at different locations.
-----------------------------------------------------------------------------------------------
openssl x509 -req -in /etc/kubernetes/pki/aly.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out /etc/kubernetes/pki/aly.crt -days 365
-----------------------------------------------------------------------------------------------
Awesome! your key and cert are ready to be used!

# Step-2 Update Kubeconfig to use new user creds
-------------
kubectl config view 
------------
CLUSTER_NAME=$(kubectl config view --minify -o jsonpath='{.clusters[0].name}')
SERVER=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')

kubectl config set-cluster "$CLUSTER_NAME" \
  --server="$SERVER" \
  --certificate-authority=/etc/kubernetes/pki/ca.crt \
  --embed-certs=true \
  --kubeconfig=aly.kubeconfig

kubectl config set-credentials aly \
  --client-certificate=/etc/kubernetes/pki/aly.crt \
  --client-key=/etc/kubernetes/pki/aly.key \
  --embed-certs=true \
  --kubeconfig=aly.kubeconfig

kubectl config set-context aly-context \
  --cluster="$CLUSTER_NAME" \
  --namespace=default \
  --user=aly \
  --kubeconfig=aly.kubeconfig

kubectl config use-context aly-context --kubeconfig=aly.kubeconfig
------------
if you want create another context
----------------------------------
kubectl config set-context new-context \
  --cluster="$CLUSTER_NAME" \
  --namespace=default \
  --user=aly \
  --kubeconfig=aly.kubeconfig
  ----
kubectl config use-context new-context --kubeconfig=aly.kubeconfig
--------------------------------------------------------------------
Context in Kubeconfig file - From the official docs, "A context element in a kubeconfig file is used to group access parameters under a convenient name. Each context has three parameters: cluster, namespace, and user. By default, the kubectl command-line tool uses parameters from the current context to communicate with the cluster."
----------------
sudo useradd -s /bin/bash -m aly
sudo passwd aly  
---
sudo mkdir -p /home/aly/.kube
sudo cp aly.kubeconfig /home/aly/.kube/config
sudo chown -R aly:aly /home/aly/.kube
---
su - aly
kubectl get pods
--------------------------------------------
```

- دى خطوات ازاى تعمل user فى الملف ده 

- الاول هتعمل private key لليوزر بتاعك 
```bash
openssl genrsa -out /etc/kubernetes/pki/aly.key 2048
```

---

- بعد كده هتعمل الـ cert 
```bash
openssl req -new -key /etc/kubernetes/pki/aly.key -out /etc/kubernetes/pki/aly.csr -subj "/CN=aly/O=XYZ-Technologies"
```

---

- بعد  هتروح للـ certificate بتاعه الـ api server علشان يعملك certificate علشان تشتغل بيها 
```bash
openssl x509 -req -in /etc/kubernetes/pki/aly.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out /etc/kubernetes/pki/aly.crt -days 365
```
- هنا الـ kubernates هيشتغل كانه هوا الـ certificate authority لو انته شغال internal 
---
- بعد كده 


----
---

# DaemonSet

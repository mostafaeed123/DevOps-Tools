
## what is the docker  and intro for docker?


تخيل انت عملت تطبيق على جهازك، شغال تمام، فيه Python 3.11 ومكتبات معينة بإصدارات معينة. لما تبعت المشروع لزميلك أو ترفعه على السيرفر، بتلاقي المشكلة الشهيرة: **"بس شغال عندي!" (It works on my machine)**.

السبب؟ اختلاف في:

- إصدار نظام التشغيل
- إصدار اللغة أو المكتبات
- إعدادات النظام
- متغيرات البيئة

Docker جه يحل بالضبط المشكلة دي.

### الفكرة الأساسية: الـ Container

هنا  Docker بيخليك "تغلف" (package) تطبيقك مع **كل حاجة محتاجها عشان يشتغل**: الكود، المكتبات، الإعدادات، حتى نظام التشغيل المصغر — في وحدة واحدة اسمها **Container**.

الـ Container ده بقى شغال بنفس الطريقة بالظبط على أي جهاز فيه Docker، سواء جهازك، جهاز زميلك، أو السيرفر.

---
- الـ container مش لازم يكون اصله نظام تشغيل كامل لانه اصلا بيعتمد على الكيرنال واصلا الكيرنال ده موجوده فى ويندوز ولينكس يعنى يقدر يشتغل على الاتنين عادى

- لو انته عايز تحمل image والـ image دى فيها مثلا 3 layer ومن ضمنهم layer هى عندك على الجهاز كده انته مش هتحمل الـlayer دى تانى 


![[Pasted image 20260825174729.png]]


الصورة دي بتوضح معمارية (Architecture) الـ Docker Engine، يعني إزاي بتتنفذ الأوامر بتاعتك لحد ما توصل تشغل الـ Container فعليًا. خليني أشرحلك كل جزء:

### 1. Docker client ($ Docker client)

ده الـ Terminal بتاعك، يعني لما تكتب أوامر زي:

```
docker run
docker build
docker ps
```

أنت هنا بتتكلم مع الـ **Client** بس، مش مع الـ Engine مباشرة.

### 2. Docker daemon

الـ Client بيبعت الأوامر دي لحاجة اسمها **daemon** (اسمه الكامل `dockerd`)، وده العقل المدبر اللي:

- بيستقبل الأوامر من الـ Client
- بيدير الـ Images والـ Networks والـ Volumes
- بيتواصل مع باقي المكونات عشان ينفذ اللي انت طالبه

يعني لو قولت `docker run nginx`، الـ Client هيبعت الطلب للـ daemon، والـ daemon هو اللي هيبدأ يحرك باقي الخطوات.

### 3. containerd

دي طبقة تانية جوانية شوية، مسؤولة عن **إدارة دورة حياة الـ Container** بشكل عام - يعني:

- تحميل الـ Images
- إنشاء الـ Container
- إدارة تشغيله وإيقافه

`containerd` ده مشروع مستقل بذاته، مش جزء أساسي حصري من Docker بس - حتى Kubernetes بيستخدمه كمان.

### 4. runc

ده أصغر طبقة وأقرب حاجة للنظام (kernel) نفسه. مهمته الوحيدة:

- **إنشاء وتشغيل الـ Container فعليًا** باستخدام features في نظام Linux (زي namespaces و cgroups)

يعني ده اللي بيعمل العزل الحقيقي (isolation) بين الـ Container والنظام.


---
![[Pasted image 20260825182525.png]]
- هنا لو الـ client عايز يعمل اعمل docker container run  لو الـ image دى موجوده قبل كده هيبعت الاوامر لـ container d وبعد كده ده هيبعتها للـ runc والى هى بالفاعل هتعمل الـ container اما الـ shim دى بيكون فيها حجات من الـ container d and runc علشان مثلا لو انته حذفت docker و كنت فى نفس الوقت مشغل container يظل الـ container شغال علشان انته كده عندك الـ shim

---
فى الـ docker demon  بيكون ليه api فى لينكس اسمه / var/run/docker.sock
 لازم يكون ليه اكسيس على الـ api ده علشان يقدرانه ينفذ الاوامر 

-  دوكر بيشتغل على بورت 2375 tcp  وبيكون http
- لو انته عايزه على https لازم تجيب شهاده tls


# How to be in the Docker group
----
```dockerfile
mostafa@mostafa-VMware-Virtual-Platform:~/Templates/mostafa$ docker info
Client: Docker Engine - Community
 Version:    29.7.2
 Context:    default
 Debug Mode: false
 Plugins:
  buildx: Docker Buildx (Docker Inc.)
    Version:  v0.36.1
    Path:     /usr/libexec/docker/cli-plugins/docker-buildx
  compose: Docker Compose (Docker Inc.)
    Version:  v5.5.0
    Path:     /usr/libexec/docker/cli-plugins/docker-compose

Server:
permission denied while trying to connect to the docker API at unix:///var/run/docker.sock
```
- اول لما تكتب الامر ده هيظهر معلومات عن الـ containers بتاعتك

- فوق هنا قال ان permission denied فى الـ ///var/run/docker.sock   وده هوا الـ demon وده هوا الـ api الى بيستقبل الـ docker container or docker image 

- فعلشان تشغل معلومات عن دوكر هتعمل الامر الى جاى

```bash
mostafa@mostafa-VMware-Virtual-Platform:~/Templates/mostafa$ sudo docker info
[sudo: authenticate] Password:        
Client: Docker Engine - Community
 Version:    29.7.2
 Context:    default
 Debug Mode: false
 Plugins:
  buildx: Docker Buildx (Docker Inc.)
    Version:  v0.36.1
    Path:     /usr/libexec/docker/cli-plugins/docker-buildx
  compose: Docker Compose (Docker Inc.)
    Version:  v5.5.0
    Path:     /usr/libexec/docker/cli-plugins/docker-compose

Server:
 Containers: 0
  Running: 0
  Paused: 0
  Stopped: 0
 Images: 0
 Server Version: 29.7.2
 Storage Driver: overlayfs
  driver-type: io.containerd.snapshotter.v1
 Logging Driver: json-file
 Cgroup Driver: systemd
 Cgroup Version: 2
 Plugins:
  Volume: local
  Network: bridge host ipvlan macvlan null overlay
  Log: awslogs fluentd gcplogs gelf journald json-file local splunk syslog
 CDI spec directories:
  /etc/cdi
  /var/run/cdi
 Swarm: inactive
 Runtimes: io.containerd.runc.v2 runc
 Default Runtime: runc
 Init Binary: docker-init
 containerd version: aad11006b869517fcd3009450b6f82da282e1a9b
 runc version: v1.4.3-0-gbb14dabe
 init version: de40ad0
 Security Options:
  apparmor
  seccomp
   Profile: builtin
  cgroupns
 Kernel Version: 7.0.0-29-generic
 Operating System: Ubuntu 26.04 LTS
 OSType: linux
 Architecture: x86_64
 CPUs: 3
 Total Memory: 7.214GiB
 Name: mostafa-VMware-Virtual-Platform
 ID: 28cd1d72-b8fe-41a9-9fad-84baccde3c69
 Docker Root Dir: /var/lib/docker
 Debug Mode: false
 Experimental: false
 Insecure Registries:
  ::1/128
  127.0.0.0/8
 Live Restore Enabled: false
 Firewall Backend: iptables
  EnableUserlandProxy: true
  UserlandProxyPath: /usr/bin/docker-proxy
```

- هنا الـ client and server الاتنين ردوا عليك كده دوكر شغال تمام

- بدل ما تقعد تعمل كل شويه الامر بتاع sudo قبل كل امر الافضل انك تحط اليوزر بتاعك فى جروب اسمه دوكر لان اصلا دوكر وانته بتكريته هوا بيتعمل جروب بشكل تلقائى اول لما بتكريته فال لما تحط اليوزر فى الجروب ده مش هتكون محتاج انك تكتب sudo تانى قبل الاوامر الى فيها docker

```bash
mostafa@mostafa-VMware-Virtual-Platform:~/Templates/mostafa$ cat /etc/group
root:x:0:
daemon:x:1:
bin:x:2:
sys:x:3:
adm:x:4:syslog,mostafa
tty:x:5:
disk:x:6:
.......
.....
.....
...
..
polkitd:x:979:
rtkit:x:978:
colord:x:977:
gnome-initial-setup:x:976:
gdm:x:975:
lxd:x:114:mostafa
mostafa:x:1000:
gamemode:x:974:
mohammed:x:1001:
mahmoud:x:1002:
docker:x:973:

```

- الاول هتضيف مصطفى فى الجروب ده كما يلى 
```bash
mostafa@mostafa-VMware-Virtual-Platform:~/Templates/mostafa$ sudo usermod -aG docker mostafa

```

- بعد كده عشلان تشوف هل الجروب اتضاف فيه مصطفى ولا لا هتعمل الاتى 
```bash
mostafa@mostafa-VMware-Virtual-Platform:~/Templates/mostafa$ sudo getent group
root:x:0:
daemon:x:1:
bin:x:2:
sys:x:3:
adm:x:4:syslog,mostafa
colord:x:977:
gnome-initial-setup:x:976:
gdm:x:975:
lxd:x:114:mostafa
mostafa:x:1000:
gamemode:x:974:
mohammed:x:1001:
mahmoud:x:1002:
docker:x:973:mostafa

```
- هنا قصاد دوكر فيه اسم مصطفى كده هوا فى الجروب ده

```bash
mostafa@mostafa-VMware-Virtual-Platform:~/Templates/mostafa$ groups
mostafa adm cdrom sudo dip plugdev users lpadmin lxd docker
```
- كده لما كتبت الامر ده عرفك الجروبات الى انته فيها وكده دوكر بقى من ضمن الجروبات الى انته فيها 
- دلوقتى لما تيجى تعمل docker info مش هيقولك ممنوع

```bash
mostafa@mostafa-VMware-Virtual-Platform:~/Templates/mostafa$ docker info
Client: Docker Engine - Community
 Version:    29.7.2
 Context:    default
 Debug Mode: false
 Plugins:
  buildx: Docker Buildx (Docker Inc.)
    Version:  v0.36.1
    Path:     /usr/libexec/docker/cli-plugins/docker-buildx
  compose: Docker Compose (Docker Inc.)
    Version:  v5.5.0
    Path:     /usr/libexec/docker/cli-plugins/docker-compose

Server:
 Containers: 0
  Running: 0
  Paused: 0
  Stopped: 0
 Images: 0
 Server Version: 29.7.2
 Storage Driver: overlayfs
  driver-type: io.containerd.snapshotter.v1
 Logging Driver: json-file
 Cgroup Driver: systemd
 Cgroup Version: 2
 Plugins:
  Volume: local
  Network: bridge host ipvlan macvlan null overlay
  Log: awslogs fluentd gcplogs gelf journald json-file local splunk syslog
 CDI spec directories:
  /etc/cdi
  /var/run/cdi
 Swarm: inactive
 Runtimes: io.containerd.runc.v2 runc
 Default Runtime: runc
 Init Binary: docker-init
 containerd version: aad11006b869517fcd3009450b6f82da282e1a9b
 runc version: v1.4.3-0-gbb14dabe
 init version: de40ad0
 Security Options:
  apparmor
  seccomp
   Profile: builtin
  cgroupns
 Kernel Version: 7.0.0-30-generic
 Operating System: Ubuntu 26.04 LTS
 OSType: linux
 Architecture: x86_64
 CPUs: 3
 Total Memory: 7.213GiB
 Name: mostafa-VMware-Virtual-Platform
 ID: 28cd1d72-b8fe-41a9-9fad-84baccde3c69
 Docker Root Dir: /var/lib/docker
 Debug Mode: false
 Experimental: false
 Insecure Registries:
  ::1/128
  127.0.0.0/8
 Live Restore Enabled: false
 Firewall Backend: iptables
  EnableUserlandProxy: true
  UserlandProxyPath: /usr/bin/docker-proxy
```

---
# Image and Container in Docker 

- فى حاجه فى docker اسمها الـ registry tree  ده المكان الى بيتخزن فيه كل الـ images الى هى لوكال  عندك على الجهاز

- اول حاجه علشان تعمل اى image الاول هتعمل pull للـ image الى انته عايز تعملها يعنى بمعنى اصح هتجبها الاول وتنزلها فى الـ  registry tree 
---
 - دلوقتى هتعامل مع الـ images اى حاجه هتكون التعامل بتاع دوكر مع الـ image هيكون فى بدايه الامر docker image   ولو كان التعامل مع الـ container هيكون فى بدايه الامر docker container
- دلوقتى علشان اسحب الimage بتاعه fedora هتعمل الاتى
```bash
mostafa@mostafa-VMware-Virtual-Platform:~/Templates/mostafa$ docker image pull fedora


Using default tag: latest
latest: Pulling from library/fedora
4dd84e24b4eb: Pull complete 
54254e96f9e8: Download complete 
5fb8de3299cd: Download complete 
Digest: sha256:6c75d5bf57cb0fa5aa4b92c6a83c86c791644496d9ac230de7711f5b8ec3b898
Status: Downloaded newer image for fedora:latest
docker.io/library/fedora:latest

```
- كده نزلت وده الـ sha بتاع الـ image  وبنتزل بتكون مضغوطه
---
```bash
mostafa@mostafa-VMware-Virtual-Platform:~/Templates/mostafa$ docker image ls
                                                                                         i Info →   U  In Use
IMAGE           ID             DISK USAGE   CONTENT SIZE   EXTRA
fedora:latest   6c75d5bf57cb        276MB         72.7MB        

```
- هنا قالك ان عندك image واحده بس 
---
- بعد ما بتعمل download for image هتعمل create for container   
```bash
mostafa@mostafa-VMware-Virtual-Platform:~/Templates/mostafa$ docker container create -it fedora bash
e87a3903439c19e699b684f831f2169d0e3b2429bd1dc221b25a97b1d3f253b4

```
- هنا هتعمل كونتينر فكتبت docker container create 
- وهنا -it معنها انه هيكون inter active terminal 
- وبعدها كتبت fedora علشان دى الـ image الى انته عايز تعمل منها container 
- اما باش الى فى الاخر دى الاوامر الى هتتعامل بيها فى الترمينال الانتراكتيف

- بعد لما كتبت الامر ده اداك الـ sha بتاع الـ container ده 
---
- علشان اشوف الـ كل الـ containers الى عندى هعمل الامر ده علشان اشوف كل الـ containers الى عندى سواء شغاله او الى لسه متحمله

```bash
mostafa@mostafa-VMware-Virtual-Platform:~/Templates/mostafa$ docker container ls -a
CONTAINER ID   IMAGE     COMMAND   CREATED         STATUS    PORTS     NAMES
e87a3903439c   fedora    "bash"    4 minutes ago   Created             determined_diffie

```
- هنا الـ id وبعدها الـ image الى مبنى عليها الـ container وبعدها الامر الى انته هتتعامل معاه واتكريت من امته اما هنا فى الـ names ده الاسم الى انته هتتعامل معاه بدل الـ id

- اما لو كتبت كده docker container ls  كده هيجب الى شغال بس من الكونتينر 

- ممكن انك تبدا تشغل الـ container ده من خلال الاتى 
```bash
mostafa@MY-Home:~$ docker container ls -la
CONTAINER ID   IMAGE     COMMAND   CREATED          STATUS    PORTS     NAMES
4dc03ca7664a   fedora    "bash"    11 seconds ago   Created             relaxed_lovelace
mostafa@MY-Home:~$ docker container start -i 4dc
[root@4dc03ca7664a /]#

```
- هنا دخل على الـ container عادى جدا بسهوله 
- هنا بعد الـ i كتبت اول شويه حروف من الهاش بتاعها او ممكن تكتب الاسم الى فى الـ name
- هنا فى الماشين دخلك كروت @  وبعدها الهاش بتاع الماشين

- علشان تجيب اسم الماشين الى جوه الـ container هتعمل الاتى

```bash
[root@4dc03ca7664a /]# cat /etc/*hostname*
4dc03ca7664a
```

- لو انته عملت امر hostname لوحده مش هيشتغل لان ده بيكون الـ minimal من الـ os

---
- لو انته عملت exit كده هيطلع من الـ container كله علطول 
```bash
[root@4dc03ca7664a /]# exit
exit
mostafa@MY-Home:~$
mostafa@MY-Home:~$ docker container ls -a
CONTAINER ID   IMAGE     COMMAND   CREATED         STATUS                      PORTS     NAMES
4dc03ca7664a   fedora    "bash"    9 minutes ago   Exited (0) 35 seconds ago             relaxed_lovelace

```
- هنا قالك انك عملت exit

---
- هنا حملت image python
```bash
mostafa@MY-Home:~$ docker image pull python
Using default tag: latest
latest: Pulling from library/python
b00bcb890d90: Download complete
b00bcb890d90: Pull complete
1da3cb2f93f2: Pull complete
68b64c51cda3: Pull complete
600962de363f: Download complete
600962de363f: Pull complete
d74736caedd4: Pull complete
9c3f3ed944a8: Pull complete
746e9fcfca16: Download complete

Digest: sha256:4fad23465a06cc5149a541fbec6f87e234a64dc0550f6bfdd2d290d8f03240df
Status: Downloaded newer image for python:latest
docker.io/library/python:latest

```

---
- بدل ما تعمل create and start للـ container اعمل علطول run ده هيعملهم هما الاتنين
وكمان لو الـ image مش موجوده عندك قبل كده هوا هيعمها pull


```bash
mostafa@MY-Home:~$ docker container run -it python:latest
Python 3.14.7 (main, Aug  5 2026, 16:32:19) [GCC 14.2.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>>

```
- هنا دخلك على بايثون علطول 
- لو عملت exit هيخرجك من بره الـ conatiner كله
- لان الكونتينر بيعمل حاجه واحده بس

---
- الكونتينر بيكون فيه جزء من الـ os والكونتينر بيكون كانه زى تطبيق واول لما تقفله كانك قفلت التطبيق علشان كده لما بتعمل exit بيقفل الكونتينر خالص 

- يعنى الـ container  == command يعنى مثلا فى فيدورا انته بتكتب bash معنى ان bash قفل كده الكونتيرا كده باش قفل

---
```bash
mostafa@MY-Home:~$ docker container run -it python:latest /bin/bash
root@9a7ace6937b6:/# ps
    PID TTY          TIME CMD
      1 pts/0    00:00:00 bash
      6 pts/0    00:00:00 ps
root@9a7ace6937b6:/#
```
- هنا كده انته شغلت الكونتير بتاع بايثون بس عايز تفتح الباش بتاعته

- طيب لو شغلت بايثون من جوه باثون الى هوا بتاع
```bash
root@9a7ace6937b6:/# python3
Python 3.14.7 (main, Aug  5 2026, 16:32:19) [GCC 14.2.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> print ("mostafa")
mostafa
>>> exit
root@9a7ace6937b6:/#

```
- هنا لما عملت exit مخرجش من الـ container كله علشان دى جوه الـ container

---
- لو انته عايز تشيل كونتير هتعمل الاتى 
```bash
mostafa@MY-Home:~$ docker container ls -a
CONTAINER ID   IMAGE           COMMAND       CREATED          STATUS                          PORTS     NAMES
9a7ace6937b6   python:latest   "/bin/bash"   5 minutes ago    Exited (0) About a minute ago             sad_wilbur
815066b96ae5   python:latest   "python3"     13 minutes ago   Exited (0) 6 minutes ago                  laughing_fermi
5c2e8d57ab50   python:latest   "python3"     14 minutes ago   Exited (0) 14 minutes ago                 awesome_chaplygin
a76972e013bd   python:latest   "python3"     15 minutes ago   Exited (0) 14 minutes ago                 vigilant_taussig
4dc03ca7664a   fedora          "bash"        33 minutes ago   Exited (0) 25 minutes ago                 relaxed_lovelace




mostafa@MY-Home:~$ docker container rm 4dc03ca7664a
4dc03ca7664a





mostafa@MY-Home:~$ docker container ls -a
CONTAINER ID   IMAGE           COMMAND       CREATED          STATUS                      PORTS     NAMES
9a7ace6937b6   python:latest   "/bin/bash"   6 minutes ago    Exited (0) 2 minutes ago              sad_wilbur
815066b96ae5   python:latest   "python3"     14 minutes ago   Exited (0) 7 minutes ago              laughing_fermi
5c2e8d57ab50   python:latest   "python3"     15 minutes ago   Exited (0) 14 minutes ago             awesome_chaplygin
a76972e013bd   python:latest   "python3"     16 minutes ago   Exited (0) 15 minutes ago             vigilant_taussig

```
- هنا لو انته عايز تمسح كونتيتر ممكن تحط اسمه او الباش بتاعه ولما تعمل ls هتلاقيه اختفى 

- فيه هنا كذا كونتينر ممكن تمسحهم من بايثون



---
- برضه لو انته عايز تمسح images هتعمل الاتى 

```dockerfile
mostafa@MY-Home:~$ docker image ls -a
                                                              i Info →   U  In Use
IMAGE           ID             DISK USAGE   CONTENT SIZE   EXTRA
fedora:latest   6c75d5bf57cb        276MB         72.7MB
python:latest   4fad23465a06       1.63GB          433MB    U


-----------------------------------------------------------------------
-----------------------------------------------------------------------
mostafa@MY-Home:~$ docker image rm fedora:latest
Untagged: fedora:latest
Deleted: sha256:6c75d5bf57cb0fa5aa4b92c6a83c86c791644496d9ac230de7711f5b8ec3b898
-----------------------------------------------------------------------
-----------------------------------------------------------------------
mostafa@MY-Home:~$ docker image ls -a
                                                              i Info →   U  In Use
IMAGE           ID             DISK USAGE   CONTENT SIZE   EXTRA
python:latest   4fad23465a06       1.63GB          433MB    U
mostafa@MY-Home:~$

```

---

```bash
docker ps
```
- بتستخدم الامر ده علشان تعرف ايه الى شغال حاليا فى دوكر

---

```bash
docker run -d --name mycontainer  ubuntu
```
- هنا لو انته عايز تشغل الكونتينر فى الخلفيه هتحط هنا الـ d -

---
----

```bash
docker run -it --name mycontainer  ubuntu
```
-  ده لو انته عايزها شغاله فى الترمينال الى انته واقف فيه 
---
---

```bash
docker run -d --name mycontainer  ubuntu
```
- اما لو انته عايزها شغاله فى الخلفيه هتعمل دى 


----
---
```bash
docker run -d --name mynginx nginx 

docker exec -it mynginx bash
```
فى الامر الاول بتاع الـ d ده اشتغل فى الخلفيه  اما الامر التانى هيفتح قدامك شيل تانى من نفس الكونتينر بس ده مش هيوقف الى شغال فى الخلفيه مثلا وممكن من خلال الترمينال الى انته فاتحه من خلال it تنفذ اوامر تانيه عادى 

----
---
```bash
docker run -d --name mynginx nginx sleep 50

docker exec -it mynginx bash
```
- هنا فى اول  امر هيشتغل لمده 50 ثانيه وبعدها يعمل sleep اما فى الامر التانى هيفتح شيل من نفس الكونتينر بس الشيل دى هتشتغل لمده الخمسين ثانيه بس وبعدها هتقف 
---
---

```bash
docker run -d -e MYSQL_ROOT_PASSWORD="12345" mysql
```

- هنا وانته بتعمل السرفر بتاع mysql بيطلب منك ضرورى وانته بتعمله انك تحط الـ environment بتاعه الباسورد وتحط الباسورد فعلشان كده بتحط -e 



---
---


```bash
docker stop mycontainer
```
- ده علشان توقف تشغيل الكونتينر ده 
```bash
docker start mycontainer
```
- علشان تشغل الكونتينر ده 

- لو انته عايز تعدل على image الاول هتحملها وبعدها تفتح منها container وبعدها تضيف فيها الى انته عايزه وبعدها تعملها كـ image جديده

---
---
- لو انته عايز تعرف معلومات عن كونتينر معني هتعمل الامر الى جاى ده
```bash
docker inspect mycontainer
```

---
--- 

## Images
- دى عباره عن ملف الملف ده بيوصف انته عملت ايه مثلا انته فتحت بورت كذا حملت ملف كذا كل حاجه من دول بيعمل layer

---
- اى اوامر هتتعمل فى وقت انى ببنى الـ image بيكون اسمها bulid time اما الاوامر الى   بتكون فى وقت عمل container دى بيكون اسمها run time
# Images Naming

---
- انته بيكون عندك image fedora مثلا انته مش هتتحتاج فيدورا بس لو حدها انته هتستخدم fedora كانه base image يعنى هتنى الابليكيشن بتاعك على فيدورا ده وبعد كده تعمل الابليكيشن ده كانه image  وتعمل export للـ image دى

---
---
- لو انته جيت مثلا تعمل pull لـ image معينه انته مش بتقوله انته عايز تجيب الـ image دى ساعتها دوكر  بشكل تلقائى من hub.docker.com دى بتكون الـ default registry 
- الـ registry ده بيكون مجرد store بيكون فيه كل الـ images
- الـ registry دى بتكون عباره عن repos   كذا واحد الـ repo الواحد بيكون عباره عن ستور واحد لكل ال versions لـ image معينه

- فى الريبو بتاعه ubuntu بكون فيه كل النسخ بتاعه ubuntu
-  كان فى git لما بتعمل tag ده بيكون version معينه للـ repo دى او مثلا نسخه معينه لـ ubuntu
-  هنا ubunto :v1  هنا كده الريبو الى هوا ubunto وبعدها رقم الـ version كده ده هوا الـ tag


- image name =  repo name : tag

---
- لما انته بتعمل docker image pull python هوا هنا التيم بتاع docker بيجيب الـ image الاصليه بتاعه python يعنى انته مش لازم تحدد tag معين لان دى official اما لو انته مثلا عايز تجيب image تانيه مش official  هتعمل الاتى 


- docker image pull mostafa123/sudo-linux:v10
- هنا بيدخل الاول على الاوكونت وبعدها يبدا يشوف هل هوا عنده الاول repo بالاسم ده ولا لا وبعدها يشوف هل هوا عنده tag بالرقم ده ولا لا
- لازم تكتب اسم الاكونت الى عمل الـ image دى اما لو انته كتبت الـ image علطول مش هيقبل علشان دى مش official
---

- docker image pull python : latest
- كده هيجبلك احدث نسخه من بايثون  هنا كلمه latest دى مش اسم الـ tage ولكن ده بيقول هاتلى احدث نسخه 

![[Pasted image 20260825191951.png]]
هنا ده docker hub الى ممكن ترفع عليه الـ repos بتاعتك الى انته ممكن تستخدمها كـ images

![[Pasted image 20260825192248.png]]
اول لما تدخل على explore هتلاقى الاتى 

![[Pasted image 20260825192311.png]]
هنا هتلاقى الـ official images شويه منها 

- لو دخلنا مثلا على بايثون هتلاقى الـ tags الى ممكن تحملها عادى
![[Pasted image 20260825192537.png]]
![[Pasted image 20260825192705.png]]
لو ضغطت هناعلى الـ tag هتلاقى انه ظهر هنا عادى جدا وهنا تقدر تحمل الى انته عايز 

---
- لما انته بتنزل مثلا image بتاعه python دوكر بيعرف مينين ان الـ arch بتاعتك هى مثلا windows  ?or linux
- بيكون عندك فى الريبو حاجه اسمها mainfest يعنى لما تكتشف ان الى هياخد الـ image دى هيكون ويندوز اديله image من نوع arch windows


- هنا لو عايز تعرف هل الـ image دى رسميه ولا لا هتعمل الاتى 


![[Pasted image 20260921172409.png]]
- هنا اول لما تلاقى الـ image مكتوبه لوحدها كده كده هى  رسميه وبيكون مكتبو تحتها docker official image     لكن اول لما تلاقى مكتوب circleci/node ده بيكون شخص عادى الى عاملها وبكون اليوزر بتاعه اسمه circleci واسم الـ repo الى فيها الـ image وكل النسخ بتاعه الـ image دى بيكون اسمها node وهكذا فى كله
هنا



---
# About docker
لو المساحه الى دوكر شغال عليها خلصت الابليكيشن هيقع 
اما لو الـ CPU بقى مليان كده مش هيعمل حاجه تانى فانته بتقوله اول لما توصل مثلا لـ 70% من طاقتك هتعمل واحد تانى  يعنى هتكريت كوبى من الدوكر ده بحيث ان الداتا تكون موجوده والابليكيشن ميقعش ويعمل كانه load balancer 


```bash
mostafa@MY-Home:~/Documents/docker/depi$ sudo  ls /var/lib/docker/
[sudo] password for mostafa: 
buildkit    engine-id  network  rootfs    swarm  volumes
containers  image      plugins  runtimes  tmp
```
- هنا المكان الى بيتخزن فيه كل حاجه تخص دوكر سواء نتورك سواء volumes سوار plugins


# Image Architecture


![[Pasted image 20260825201623.png]]
- هنا الـ image دى فيها كذا layer مثلا اول layer دى بيكون فيها الكيرنال والى بعدها فيها مثلا تعديل تانى والى بعدها فيها تعديل تالت لحد اخر layer انته محتاجها وبعدها بتقفلها 

- لما انته بتكون عايز تحمل الـ images دى الى بيحصل الاتى
- اول حاجه بيعملها download وبعدها يعمل extract  علشان هى بتكون مضغوطه وبعدها هيعمل pull  وبعدين يديلك الـ id بتاع كل layer وبعدين الـ id بتاع الـ image كلها 
![[Pasted image 20260825202044.png]]

- ---
![[Pasted image 20260825202228.png]]
- هنا مثلا حملت اوبنتو فى لاير وبعدها بايثون وبعدها الكود كل واحده من دول لاير 
![[Pasted image 20260825202324.png]]

- يبقى هنا مثلا فى الاولى 3 ملفات وفى التانى 3 برضه بس اتعدل على الملف رقم 5 فهم 6 ملفات بس
![[Pasted image 20260825202430.png]]

---
```bash
docker container run -it --name "hadoop" -h hadoop asant76/hadoop-pseudo:v1.0 bash -c "/usr/local/bootstrap.sh; bash"
```

- هنا عملت docker container run علشان يحملها ويشغلها علطول 
- هنا -it علشان يكون interface    يعنى تتعامل مع الترمينال 
- هنا --name علشان تسمى الـ container بالاسم ده
-  هنا - h علشان تغير اسم الجهاز جوه الكونتينر 
- هنا asant76/hadoop-pseudo:v1.0   هنا دى اسم الـ image الى هى مش official 
- هنا فى الاخر بتختار اسم الحاجه الى هتتعامل معاها الى هى الباش bash -c "/usr/local/bootstrap.sh; bash" هنا دى شيل اسكربت اتعملت فى الـ image دى علشان اول لما تتحمل تشتغل بشكل تلقائى 

- بعد لما تعمل الامر ده هتلاقى الـ container اشتغل وهيكون فيه ويب ابليكيشن كما يلى 
![[Pasted image 20260825204503.png]]

- زى ده كده مضظهرتش انك مثلا تحمل نظام تشغيل معين 
- لو انته عملت exit كده الويب هيقفل بشكل تلقائى 

---
- لو انته عايز معلومات عن image معينه هتكتب الاتى 
```dockerfile
docker image inspect python:latest
```
- هيظهرلك معلومات عن python image  فى حاله json   
![[Pasted image 20260825224406.png]]

---
برضه بنفس الطريقه ممكن انك تجيب معلومات عن container معين كما يلى 

```bash
mostafa@MY-Home:~$ docker container ls -a
CONTAINER ID   IMAGE           COMMAND     CREATED      STATUS                  PORTS     NAMES
815066b96ae5   python:latest   "python3"   3 days ago   Exited (0) 3 days ago             laughing_fermi
----------------------------------------------------------
----------------------------------------------------------

mostafa@MY-Home:~$ dokcer container inspect 815066b96ae5

```

![[Pasted image 20260825225046.png]]

---

---

![[Pasted image 20260825233404.png]]
هنا لما حملت extention docker هنا ظهرلك الـ images and containers  وبيظهرلك كل حاجه 

![[Pasted image 20260825233512.png]]
لو حطيت الماوس عليها هيديك عنها معلومات
![[Pasted image 20260825233549.png]]
هنا برضه بيقولك ان الـ container ده مبنى على الـ images دى  وعليها علامه انه متوقف
![[Pasted image 20260825233732.png]]
ممكن من هنا تقوله run يعنى معنها اعمل container 

- لو قولتله inspect هيفتحلك json file وهيكون فيه كل بيانات الـ image دى
-  هنا لو قولتله run interactive معناها انه يفتح لك ترمينال interactive
![[Pasted image 20260825234029.png]]
هنا عمللك انه فيه واحده شغاله وكمان فتحلك ترمينال 
![[Pasted image 20260825234218.png]]
هنا تقدر تعمل exit من الـ container ده



---
-  لو انته قولته  الاتى الى هوا docker image ls -q   هيجيب الـ id علطول

```bash
mostafa@MY-Home:~$ docker image ls -q
4fad23465a06
```

![[Pasted image 20260825234410.png]]

- طيب لو انته مثلا عايز تحذف كل الـ images هتعمل الاتى

```bash
mostafa@MY-Home:~$ docker image rm $(docker image ls -q)
```
- معناها احذفلى كل الـ ids الى هتخرج من هنا 

```bash
docker container run -d --name server-nginx -p 80:80 nginx:latest
```
- هنا -d يعنى يشتغل فى الباكجرواند 
- اما -p انه يشتغل على بورت 80:80 
- اول لما تدخل على البورت ده http://localhost
- هيدخلك على الويب بتاع nginx الى شغال من الدوكر 

---
---

-  لو انته عايز تنقل ملف من جهازك لـ container ubunto هتعمل الاتى 
```bash
docker container cp /home/mostafa/Desktop 458:/tmp
```
- هنا هتكتب الاول docker container   وبعدها cp وبعدها مسار الملف الى على جهازك وبعدها اول مثلا 3 حروف من الـهاش بتاع الـ image الى فى الـ container وبعدها المسار الى جوه الـ container

- بس الطريقه دى مش فعاله لانك لو عايز تعدل على الملف هتعدل عليه على جهازك وبعدها تنقله تانى للكونتينر بنفس الطريقه 

----

```bash
mostafa@MY-Home:~$ docker container run -it -p 8000:80 nginx:latest
```
- هنا هيحمل الـ image وهيعمل container وهيشغله  
- هنا ده هيشتغل على بورت 80 بس الـ host الى هيتفتح عليه هيكون host 8000 على الويب
![[Pasted image 20260826004110.png]]
اشتغلت هنا 

- ممكن نعمل inspect للـ container ده هنلاقى الاتى 

![[Pasted image 20260826004324.png]]
![[Pasted image 20260826004441.png]]
- اول لما تضغط على individual containers هتلاقى انك ممكن تحذفهم كلهم مره واحده

---
---
```bash
mostafa@MY-Home:~$ docker container run -d --name web-server nginx:latest
18625669238fe156945975d15df055c1efae0acbb8d5246b82d040968f1cf13f
```

- هنا خليته يشتغل فى الخلفيه واديته اسم  ممكن اعرف الـ ip بتاعه كما يلى من خلال الـ inspect
![[Pasted image 20260826004828.png]]

---
- ممكن من السرفر التانى تشوف السرفر التانى عن طريق الاتى 
```bash
curl http://172.17.0.2
```
![[Pasted image 20260826005541.png]]

- هتلاقى ده او ممكن تعمل ping برضه
```bash
ping  172.17.0.2
```


----
```bash
mostafa@MY-Home:~$ docker container run -it --name cleint  --add-host web:172.17.0.2 rockylinux:9
```
- هنا دى لو انته عايز تحط الـ ip and host فى ملف الـ hosts علطول وانته بتكريت الـ container  عملت الى فات ده الى هوا الاوبشن بتاع --add-host web:172.17.0.2 

- لو فتحت ملف /etc/hosts هتلاقى االتى 

```bash
ostafa@MY-Home:~$ docker container start -ai  eabadf1d67ac


[root@eabadf1d67ac /]# cat /etc/hosts
127.0.0.1       localhost
::1     localhost ip6-localhost ip6-loopback
fe00::  ip6-localnet
ff00::  ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
172.17.0.2      web
172.17.0.2      eabadf1d67ac
```


----
```bash
ostafa@MY-Home:~$ docker container start -ai  eabadf1d67ac
```
- هنا فى الامر ده علشان انك تقدر تفتح الـ container تانى بعد لما انته كنت قافله 


----
# Networking

- لما بتكريت الـ container بيكون  isolated ومعاه الـ network stack بتاعته زى الـ vm
- فيه تلت انواع من الـ networks بين الـ containers :::
- اول حاجه الـnone   دى مش هتعرف انك تتواصل مع اى حد ومش connected على اى حد 
- الـ bridged دى هى الـ default لما انته بتعمل connect على اى container
- الـ host 

```bash
mostafa@MY-Home:~$ ip link show
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: ens33: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
    link/ether 00:0c:29:12:f8:82 brd ff:ff:ff:ff:ff:ff
    altname enp2s1
    altname enx000c2912f882
3: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN mode DEFAULT group default 
    link/ether 86:13:e1:f0:91:0b brd ff:ff:ff:ff:ff:ff
```
- هنا هيظهرلك الـ network interfaces   ومن ضمنهم docker  الـ networks الخاصه بدوكر


```bash
mostafa@MY-Home:~$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host noprefixroute 
       valid_lft forever preferred_lft forever
2: ens33: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 00:0c:29:12:f8:82 brd ff:ff:ff:ff:ff:ff
    altname enp2s1
    altname enx000c2912f882
    inet 192.168.249.131/24 brd 192.168.249.255 scope global dynamic noprefixroute ens33
       valid_lft 1634sec preferred_lft 1634sec
    inet6 fe80::20c:29ff:fe12:f882/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
       
       
3: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default 
    link/ether 86:13:e1:f0:91:0b brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.1/16 brd 172.17.255.255 scope global docker0
       valid_lft forever preferred_lft forever
    inet6 fe80::8413:e1ff:fef0:910b/64 scope link proto kernel_ll 
       valid_lft forever preferred_lft forever
```
- هنا فى الاخر docker هنا الـ bridged واخده من الـ ip ده inet 172.17.0.1 علشان كده اول لما بيتعمل container بياخد من الـ ip ده 172.17.0 
![[Pasted image 20260828111031.png]]
هنا تقدر تظهر الـ networks الى فى docker ومين الى متصل بيها فاول لما تعمل container هتلاقى ان بقا فيه مثلا اجهزه فى الـ bridged

![[Pasted image 20260828111352.png]]
هنا اول لما تحط الماوس على bridged هتلاقى ان الى متصل على الـ bridged هيظهر

```bash
mostafa@MY-Home:~$ docker container run -d --name alp alpine
```


```bash
ostafa@MY-Home:~$ docker container run -d --name alp2 alpine
6c1c7a8ca5189c2d6af76ee17c151b4a2b1ee74064a122c7187a5a0db6043ca2
```
- لو حطيت الماوس على الـ bridged بعد لما كريتت التانيه هتلاقى ان فيه اتنين فى نفس bridged

---
-  هنا ctrl + p      ,,,,,,,,ctrl +v بتخرجك بره الـ container من غير ما تقفله 

---
- هنا لما عملت الامر ده لقيت ان فيه اتنين ادابتر اتضافو 
```bash
mostafa@MY-Home:~$ ip link show
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: ens33: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
    link/ether 00:0c:29:12:f8:82 brd ff:ff:ff:ff:ff:ff
    altname enp2s1
    altname enx000c2912f882
    
    
    
3: docker0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default 
    link/ether 86:13:e1:f0:91:0b brd ff:ff:ff:ff:ff:ff
8: veth3cca6f3@if2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master docker0 state UP mode DEFAULT group default 
    link/ether 4e:37:f4:af:b5:01 brd ff:ff:ff:ff:ff:ff link-netnsid 0
9: veth4ca177b@if2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master docker0 state UP mode DEFAULT group default 
    link/ether ee:6e:76:f5:23:8a brd ff:ff:ff:ff:ff:ff link-netnsid 1
mostafa@MY-Home:~$ 
```

- كل container هتكريته هيتكريتله container adapter
- هنا الـ lo  و الـ ens والـ docker  بيكونوا واخدين مثلا 1 و2 و3 والباقى بتاع الكونتير بيكون واخد ارقام اكبر  من كده 

---

```bash
mostafa@MY-Home:~$ docker container run -it --name alp3 --network none alpine
```
- هنا علشان تختار النتورك الى انته عايزها هتكتب network وتحط none علشان تكون دى النتورك الى انته عايزها 


---
```bash
mostafa@MY-Home:~$ docker container run -it --name alp4 --network host alp
ine
/ # 
```

- هنا دى  اتعملت فى الـ host
**الـ container بيشيل عزل الشبكة بتاعه بالكامل، وبيستخدم شبكة الـ host نفسها مباشرة.**

يعني عمليًا:

- مفيش IP منفصل للـ container — بيستخدم نفس IP بتاع جهازك.
- مفيش NAT ولا port mapping.
- أي port بيفتحه برنامج جوه الـ container، بيبقى مفتوح على الجهاز الحقيقي على طول.
### مميزات استخدامه

1. **أداء أفضل شوية** في تطبيقات الشبكة الثقيلة (زي load balancers أو proxies) لأنه مفيش طبقة NAT إضافية.
2. **سهولة** — مش محتاج تعمل `-p` لكل بورت، البورتات بتتفتح تلقائيًا.
3. مفيد لو التطبيق محتاج يشوف كل تفاصيل الشبكة الحقيقية بتاعة الجهاز (زي أدوات مراقبة الشبكة).

### عيوبه (مهم تعرفهم)

1. **أمان أقل** — الـ container بقى شايف ومتصل بشبكة الجهاز زي أي برنامج عادي، فمفيش عزل يحميك لو حصل اختراق جوه الـ container.
2. **تعارض البورتات** — لو حاولت تشغل حاجتين على نفس البورت (واحدة في container والتانية على الجهاز، أو containerين بـ host mode) هتاخد error فورًا، لأنهم بيتشاركوا نفس namespace الشبكة.
3. **مش متاح على كل الأنظمة** — بيشتغل كويس على Linux، لكن على Docker Desktop (Windows/Mac) بيكون محدود جدًا أو مش شغال زي المتوقع، لأن Docker فعليًا شغال جوه VM.

### مثال عملي يوضح الفرق

لو شغلت nginx بـ bridge network:
```bash
docker run -d -p 8080:80 nginx
```
هتدخل على `localhost:8080`.

لو شغلته بـ host network:

```bash
docker run -d --network host nginx
```
هتدخل مباشرة على `localhost:80` (نفس بورت الجهاز)، من غير أي `-p`.

---
---

- انته لما بتكريت نتورك بيسالك انته عايز الدرايفر بتاعها ايه  وبرضه الـ docker localhost بيكون عليه by default 3 انواع من الـ drivers
-  فيه درايفر اسمه bridge 
- وفيه mac vlan  ده درايفر بيخليك تعامل الـ container كانه physical device على النتورك 
- اخر درايفر  اسمه over lay driver  علشان تخلى الـ containers يكلموا بعض  من على hosts مختلفه

---
 علشان تعرف الـ networks الى عندك هتعمل الاتى 
```bash
mostafa@MY-Home:~$ docker network ls
NETWORK ID     NAME      DRIVER    SCOPE
88bd72759319   bridge    bridge    local
8fe054d50f6c   host      host      local
4745244a77df   none      null      local
```

---
 - علشان تكريت network هتعمل الاتى
```bash
mostafa@MY-Home:~$ docker network create privete-network
25d3ab7c67874210bc9c74219ac53ad157b1ca36e56469e6f6349abae011bbdb
```

![[Pasted image 20260828120518.png]]
- طبعا الـ default بتاع الشبكه دى هيكون هوا bridged

```bash
mostafa@MY-Home:~$ docker network ls
NETWORK ID     NAME              DRIVER    SCOPE
88bd72759319   bridge            bridge    local
8fe054d50f6c   host              host      local
4745244a77df   none              null      local
25d3ab7c6787   privete-network   bridge    local
```
- هنا النتورك الى انا كريتتها الدرايفر بتاعها هوا bridged

---
- ممكن انك تغير الـ network بتاعه الـ running container وتخليها متصله بـ private network 

```bash
mostafa@MY-Home:~$ docker network connect privete-network  alp
mostafa@MY-Home:~$ docker network connect privete-network  alp2
```

- لو حطيت الماوس على  الـ private-network هتلاقى ان فيه الاتنين كونتينر 

- ممكن انك وانته بتكريت نتورك تعمل subnet جديده علشان لو هى نفس الـ subnet وجيت انته تخلى الـ containers يتصلوا بيها كده هيكونوا متصلين بالاتنين نتورك

```bash
mostafa@MY-Home:~$ docker network create --subnet 10.0.0.0/16  private-net
work-2
a326550726e5ef0f1e9daddbc093f877209e459aa49aae980d1f4b39fe927d48
```

---

```bash
mostafa@MY-Home:~$ docker network disconnect privete-network  alp2
mostafa@MY-Home:~$ docker network disconnect privete-network  alp
mostafa@MY-Home:~$ docker network disconnect bridge  alp
mostafa@MY-Home:~$ docker network disconnect bridge  alp2
mostafa@MY-Home:~$ docker network connect privete-network2  alp
Error response from daemon: network privete-network2 not found
mostafa@MY-Home:~$ docker network ls
NETWORK ID     NAME                DRIVER    SCOPE
88bd72759319   bridge              bridge    local
8fe054d50f6c   host                host      local
4745244a77df   none                null      local
a326550726e5   private-network-2   bridge    local
25d3ab7c6787   privete-network     bridge    local
mostafa@MY-Home:~$ docker network connect privete-network-2  alp
Error response from daemon: network privete-network-2 not found

mostafa@MY-Home:~$ docker network connect private-network-2  alp
mostafa@MY-Home:~$ docker network connect private-network-2  alp2
```
- هنا خليته يتصل بالنتورك الجديده بس 
![[Pasted image 20260828122018.png]]
- هنا لو انته ضعطت على الـ contianer ده كليك يمين ودخلت على الـ attach shell كده هيدخلك على الـ terminal بتاعه
![[Pasted image 20260828122225.png]]
دخلك هنا 

![[Pasted image 20260828122530.png]]
لما عملت هنا inspect ظهرلك الـ ip بتاعه تعمل ping على الـ default gateway وهيعمل ping ادى جدا


```bash
docker network create --subnet 10.0.0.0/16 --internal private-net
```
بيحصل حاجة مهمة جدًا: **الشبكة دي بتتقطع تمامًا عن الإنترنت الخارجي (والعالم الخارجي بشكل عام).**

### يعني إيه بالظبط؟

في الوضع العادي (من غير `--internal`)، أي custom bridge network بيعمله Docker بتقدر الـ containers اللي جواها:

- تتواصل مع بعض 
- تخرج برا وتوصل للإنترنت (تعمل `ping google.com` مثلاً) 
- الجهاز الخارجي (الـ host أو أي حد برا) يقدر يوصلها لو عملت port mapping 

مع `--internal`:

- الـ containers جوه الشبكة تقدر تتكلم مع بعض بس 
- **مفيش خروج للإنترنت خالص**  (يعني `ping google.com` هيفشل)
- Docker بيوقف/يمنع الـ default gateway اللي بيوصلها بالعالم الخارجي

# Port Mapping
- لو عندك كونتينر متصل على نتورك الهوست وكان فاتح nginx على بورت 80  وجه كونتينر تانى دخل على الهوست برضه وعايز يفتح على بورت 80 مش هيشتغل 
- لو انته عندك سرفرين واحد باك اند وواحد فرونت اند لو الباك اند وقع كده اول لما يجى يتصل تانى بالانترنت هياخد ip جديد غير الى كان معاه والفرونت اند كان بيتواصل مع السرفر من خلال الـ ip القديم دلوقتى الـ ip اتغير فعلشان لو المشكله دى حصلت يقدورا يتواصلوا المفروض يعملوا port mapping

- الوحيد الى مش هيتغير هوا الـ ip بتاع الـ bridge الى هيكون default gateway   الى ممكن يكون مثلا 

- 172.17.0.1

```bash
mostafa@MY-Home:~/Documents/docker/depi$ docker run -d -p 5000:80 nginx
6c00ad59bf984f8db386da315e2f6eb64df71cba4d08f1ac8bda666680e748c4
```
 - انته كده بتعمل port mapping يعنى بتقوله لما تيجى تشغل الابليكشن ده  اى حد هيكلم الابليكيشن ده على بورت 5000  يقدر يدخل على الابليكشن نفسه الى بيعمل listen على بورت 80 
- 

```bash
mostafa@MY-Home:~/Documents/docker/depi$ docker ps
CONTAINER ID   IMAGE     COMMAND                  CREATED          STATUS          PORTS                                     NAMES
6c00ad59bf98   nginx     "/docker-entrypoint.…"   20 seconds ago   Up 19 seconds   0.0.0.0:5000->80/tcp, [::]:5000->80/tcp   awesome_snyder
```

- هنا لو انته قفلت الابليكيشن ده وبعدها جيت تفتحه هتلاقيه شغال على  نفس البورت الى هوا 5000 
- طبعا لو الباك اند وقع والفرونت اند عايز يتصل تانى  ممكن تتصل بيه عن طريق الـ ip of gateway وكمان تحط الـ الاتى 
```bash
172.2.0.1:5000
```
- ده ip الـ gateway وده الـ port mapping بتاعه nginx الى انته عايز توصله  هتعمل ده من الفرونت اند علشان توصل للباك اند


---

---
---
# Volumes
- لو الكونتينر  الى انته عامله وقع كده البيانات المهمه الى فيه هتطير فعلشان كده لازم تاخد البيانات المهمه تحطها فى فولدر وطبعا على حسب كل اداه بتشوف ايه المسار المهم فى الكونتينر الى انته عامله وبتبدا تخزن الداتا الى فى المسار ده 

فيه كذا نوع من الـ volumes  اول نوع هوا
- 1- الـ volume mount الى هوا انته بتعمل volume جوه الـ docker  وبتعمل للفولدر ده mapping على المكان الى جوه الكونتينر الى انته عايز تخزن فيه الداتا 
- 2- 

- بيكون فيه فولدر بيكريته دوكر فى المسار الاتى اسمه volumes
```bash
root@MY-Home:/var/lib/docker# ls
buildkit    engine-id  network  rootfs    swarm  volumes
containers  image      plugins  runtimes  tmp

```



---
- لو انته عايز تكريت volume هتعمل الاتى 
```bash
docker volume create myvolume
```
![[Pasted image 20260902184354.png]]


```bash
root@MY-Home:/var/lib/docker/volumes# ls
backingFsBlockDev  metadata.db  myvolume
```
- ده اسم الـ volume الى اتكريت اسمه myvolume اما الملفين التانين دول ميتا داتا 

```bash
root@MY-Home:/var/lib/docker/volumes/myvolume# ls
_data
```

- هنا بيتخزن الداتا بتاعتك الى هستتخدمها 

- بعد كده لما تيجى تكريت contianer ممكن انك تقوله فين مكان الـ volume

```bash
root@MY-Home:~# docker container run -it -v myvolume:/app/code python bash
root@af1b4f2690b2:/# ls
app  boot  etc   lib    media  opt   root  sbin  sys  usr
bin  dev   home  lib64  mnt    proc  run   srv   tmp  var
```
- هنا الامر ده هيعمل container بس هنا عملت -v وبعدها اسم الـ volume الى انته عايز تخزن فيه الدتا وبعدها نقطتين وبعدها المسار الى هيتكريت فى الماشين الى اول لما تعمل فيه ملفات فى الكونتينر هتروح على المكان الى فى الـ volume علشان اول لما تمسح الماشين تظل الداتا موجوده

- بعدها ممكن تدخل على المكان او المسار الى انته كرييته فى الكونتينر 

```bash
root@MY-Home:~# cd /var/lib/docker/volumes/myvolume/_data/
root@MY-Home:/var/lib/docker/volumes/myvolume/_data# echo "say my name" >> file.txt
root@MY-Home:/var/lib/docker/volumes/myvolume/_data# ls
file.txt
root@MY-Home:/var/lib/docker/volumes/myvolume/_data# cat file.txt 
say my name


```

- هنا انا هنا دخلت على الـ volume الى انا كرييته وبعدها وعملت ملف لو انا دخلت على الـ container علشان اشوف الملف ده هلاقيه موجود فى المسار الى اتكريت جديد الى هوا ده /app/code

```bash
root@af1b4f2690b2:/# cd /app/code
root@af1b4f2690b2:/app/code# ls
file.txt
```
- كده اى ملف هيتحط فى المسار بتاع /app/code  هيظهر علطول ويتخزن فى الـ volume 

-  فى حاله انى مسحت الـ container ده  فكده الداتا اتمسحت بس موجوده عندى على الـ volume كده بسهوله اقدر ارجعها كما يلى 

```bash
root@MY-Home:~# docker container run -it -v myvolume:/app/code python bash
```
- كده الداتا رجعت 

---
- علشان تشوف الـ volumes الى عندك هتعمل الاتى 

```bash
mostafa@MY-Home:~$ docker volume ls
DRIVER    VOLUME NAME
local     myvolume
```

 - لو عملت inspect هتلاقى الاتى 
![[Pasted image 20260921184722.png]]
- هنا بيقولك ان الـ type بتاعى هوا الـ volume  واسمه هوا depi  

---
---
- فى حاله ان السرفيس دوكر كلها اتمسحت وكمان اتمسح معاها كمان الـ volume
كده انته ممكن تعمل فولدر على جهاز الهوست ويكون بره خالص الـ docker علشان لو دوكر كله اتمسح

- الاول عملت فولدر للمكان الى هخزن فيه ومسيته depi وبعدها عملت كونتينر 
```bash
mostafa@MY-Home:~/Documents/docker/depi$ docker run --name nginxlocal
 -d -v /home/mostafa/Documents/docker/depi:/usr/share/nginx/html nginx
9fab5f678030a551fa92294a99bb6f5a0e1ee4bcd6f901b97b0c3a93b12bef70
```

- جبت المسار الكامل بتاع الفولدر بتاعى والمسار بتاع الحاجه الى المفروض اعملها mapping
![[Pasted image 20260921192526.png]]

```bash
mostafa@MY-Home:~/Documents/docker/depi$ docker exec -it 9fab5f678030a551fa92294a99bb6f5a0e1ee4bcd6f901b97b0c3a93b12bef70 bash
```
- بعد كده هتدخل على الكونتينر بالشكل ده 

---
```bash
root@9fab5f678030:/# curl localhost
<html>
<head><title>403 Forbidden</title></head>
<body>
<center><h1>403 Forbidden</h1></center>
<hr><center>nginx/1.31.4</center>
</body>
</html>
```
- بس هنا لما عملت هنا كده ادانى forbidden لان مفيش حاجه يقراها 
- السبب ان الفولدر الى بيحصل فيه mount الى هوا على جهاز الـ host كان فاضى فاول لما بيكون فاضى بيفضى هوا لوحده بشكل تلقائى المكان الى انته مشاور عليه فى الـ mapping الى هوا ده /usr/share/nginx/html 
- لكن بخلاف كده لو انته عملت ملف فى المسار ده /usr/share/nginx/html  هيظهر عندك فى الـ mount الى مساره ده /home/mostafa/Documents/docker/depi والعكس صحيح

---
---
 تالت طريقه هى انك ممكن تعمل الداتا دى تتخزن على الكلاود


---
---


```bash
root@9fab5f678030:/usr/share/nginx/html# cat /etc/nginx/conf.d/default.conf 
server {
    listen       80;
    listen  [::]:80;
    server_name  localhost;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }

    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }

}

```
- ده برضه من المسارات المهمه فى nginx  الى هوا /etc/nginx/conf.d/default.conf  
- فانته ممكن تعمل الاتى لو انته عايز تعمل mapping لاكثر من حاجه كما يلى 
```bash
docker run --name nginxlocal
 -d -v /home/mostafa/Documents/docker/depi:/usr/share/nginx/html -v ~/conf:/etc/nginx/conf.d/   nginx
```

- هنا بيعمل كونتينر بس بيربط فولدرين بدل فولدر واحد 

---

# How i can make my own image


- انا مثلا شغال على كونتينر الكونتينر ده عايز اعمل منه image بعد لما عدلت عليه هتعمل الاتى 
```bash
mostafa@MY-Home:~/Documents/docker/depi$ docker commit nginxlocal 
sha256:7e6fd24f23e890fd0e3fda638a51f083f7c69fd030587d506bf8130bea6600e8
```
- هنا بعد commit بتحط اسم الـ container الى عايز تعمله image او بتحط الهاش بتاعه 
```bash
mostafa@MY-Home:~/Documents/docker/depi$ docker image tag sha256:7e6fd24f23e890fd0e3fda638a51f083f7c69fd030587d506bf8130bea6600e8  whoami894/nginxmine:v1
```
- بعد كده هنا هتكتب docker image tag وبعدها الهاش الى طلع فى الامر الى فات هتحطه لان ده الـ image الى انته عايز تعملها وبعد كده هتحط اسم الاكونت بتاعك على docker hub وبعدها اسم الـ repo وبعدها رقم الـ version الى انته هتحطها على docker hub

- بس الصح انى المفروض كلمه sha256 كما يلى 

```bash
mostafa@MY-Home:~/Documents/docker/depi$ docker image tag 7e6fd24f23e890fd0e3fda638a51f083f7c69fd030587d506bf8130bea6600e8  whoami894/nginxmine:v1
```

---
---

- ممكن انك تعمل الـ commit والتاج فى نفس الوقت كما يلى 
```bash
mostafa@MY-Home:~/Documents/docker/depi$ docker commit nginxlocal whoami894/nginxmine:v1

```
- بتحط عادى دوكر commit وبعدها بتحط اسم الكونتينر او الهاش بتاعه وبعدها بتحط التاج الى انته عايزه كما يلى whoami894/nginxmine:v1 



---
---





- بعد كده بتعمل الاتى علشان ترفعها على docker.hub

```bash
mostafa@MY-Home:~/Documents/docker/depi$ docker push whoami894/nginxmine:v2
The push refers to repository [docker.io/whoami894/nginxmine]
657dd7fba849: Mounted from library/nginx 
6310eb16bf42: Mounted from library/nginx 
30576ad53d33: Mounted from library/nginx 
b8f66660faa6: Mounted from library/nginx 
c90544874aaf: Mounted from library/nginx 
8f655e1bd5c1: Mounted from library/nginx 
0a35a4e59186: Mounted from library/nginx 
914e036847c5: Pushed 
v2: digest: sha256:7e6fd24f23e890fd0e3fda638a51f083f7c69fd030587d506bf8130bea6600e8 size: 2037
```
- هنا بتعمل docker push وبتحط التاجه الى انته عايز ترفعها على docker ولكن لو انته مش عامل للـ image دى ريبو هيتعمل بشكل تلقائى اول لما تعمل push


![[Pasted image 20260922132855.png]]
---

# Docker File


- هنا بدل ما انته كل شويه تدخل تعمل حجات فى دوكر ممكن تقول لدوكر هوا يعمل ايه لوحده 
- بيكون text file عادى خالص بيكون فيه  instructions مترتبه تقوله فيه يعمل ايه علشان يعملك مثلا image معينه من غير ما تحتاج تعمل container او تعمل downlaod لـ image او  تعمل ابديت او اى حاجه تانيه
```dockerfile
FROM ubuntu
RUN sleep 50
```
- هنا from معناها من الـ image الى اسمها ابونتو هتعمل منها كونتينر وبعدها 
- هنا فى run اثناء عمليه الـ build بتاع الـ dockerfile هتعمل sleep لمدخ خمسين ثانيه ويعدها تكمل الـ build

---
---
```bash
mostafa@MY-Home:~/Documents/docker$ docker build -t sleep .
[+] Building 78.2s (7/7) FINISHED  docker:default
 => [internal] load build definition from d  0.1s
 => => transferring dockerfile: 62B          0.0s
 => [internal] load metadata for docker.io/  3.2s
 => [auth] library/ubuntu:pull token for re  0.0s
 => [internal] load .dockerignore            0.0s
 => => transferring context: 2B              0.0s
 => [1/2] FROM docker.io/library/ubuntu:la  21.3s
 => => resolve docker.io/library/ubuntu:lat  0.1s
 => => sha256:d9b9856437537fc06 391B / 391B  0.3s
 => => sha256:09923199ca 41.57MB / 41.57MB  11.8s
 => => extracting sha256:09923199ca0ebd3ad9  9.1s
 => => extracting sha256:d9b9856437537fc061  0.1s
 => [2/2] RUN sleep 50                      51.9s
 => exporting to image                       1.0s
 => => exporting layers                      0.5s
 => => exporting manifest sha256:81f1a2e288  0.1s
 => => exporting config sha256:d006e4396b64  0.0s
 => => exporting attestation manifest sha25  0.1s
 => => exporting manifest list sha256:71041  0.1s
 => => naming to docker.io/library/sleep:la  0.0s
 => => unpacking to docker.io/library/sleep  0.1s
mostafa@MY-Home:~/Documents/docker$ 
```
- علشان تحول الـ Dockerfile لـ image تقدر تستخدمها عملت الامر الى فوق ده 
- docker build -t 
- هنا -t علشان تحط اسم للـ image دى وسميتها sleep وبعدها هنا النقطه الى فى الاخر دى معنها انك بتقوله ان docker file موجود فى المكان الى انا واقف فيه 
- بس المشكله هنا ان sleep 50 هتحصل فى الـ run time بتاع الـ build بتاع الـ image مش فى الـ container

```bash
mostafa@MY-Home:~/Documents/docker$ docker image ls
                              i Info →   U  In Use
IMAGE                    ID             DISK USAGE
amazonlinux:latest       6a048161f8ac        463MB
amazonserverlocal:latest
                         7f9420ca2c66        458MB
ansible-node:latest      ad728f531efc        422MB
nginx:latest             b34848eff6db        241MB
python:latest            4fad23465a06       1.63GB
sleep:latest             7104170cb9d9        157MB
whoami894/flask:v1.11    98649b8c7e1f       1.64GB
whoami894/nginxmine:v2   7e6fd24f23e8        239MB
whoami894/web_flaskpy:v1
                         aa5bd651e0a5       1.74GB
mostafa@MY-Home:~/Documents/docker$ 
```
- هنا ظهرت دلوقتى الـ image الجديده دلوقتى ممكن تعمل منها كونتينر عادى 

---
---
```dockerfile
WORKDIR /usr/src/app
```
- هنا work dir بيعمل فولدر وبيخليك تدخل فيه 

---
---
```dockerfile
EXPOSE 3000
```
- ده بيكون عباره عن سطر انته كاتبه ملهوش اى تاثير بس بيعرفك لو انته  مثلا عايز تعرف نفسك انك هتفتح الابليكشن من على بورت 3000 بس لو انته عامل فى اعدادت الابليكششن انه يشتغل على بورت 5000 وكاتب فى الـ dockerfile expose 3000 هيشتغل برضه على 5000 لان الـ expose مجرد بس سطر بتقراه مش بيعمل حاجه 

---
---

- اما لو انته عايز امر sleep يظهر وقت تشغيل الكونتينر هتعمل الاتى 

```dockerfile
FROM ubuntu
CMD ["sleep" , "50"]

```


- هنا الـ cmd مش بيتشغل وقت الـ build هوا بيخزن الامر علشان يشغله اول لما تيجى تعمل docker run
```bash
mostafa@MY-Home:~/Documents/docker$ docker build -t sleep2 .
[+] Building 1.6s (6/6) FINISHED   docker:default
 => [internal] load build definition from d  0.0s
 => => transferring dockerfile: 70B          0.0s
 => [internal] load metadata for docker.io/  1.3s
 => [auth] library/ubuntu:pull token for re  0.0s
 => [internal] load .dockerignore            0.0s
 => => transferring context: 2B              0.0s
 => CACHED [1/1] FROM docker.io/library/ubu  0.0s
 => => resolve docker.io/library/ubuntu:lat  0.0s
 => exporting to image                       0.1s
 => => exporting layers                      0.0s
 => => exporting manifest sha256:6da8eb4a17  0.0s
 => => exporting config sha256:c0f881c337df  0.0s
 => => exporting attestation manifest sha25  0.0s
 => => exporting manifest list sha256:29690  0.0s
 => => naming to docker.io/library/sleep2:l  0.0s
 => => unpacking to docker.io/library/sleep  0.0s
mostafa@MY-Home:~/Documents/docker$ 
```
- حتى هنا هوا مقراش الـ cmd لانه مش هيعمل run هنا 
---
---
```dockerfile
FROM ubuntu
COPY ./script.sh ./script.sh
CMD ["./script.sh"]
```
- هنا copy انه بياخد كوبى من جهاز الهوست ويحطه فى المكان الى واقف فيه فى الكونتينر وبعدها اول لما تفتح الكونتينر هتشغل الاسكربت ده 
- بس لما عملته build وجيت اعمله رن عمل كده 
```bash
mostafa@MY-Home:~/Documents/docker$ docker run -it imagescript:latest
docker: Error response from daemon: failed to create task for container: failed to create shim task: OCI runtime create failed: runc create failed: unable to start container process: error during container init: exec: "./script.sh": permission denied

Run 'docker run --help' for more information
```
بسبب ان الاسكربت المفروض تديله permission صح
انته المفروض هتغير الـ permission فى ملف الـ docker file كما يلى 

```dockerfile
FROM ubuntu
COPY ./script.sh ./bash.sh
RUN   chmod 700 bash.sh
CMD ["./bash.sh"]
```
- طبعا استخدمنا هنا run علشان تغير الـ permission
```bash
mostafa@MY-Home:~/Documents/docker$ docker build -t imagescript2 .
[+] Building 6.0s (9/9) FINISHED   docker:default
 => [internal] load build definition from d  0.0s
 => => transferring dockerfile: 119B         0.0s
 => [internal] load metadata for docker.io/  1.7s
 => [auth] library/ubuntu:pull token for re  0.0s
 => [internal] load .dockerignore            0.0s
 => => transferring context: 2B              0.0s
 => [internal] load build context            0.0s
 => => transferring context: 30B             0.0s
 => CACHED [1/3] FROM docker.io/library/ubu  0.2s
 => => resolve docker.io/library/ubuntu:lat  0.2s
 => [2/3] COPY ./script.sh ./bash.sh         0.1s
 => [3/3] RUN   chmod 700 bash.sh            2.4s
 => exporting to image                       1.0s
 => => exporting layers                      0.5s
 => => exporting manifest sha256:0a4fff70f5  0.1s
 => => exporting config sha256:ef9560c4c9d1  0.1s
 => => exporting attestation manifest sha25  0.0s
 => => exporting manifest list sha256:a5427  0.0s
 => => naming to docker.io/library/imagescr  0.0s
 => => unpacking to docker.io/library/image  0.1s
mostafa@MY-Home:~/Documents/docker$ 
```
- هنا غيرت الـ permission 
```bash
 => CACHED [1/3] FROM docker.io/library/ubu  0.2s
```
- اول لما تلاقى دى معناها انه عملها قبل كده يعنى مش هتاخد وقت معاه 

---
---

```bash
mostafa@MY-Home:~/Documents/docker$ docker run -it imagescript2
my name is mostafa
```
- هنا اول لما عملت الكونتينر شغل الاسكربت ووقف 
---
---

```dockerfile
FROM ubuntu
COPY ./script.sh ./bash.sh
RUN   chmod 700 bash.sh
#CMD ["./bash.sh"]
ENTRYPOINT  ["./bash.sh"]

```
- خلى بالك ان الـ entrypoing هى زيها زى الـ cmd   يعنى لو عملت build وشغلت الـ image هيشغل معاك الاسكربت عادى


---
---
```dockerfile
CMD ["bash","bash.sh"]
```
- دى برضه لو عايز تعمل run للملف ده 
---
---
```dockerfile
FROM ubuntu
COPY ./script.sh ./bash.sh
COPY ./override.sh ./override2.sh
RUN   chmod 700 bash.sh
RUN   chmod 700 override2.sh
CMD [ "bash","bash.sh"]
#ENTRYPOINT  ["./bash.sh"]

```
- هنا انا عملت كوبى لملفين والمفروض لو عملته build وشغلته المفروض bash.sh هوا الى هيشتغل بس علشان ده cmd ممكن تعمل override عادى وتستخدم الملف التانى الى انته حطيته جوه وتشغله كما يلى 
```bash
mostafa@MY-Home:~/Documents/docker$ docker run script bash ./override2.sh
override
done
```
- هنا انا قولتله يشغل الى بقوله عليه ده وميشغلش الى جوه 

---
---
اما بالنسبه للـ entry point 


```dockerfile
FROM ubuntu
COPY ./script.sh ./bash.sh
COPY ./override.sh ./override2.sh
RUN   chmod 700 bash.sh
RUN   chmod 700 override2.sh
ENTRYPOINT  [ "bash","bash.sh"]

```


```bash
mostafa@MY-Home:~/Documents/docker$ docker run script bash ./override2.sh
hello my name is mostafa
```
- هنا علشان ده entry point كانه مشفش الملف الى انته حطيهوله

----
---
---
# how to create a Dockerfile for specific  application

انته مثلا عايز تعمل سرفر node.js فالمفروض هتعمل node js وبعد تحمل npm وبعدها  بس انته مثلا ممكن متكنش عارف الخطوات بالظبط ممكن بقى تبحث على جوجل وتقوله ازاى اعمل ملف دوكر لـ node js  كما يلى 

![[Pasted image 20260922161334.png]]
هيظهرلك مثلا دول هتدخل على واحد فيهم وتشوف هل انته عايز تزود حاجه ولا ده كفايه 
![[Pasted image 20260922161407.png]]
- ده مثلا واحد هتجيبه منه وتنزد عليه او تعدل عليه 
```dockerfile
FROM node: 18-alpine

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install
# If you are building your code for production
# RUN npm ci --omit=dev

COPY . .

EXPOSE 3000
CMD [ "node", "server.js" ]
```

# Enhance Dockerfile

- اول حاجه هنا لو انته مثلا جيت تنزل وتسطب المتطلبات بتاعه الـ node js  لو هتنزل اخر نسخه هينزلك نسخه حجمها كبير جدا ممكن يكون بيعدى الـ 1 جيجا اما مثلا لو نزلت node alpine دى حجمها 100 ميجا 
- يبقى اول تعديل ممكن تعمله على الـ Dockerfile هوا انك تشوف حجم الـ image

- عندك ملف اسمه .dockerignor    ده بتحط فيه الحجات الى انته عايز الـ docker file يتجاهلها زى الاتى 
![[Pasted image 20260922163705.png]]
```bash
mostafa@MY-Home:~/Documents/docker$ touch .dockerignore
```

```
Docerfile
node_modules
```
- ده مثلا الى هيكون فى الملف يعنى مثلا مش هينقل ملف الـ dockerfile على الكونتينر  وبرضه node_modules
```dockerfile
FROM node AS build

WORKDIR /app/

COPY package.json ./
RUN npm install


COPY . .
RUN npm run build


FROM nginx
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx" , "-g" ,"deamon off"]
```
- هنا انته فى البدايه هتعمل build من node وبعدها هتعمل فولدر app وتنزل الباكدجات وتعمل  copy وبعد لما تخلص ده كله RUN npm run build دى معناها انه هيعملك build من الاوامر الى فاتت دى وهيجبلك الصوره بتاعته هتكون عباره عن html وبعد ما يخلص دول 
- هيبدا انه من الـ image بتاعه nginx ويهمل كوبى من /app/dist ده المكان الى هيكون فيه الـ build بتاع الـ image الاولى الى هتكون عباره عن html وهيحطها فى فولدر الـ html بتاعه الـ nginx واول لما تفتحه هتلاقيه ملف html


- يعنى بمعنى اصح هوا هيعمل الـ build ويبعته للـ nginx والشغل بتاع الـ build هيبدا من عند الـ nginx


# Image Registry

- ممكن تخزنها على docker hub
![[Pasted image 20260914194643.png]]
اول لما بتدخل على الصفحه بتاعتك على الموقع ده 

- الاول هتعمل ريبو يعنى اختار create repo
![[Pasted image 20260914195041.png]]
اخترت ليه اسم وبعدها خليته بابليك 
![[Pasted image 20260914195111.png]]
كده ده شكل الريبو دلوقتى عايز تضيف الـ image دى هتعمل الاتى 

![[Pasted image 20260914195157.png]]
هنا على الموقع كاتبلك لو انته عايز تحط الـ image دى على البروفايل بتاعك هتعمل الامر ده فى الترمينال 

```bash
mostafa@MY-Home:~/Documents$ docker login

USING WEB-BASED LOGIN

i Info → To sign in with credentials on the command line, use 'docker login -u <username>'
         

Your one-time device confirmation code is: GTGS-KLMP
Press ENTER to open your browser or submit your device code here: https://login.docker.com/activate

Waiting for authentication in the browser…


WARNING! Your credentials are stored unencrypted in '/home/mostafa/.docker/config.json'.
Configure a credential helper to remove this warning. See
https://docs.docker.com/go/credential-store/

Login Succeeded
```
- الاول بتعمل لوجين وبيحولك على الويب وبعدها تسجل دخول وبعدها بتعمل الامر بالشكل ده 

```bash
mostafa@MY-Home:~/Documents$ docker push whoami894/web_flaskpy:v1
The push refers to repository [docker.io/whoami894/web_flaskpy]
ec935196e6a0: Mounted from library/python 
68b64c51cda3: Mounted from library/python 
1da3cb2f93f2: Mounted from library/python 
d74736caedd4: Mounted from library/python 
600962de363f: Mounted from library/python 
9c3f3ed944a8: Mounted from library/python 
b00bcb890d90: Mounted from library/python 
692549fa0eb8: Pushed 
v1: digest: sha256:aa5bd651e0a5768975b0710bf45aa47bd15b1d410fd4a26ef542d764e4403703 size: 2060
```
- كده نزل على دوكر هوب كما يلى 
![[Pasted image 20260914200642.png]]

![[Pasted image 20260914200754.png]]
 كده اتغيرت بقت بالشكل ده 
![[Pasted image 20260914200900.png]]
ده شكل الريبو من بره 

![[Pasted image 20260914200929.png]]
بعد كده لما تدخل على التاج ده هتلاقى الاتى 

![[Pasted image 20260914200958.png]]

![[Pasted image 20260914201007.png]]

- لو انته عملت تحديث على الـ image دى وجيت ترفعها 
- لو انته عايز تعمل الـ latest هتعمل الاتى 

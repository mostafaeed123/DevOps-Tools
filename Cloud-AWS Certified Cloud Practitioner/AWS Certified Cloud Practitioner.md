

# Intro

- بدل ما تعمل داتا سنتر هتستخدم aws علشان انك  هوا هيديك كل الريسورسز الى انته عايزها وانته اعمل الى انته عايزه فيه كذا نوع 

---
---
- الى بالاصفر ده مش انته الى بتتكحم فيه اما الازرق انته الى بتتحكم فيه 
![[Pasted image 20261004193249.png]]

- اول حاجه هى الـ IaaS 


----
---
- تانى حاجه الـ PaaS هوا بيديك السرفرات والـ virtualization والـ storage انته بس بتنزل الابليكيشن بتاعك الى انته عايزه وتتعامل معاه 

----
- الـ SaaS ده بيديك كل حاجه وانته بتستخدم الخدمه دى انته بس بتستخدمها  زى مثلا teams

---
- بناء على الـ configuration هتعرف هل دى paas ولا saas ولا iaas

---
---

## AWS Global Infrastructure

### AWS Regions
- الـ AWS Regions بتكون مدينه وبتكون مجموعه مثلا من 3 الى 6 Availability Zones  (AZ)  وبتكون فيها كذا Data Centers  يعنى مثلا جيت فى شبرا عملت تجميعه من الـ AZ وبيكون فيها كذا داتا سنتر 
-  لو فيه 3 AZ   جوه القاهره دى بتبقى اسمها Region

![[Pasted image 20261004194808.png]]
اكتب كده علشان يجبلك الـ regions الى موجوده 

![[Pasted image 20261004194849.png]]

![[Pasted image 20261004194929.png]]
- هنا فيه region واحده بس  مثلا يعنى 

---
![[Pasted image 20261004195115.png]]

- هنا فيه edge location 23 واحده فى اسيا 

---
---
- لو فيه سرفر فى المانيا وفيه ناس من مصر عايزين يدخلوا الموقع ده  فهنا بيجى دور الـ edge location  انه بيسهلك انك تدخل على الموقع 


---
- الـ AZ بتكون من 3-6 AZ فى نفس الـ region

----
# start


![[Pasted image 20261004195821.png]]
اول لما تدخل هتبحث عن دى وتدخل على IAM 

![[Pasted image 20261004195851.png]]
هيديك اليوزر الى انته عملتها 

----
![[Pasted image 20261005145502.png]]
- هنا لو لقيت ان مفيش users انته عملتها خالص هتظهر بالشكل ده 


----
# how to  Create user ? 
- الاول هتكون واقف هنا 
![[Pasted image 20261005145739.png]]
- هنا هتضغط على create user   
![[Pasted image 20261005145827.png]]

- هنا بتختار اسم  الـ user
![[Pasted image 20261005150100.png]]
- هنا انته بتختار دى لو انته عايز اليوزر انه يقدر يتصل بالـ aws من خلال الـ console 

- لو دخلت على اليوزر هتلاقى الاتى 
![[Pasted image 20261004200109.png]]
- لو انته عايز تضيفيه لجروب والجروب ده فيه الصلاحيات الى انته محددها للجروب ممكن تضيفه فى الجروب ده علطول الى هوا add user group 
---

![[Pasted image 20261004200218.png]]
- اما لو انته عايز انك تحدد الـ permission براحتك  لليوزر هتختار attach policies directly 
---

-   لو انته عايزه ياخد permission على ec2 هتبحث عنها فى الـ permission وهيدخل عليها  وتختارها علشان ياخد الـ permission 
![[Pasted image 20261005152048.png]]

![[Pasted image 20261005152136.png]]
- هنا هتختارها وتعمل next 
![[Pasted image 20261005152335.png]]
- هنا برضه ضيفت الـ administrator access  

![[Pasted image 20261005152504.png]]
- برضه ضيفت دى لليوزر الى هستخدمه 
- ديما متخدلش aws من خلال الـ root لانك ممكن تسمح الحساب كله انما لو انته عامل يوزر زى ده كده ممكن تعمل اى حاجه عادى بس متقدرش تمسح الاكاونت 
![[Pasted image 20261005153903.png]]

- لو ضغطت على علامه الـزائد دى هيظهرلك الكلام الى موجود فى الـ permission ده كما يلى 
![[Pasted image 20261005153954.png]]
---


---
---

![[Pasted image 20261005152624.png]]
- دول التلاته الى انا اخترتهم 
![[Pasted image 20261005152647.png]]
بعد كده create user علشان تعمله 
![[Pasted image 20261005152748.png]]
- كده اليوزر اتعمل هنا اهوا 

---

---
![[Pasted image 20261005153133.png]]
- لو انته وانته بتعمل يوزر واخترت provide user access  علشان تسجل دخول من الـ console وتحط الباسورد بتاعك

---
---
![[Pasted image 20261005155026.png]]
- هنا لما انا سجلت من خلال الـ mostafa1 

---
![[Pasted image 20261005155235.png]]
- هنا انته داخل من خلال الاكاونت ده 
---
---
- لو فيه كذا يوزر عايزهم ياخدوا نفس الـ permission ممكن تعمل جروب وتحط فيه الـ permission الى انته عايزه وتحط اليوزرز الى انته عايزهم فيه

---
---
# How to create group

![[Pasted image 20261005160350.png]]
- هنا هتعمل يوزر جديد
![[Pasted image 20261005160429.png]]
- هنا اسم الجروب وهنا بتختار الـ users الى انته عايز تضيفهم فى الجروب 
![[Pasted image 20261005160518.png]]
- هنا هتختار الـ permission الى انته عايزها  للجروب 
![[Pasted image 20261005160611.png]]

---
![[Pasted image 20261005160629.png]]

- كده الجروب اتعمل 
![[Pasted image 20261005160700.png]]
- كده الجروب ودول اليوزر الى موجودين فيه 
---
---

# polices 
- دى بتكون عباره عن list of permission 


![[Pasted image 20261005162059.png]]

- هنا لو انته مثلا عايز الـ cluster يكلم ec2 يبقى لازم نعمله role ودى من ضمن مميزات الـ role
- الـ policy انته بتديه لليوزر والـ role انته بتديه للـ non user 

# multifactor authenticator
![[Pasted image 20261005162524.png]]
- لو دخلت على  يوزر هتلاقى انه هنا مثلا بيقولك ان مفيش multifactor authenticator
- انته ممكن تفعله 
![[Pasted image 20261005162631.png]]

- هنا هتضغط عليه وتقوله انك عايز تعمله  enable
![[Pasted image 20261005162732.png]]
هتختار authenticator app  وبعدها تحمل google authenticator وتعمل سكان للـ qr code وبعدها لما تيجى تسجل دخول هتستخدم الكود ده 


---

- لو انته عايز تلغى الـ multifactor authenticator  هتعمل الاتى 
![[Pasted image 20261005163031.png]]
- هتدخل على الـ user بتاعك 
![[Pasted image 20261005163122.png]]
وبعدها تدخل على الـ security credentials  وهتنزل تحت شويه كما يلى 

![[Pasted image 20261005163205.png]]
![[Pasted image 20261005163222.png]]

اعمله remove كده مبقاش موجود

---
---
# how do you can access aws 

## first one 
- اول واحده من خلال الـ console من على الويب ممكن تعمل access لـ aws 


## second one 
- من خلال الـ CLI بتاع amazon حتمله وده شكله 
![[Pasted image 20261005163710.png]]

----

[Download Amazon CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

![[Pasted image 20261005164547.png]]

![[Pasted image 20261005203615.png]]

- هتروح على الاكاونت بتاعك وتدخل على iam user
![[Pasted image 20261005164903.png]]
 
 - او ممكن تنزل لتحت شويه كما يلى 
![[Pasted image 20261005165447.png]]
- هتدخل على الـsecutity credential وتزل لتحت شويه
![[Pasted image 20261005165521.png]]

 هنا تقدر تعمل الـ access key 
![[Pasted image 20261005165320.png]]
- هيظهرلك الصفحه دى 
![[Pasted image 20261005165634.png]]
- انا هنا عايز اتعامل مع الـ command line هتختار اول واحده 
![[Pasted image 20261005165717.png]]
- هنا بتعمل next 
![[Pasted image 20261005165807.png]]
- بتعمل هنا description  وبعدها بتعمل create وبتظهر الصفحه الى جايه دى 
![[Pasted image 20261005165918.png]]

لازم تقوله انا عايز احمل الملف ده  علشان اول لما تحمله مش ختعرف تبص عليه تانى 
وبعدها قولهdone 
![[Pasted image 20261005175500.png]]
بيظهر بالشكل ده لما تفتحه  اضغط على ok هتلقى الصفحه زى كده 
![[Pasted image 20261005175640.png]]


![[Pasted image 20261005175739.png]]
- هنا انته كتبت دول وكده انته سجلت 
```powershell
PS C:\Users\batman> ls C:\Users\batman\.aws\


    Directory: C:\Users\batman\.aws


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----         10/5/2026   5:57 PM             11 config
-a----         10/5/2026   5:57 PM            119 credentials
```

![[Pasted image 20261005203146.png]]


- الاوامر مش لازم تحفظها ممكن تكتب  على جوجل مثلا الاتى 
![[Pasted image 20261005180416.png]]

![[Pasted image 20261005180433.png]]


![[Pasted image 20261005203205.png]]


- جابلك اليوزرز الى عندك 
```powershell
PS C:\Users\batman> aws ec2 help

ec2
^^^


Description
***********

This is the *Amazon EC2 API Reference* . It provides descriptions, API
request parameters, and the XML response for each of the Amazon EC2
Query API actions. Note that the Amazon EC2 API includes actions for
Amazon EC2 plus additional services, such as Amazon EBS and Amazon
VPC.

   **Learn more**

* To learn about using the Query API, see Using the API for Amazon EC2
  .

* To learn about the permissions required to call an Amazon EC2 API
  action, see Actions, resources, and condition keys for Amazon EC2 .

* To get the list of API actions by service and resource, see Actions
  by service .

* To get the alphabetical list of API actions, see .

* To get descriptions of the API error codes, see Error codes for the
  Amazon EC2 API .

Alternatively, use one of the following methods to access the Amazon
EC2 API, instead of using the Query API directly:

* Amazon Web Services CLI Command Reference - ec2 commands
```
- هنا لو انته عايز تعرف معلومات عن حاجه معينه بتبحث ai او جوجل 

## How to create user in CLI

- مثلا لو انته عايز تعمل user
الاول هتبحث google or ai علشان مش لازم تحفظ الامر الى جاى ده رد claude


To create an IAM user with the AWS CLI:

**1. Create the user**

powershell


![[Pasted image 20261005203222.png]]



**2. Give the user permissions** (a new user has none by default)

Attach a managed policy, for example read-only EC2:

PowerShell

```powershell
aws iam attach-user-policy --user-name myuser --policy-arn arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess
```

Or full admin (use carefully):

PowerShell

```powershell
aws iam attach-user-policy --user-name myuser --policy-arn arn:aws:iam::aws:policy/AdministratorAccess
```

**3. Choose how the user will sign in**

For the **CLI/API** (access keys):

PowerShell
![[Pasted image 20261005203237.png]]


This prints the `AccessKeyId` and `SecretAccessKey`. The secret is shown only once, so save it somewhere safe and don't share it in screenshots or chats.

For the **web console** (password):

powershell

![[Pasted image 20261005203247.png]]


**4. Verify**

powershell

```powershell
aws iam list-users
aws iam list-attached-user-policies --user-name myuser
```

**Optional: put the user in a group** (easier to manage permissions for many users):

powershell

```powershell
aws iam create-group --group-name developers
aws iam attach-group-policy --group-name developers --policy-arn arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess
aws iam add-user-to-group --user-name myuser --group-name developers
```

**Notes:**

- Your current CLI user needs IAM permissions (like `IAMFullAccess` or `AdministratorAccess`) to run these commands; otherwise you'll get `AccessDenied`.
- IAM is global, so you don't need `--region`.
- Follow least privilege: give only the permissions the user actually needs.

![[Pasted image 20261005181854.png]]
- كده اليوزر اتعمل بشكل صحيح

---
---
- لو انته عايز تلغى تفعيل الـ access key هتعمل الاتى
![[Pasted image 20261005182054.png]]

![[Pasted image 20261005182120.png]]
- هنا ممكن تلغى التفعيل عادى 

---
---

## Third one 
- ممكن تستخدم الـ SDK يعنى تستخدم terraform 

---
# Cloud trail


![[Pasted image 20261005183035.png]]

![[Pasted image 20261005183327.png]]

![[Pasted image 20261005183407.png]]


- هنا بيقولك كل يوزر عمل ايه 
![[Pasted image 20261005183501.png]]
- هنا اليوزر ده الى اسمه mostafa1  عمل login from console 
![[Pasted image 20261005183714.png]]
- هنا لو دخلت هنا هيديك ملف json
![[Pasted image 20261005183907.png]]
- هنا مثلا جابلك الـ ip بتاع الى عمل كده وبعدها بيقولك انه بيعملها من المتصفح 

- لكن لو لقيت CLI  كده فى الـ user agent كده يبقى هوا معمول فى الـ CLI

---
---
- هنا الحاجه الى عملها دى  عملها فى الـ IAM
![[Pasted image 20261005184912.png]]

- والـ cloud trail بيعرفك مين الى عمل ايه ومين الى معملش علشان لو حصل مشكله 
![[Pasted image 20261005185156.png]]
- هنا ممكن تفلتر التاريخ

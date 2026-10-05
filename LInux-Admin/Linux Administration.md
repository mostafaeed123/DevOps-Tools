

# # basic commands


> [!note] ملاحظة مهمة السيرفرات في الغالب **لا تحتوي على GUI** — فستجد Terminal فقط.

### عرض التاريخ والوقت

```bash
date
```

---

## 👥 أنواع المستخدمين

### 1. Root User 

- **User ID = 0** دايماً
- يملك **كل الصلاحيات** بدون استثناء
- يقدر يمسح الـ Filesystem كامل، يفورمات الديسك، أي حاجة
- خطير جداً إذا اُستُخدم بشكل خاطئ

### 2. Normal User 

- **User ID = 1000 أو أكبر**
- صلاحياته محدودة بملفاته الشخصية فقط
- مش من حقه يعمل أي تعديلات على السيستم

> [!tip] تشبيه السيستم زي **الأحوال المدنية** — كل مستخدم له رقم ID فريد، زي رقم البطاقة.

---

##  Switch User — تبديل المستخدم

### الأمر

```bash
su USERNAME     # Switch to specific user
su              # Switch to root (بدون اسم)
su - USERNAME   # Switch with environment
```

### أمثلة

```bash
su mostafa      # التحويل لمستخدم مصطفى
su              # التحويل لـ root
exit            # الرجوع للمستخدم السابق
```

### معرفة User ID الحالي

```bash
id
# output: uid=0(root) gid=0(root) ...
# أو: uid=1000(mostafa) gid=1000(mostafa) ...
```

### معرفة User ID مستخدم معين

```bash
id mostafa
# output: uid=1000(mostafa) ...
```

---

##  قواعد الباسورد عند Switch User

| من          | إلى             | باسورد مطلوب؟         |
| ----------- | --------------- | --------------------- |
| Root        | أي يوزر         | ❌ لا                  |
| Normal User | Root            | ✅ باسورد الـ Root     |
| Normal User | Normal User آخر | ✅ باسورد اليوزر الهدف |

> [!warning] مهم لو صلاحياتك **أعلى** وعايز تنزل → مش هيسألك لو صلاحياتك **أقل** وعايز ترتفع → هيسألك على باسورد

---



# # Understanding_FHS

##  أنواع الـ File Systems

### Windows vs Linux

||Windows|Linux|

|**القديم**|FAT16, FAT32|EXT2|
|**الحديث**|NTFS|EXT3, EXT4|
|**المتقدم**|—|ZFS|

> [!note] القاعدة كل إصدار أحدث = حجم أكبر، سرعة أحسن، أمان أعلى. المعيار الحالي في Linux هو **EXT4**.

**مقارنة EXT:**

-  هنا **EXT3** → يدعم Disk أكبر من EXT2
- هنا  **EXT4** → يدعم ملفات حتى **16 TB**، وFile System أكبر بكثير

---

## 👥 أنواع المستخدمين (تفصيل)

### ملخص الـ User IDs

| النوع                    | User ID   | وصف                              |
| ------------------------ | --------- | -------------------------------- |
| **Root**                 | `0`       | السوبر يوزر — صلاحيات غير محدودة |
| **System/Service Users** | `1 – 999` | يوزرز للـ Services فقط (RHEL 7+) |
| **Normal Users**         | `1000+`   | المستخدمين العاديين              |

> [!info] ملاحظة تاريخية في RHEL 6 وما قبله، الـ Service Users كانت من `1 – 499`. في RHEL 7+، اتغيرت لـ `1 – 999` لأن عدد الـ Services زاد.


---

##  System/Service Users 

### المشكلة

لو شغّلت Webserver بصلاحيات **Root** وحصل Attack:

- المهاجم هياخد صلاحيات الـ Root
- **كارثة كاملة** 

### الحل — Dedicated User لكل Service

```
Apache   → يوزر اسمه "apache"   (UID: مثلاً 48)
Postfix  → يوزر اسمه "postfix"  (UID: مثلاً 89)
MySQL    → يوزر اسمه "mysql"    (UID: مثلاً 27)
```

**مميزات الـ Service User:**

- مالوش باسورد (مش ممكن يعمل Login)
- صلاحياته محدودة بملفات الـ Service بتاعته فقط
- لو حصل Attack → المهاجم مش هيقدر يعمل حاجة

> [!tip] تشبيه زي مبنى فيه الدور الخامس → داتا سنتر + مخزن + خزنة. بدل ما تدي كل واحد كارت واحد بيدخل كل حاجة، اعمل كارت منفصل لكل غرفة. لو اتسرق كارت المخزن → المهاجم يدخل المخزن بس، مش الخزنة.

### الـ Package بيعمل الـ User تلقائياً

مش محتاج تعمله يدوياً — لما بتعمل `install` لأي Service، الـ Script بتاعته بتعمل الـ User أوتوماتيك.

---

## 📁 أين تُخزَّن معلومات المستخدمين؟

```bash
/etc/passwd    # كل المستخدمين على النظام
```

---

##  هيكل الـ File System (Inverted Tree)

### المقارنة مع Windows

```
Windows:         Linux:
C:\              /  (slash)
├── Windows      ├── etc
├── Users        ├── home
└── Program      └── usr
    Files
```

كلاهما **Inverted Tree** (شجرة مقلوبة) — الفرق بس في نقطة البداية:

- Windows → `C:\`
- Linux → `/`

> [!note] في Linux، مفيش حاجة اسمها `/` تانية على نفس الجهاز. زي ما مفيش `C:` تانية في Windows على نفس الجهاز.

---

##  شرح كل Directory بالتفصيل

### `/` — Root Filesystem

- **نقطة وهمية** — مش موجودة فعلياً على الـ Disk
- بتمثل بداية الـ File System
- كل اللي تحتها بيتخزن على الـ Partition الأساسي
- تعادل `C:\` في Windows

---

### `/home` — Home Directories

```
/home/
├── ahmed/     → ملفات أحمد فقط
├── ali/       → ملفات علي فقط
└── mostafa/   → ملفات مصطفى فقط
```

- لكل يوزر عادي فولدر باسمه
- اليوزر يتعامل فقط مع فولدره الخاص
- تعادل `C:\Users\` في Windows

---

### `/root` — Home Directory لـ Root User

- منفصل عن `/home` (مش جوّاه!)
- بيُعزَل الـ Root User لأن ملفاته حساسة جداً
- تعادل `C:\Users\Administrator\` لكن أكثر أماناً

---

### `/etc` — Configuration Files

- **كل ملفات الإعدادات** للنظام والـ Services
- أمثلة:
    - إعدادات كارت الشبكة (IP Address)
    - معلومات المستخدمين (`/etc/passwd`)
    - إعدادات Apache → `/etc/apache2/`
    - إعدادات SSH, MySQL, DHCP, وغيرها
- **القاعدة:** أي Config File → تحت `/etc`

```bash
# مثال: ملف الـ Network
/etc/network/interfaces

# مثال: قاعدة بيانات المستخدمين
/etc/passwd
```

---

### `/dev` — Devices

> [!important] قاعدة مهمة **Linux يتعامل مع كل حاجة كـ File!**
> 
> - الشاشة → File
> - الماوس → File
> - الهارد ديسك → File
> - الـ TTY → File

- `/dev` = اختصار **Devices**
- فيها ملفات لكل الأجهزة المتصلة
- للوصول لـ Partition معين → تكسسه عبر ملفه هنا

```bash
/dev/sda      # أول هارد ديسك
/dev/sda1     # أول partition في أول هارد ديسك
/dev/tty1     # TTY1
```

---

### `/bin` و `/sbin` — Commands

|Directory|محتواها|من يستخدمها؟|
|---|---|---|
|`/bin`|أوامر النظام الأساسية|**الكل** (Root + Users)|
|`/sbin`|أوامر Admin|**Root فقط**|

- `bin` = Binary
- `sbin` = Super-user Binary

> [!info] ملاحظة (RHEL 7+) من الإصدار 7، اتعملوا **Symbolic Links** (Shortcuts):
> 
> - `/bin` → `/usr/bin`
> - `/sbin` → `/usr/sbin` عشان يظبطوا الـ Security ويحطوهم في Layer أعمق.

---

### `/usr` — User Programs (Shared Files)

- زي **Program Files** في Windows
- فيه الملفات المشتركة بين كل اليوزرز:
    - الخطوط (Fonts)
    - الـ Libraries
    - أوامر البرامج المنزّلة
    - الـ Documentation

```
/usr/
├── bin/       → أوامر البرامج
├── sbin/      → أوامر Admin للبرامج
├── lib/       → Libraries (32-bit)
├── lib64/     → Libraries (64-bit)
└── share/     → Shared data (Fonts, Docs)
```

---

### `/var` — Variable Data

- الملفات اللي **بتتغير باستمرار**
- أمثلة:
    - قواعد البيانات: `/var/lib/mysql/`
    - الـ Logs: `/var/log/`
    - الـ Mail Boxes: `/var/mail/`
- **القاعدة:** أي داتا بتتغير → تحت `/var`

---

### `/tmp` — Temporary Files

- ملفات **مؤقتة** بتتمسح أوتوماتيك
- مثال: لما بتفتح فيديو على YouTube → أجزاء منه بتتحفظ مؤقتاً هنا
- بتتمسح عند الـ Reboot
- الـ System بيعمل Cleanup أوتوماتيك بعد فترة معينة (قابل للتخصيص)

> [!warning] فرق مهم **`/tmp`** → الـ Applications هي اللي بتكتب فيها **`/proc`** → الـ Kernel هو اللي بيكتب فيها فقط

---

### `/proc` — Kernel Information (Virtual)

- **ليست موجودة فعلياً على الـ Disk** (Virtual File System)
- الـ Kernel يخزّن فيها معلومات عن:
    - الـ Hardware (CPU, RAM, Disk)
    - الـ Running Processes
    - الـ Network parameters
- بتتمسح عند الـ Reboot

```bash
/proc/cpuinfo    # معلومات الـ CPU
/proc/meminfo    # معلومات الـ RAM
/proc/1234/      # معلومات Process رقم 1234
```

> [!note] Permissions
> 
> - `/tmp` → يمكن قراءة وكتابة
> - `/proc` → **قراءة فقط** للمستخدمين — الـ Kernel فقط يكتب

---

### `/sys` — System Hardware Info

- قريبة من `/proc` لكن أكثر تركيزاً على الـ Hardware
- الـ Kernel يستخدمها لتخزين معلومات الأجهزة

||`/proc`|`/sys`|
|---|---|---|
|المحتوى|Hardware + Software (Processes)|Hardware بشكل أساسي|
|من يكتب؟|الـ Kernel|الـ Kernel|

---

### `/boot` — Boot Files

- فيه الـ **Boot Loader** (GRUB — قديماً LILO)
- فيه الـ **Kernel** نفسه
- لما النظام بيقلع → بيقرأ من هنا

---

### `/opt` — Optional Software

- فاضية بالـ Default
- بعض الـ Vendors الكبار بيطلبوا التثبيت هنا

**أمثلة:**

- Oracle Database → `/opt/oracle/`
- IBM DB2 → `/opt/IBM/`
- Splunk → `/opt/splunk/`

**الفائدة:** لو حبيت تعمل Uninstall → امسح الفولدر بتاعه وخلاص

---

### `/srv` — Service Data

- فاضية بالـ Default
- للـ Services اللي بتشتغل على السيرفر
- مثال: ملفات الـ Websites لـ Apache

---

### `/mnt` و `/media` — Mount Points

|Directory|الاستخدام|
|---|---|
|`/mnt`|Mount يدوي (قديم — أيام الـ Floppy Disk)|
|`/media`|**Removable Media** (USB, Portable HDD, CD)|

لما بتحط USB Flash Drive → بيظهر تلقائياً تحت `/media`

---

### `/lib` و `/lib64` — Libraries

- الـ Libraries اللي بتحتاجها الـ Applications للتشغيل
- زي الـ DLL Files في Windows

```
/lib/     → Libraries لـ 32-bit
/lib64/   → Libraries لـ 64-bit
```

> [!info] الـ 64-bit System يقدر يشغّل برامج 32-bit وبرامج 64-bit. لذلك هتلاقي `/lib` و `/lib64` الاتنين موجودين على نظام 64-bit. أما 32-bit → هتلاقي `/lib` بس.

---

## 🔑 ثلاث معاني لكلمة "Root"

> [!warning] لا تخلط بينهم!

|المعنى|الوصف|
|---|---|
|**Root User**|المستخدم الـ Admin (UID = 0)|
|**Root Filesystem**|نقطة بداية الـ File System (`/`)|
|**Root Home Directory**|الفولدر الخاص بمستخدم Root (`/root`)|

---

## 📊 ملخص شامل

```
/
├── home/          → Home Dirs للـ Normal Users
├── root/          → Home Dir للـ Root User (منفصل!)
├── etc/           → كل Config Files
├── bin/           → أوامر للجميع
├── sbin/          → أوامر للـ Root فقط
├── usr/           → Shared Programs & Files
│   ├── bin/
│   ├── sbin/
│   ├── lib/
│   └── share/
├── var/           → Variable Data (DBs, Logs, Mail)
├── tmp/           → Temporary Files (تتمسح)
├── proc/          → Kernel Info (Virtual)
├── sys/           → Hardware Info (Virtual)
├── dev/           → Device Files
├── boot/          → Boot Loader + Kernel
├── lib/           → Libraries 32-bit
├── lib64/         → Libraries 64-bit
├── opt/           → Optional Software
├── srv/           → Service Data
├── mnt/           → Manual Mount
└── media/         → Removable Media
```

---


# # Navigation & File Basics


### القاعدة 2 — Linux Case Sensitive

```
Download ≠ download ≠ DOWNLOAD ≠ DownLoad
```

الأربعة أسماء **مختلفة تماماً** في Linux. في Windows → كلهم **نفس الشيء**.

> [!warning] انتبه! لو فايلك اسمه `Downloads` وكتبت `downloads` → مش هيلاقيه!

---

## Slash vs Backslash

|الرمز|الاسم|يُستخدم في|
|---|---|---|
|`/`|Slash|**Linux**|
|`\`|Backslash|**Windows**|

```bash
# Linux
/home/mostafa/Downloads

# Windows
C:\Users\Mostafa\Downloads
```

---

##  التنقل في الـ File System

### `pwd` — معرفة مكانك الحالي

```bash
pwd
# Print Working Directory
# مثال output: /root
```

### `ls` — عرض محتوى Directory

```bash
ls /home                    # محتوى /home
ls /home/mostafa            # محتوى فولدر مصطفى
ls /home/mostafa/Downloads  # محتوى Downloads
```

**ألوان الـ `ls`:**

- 🔵 **أزرق** → Directory
- ⚪ **أبيض** → File عادي
- 🟢 **أخضر** → Executable / ملف قابل للتشغيل

### `cd` — التنقل بين Directories

```bash
cd /var/log           # روح لـ /var/log
cd /home/mostafa      # روح لـ home مصطفى
cd                    # روح لـ Home Directory بتاعتك
cd /                  # روح للـ Root Filesystem
cd -                  # ارجع للمكان اللي كنت فيه قبل كده
cd ..                 # اطلع Directory واحدة فوق (Parent)
cd ../..              # اطلع Directory اتنين فوق
```

> [!tip] اختصارات مفيدة
> 
> - `cd` (بدون حاجة) → بيوديك لـ Home Directory بتاعتك
> - `cd -` → toggle بين آخر مكانين كنت فيهم
> - `cd ~username` → روح لـ Home Directory بتاع يوزر معين

---
##  Absolute vs Relative Path

### Absolute Path (المسار الكامل)

- بيبدأ دايماً من `/`
- مش بيتأثر بمكانك الحالي
- دايماً صح بغض النظر انت فين

```bash
cd /home/mostafa/Downloads    # Absolute Path
ls /var/log/syslog            # Absolute Path
```

### Relative Path (المسار النسبي)

- بيعتمد على مكانك الحالي
- بيبدأ باسم الـ Directory مباشرة

```bash
# لو انت موجود في /home/mostafa
cd Downloads        # روح Downloads الجوّاه

# لو انت موجود في /home/mostafa/Downloads
cd ..               # ارجع لـ /home/mostafa
cd ../..            # ارجع لـ /home
```

> [!example] تشبيه عملي زي ما بتقول لأخوك:
> 
> - **Absolute:** "روح المطبخ" (من أي مكان)
> - **Relative:** "روح الأوضة اللي على اليمين" (من مكانك الحالي)

### الـ Dots المهمة

|الرمز|المعنى|
|---|---|
|`.`|Current Directory (المكان الحالي)|
|`..`|Parent Directory (اللي فوق)|

```bash
cd .        # ابقى في نفس المكان (مش مفيدة هنا، مفيدة في Scripts)
cd ..       # اطلع فوق
cd ../..    # اطلع فوقين
```

> [!note] لو عملت `cd ../../../../../../` وعدّيت الـ Root → مش هيحصل حاجة. الـ `/` هي Parent of itself — مالهاش فوقيها.

---

##  إنشاء Files وعرضها

### `touch` — إنشاء File فارغ

```bash
touch file1             # إنشاء ملف واحد
touch file2 file3       # إنشاء أكتر من ملف
touch file1 file2 file3 file4   # إنشاء 4 ملفات مرة واحدة
```

**لو الملف موجود أصلاً:**

- المحتوى **مش بيتغير**
- بس **التوقيت بيتحدّث** (Last Access Time)

### `cat` — عرض محتوى File

```bash
cat /var/log/messages    # عرض محتوى الملف
# cat = concatenate
```

---

## ✏️ nano — محرر النصوص

```bash
nano filename    # فتح أو إنشاء ملف
```

### أوامر nano الأساسية

|الأمر|الوظيفة|
|---|---|
|`Ctrl + O`|Save (Write Out)|
|`Ctrl + X`|Exit|
|`Ctrl + W`|Search (Where is)|
|`Ctrl + K`|Cut السطر|
|`Ctrl + U`|Paste (UnCut)|

### الطريقة الذكية

- **Save وExit في خطوة واحدة:** اضغط `Ctrl + X`
    - لو عدّلت → هيسألك "Save?" → اضغط `Y` ثم Enter
    - لو ما عدّلتش → بيخرج مباشرة

> [!info] nano ده جزء من مشروع **GNU** — اتكتب في الفترة من 1984 لـ 1991.

---

##  ملاحظات مهمة

### لو الأمر اتنفذ بدون Error

- في Linux → **الصمت يعني النجاح**
- لو في مشكلة → هيطلع Error واضح على طول

```bash
ls testing    # لو الملف مش موجود → Error فوري
# No such file or directory
```

### Trailing Slash — القاعدة

```bash
cd /var/log/      # ✅ صح — Directory
cat /var/log/     # ❌ غلط — مش ملف
cat /var/log/syslog    # ✅ صح — File بدون trailing slash
```

---

# # File Operations & User Management 

## 🌳 أمر `tree` — عرض الـ File System كشجرة

```bash
tree /home          # عرض /home كشجرة
tree                # عرض المكان الحالي
tree /usr
```

> [!note] لو `tree` مش موجود على السيرفر، ثبّته بـ `yum install tree` أو `apt install tree`.

---

##  إنشاء Directories

### `mkdir` — Make Directory

```bash
mkdir dir1                    # إنشاء directory واحدة
mkdir dir1 dir2 dir3          # إنشاء أكتر من directory مرة واحدة
mkdir /tmp/mydir              # إنشاء directory في مكان تاني
```

> [!warning] فرق مهم عن `touch`
> 
> - `touch` على ملف موجود → يحدّث الـ Timestamp فقط ✅
> - `mkdir` على directory موجودة → **Error مباشرة** ❌
> 
> ولاحظ: الـ Error بيقول "File exists" مش "Directory exists" — السبب هتعرفه لاحقاً!

### إنشاء في مكان غير مكانك الحالي

```bash
# لو انت في /home/mostafa وعايز تعمل directory في /tmp
mkdir /tmp/dir2        # حدّد الـ Path كامل
touch /var/log/myfile  # نفس الفكرة مع touch
```

> [!tip] القاعدة الذهبية لو عايز تعمل أي عملية في مكان غير اللي انت فيه → **حدّد الـ Path بالكامل**

---

##  نسخ الملفات والـ Directories — `cp`

### نسخ File

```bash
cp file1 backup_file          # نسخ في نفس المكان باسم جديد
cp file1 /tmp/file1           # نسخ لمكان تاني بنفس الاسم
cp file1 /tmp/newname         # نسخ لمكان تاني باسم جديد
```

### نسخ Directory (محتاج `-r`)

```bash
cp -r dir1 dir2               # نسخ dir1 جوّه dir2
cp -r dir1 /tmp/              # نسخ dir1 لـ /tmp
cp -r dir1 /tmp/report        # نسخ dir1 لـ /tmp باسم جديد
```

> [!important] `-r` = Recursive لازم تستخدم `-r` مع أي Directory فيها محتوى. بدون `-r` → "omitting directory" — بيتجاهلها!

### ⚠️ سلوك `cp` لو الـ Destination موجودة

**لو الـ Destination مش موجودة:**

```bash
cp -r dir1 /tmp/newdir    # ينسخ dir1 باسم newdir
```

**لو الـ Destination موجودة:**

```bash
cp -r dir1 /tmp/existingdir   # ينسخ dir1 جوّه existingdir
# يعني: /tmp/existingdir/dir1
```

**لو الـ Destination موجودة وفاضية:**

```bash
# ينقل الـ Content بس، مش الـ Directory نفسها
```

---

##  نقل الملفات — `mv`

### نقل File

```bash
mv file1 /tmp/             # نقل لمكان تاني
mv file1 newname           # Rename في نفس المكان
mv file1 /tmp/newname      # نقل ومع Rename
```

### نقل Directory

```bash
mv dir1 /var/              # نقل directory (بدون -r!)
mv dir1 /tmp/newdir        # نقل وتغيير اسم
```

> [!note] الفروق الجوهرية بين `cp` و`mv`
> 
> ||`cp`|`mv`|
> |---|---|---|
> |السورس|**يبقى**|**بيتشال**|
> |مع Directory|يحتاج `-r`|**مش محتاج** `-r`|

### 💡 Rename عبر `mv`

مافيش أمر اسمه `rename` للملفات — بتعمله بـ `mv`:

```bash
mv old_name new_name       # غيّر الاسم في نفس المكان
mv file1 august_report     # مثال عملي
```

---

## 🗑️ حذف الملفات — `rm`

### حذف File

```bash
rm file10                  # بيسألك تأكيد
rm -f file10               # حذف بدون سؤال (Force)
```

### حذف Directory فاضية

```bash
rm -r emptydir             # ينفع
```

### حذف Directory فيها محتوى

```bash
rm -r dir2                 # بيسألك على كل ملف واحد واحد 😩
rm -rf dir2                # حذف كل حاجة بدون أسئلة ✅
```

> [!danger] ⚠️ أخطر أمر في Linux
> 
> ```bash
> rm -rf /          # ❌ ده بيمسح كل حاجة على السيستم!
> rm -rf / dir1     # ❌ لو حطيت مسافة بالغلط بين / والاسم
> ```
> 
> **في RHEL 7+:** لو حاولت تعمل `rm -rf /` → هيطلب منك تضيف `--no-preserve-root` عمداً. **قبل RHEL 7:** بيتنفذ على طول وربنا يستر! 😱
> 
> **لو حصلت:** ابدأ تكتب استقالتك فوراً 😅

---

##  الصيغة العامة لأي أمر

```
command  [options]  [arguments]
```

|الجزء|الشرح|مثال|
|---|---|---|
|`command`|الأمر نفسه|`ls`, `cp`, `rm`|
|`[options]`|اختياري — بيغير سلوك الأمر|`-r`, `-l`, `-f`|
|`[arguments]`|المعلومات اللي الأمر يشتغل عليها|اسم الملف أو الـ Path|

> [!important] الـ Spaces مهمة جداً!
> 
> ```bash
> cp -r dir1 /tmp    # ✅ صح — فيه spaces
> cp-r dir1/tmp      # ❌ غلط — مفيش spaces
> ```
> 
> لازم يكون في مسافة بين الأمر والـ Option، وبين الـ Option والـ Argument.

### أمثلة توضيحية

```bash
ls                    # أمر بس — بدون options أو arguments
ls -l                 # أمر + option
cp file1 file2        # أمر + argument1 + argument2
cp -r dir1 /tmp/dir2  # أمر + option + argument1 + argument2
```

### الـ Options بيغيروا سلوك الأمر

```bash
ls           # عرض أسماء الملفات فقط
ls -l        # Long listing — أسماء + صلاحيات + حجم + توقيت
ls -a        # عرض الـ Hidden files (اللي بتبدأ بـ .)
ls -r        # Reverse — عكس الترتيب الأبجدي
ls -R        # Recursive — عرض كل حاجة جوّاها
ls -la       # دمج أكتر من option
```

> [!info] Hidden Files في Linux أي ملف أو Directory بيبدأ بـ `.` (نقطة) → **مخفي**
> 
> ```bash
> ls      # مش بيعرضهم
> ls -a   # بيعرضهم
> ```

---

##  Keyboard Shortcuts مهمة

### التنقل في السطر

|الاختصار|الوظيفة|
|---|---|
|`Ctrl + A`|روح لأول السطر|
|`Ctrl + E`|روح لآخر السطر|
|`Ctrl + K`|امسح من مكانك لآخر السطر|
|`Ctrl + U`|امسح من مكانك لأول السطر|

### التحكم في الـ Session

| الاختصار   | الوظيفة                             |
| ---------- | ----------------------------------- |
| `Ctrl + D` | Logout (= `exit` = `logout`)        |
| `Ctrl + C` | إيقاف أمر شغّال نهائياً (Terminate) |
| `Ctrl + Z` | إيقاف مؤقت (Pause)                  |
| `Ctrl + S` | Lock الشاشة                         |
| `Ctrl + Q` | Unlock الشاشة                       |

### بعد `Ctrl + Z` (Pause)

```bash
bg    # رجّع الأمر يشتغل في الـ Background
```

### تنفيذ أكتر من أمر مع بعض

```bash
ls ; date       # نفذ ls ثم date
```

---

## 🖥️ التحكم في الـ Terminal

```bash
clear          # مسح الشاشة (بس ممكن ترجع للفوق)
reset          # مسح كامل — مش ممكن ترجع للفوق
Ctrl + L       # = clear
```

### التمرير في الـ Terminal

- **`Shift + Page Up`** → طلوع لفوق
- **`Shift + Page Down`** → نزول لتحت

> [!note] الـ Scroll بالـ MobaXterm أو PuTTY مش بيشتغل على الـ Native TTY — ده Buffer من الـ Terminal نفسه مش من Linux.

---

## 🔄 Reboot & Shutdown

### أوامر إعادة التشغيل (كلها بتعمل نفس الشيء)

```bash
reboot
shutdown -r now
systemctl reboot
init 6
```

### أوامر إيقاف التشغيل

```bash
shutdown -h now
systemctl poweroff
init 0
poweroff
```

---

## 👥 Users & Groups

### مراجعة أنواع المستخدمين

|النوع|UID|وصف|
|---|---|---|
|Root|`0`|السوبر يوزر|
|Service Users|`1 – 999`|للـ Services فقط|
|Normal Users|`1000+`|المستخدمين العاديين|

### إنشاء مستخدم جديد

```bash
useradd ahmed          # إنشاء يوزر
# أوتوماتيك بيعمل:
# - Home Directory: /home/ahmed
# - Group باسمه: ahmed (Primary Group)
```

### تحديد الباسورد

```bash
passwd ahmed           # تحديد باسورد ليوزر معين
passwd                 # تغيير باسوردك أنت
```

### معرفة معلومات مستخدم

```bash
id ahmed
# output: uid=1002(ahmed) gid=1002(ahmed) groups=1002(ahmed)
```

---

##  Groups — الفهم الصحيح

### Primary Group vs Secondary Groups

- لكل يوزر **Primary Group واحدة بس**
- ممكن يكون ممبر في **أكتر من Secondary Group**

### User Private Group (UPG)

لما بتعمل يوزر جديد:

1. بيتعمل **Group بنفس الاسم** أوتوماتيك
2. الـ Group دي = **Primary Group** بتاعته
3. مفيش أي حد تاني فيها غيره

```
useradd mostafa  →  Group "mostafa" اتعملت → فيها مصطفى بس
useradd ali      →  Group "ali" اتعملت → فيها علي بس
useradd ahmed    →  Group "ahmed" اتعملت → فيها أحمد بس
```

> [!example] تشبيه واقعي انت System Admin (Primary Group: sysadmin) بس ممكن تكون ممبر كمان في:
> 
> - network_admins (Secondary)
> - datacenter_team (Secondary)
> - database_admins (Secondary)
> 
> دورك الأساسي = sysadmin، لكن ليك صلاحيات في أماكن تانية.

---

## 🔐 قواعد الباسورد

### الـ Root

- يقدر يختار أي باسورد لأي يوزر بدون قيود
- لو اختار باسورد ضعيفة → Warning بس، مش Error

### اليوزر العادي

- لو عايز يغيّر باسورده هو → بيسأل عن الباسورد الحالية أولاً
- لازم يختار باسورد قوية (8+ حروف على الأقل)
- لو اختار باسورد ضعيفة → **Error ومش بيقبلها**



----

# # User Administration 

---

## 🔧 إدارة المستخدمين — User Administration

### إضافة مستخدم جديد

```bash
useradd ali           # إنشاء يوزر
useradd -g dc_admins user1    # إنشاء يوزر وتحديد Primary Group
```

> [!warning] لو اليوزر موجود أصلاً بيطلعلك `already exists` — مش بيكريت تاني

> [!important] لما تحدد Primary Group بنفسك Linux **مش بيعمل** Group بنفس اسم اليوزر أوتوماتيك — بس لو ما حددتش، بيعملها.

### تعديل يوزر موجود

- ```bash
  usermode -s  /bin/bash mostafa
  ```
- هنا لو انته عايز تعدل الشيل بتاعك الى هتستخدمه  يعنى هنا هيخلى اليوزر الى اسمه مصطفى يستخدم الباش 

---
```bash
usermod -c "my name is mostafa" mostafa
```

- كده انته عملت كومنت لليوزر ده فى ملف الـ etc/passwd

---


```bash
usermod -u 2000 mostafa
```

- كده انته غيرت الـ id بتاع الجروب  الىى اسمه مصطفى
---

```bash
usermod -G network_admins user1       # ضيف لـ Secondary Group (بيحل القديمة!)
usermod -aG network_admins user1      # ضيف لـ Secondary Group (بيضيف للقديمة) ✅
usermod -g dc_admins user1            # غيّر Primary Group
```

> [!danger] الفرق بين `-G` و `-aG`
> 
> - `-G` بدون `-a` → **بيشيل** كل الـ Secondary Groups القديمة وبيحطه في الجديدة فقط!
> - `-aG` → **بيضيف** على الموجود
> 
> دايماً استخدم `-aG` لو عايز تضيف بدون ما تمسح!

### حذف مستخدم

```bash
userdel user1           # بيمسح اليوزر بس — الملفات بتفضل!
userdel -r user1        # بيمسح اليوزر + Home Directory + الملفات
```

> [!note] لما بتمسح يوزر، الـ Private Group بتاعته بتتمسح معاه أوتوماتيك. لو اليوزر ده كانت له Primary Group تانية (مش بنفس اسمه) — الـ Group دي **مش بتتمسح**.

### تحديد الباسورد

```bash
passwd ali         # تحديد باسورد لأي يوزر (Root بس)
passwd             # تغيير باسوردك أنت
```

---

##  إدارة الـ Groups

### إضافة Group

```bash
groupadd dc_admins
groupadd network_admins
groupadd database_admins
```

### حذف Group

```bash
groupdel network_admins      # ينفع لو هي Secondary Group
groupdel dc_admins           # ❌ مش هينفع لو هي Primary Group لأي يوزر
```

> [!important] قاعدة حذف الـ Groups
> 
> - **Secondary Group** → تنحذف بدون مشاكل
> - **Primary Group** لأي يوزر → **لازم تمسح اليوزر الأول**
> 
> السبب: ما ينفعش يوزر يعيش من غير Primary Group!

---

## ملفات قاعدة البيانات

### `/etc/passwd` — معلومات المستخدمين

```
username : x : UID : GID : GECOS : home_dir : shell
```

|الحقل|المثال|المعنى|
|---|---|---|
|username|`mostafa`|اسم المستخدم|
|password|`x`|الباسورد مخزنة في `/etc/shadow`|
|UID|`1001`|رقم المستخدم|
|GID|`1001`|رقم الـ Primary Group|
|GECOS|`Mostafa Hamouda`|وصف/اسم كامل|
|home_dir|`/home/mostafa`|الـ Home Directory|
|shell|`/bin/bash`|الـ Shell الافتراضي|

```bash
cat /etc/passwd    # عرض كل المستخدمين
id ali             # عرض معلومات يوزر معين
```

### `/etc/group` — معلومات الـ Groups

```
group_name : x : GID : members_list
```

|الحقل|المعنى|
|---|---|
|group_name|اسم الـ Group|
|x|الباسورد في `/etc/gshadow`|
|GID|رقم الـ Group|
|members|قائمة الأعضاء (مفصولة بفاصلة)|

```bash
cat /etc/group     # عرض كل الـ Groups
```

### `/etc/shadow` و `/etc/gshadow`

- **`/etc/shadow`** → باسوردات اليوزر (مشفّرة)
- **`/etc/gshadow`** → باسوردات الـ Groups

> [!info] علامة `!` في الباسورد معناها اليوزر ده **لسه ما حُدّدش له باسورد** ومش هيقدر يعمل Login. اليوزر بيكون Active بس محتاج `passwd` عشان يتفعّل فعلياً.

---

##  مفهوم الـ File Ownership والـ Groups

### ليه الـ Primary Group مهمة؟

لما بتعمل أي ملف أو directory → الملف بيتملك من:

- **اليوزر** = أنت (اللي عامله)
- **الـ Group** = الـ Primary Group بتاعتك

```bash
touch file1      # الملف بيبقى مملوك ليوزرك وبرايمري جروبك
```

### ليه بنعمل Groups؟ — File Collaboration

لو فريق Database Admins كلهم في نفس الـ Group → كلهم يقدروا يتعاملوا مع نفس الملفات.

> [!example] سيناريو واقعي واحد من الفريق اجازة؟ مش مشكلة — الملفات مملوكة للـ Group، مش للشخص. **لو كل حد شغّال بـ Private Group بس** → لما حد يغيب، الباقيين مش هيقدروا يوصلوا لملفاته → **كارثة!** 😱

---

# # File Permissions 

### الثلاث فئات

|الفئة|الرمز|المعنى|
|---|---|---|
|**User (Owner)**|`u`|صاحب الملف|
|**Group**|`g`|أعضاء الـ Group المالكة|
|**Others**|`o`|أي حد تاني|

### الثلاث صلاحيات

|الصلاحية|الرمز|على **File**|على **Directory**|
|---|---|---|---|
|**Read**|`r`|عرض المحتوى|عمل `ls`|
|**Write**|`w`|تعديل/حذف|إضافة/حذف ملفات|
|**Execute**|`x`|تنفيذ الملف|عمل `cd` أو `ls -l`|

> [!important] الـ Execute على Directory بدون `x` على Directory → مش هتقدر تدخل جوّاها بـ `cd` ومش هتقدر تعمل `ls -l`.

---

## 📋 قراءة الـ Permissions

### شكل الـ Permissions في `ls -l`

```
- rwx r-- r--   1   root root   0   Aug 3  file1
│ │││ │││ │││
│ │││ │││ └── Others (r--)
│ │││ └────── Group (r--)
│ └────────── User/Owner (rwx)
└──────────── File Type (- = regular file)
```

### أنواع الملفات (الحرف الأول)

| الرمز | النوع                                 |
| ----- | ------------------------------------- |
| `-`   | ملف عادي                              |
| `d`   | Directory                             |
| `l`   | Symbolic Link                         |
| `b`   | Block Device (مثل: الـ Disk)          |
| `c`   | Character Device (مثل: الكيبورد، TTY) |

> [!info] Block vs Character Device
> 
> - **Block Device** → بياخد ويبعت Data بـ Blocks (مثل: الـ HDD)
> - **Character Device** → بياخد ويبعت Data حرف حرف (مثل: الكيبورد أو TTY)

---

## ✏️ تغيير الـ Permissions — `chmod`

### الصيغة

```bash
chmod [who][+|-][permission] file
```

### أمثلة عملية

```bash
# إضافة صلاحيات
chmod u+x file1          # إضافة Execute للـ Owner
chmod g+w file1          # إضافة Write للـ Group
chmod o+r file1          # إضافة Read للـ Others
chmod a+x file1          # إضافة Execute للكل (all)

# حذف صلاحيات
chmod u-x file1          # حذف Execute من الـ Owner
chmod g-r file1          # حذف Read من الـ Group
chmod o-rwx file1        # حذف كل الصلاحيات من Others

# عمليات مجمّعة
chmod u+r,g-r file1      # إضافة Read للـ Owner وحذفها من الـ Group
chmod ug+r file1         # إضافة Read للـ Owner والـ Group مع بعض
chmod ugo-x file1        # حذف Execute من الكل
chmod -x file1           # بدون تحديد → بيطبق على الكل (= `a-x`)
```

### تطبيق على Directory وكل محتواها

```bash
chmod -R g-rw /home/work   # تطبيق ريكيرسيف على الـ Directory وكل جوّاها
```

> [!warning] `-R` مع `chmod` بيطبق الصلاحيات على الـ Directory **وكل الملفات اللي جوّاها**. بدون `-R` → بيطبق على الـ Directory من بره بس!

---

##  تغيير الـ Ownership — `chown`

```bash
# تغيير الـ Owner فقط
chown ali /home/work

# تغيير الـ Group فقط
chown :dc_admins /home/work

# تغيير الـ Owner والـ Group مع بعض
chown ali:dc_admins /home/work

# تطبيق ريكيرسيف
chown -R ali:dc_admins /home/work
```

> [!tip] الفرق بين `chmod` و `chown`
> 
> - `chmod` → بيغير **الصلاحيات** (read/write/execute)
> - `chown` → بيغير **المالك** (user/group)

---
##  ألوان `ls`

|اللون|المعنى|
|---|---|
|⚪ أبيض|ملف عادي|
|🔵 أزرق|Directory|
|🟢 أخضر|ملف قابل للتنفيذ (Execute Permission)|

---

## 📝 ملخص الأوامر

|الأمر|الوظيفة|
|---|---|
|`useradd [user]`|إضافة مستخدم|
|`useradd -g [grp] [user]`|إضافة مستخدم مع Primary Group|
|`usermod -aG [grp] [user]`|إضافة يوزر لـ Secondary Group|
|`usermod -g [grp] [user]`|تغيير Primary Group|
|`userdel [user]`|حذف يوزر (الملفات بتفضل)|
|`userdel -r [user]`|حذف يوزر + ملفاته|
|`groupadd [grp]`|إضافة Group|
|`groupdel [grp]`|حذف Group|
|`passwd [user]`|تحديد/تغيير باسورد|
|`id [user]`|عرض معلومات يوزر|
|`chmod [perms] [file]`|تغيير الصلاحيات|
|`chmod -R [perms] [dir]`|تغيير صلاحيات Directory وكل محتواها|
|`chown [user]:[grp] [file]`|تغيير المالك والـ Group|

---


# # Numeric Permissions



### الفكرة الأساسية

بدل ما بتكتب `rwx`، بتجمع أرقام لكل صلاحية:

|الصلاحية|الرمز|الرقم|
|---|---|---|
|Read|`r`|**4**|
|Write|`w`|**2**|
|Execute|`x`|**1**|
|لا شيء|`-`|**0**|

### طريقة الحساب

كل فئة (User/Group/Others) بتحسب لوحدها:

```
rwx = 4+2+1 = 7
rw- = 4+2+0 = 6
r-x = 4+0+1 = 5
r-- = 4+0+0 = 4
-wx = 0+2+1 = 3
-w- = 0+2+0 = 2
--x = 0+0+1 = 1
--- = 0+0+0 = 0
```

### الصيغة الكاملة

```
chmod [user][group][others] filename
chmod 764 file1
       │││
       ││└── Others: r-- (4)
       │└─── Group:  rw- (6)
       └──── User:   rwx (7)
```

> [!tip] الأرقام مش عشوائية! 4 + 2 + 1 = 7 → مافيش تعارض بين الأرقام دي أبداً. كل رقم بيعبر عن بت واحد في النظام الثنائي (Binary).

### أمثلة عملية

```bash
chmod 777 file1    # rwxrwxrwx — الكل عنده كل حاجة
chmod 755 file1    # rwxr-xr-x — المعتاد للـ Executables
chmod 644 file1    # rw-r--r-- — المعتاد للملفات العادية
chmod 700 file1    # rwx------ — الـ Owner بس
chmod 000 file1    # --------- — محدش يعمل حاجة
chmod 640 file1    # rw-r----- — Owner rw، Group r، Others لا شيء
chmod 765 file2    # rwxrw-r-x
```

```bash
# مع Directory وكل محتواها
chmod -R 755 /home/work
```

---

---

# # I/O Redirection & Pipes


### المفهوم الأساسي

أي عملية على الجهاز بتمر بثلاث مراحل:

```
Input → Processing → Output
                  └→ Error (لو حصل)
```

### الـ File Descriptors (أرقام توصيفية)

| الاسم                        | الرقم | الافتراضي |
| ---------------------------- | ----- | --------- |
| **stdin** (Standard Input)   | `0`   | الكيبورد  |
| **stdout** (Standard Output) | `1`   | الشاشة    |
| **stderr** (Standard Error)  | `2`   | الشاشة    |

> [!note]
> 
> - الـ stdout هو **الطبيعي** — أي أمر المفروض يطلع منه Output.
> - الـ stderr هو **الاستثناء** — بيطلع بس لو في حاجة غلط.
> - عشان كده لو بتتعامل مع الـ Error لازم تحدد رقمه `2` صراحة.

---

### `>` — إعادة توجيه الـ Output (Overwrite)

```bash
ls > result.txt          # حط ناتج ls في ملف (بيمسح القديم)
ls /var > result.txt     # نفس الفكرة
date > result.txt        # حط التاريخ في ملف
```

> [!warning] علامة واحدة = Overwrite لو الملف موجود، بيمسح محتواه ويكتب الجديد!

### `>>` — إعادة توجيه الـ Output (Append)

```bash
ls >> result.txt         # ضيف ناتج ls على اللي موجود (مش بيمسح)
date >> result.txt       # ضيف التاريخ على اللي موجود
```

> [!tip] علامتين = Append بيحافظ على الـ Content القديم ويضيف عليه.

---

### `2>` — إعادة توجيه الـ Error

```bash
ls /notexist 2> error.txt    # حط الـ Error في ملف
ls /notexist 2>> error.txt   # ضيف الـ Error على الملف
```

### فصل الـ Output عن الـ Error في ملفات مختلفة

```bash
ls file2 /notexist > output.txt 2> error.txt
# Output في output.txt
# Error في error.txt
```

### دمج الـ Output والـ Error في ملف واحد

```bash
# طريقة 1
ls file2 /notexist > result.txt 2> result.txt

# طريقة 2 (أفضل)
ls file2 /notexist > result.txt 2>&1
# 2>&1 = وجّه الـ Error ليطلع في نفس مكان الـ stdout
```

---

### `<` — تغيير مصدر الـ Input

```bash
cat < file1          # اقرأ من file1 بدل الكيبورد
```

---

### `/dev/null` — سلة المهملات

```bash
ls /notexist 2> /dev/null    # اتجنب الـ Error — مش عايز أشوفه
ls > /dev/null               # اتجنب الـ Output تماماً
```

> [!info] `/dev/null` ده ملف خاص — أي حاجة بتروح فيه بتتمسح أوتوماتيك. مفيد لما تشغّل أمر بس مش عايز تشوف ناتجه.

---

##  Pipe `|` — توصيل الأوامر مع بعض

### الفكرة

الـ Pipe بتاخد الـ **Output** من أمر وبتحطه كـ **Input** لأمر تاني.

```bash
command1 | command2
# Output من command1 → Input لـ command2
```

> [!tip] الـ Pipe (`|`) = Shift + Backslash على الكيبورد

### أمثلة عملية

```bash
# عرض ملف كبير صفحة بصفحة
ls -l / | less
cat /etc/passwd | less

# دمج أوامر
ls -l /var | less
ls -l /var | more
```

---

## 📄 `less` و `more` — عرض الملفات صفحة بصفحة

### `less`

```bash
less /etc/passwd    # فتح ملف في less
ls -l / | less      # عرض ناتج أمر في less
```

|الضغطة|الوظيفة|
|---|---|
|`Space` أو `Page Down`|الصفحة التالية|
|`Page Up`|الصفحة السابقة|
|`q`|خروج|
|`/keyword`|بحث عن كلمة|

> [!note] `less` بيفضل مفتوح حتى بعد ما تخلص — لازم تضغط `q` للخروج.

### `more`

```bash
more /etc/passwd    # فتح ملف في more
```

> [!note] `more` بيخرج أوتوماتيك لما يوصل لنهاية الملف.

---

##  `tee` — نسخ للشاشة وللملف في آن واحد

### المشكلة

```bash
ls -l / > result.txt    # بتحط في ملف بس — مش بتشوف على الشاشة ❌
```

### الحل: `tee`

```bash
ls -l / | tee result.txt
# نسخة على الشاشة + نسخة في الملف ✅
```

> [!tip] `tee` بيعمل نسخة تطلع على الشاشة **ونسخة** تتحط في الملف في نفس الوقت.

```bash
# Append بدل Overwrite
ls -l / | tee -a result.txt
```

---

## 📂 `cat` مع الـ Redirection

### قراءة من ملف

```bash
cat file1               # عرض محتوى ملف
cat < file1             # نفس النتيجة (Input من ملف)
```

### الكتابة في ملف عبر `cat` + Here Document

```bash
cat > myfile.txt << END
اكتب اللي عايزه هنا
سطر تاني
سطر تالت
END
```

```bash
cat >> myfile.txt << STOP
ضيف محتوى جديد
STOP
```

> [!info] Here Document `<<` بيقرأ من الـ Terminal لحد ما يلاقي كلمة التوقف اللي انت حددتها (مثلاً `END` أو `STOP`). أول ما يلاقيها، بيحط كل اللي كتبته في الملف.

---

##  نوع الملف بالـ Content — أمر `file`

في Linux، الـ Extension مالهوش قيمة! النوع بيتحدد من الـ Content الجوّاني.

```bash
file image.jpg          # → JPEG image data
file script.sh          # → Bash script text
file /bin/ls            # → ELF 64-bit LSB executable
file myfile.mp3         # → بيقولك النوع الحقيقي بغض النظر عن الامتداد
```

> [!important] لو غيّرت امتداد ملف في Linux → مش هيأثر على طريقة التعامل معه! Linux بيبص على الـ Signature (Header) الجوّانية في الملف.

---

## 🔗 سلسلة أوامر — `;`

```bash
ls ; date               # نفّذ ls ثم date (حتى لو الأول فشل)
```

---

## 💡 سيناريو عملي — لماذا نحتاج كل ده؟

> [!example] سيناريو: Database Backup Automation عندك Script بتاخد Backup من Database كل أسبوع أوتوماتيك:
> 
> 1. بتوقف الـ Database
> 2. بتاخد الـ Backup
> 3. بتتشيك على الـ Backup
> 4. بترفعه على Backup Server
> 5. بتبعت Email بالنتيجة
> 6. بتشغّل الـ Database تاني
> 
> الـ Script دي بتطلع Output وErrors كتير. بدل ما تكون موجود على الجهاز وقت التنفيذ:
> 
> ```bash
> ./backup.sh > /var/log/backup.log 2> /var/log/backup_errors.log
> ```
> 
> يوم الأحد لما تيجي للشغل → تفتح الملفين وتشوف اللي حصل!

---



# WC Commands



##  `tee` — نسخة على الشاشة ونسخة في ملف

```bash
ls | tee result.txt          # اعرض على الشاشة + احفظ في ملف (Overwrite)
ls | tee -a result.txt       # اعرض على الشاشة + أضف على الملف (Append)
```

> [!important] `tee` دايمًا بتعمل Overwrite! لو محتاج Append استخدم `-a`

---

##  System Info Commands — أوامر معلومات النظام

### `w` — من المتصل ومعلومات الجهاز

```bash
w
```

بيطلعلك:

- كام وقت الجهاز شغّال (Uptime)
- كام يوزر عامل Login
- الـ Load Average في آخر 1 دقيقة / 5 دقايق / 15 دقيقة
- مين اللي عامل Login وجاي منين (TTY أو PTS) ومن أي IP

### `who` — عرض مبسط لليوزرز

```bash
who
```

بيقولك مين عامل Login، من أين، وامتى.

### `whoami` — أنت مين؟

```bash
whoami    # بيقولك اسم اليوزر الحالي وعامل Login منين وامتى
```

---

### الفرق بين TTY وPTS

| النوع | المعنى                                                             |
| ----- | ------------------------------------------------------------------ |
| `tty` | Teletype — كيبورد وشاشة واصلين مباشرة بالجهاز                      |
| `pts` | Pseudo Terminal — اتصال عن بُعد (SSH) أو نافذة Terminal من الـ GUI |

> [!info] في عندك Monitor واصل؟ أول مونيتور واصل بالجهاز هيبان كـ `:0` تاني مونيتور `:1` وهكذا.

---

---

### `type` — بيشرحلك الأمر ده بيعمل إيه

```bash
type ls          # → ls is aliased to 'ls --color=auto'
type chmod       # → chmod is /usr/bin/chmod
type calendar    # → calendar is /usr/bin/calendar
```

### `which` — فين الـ Binary بتاع الأمر

```bash
which ls         # → /usr/bin/ls
which calendar   # → /usr/bin/calendar
which tee        # → /usr/bin/tee
```

---

# # Filesystem  Inodes, Links & Disk Management

### الفكرة الأساسية: الكيرنل بيتعامل بالأرقام

زي ما كل يوزر عنده UID وكل جروب عنده GID، كل **ملف** بيكون له **رقم** بيحدد مكانه على الديسك.

---

### الديسك وتقسيمه

```
Raw Disk (أرض خام)
    ↓
MBR (Master Boot Record) ← أول 512 byte
    ├── Bootloader code
    └── Partition Table (64 byte) → بيحدد بداية ونهاية كل Partition
         ↓
Partitions (بارتيشنز)
    ├── Partition 1 → Filesystem + Inode Table
    ├── Partition 2 → Filesystem + Inode Table
    └── Partition 3 → Filesystem + Inode Table
```

---

### MBR — Master Boot Record

|الجزء|الحجم|الوظيفة|
|---|---|---|
|Bootloader|446 byte|كود التشغيل|
|Partition Table|64 byte|جدول البارتيشنز|
|Signature|2 byte|توقيع MBR|

> [!important] حدود MBR كل Partition بياخد 16 byte في الجدول ➝ أقصى عدد Partitions = **4 فقط**
> 
> ده لأن MBR اتصمم في **الثمانينات** وكانت أكبر مساحة Disk بالميجا!

---

---

### Extended Partition — تجاوز حد الـ 4

لأن MBR بيسمح بـ 4 بس، الحل كالتالي:

```
Disk
├── Primary 1        (sda1)
├── Primary 2        (sda2)
├── Primary 3        (sda3)
└── Extended         (sda4) ← بياخد واحد من الـ 4 slots
     ├── Logical 5   (sda5)
     ├── Logical 6   (sda6)
     ├── Logical 7   (sda7)
     └── Logical 8   (sda8)
```

> [!important] قواعد مهمة
> 
> - هنا  **Logical** دايماً بيبدأ يعد من **5** — بغض النظر استخدمت كام Primary
> - الـ Extended نفسه بياخد واحد من الـ 4 slots البرايمري
> - أقصى Primary مع Extended = **3 Primary + 1 Extended**

---

### Filesystem — طريقة الزراعة

الـ Filesystem هو الطريقة اللي بتنظم فيها تخزين واسترجاع البيانات على الـ Partition.

```
قطعة الأرض = Partition
طريقة الزراعة = Filesystem
المحصول = Data
```

|Filesystem|نظام التشغيل|ملاحظة|
|---|---|---|
|FAT32|الكل!|Universal — أي OS بيدعمه|
|NTFS|Windows أساساً|Linux/Mac محتاجين package|
|ext2, ext3, ext4|Linux|الأشهر في Linux|
|XFS|Linux|مناسب للملفات الكبيرة|
|Btrfs|Linux|ميزات متقدمة|
|ZFS|Linux/Solaris|للـ Enterprise|

> [!tip] مفيش Filesystem "أحسن" من التاني! كل واحد ليه مميزات وعيوب. الاختيار بيعتمد على **احتياجك انت**.

---

##  Inode — رقم الملف

### الفكرة

كل ملف أو Directory بيكون له **Inode Number** — رقم فريد يحدد مكانه على الـ Partition.

### Inode Table بتخزن فيها ايه؟

|المعلومة|الوصف|
|---|---|
|Inode Number|رقم الملف الفريد|
|File Type|ملف عادي، Directory، Link...|
|Permissions|rwxrwxrwx|
|Owner (UID)|مين صاحب الملف|
|Group (GID)|الجروب بتاعه|
|Size|الحجم|
|Timestamps|Access / Modify / Change|
|Link Count|عدد الـ Hard Links|
|Block Pointers|فين الداتا الحقيقية|



> [!important] اسم الملف مش موجود في الـ Inode! اسم الملف بيتخزن في الـ **Directory** — مش في الـ Inode نفسه.
> 
> الـ Directory بتخزن: اسم الملف ← Inode Number

---

### الـBlock Size وعلاقته بالـ Inodes

```
كل Partition → مقسم لـ Blocks (بلاطات)
كل Inode → بيشاور على Block واحد أو أكتر
```

- الـ Default Block Size = **128 byte** (قابل للتغيير وانت بتعمل Format)
- الملف الواحد ممكن يحجز **أكتر من Block** لو حجمه كبير
- أول Inode بس هو اللي بيمثل الملف — الباقيين بيتعلم عليهم "Used"

---

### الأوامر المتعلقة بالـ Inodes

```bash
ls -lai              # عرض الملفات مع الـ Inode Number
df -i                # عدد الـ Inodes المستخدمة والمتاحة
df -h                # مساحة الـ Disk الحرة بشكل مقروء
```

---

### مشكلة: Disk Fري بس مش بيكتب!

ممكن تكون الـ Free Space موجودة لكن **عدد الـ Inodes خلص!**

```bash
df -i   # تشوف الـ Inodes المتاحة
```

> هيحصل كده لو اخترت Block Size كبيرة جداً مع ملفات صغيرة جداً → مساحة هُدِرت في كل Block.

---

## ما بيحصل في عمليات Copy/Move/Remove

### الـ Copy على نفس الـ Filesystem

```
1. احجز Inode جديد
2. اكتب نسخة من البيانات على Blocks جديدة
3. اعمل Pointer في الـ Directory الجديدة
```

### الـ Move على نفس الـ Filesystem

```
1. سيّب Data Blocks زي ما هي (لا تتحرك!)
2. سيّب الـ Inode زي ما هو
3. غيّر بس الـ Pointer في الـ Directory
```

> عشان كده Move على نفس الـ Partition = **سريع جداً** (بس بيتغير الـ Pointer)

### الـ Move بين Partition وتاني

```
1. احجز Inode جديد في الـ Partition الجديد
2. انقل نسخة من البيانات
3. اعمل Pointer في المكان الجديد
4. امسح الـ Pointer القديم (علّم الـ Inode "Free")
```

> عشان كده Move بين Partitions = **بطيء** (نسخ + حذف)

### Remove

```
1. علّم الـ Inode "Free" (ست Free)
2. البيانات فعلياً لسه موجودة على الديسك!
```

> [!important] سر استرجاع الملفات لما تمسح ملف، البيانات مش بتتمسح فعلياً — بس الـ Inode بيتحرر. عشان كده أدوات الـ Recovery ممكن تسترجع الملف لو ما اتكتبش فوقيه.
> 
> **لو محتاج Recovery: لا تكتب أي حاجة جديدة على الـ Disk!**


---

##  Soft Links vs Hard Links

### Soft Link (Symbolic Link) — الـ Shortcut

```bash
ln -s /path/to/original /path/to/link
```

```
Directory A:
file1 → Inode 500 → Data Block
   ↑
Directory B:
file2 → "file1" (اسم، مش Inode!)
```

**خصائص:**

- بيشاور على **اسم الملف** مش على الـ Inode
- ممكن يشتغل **بين Filesystems مختلفة**
- ممكن يشتغل على **Directories**
- لو الملف الأصلي اتمسح → **Link بيكسر** (ظاهر باللون الأحمر)
- بياخد **Inode مختلف** عن الأصل

```bash
ls -la file2    # هتلاقي → file1 (بيشاور على الاسم)
```

### Hard Link — ريفرنس للـ Inode نفسه

```bash
ln /path/to/original /path/to/link
```

```
Directory A:
file1 → Inode 500 → Data Block
                ↑
Directory B:
file2 → Inode 500 (نفس الـ Inode!)
```

**خصائص:**

- بيشاور على **نفس الـ Inode**
- لازم يكون على **نفس الـ Filesystem**
- **مش بيشتغل على Directories**
- لو الأصل اتمسح → **Hard Link لسه شغال** (البيانات موجودة)
- بياخد **نفس الـ Inode Number**

```bash
ls -lai file1 file2    # هتلاقي نفس الـ Inode Number
```

---

### ملاحظة على Directory Listing

```
الأمر ls -lai بيشوف:
file1   Inode 500
file2   Inode 500   ← نفس الرقم = Hard Link

الملف الأخضر في ls → Executable
الملف الأبيض → ملف عادي
اللون اللبني → Soft Link (شغال)
اللون الأحمر → Soft Link مكسور (broken)
```

---

##  Disk Naming — أسماء الـ Disks والـ Partitions

### الـ PATA/IDE (القديم)

```
/dev/hda   → أول Disk (Primary Master)
/dev/hdb   → تاني Disk (Primary Slave)
/dev/hdc   → تالت Disk (Secondary Master)
/dev/hdd   → رابع Disk (Secondary Slave)
```

|Partition|الاسم|
|---|---|
|أول Primary|`/dev/hda1`|
|أول Logical|`/dev/hda5`|

### الـ SATA/SCSI/SSD/SAS (الحديث)

```
/dev/sda   → أول Disk
/dev/sdb   → تاني Disk
/dev/sdc   → تالت Disk
```

| Partition    | الاسم                           |
| ------------ | ------------------------------- |
| أول Primary  | `/dev/sda1`                     |
| تاني Primary | `/dev/sda2`                     |
| الـ Extended | `/dev/sda4` (لو 3 Primary قبله) |
| أول Logical  | `/dev/sda5`                     |
| تاني Logical | `/dev/sda6`                     |

> [!important] قاعدة مهمة الـ **Logical** دايماً بتبدأ تعد من **5** — حتى لو استخدمت Primary واحدة بس! الـ 1-4 محجوزة للـ Primary والـ Extended.

---

### Virtual Machines

```
/dev/vda   → Virtual Disk (VMware, KVM, etc.)
```

---

### Optical Drives (CD/DVD)

```
/dev/sr0   → أول optical drive (CD/DVD/Blu-ray)
/dev/sr1   → تاني optical drive
```

> بدل ما يعمل `/dev/cdrom` و `/dev/dvd` و `/dev/dvdrw` كل واحدة لوحدها، اللينكس بيعمل Soft Links كلها بتشاور على `/dev/sr0`.

---

### أوامر مهمة

```bash
lsblk            # عرض كل الـ Disks والـ Partitions
df -h            # مساحة الـ Filesystem الحرة
df -i            # الـ Inodes
df -hT           # مع نوع الـ Filesystem
```

---

## 🌱 Format والـ Filesystem

```
Format = "تجهيز الأرض للزراعة"
```

عملية الـ Format بتعمل:

1. مسح (أو إعادة كتابة) الـ Partition Table
2. إنشاء الـ Inode Table للـ Partition
3. تحديد الـ Block Size

> [!warning] Format = مسح البيانات لو عملت Format لـ Partition فيه داتا → مع السلامة! لازم تعمل Format في حالتين فقط:
> 
> 1. ديسك جديد من أول وجديد
> 2. عايز ترجع الديسك Raw وتبدأ من الأول

---


# # Linux Disk Partitioning
## 🔧 الإعداد — إضافة هارد ديسك جديد للـ VM

### المواصفات الابتدائية للـ VM

- RAM: 2 GB
- CPU: 2 Cores
- HDD الأول: 100 GB (مستخدم منه 3 GB فقط)
- HDD الثاني (جديد): **20 GB** — نوع **SCSI** (الموصى به للـ Virtual Environment)

### ⚠️ ملاحظة مهمة: الديسك مش بيظهر فور الإضافة

عند إضافة ديسك وهو شغال (Hot-plug):

- على **Physical Machine**: لازم تعمل **Restart**
- على **Virtual Machine**: لازم تعمل **Shutdown** كامل ثم إعادة تشغيل

**السبب:** الـ BIOS بيعمل Detect للهاردوير بس أول ما المكنة تبدأ. الـ VM settings بتتقرأ من ملف `.vmx` فقط لما المكنة تبدأ.

### الحل البديل (بدون Shutdown): `sg3_utils`

```bash
# تفرس الـ VM تعمل Rescan للـ SCSI Bus وهي شغالة
# يشتغل مع Virtual و Physical Hardware
```

> سيتم شرحها في درس قادم

---

##  أوامر عرض الديسكات

### `lsblk` — عرض الديسكات والبارتيشنز

```bash
lsblk
```

- يعرض كل الديسكات المتصلة بالمكنة
- يعرض البارتيشنز تحت كل ديسك

### `fdisk -l` — معلومات تفصيلية

```bash
fdisk -l              # كل الديسكات
fdisk -l /dev/sdb     # ديسك معين بس
```

**مثال على الـ Output:**

```
Disk /dev/sda: 100 GB
Sector size: 512 bytes
Disk label type: dos (MBR)

/dev/sda1   2048    ...   512 MB   Linux
/dev/sda2   ...     ...   ~100 GB  LVM
```

**معلومات مهمة في الـ Output:**

|المعلومة|المعنى|
|---|---|
|Disk label type: dos|نوع البارتيشن تيبل = MBR|
|Sector size: 512 bytes|حجم كل Sector|
|System ID|نوع الـ File System للبارتيشن|

---

##  fdisk — إنشاء وحذف البارتيشنز

> **⚠️ قاعدة مهمة:** `fdisk` بيتعامل مع الـ **Disk** مش البارتيشن

```bash
fdisk /dev/sdb    # افتح الديسك كله مش بارتيشن فيه!
```

### أوامر داخل fdisk

|الأمر|الوظيفة|
|---|---|
|`m`|Help — عرض كل الأوامر|
|`n`|New partition|
|`p`|Primary partition|
|`e`|Extended partition|
|`d`|Delete partition|
|`P`|Print partition table|
|`w`|Write (حفظ التغييرات — **خطير!**)|
|`q`|Quit بدون حفظ|

### ⚠️ كل التغييرات في الـ Memory — مش على الديسك!

> `fdisk` بيحفظ كل حاجة في الـ RAM لحد ما تعمل `w`. لو عملت `Ctrl+C` مش هيتغير أي حاجة على الديسك.

### إنشاء Primary Partition

```
Command: n
Partition type: p (Primary)
Partition number: 1
First sector: [Enter] (افتراضي = أول sector فاضي)
Last sector: +5G    ← أسهل من حساب السيكتورز!
```

**طرق تحديد حجم البارتيشن:**

```
+5G    ← 5 جيجا
+500M  ← 500 ميجا
+1T    ← 1 تيرا
2097152  ← رقم السيكتور (صعب ومؤلم!)
```

### ليه أول 2048 Sector محجوزين؟

- أول **2048 sector** = ~128 MB
- محجوزين للـ Bootloader والـ MBR
- البارتيشن بيبدأ من بعدهم تلقائياً

### إنشاء Extended وLogical Partitions

```
fdisk: n → e  → Extended (لازم تعملها قبل Logical)
fdisk: n → l  → Logical (بيظهر بس لو في Extended موجود)
```

> **قاعدة:** المكنة مش بتعرضلك Logical إلا لو عندك Extended أصلاً.

### تأكيد التغييرات قبل الحفظ

```bash
# داخل fdisk — اعمل Print قبل Write
Command: p
```

يعرضلك شكل الديسك بعد التغييرات **لو عملت Write دلوقتي**.

### حفظ التغييرات

```bash
Command: w   # Write إلى الديسك — لا رجعة!
```

---

## 🏷️ مفهوم System ID

كل بارتيشن عنده **System ID** — رقم بيحدد نوع الـ File System.

|نوع الـ File System|System ID|
|---|---|
|FAT32|0x0B|
|NTFS|0x07|
|Linux (ext2/3/4/xfs)|0x83|
|Linux LVM|0x8E|
|Linux RAID|0xFD|
|HFS+ (Apple)|0xAF|

> **السبب:** عشان الـ OS يعرف نوع كل بارتيشن من غير ما يفتحه.

---

## 📢 partprobe — إخبار الـ Kernel بالتغييرات

```bash
partprobe /dev/sdb
```

**متى تستخدمه؟**

- بعد أي تعديل على البارتيشن تيبل
- الـ Kernel بيقرأ البارتيشن تيبل أول ما يشوف الديسك — لو عدّلته لازم تقوله يقرأه تاني

> بدون `partprobe` → الـ Kernel لسه شايف النسخة القديمة من البارتيشن تيبل

```bash
partprobe          # يسكان كل الديسكات
partprobe /dev/sdb # ديسك معين بس (أسرع وأأمن)
```

---

## 🗄️ إنشاء File System (mkfs)

> **⚠️ قاعدة مهمة:** `mkfs` بيتعامل مع الـ **Partition** مش الديسك كله

```bash
mkfs.ext4  /dev/sdb1   # ✅ صح
mkfs.ext4  /dev/sdb    # ❌ غلط — هتفرمت الديسك كله!
```

### أنواع الـ File Systems

|الأمر|النوع|
|---|---|
|`mkfs.ext2`|Extended 2 (قديم)|
|`mkfs.ext3`|Extended 3|
|`mkfs.ext4`|Extended 4 (شائع)|
|`mkfs.xfs`|XFS (سريع جداً في الـ Format)|
|`mkfs.btrfs`|Btrfs|

### مثال

```bash
mkfs.ext4 /dev/sdb1
mkfs.xfs  /dev/sdb2
```

### الفرق بين ext4 و xfs في الـ Format Speed

**ext4:**

- بياخد وقت أطول خصوصاً على الديسكات الكبيرة
- مثال: 4 ديسكات × 3TB = 12TB → ممكن تاخد **45 دقيقة**!

**XFS:**

- Format شبه فوري حتى على الـ 6TB
- مفيد جداً في Production مع الـ RAID وال LVM

### Block Size

```bash
mkfs.ext4 -b 4096 /dev/sdb1    # Block size = 4KB (الافتراضي)
mkfs.ext4 -b 1024 /dev/sdb1    # Block size = 1KB
```

> **لما تغير Block Size:**
> 
> - الـ Database كبيرة بملفات قليلة → Block size كبير (أقل Inodes → بحث أسرع)
> - ملفات صغيرة كتير → Block size صغير (توفير مساحة)

---

##  Super Blocks — نسخ الأمان

### ما هو Super Block؟

الـ **Super Block** = الـ Inode Table الرئيسي للبارتيشن.

- بيحتوي على **Metadata** عن كل الملفات (مش الـ Data نفسها)
- لو اتمسح → مش هتقدر توصل لأي ملف

### نسخ متعددة للأمان

الـ `mkfs` بيعمل **أكتر من نسخة** من الـ Super Block في أماكن مختلفة على البارتيشن.

**عدد النسخ بيعتمد على حجم البارتيشن:**

|حجم البارتيشن|عدد نسخ الـ Super Block|
|---|---|
|صغير (500MB)|2-3 نسخ|
|كبير (100GB)|~8 نسخ|
|كبير جداً (6TB)|10-16 نسخ|

> **السبب:** لو الـ Super Block الرئيسي اتمسح → النظام يرجع لنسخة احتياطية.

### عرض معلومات الـ File System

```bash
dumpe2fs /dev/sdb1    # يعرض كل تفاصيل الـ ext2/3/4 File System
```

**Output يشمل:**

- Inode size
- عدد الـ Inodes
- تاريخ الإنشاء
- آخر Mount
- آخر Write
- Mount options
- مواقع الـ Super Blocks الاحتياطية

---

##  Inode Table

### ما هو الـ Inode؟

كل **4KB Block** على الديسك بيمثله **Inode واحد** في الـ Inode Table.

الـ Inode بيخزن **Metadata** فقط:

- رقم الـ Block
- الـ Permissions
- الـ Owner
- Access Time
- Modification Time

> ❌ الـ Inode **لا** يخزن الـ Data نفسها — فقط معلومات عنها

**تشبيه:** الـ Inode Table = **فهرس الكتاب** — والـ Data = محتوى الكتاب نفسه

### حجم الـ Inode Table

صغير جداً مقارنة بالـ Data:

- بارتيشن 500MB → Inode Table كلها ~20-30 MB
- بارتيشن 100GB → Inode Table ~2 GB
- بارتيشن 1TB → أقل من 5 GB للـ Inode Table كلها مع نسخها

### تغيير Inode Size

```bash
mkfs.ext4 -I 512 /dev/sdb1    # Inode size = 512 bytes (الافتراضي 256)
```

---

## 🔗 Mount و Unmount

> **⚠️ مهم:** لازم تعمل Mount قبل ما تقدر توصل للبارتيشن

### Mount

```bash
mount /dev/sdb1 /media
mount /dev/sdb2 /mnt/data
```

### Unmount

```bash
umount /media       # بـ "u" مش "un"
```

### التحقق من المساحة

```bash
df -h    # يعرض كل الـ Mounted Partitions وحجمها
```

**مثال:**

```
Filesystem      Size  Used Avail Use% Mounted on
/dev/sdb1        20G   69M   20G   1% /media
```

### ⚠️ لازم تعمل Unmount قبل الـ File System Check

> عمل `e2fsck` على Partition وهو Mounted = **Data Corruption**!

---

##  مسح البارتيشن وإرجاع الديسك Raw

### حذف البارتيشن بـ fdisk

```bash
fdisk /dev/sdb
Command: d    # Delete
Command: w    # Write
partprobe /dev/sdb
```

> بعد الحذف: البارتيشن راح، لكن الـ MBR/Partition Table لسه موجود!

### مسح الـ Partition Table نفسه

**الطريقة 1: dd مع /dev/zero (الموصى بها)**

```bash
dd if=/dev/zero of=/dev/sdb bs=1 count=512
```

- يكتب أصفار على أول 512 bytes (= كل الـ MBR)
- أو `count=64` لمسح الـ Partition Table بس (64 bytes)

**الطريقة 2: dd مع /dev/random (مش موصى بها)**

```bash
dd if=/dev/random of=/dev/sdb bs=1 count=512
```

### ⚠️ الفرق بين /dev/zero و /dev/random

|الملف|ما يكتب|المشكلة|
|---|---|---|
|`/dev/zero`|أصفار ثابتة|✅ لا يوجد|
|`/dev/random`|أحرف عشوائية من كل اللغات|❌ قد لا يكتب المساحة المطلوبة بالكامل بسبب encoding|
|`/dev/urandom`|نفس المشكلة|❌ نفس المشكلة|

**السبب التقني:** الـ `random` بيكتب characters من كل اللغات (عربي، هندي، عبري...) وكل حرف بياخد bytes مختلفة حسب الـ encoding. لو الـ File بيحفظ بـ ANSI فالحروف غير اللاتينية بتتقلص وما بتاكلش المساحة الصح.

> **الخلاصة: دايماً استخدم `/dev/zero` لمسح الـ Partition Table**

### بناء MBR جديد

```bash
fdisk /dev/sdb
# مجرد فتح وإغلاق بـ w → بيبني MBR تلقائياً
Command: n → p → 1 → [Enter] → +10G
Command: w
partprobe /dev/sdb
```

---

## File System Check (e2fsck)

### متى تحتاجه؟

- بعد انقطاع الكهرباء فجأة
- لو الـ OS طلب منك Check عند البداية

###  شروط قبل الـ Check

```
1. الـ Partition لازم يكون UNMOUNTED أولاً
2. خد Backup قبل تعمل Force Check
```

### الاستخدام الأساسي

```bash
umount /dev/sdb1          # أولاً — Unmount
e2fsck /dev/sdb1          # ثانياً — Check
```

### Force Check

```bash
e2fsck -f /dev/sdb1    # Force check حتى لو الـ FS تبدو سليمة
```

> لو لقى مشاكل هيسألك تصلحها — قوله Yes

### لو ما قدرش يكمل بسبب Corruption

```bash
# قبل أي Force Check → خد Backup الأول
dd if=/dev/sdb1 of=/backup/sdb1.bak

# بعد الـ Backup
e2fsck -f /dev/sdb1
```

### Restore من الـ Backup

```bash
dd if=/backup/sdb1.bak of=/dev/sdb1
```

---

## 📊 أوامر مفيدة متنوعة

### dd — نسخ ومسح

```bash
# نسخ ملف
dd if=/dev/zero of=bigfile.img bs=1M count=100   # يعمل ملف 100MB من أصفار

# الـ Block Size وعدد الـ Blocks
# bs=1M count=100  → 100 × 1MB = 100MB
# bs=1  count=64   → 64 × 1byte = 64 bytes
```

### التحقق من الـ Encoding

```bash
# المشكلة: نص عربي تحفظه بـ ANSI → يتخرب
# الحل: احفظ بـ UTF-8 أو Unicode

# ANSI      = حروف لاتينية فقط، حجم ملف أصغر
# UTF-8     = يدعم كل اللغات، حجم أكبر
```

### xfs_info — معلومات الـ XFS

> سيتم شرحها في درس قادم

---

## 📝 الـ MBR — تركيبه

|الجزء|الحجم|الوظيفة|
|---|---|---|
|Boot Loader|446 bytes|تحميل الـ OS|
|Partition Table|64 bytes|معلومات البارتيشنز|
|Magic Number|2 bytes|Checksum للتحقق|
|**المجموع**|**512 bytes**||

---

## ✅ التاسك المطلوب

> **Deadline:** يوم الأحد

### المهمة:

1. أضف **ديسك جديد** اسمه `/dev/sdb` بحجم 20GB
2. عمل عليه **بارتيشنين** كلهم Primary:

|البارتيشن|الحجم|نوع الـ FS|Mount Point|
|---|---|---|---|
|`/dev/sdb1`|5 GB|**ext4**|`/data`|
|`/dev/sdb2`|8 GB|**XFS**|`/work`|

3. عمل **Mount Points** جديدة:

```bash
mkdir /data
mkdir /work
mount /dev/sdb1 /data
mount /dev/sdb2 /work
```

---

## 🔜 الدرس القادم

- تفاصيل الـ **Mount** بالكامل
- مقدمة لـ **LVM** (Logical Volume Manager)
- الفرق بين ext2, ext3, ext4, XFS
- **sg3_utils** لإضافة ديسكات وهي شغالة

---

## 💡 ملخص الـ Workflow الكامل

```bash
# 1. تعرف على الديسكات
lsblk
fdisk -l

# 2. فتح الديسك وعمل بارتيشن
fdisk /dev/sdb
# داخله: n → p → 1 → [Enter] → +5G → w

# 3. إخبار الـ Kernel
partprobe /dev/sdb

# 4. عمل File System
mkfs.ext4 /dev/sdb1

# 5. عمل Mount
mkdir /data
mount /dev/sdb1 /data

# 6. التحقق
df -h
```

---

> **تذكر دايماً:**
> 
> - `fdisk` → للديسك كله
> - `mkfs` → للبارتيشن
> - `partprobe` بعد أي تعديل
> - `umount` قبل `e2fsck`
> - `dd if=/dev/zero` مش `/dev/random` لمسح الـ MBR
> - خد **Backup** قبل أي Force Check!



---

# # Compressing & Archiving Files 

---

## ⚖️ الفرق بين gzip و bzip2

|الخاصية|`gzip`|`bzip2`|
|---|---|---|
|**السرعة**|✅ أسرع|🐢 أبطأ|
|**Compression Ratio**|متوسط|✅ أعلى (أقل مساحة)|
|**الاستخدام الأمثل**|لما تحتاج سرعة|لما تحتاج أقل مساحة ممكنة|

> [!tip] قاعدة سهلة للاختيار
> 
> - **سرعة** → `gzip`
> - **أقل مساحة** → `bzip2`

---

##  تجربة عملية — ضغط ملف نصي كبير

### إنشاء ملف نصي كبير للتجربة

```bash
# إنشاء ملف نصي كبير عن طريق redirect output من ls
ls / > myfile
```

> [!info] ملاحظة الأمر ده عمل redirect للـ output بس **مش** للـ error، فممكن تظهر رسائل error في الشاشة وده طبيعي

```bash
# التحقق من حجم الملف
ls -lh myfile
# النتيجة: ~18 MB
```

---

### ضغط بـ gzip

```bash
# ضغط الملف
gzip myfile
# الناتج: myfile.gz

# التحقق من الحجم بعد الضغط
ls -lh myfile.gz
# النتيجة: ~1.5 MB (من 18 MB!)
```

```bash
# فك الضغط
gunzip myfile.gz
# يرجع الملف لأصله: myfile
```

---

### ضغط بـ bzip2

```bash
# ضغط الملف
bzip2 myfile
# الناتج: myfile.bz2

# التحقق من الحجم
ls -lh myfile.bz2
# النتيجة: ~975 KB (أقل من gzip!)
```

```bash
# فك الضغط
bunzip2 myfile.bz2
```

> [!example] مقارنة النتائج العملية
> 
> - الملف الأصلي: **18 MB**
> - بعد `gzip`: **~1.5 MB**
> - بعد `bzip2`: **~975 KB** ✅ أصغر

---

### قياس وقت الضغط باستخدام `time`

```bash
time gzip myfile
# النتيجة: ~4 ثواني
```

> [!warning] bzip2 بياخد وقت أكبر من gzip لأن الـ Compression Ratio بتاعه أعلى، يعني بيشتغل أكتر عشان يضغط أكتر

---

## ❗ استثناء مهم — الفيديو والصوت

> [!important] ملفات الفيديو والأوديو **لا تخضع** لعمليات الضغط العادية!
> 
> **السبب:**
> 
> - ضغط النصوص بيشتغل على البيانات النصية
> - ضغط الفيديو/الصوت بيشتغل بطريقة **مختلفة تماماً**
> 
> **إزاي بيشتغل ضغط الفيديو؟**
> 
> - كل بيكسل على الشاشة عنده قيمة RGB
> - ضغط الفيديو ببساطة بيقلل **عدد البكسلز** (الـ Resolution)
> - مش بيضغط نص، بيقلل عدد النقاط
> 
> **النتيجة:**
> 
> - في برامج متخصصة لضغط الفيديو والصوت منفصلة تماماً
> - الـ Algorithms مختلفة زي Manchester Encoding وغيرها

---

##  الفرق بين Compression و Archiving

> [!important] الفرق الأساسي
> 
> ||**Compression**|**Archiving**|
> |---|---|---|
> |**الهدف**|تقليل المساحة|جمع ملفات في ملف واحد|
> |**هل المساحة بتقل؟**|✅ نعم|❌ ليس بالضرورة|
> |**المثال**|gzip, bzip2|tar|

> [!quote] تشبيه مبسّط الأرشفة زي ما تاخد أوراق كتير وتحطهم في فايل واحد — جمعتهم في مكان واحد لكن الحجم الإجمالي مش بالضرورة اتقلل

---

##  أوامر du لمعرفة حجم المجلدات

```bash
# إظهار حجم كل ملف جوه المجلد واحد واحد
du /etc

# إظهار الحجم الإجمالي فقط (Summary)
du -s /etc

# إظهار الحجم الإجمالي بشكل Human Readable
du -sh /etc
```

> [!note] شرح الأوبشنز
> 
> - **`-s`** = Summary → بيجيب الناتج النهائي الإجمالي بس
> - **`-h`** = Human Readable → بيعرض بـ MB/GB بدل Bytes
> - **`-sh`** = الاتنين مع بعض

---

##  الأرشفة باستخدام `tar`

### أصل الكلمة

> [!info] تاريخ `tar` `tar` اختصار لـ **T**ape **AR**chive الناس قديماً كانت بتعمل backup وتحطه على **Tapes** (أشرطة)، فأول أداة اتعملت لأخد Directory كاملة وحطها على الشريط اتسمت `tar`

---

### أوبشنز tar الأساسية

|الحرف|المعنى الكامل|الوظيفة|
|---|---|---|
|`c`|**C**reate|إنشاء أرشيف جديد|
|`x`|e**X**tract|فك الأرشيف|
|`t`|lis**T**|عرض محتويات الأرشيف بدون فكّه|
|`v`|**V**erbose|عرض الملفات أثناء العملية|
|`f`|**F**ile|تحديد اسم ملف الأرشيف|
|`z`|gzip|استخدام ضغط gzip|
|`j`|bzip2|استخدام ضغط bzip2|

---

###  ملاحظة مهمة جداً عن `tar`

> [!warning] `tar` لا يحتاج `-` قبل الأوبشنز!
> 
> ```bash
> tar cvf archive.tar folder/    # ✅ الصح
> tar -cvf archive.tar folder/   # يشتغل لكن مش الأصل
> ```
> 
> `tar` هو **واحد من الأوامر النادرة جداً** في Linux اللي الأوبشنز بتاعته بتيجي **بدون `-`**
> 
> لو قلت `tar --help` هيشتغل، لكن بعض الأوبشنز بتاخد معنى تاني لما تحط معاها `-` من غير `-`

---

##  الأوامر الكاملة مع أمثلة

### إعداد التجربة

```bash
# أخد نسخة من /etc للتجربة
cp -r /etc .

# التحقق من حجم المجلد
du -sh /etc
# النتيجة: ~35 MB
```

---

### 1️-أرشفة فقط (بدون ضغط)

```bash
# إنشاء أرشيف
tar cvf etc-backup.tar etc/
- هنا انته بتقوله يعمل ملف ويسميه باكابب  ويكون محتواه ايتيسيى    
# التحقق من الحجم
ls -lh etc-backup.tar
# النتيجة: ~31 MB (قريبة من 35 MB — تقريباً نفس المساحة!)
```

> [!note] ليه المساحة فرقت شوية رغم إن الأرشفة مش بتقلل المساحة؟ لأن الأرشفة لوحدها بتوفر overhead بسيط من metadata الملفات، زي ما لما تحط أوراق في فايل — فرق بسيط جداً

---

### 2️⃣ أرشفة + فك الأرشيف (بدون ضغط)

```bash
# حذف المجلد الأصلي
rm -rf etc

# استرجاع المجلد من الأرشيف
tar xf etc-backup.tar

# التحقق إن الحجم رجع
du -sh etc
```

- هنا xf  دى بتقول extract file فك ضغط الملف الى هوا بدون ضغط 
- هنا بيفك الضغط ولكن مش بيحذفها 
```bash
┌─[bat@parrot]─[~/Music]
└──╼ $tar -cf  task.tar  task\ details.docx 


┌─[bat@parrot]─[~/Music]
└──╼ $tar -xf task.tar 


-rw-r--r-- 1 bat bat  96813 فبر 17 14:35 'task details.docx'
-rw-r--r-- 1 bat bat 102400 فبر 22 13:18  task.tar

```


- هنا الملف مش بيتمسح حتى بعد لما بتفك الضغط

---

### 3️- أرشفة مع Verbose (عرض الملفات أثناء العملية)

```bash
# إنشاء أرشيف مع verbose
tar cvf etc-backup.tar etc/
# هيعرضلك اسم كل ملف وهو بيتضاف
```

```bash
# فك أرشيف مع verbose
tar xvf etc-backup.tar
# هيعرضلك اسم كل ملف وهو بيتفك
```

---

### 4️- أرشفة + ضغط بـ gzip

```bash
# إنشاء أرشيف مضغوط بـ gzip
tar cvzf etc-backup.tar.gz etc/
```
x
> [!tip] الامتداد الصح لـ gzip `.tar.gz` — لازم يكون الامتداد كده عشان تعرف إنه أرشيف مضغوط بـ gzip

```bash
# فك الأرشيف المضغوط بـ gzip
tar xvzf etc-backup.tar.gz
```

---

### 5️-أرشفة + ضغط بـ bzip2

```bash
# إنشاء أرشيف مضغوط بـ bzip2
tar cvjf etc-backup.tar.bz2 etc/
```

> [!tip] الامتداد الصح لـ bzip2 `.tar.bz2` — الامتداد لازم يكون كده

```bash
# فك الأرشيف المضغوط بـ bzip2
tar xvjf etc-backup.tar.bz2
```

> [!warning] bzip2 بياخد وقت أكبر لأن الـ Compression Ratio بتاعه أعلى، هتلاقيه أبطأ من gzip

---

### مقارنة النتائج العملية على /etc (35 MB)

```
أرشفة فقط (tar):          ~31 MB   (نفس تقريباً)
أرشفة + gzip (.tar.gz):   أقل بكتير
أرشفة + bzip2 (.tar.bz2): أقل من gzip ✅
```

---

##  عرض محتويات الأرشيف بدون فكّه

```bash
# عرض محتويات tar عادي
tar tvf etc-backup.tar

# عرض محتويات tar.gz
tar tvzf etc-backup.tar.gz

# عرض محتويات tar.bz2
tar tvjf etc-backup.tar.bz2
```

> [!example] فايدة عملية تقدر تشوف إيه جوه الأرشيف **بدون ما تفكّه** أصلاً!
> 
> ```bash
> ls -lh
> # /etc مش موجودة
> 
> tar tvzf etc-backup.tar.gz
> # بيعرضلك كل الملفات الموجودة جوا الأرشيف
> ```

---

##  ألوان الـ Terminal ومعناها

> [!info] ألوان `ls --color`
> 
> - 🔴 **أحمر** = ملف مضغوط أو مؤرشف (compressed/archived file)
> - **أسود على أحمر** (داكن جداً) = Broken Symbolic Link — بيشاور على حاجة مش موجودة

---

##  ملخص الصيغة العامة لـ tar

```
tar  [أوبشنز]  [اسم الأرشيف الناتج]  [المصدر]
tar    cvf      etc-backup.tar         etc/
tar    cvzf     etc-backup.tar.gz      etc/
tar    cvjf     etc-backup.tar.bz2     etc/
tar    xvf      etc-backup.tar
tar    xvzf     etc-backup.tar.gz
tar    xvjf     etc-backup.tar.bz2
tar    tvzf     etc-backup.tar.gz
tar    tvjf     etc-backup.tar.bz2
```

---

## 🔄 Cheat Sheet كامل

```bash
# ===== ضغط ملف واحد =====
gzip myfile                  # → myfile.gz
bzip2 myfile                 # → myfile.bz2

# ===== فك ضغط ملف =====
gunzip myfile.gz             # → myfile
bunzip2 myfile.bz2           # → myfile

# ===== قياس وقت عملية =====
time gzip myfile

# ===== حجم مجلد =====
du /etc                      # كل ملف لوحده
du -s /etc                   # إجمالي فقط
du -sh /etc                  # إجمالي بشكل مقروء

# ===== أرشفة فقط =====
tar cvf archive.tar folder/
tar xvf archive.tar
tar tvf archive.tar          # عرض المحتويات

# ===== أرشفة + gzip =====
tar cvzf archive.tar.gz folder/
tar xvzf archive.tar.gz
tar tvzf archive.tar.gz      # عرض المحتويات

# ===== أرشفة + bzip2 =====
tar cvjf archive.tar.bz2 folder/
tar xvjf archive.tar.bz2
tar tvjf archive.tar.bz2     # عرض المحتويات
```

---

##  ملخص المفاهيم

> [!summary] خلاصة الدرس
> 
> 1. **Compression** = تقليل المساحة → `gzip` أو `bzip2`
> 2. **Archiving** = جمع ملفات في ملف واحد → `tar`
> 3. **Archiving + Compression** = الاتنين مع بعض → `tar` مع `-z` أو `-j`
> 4. **gzip** أسرع، **bzip2** أعلى compression ratio
> 5. الفيديو والصوت لهم طريقة ضغط **مختلفة تماماً** — لا تستخدم gzip/bzip2 عليهم
> 6. `tar` من الأوامر النادرة اللي **لا تحتاج `-`** قبل الأوبشنز

---



# # Process Management


### Program vs Process

|المصطلح|التعريف|
|---|---|
|**Program**|ملف Binary موجود على الديسك، لسه مش شغال (مش بياكل موارد)|
|**Process**|نفس الملف لما بدأت تشغله — بياكل CPU وـRAM وحاجز موارد|

> [!tip] بمعنى أبسط
> 
> - الـ Program = ملف exe/binary على الهارد **ساكن**
> - الـ Process = نفس الملف **وهو شغال فعلاً**

---

### دور الـ System Admin مع الـ Processes

دورك كـ SysAdmin مش إنك تكتب كود، دورك إنك **تتحكم** في الـ Processes:

**المستوى الأساسي (الكورس ده):**

- تشغّل Process
- تعمل لها Pause (Suspend)
- توقفها
- تعمل لها Terminate لو هنجت

**المستوى المتقدم (Performance Tuning):**

- تتحكم في قد إيه Process بتاخد من الـ RAM
- تتحكم في قد إيه بتكتب على الديسك (Read/Write Speed)
- تتحكم في قد إيه بتاخد من الـ CPU

> [!example] مثال عملي على المستوى المتقدم لو عندك Oracle Database شغالة وبتاخد موارد المكنة كلها:
> 
> ```
> RAM:   max 2GB
> Write Speed: max 10 KB/s
> Read Speed:  max 20 KB/s
> CPU:   max 1%
> ```
> 
> ده دورك في Performance Tuning لاحقاً

---

##  Process ID (PID) و Parent Process ID (PPID)

### الـ PID

> كل Process بتشتغل بياخد رقم فريد من الـ Kernel اسمه **PID (Process ID)**

### الـ PPID

> كل Process كمان عندها **PPID (Parent Process ID)** — رقم الـ Process اللي فتحتها

---

### ليه محتاج تعرف الـ PPID؟ — سببين مهمين

#### السبب الأول: Copy-On-Write (COW)

> [!info] إزاي Linux بيشغّل Process جديدة لما تفتح `nano` من الـ Shell مثلاً:
> 
> 1. هنا فى Linux **مش بيالوكيت** Memory من الصفر حتة بحتة
> 2. بدل كده بيعمل **نسخة طبق الأصل (Clone)** من الـ Shell في الـ RAM
> 3. بعدين بيـ Customize النسخة دي على قد ما الـ `nano` محتاج
> 
> **ليه ده أسرع؟** لأنه لو الـ Shell مثلاً كانت واخدة 20 MB، بدل ما يالوكيت 20 MB جديدة، بياخد Copy وبيتعامل معاها بشكل أسرع

#### الـ Shared Libraries وعلاقتها بـ COW

> [!info] الـ Shared Memory بين Processes
> 
> - برامج كتير بتستخدم نفس الـ C Libraries مثلاً
> - الـ Shell استخدمت 20 Library، الـ nano استخدمت 12 Library منهم مشتركة
> - Linux بيحط الـ Pages المشتركة في **Common Memory Space** واحد
> - الـ Shell بتشاور عليه، والـ nano بتشاور عليه برضو
> 
> **لو Process حبت تكتب على الـ Shared Page:**
> 
> - مش بيغيرها الأصلية
> - بيعمل لها نسخة منفصلة صغيرة (Slot) وبيكتب فيها بس
> 
> هذا هو مبدأ **Copy-On-Write**

#### السبب الثاني: إيقاف Process هنجت عن طريق الـ Parent

> [!warning] السيناريو العملي عندك Process هنجت وبقت **Not Responding**:
> 
> 1. بتجرب تعمل لها `kill` → مش بتستجيب
> 2. الحل: **اقتل الـ Parent بتاعها**
> 3. لما الـ Parent بتموت، الـ Child بتموت معها أوتوماتيك
> 
> **السبب:** الـ Child كانت مبنية على نفس الـ Shared Memory Space بتاع الـ Parent، لما الـ Parent راحت راحت معها

> [!example] مقارنة مع Windows في Windows لما Process تهنج، غالباً بتضطر تعمل **Restart كامل للجهاز**! في Linux: اقتل الـ Parent وخلاص، من غير Restart

---

##  أول Process على السيستم

### في RHEL 7 وما بعده (Systemd)

```
أول Process = systemd
PID بتاعها = 1
```

### في RHEL 6 وما قبله

```
أول Process = init
PID بتاعها = 1
```

> [!note] مين اللي بيفتح systemd أو init؟ الـ **Kernel** نفسه هو اللي بينادي عليهم، عشان كده الـ PPID بتاعت systemd = **0** (الـ Kernel)
> 
> دي أول Process، يعني PPID بتاعها = 0 (الـ Kernel نفسه)

> [!info] وظيفة systemd/init هي بتنادي على بقية الـ Services (Daemons) الموجودة على المكنة

---

##  أوامر عرض الـ Processes

### 1. `ps` — Process Status

```bash
# عرض Processes من الـ Terminal الحالي فقط
ps

# عرض كل الـ Processes من كل الـ Terminals
ps ax

# عرض تفصيلي لكل الـ Processes
ps aux

# عرض مع PID و PPID
ps -af
```

> [!warning] ملاحظة مهمة زي `tar`، الأمر `ps` فيه أوبشنز **بداش وبدون داش** وبتاخد معاني مختلفة
> 
> - `ps aux` (بدون داش) ← شغاله
> - `ps -aux` (بداش) ← ممكن يكون ليه معنى تاني

---

### تفسير عمود الـ STATUS في `ps aux`

|الحرف|المعنى|
|---|---|
|`S`|Sleeping — نايمة/مستنية|
|`R`|Running — شغالة دلوقتي|
|`T`|Stopped — متوقفة مؤقتاً (Paused)|
|`Z`|Zombie — خلصت بس الـ Parent لسه مش شافها|
|`D`|Uninterruptible Sleep|

---

### تفسير عمود الـ TTY

|القيمة|المعنى|
|---|---|
|`tty1`, `tty2`|Local Login|
|`pts/0`, `pts/1`|Remote Login (SSH) أو Graphical Terminal|
|`?`|Daemon — شغالة في الـ Background، مش مرتبطة بـ Terminal|

![[Pasted image 20260222135031.png]]

---

### ناتج `ps aux` — شرح الأعمدة

```
USER    PID  %CPU  %MEM   VSZ    RSS   TTY   STAT  START   TIME    COMMAND
root      1   0.0   0.1  172020  3964   ?     Ss    10:00   0:02    /usr/lib/systemd/systemd
```

| العمود    | المعنى                                         |
| --------- | ---------------------------------------------- |
| `USER`    | اليوزر اللي شغّل الـ Process                   |
| `PID`     | رقم الـ Process                                |
| `%CPU`    | قد إيه واخدة من الـ CPU                        |
| `%MEM`    | قد إيه واخدة من الـ RAM                        |
| `VSZ`     | Virtual Memory (مش محتاج تهتم بيها دلوقتي)     |
| `RSS`     | Residential Memory (مش محتاج تهتم بيها دلوقتي) |
| `TTY`     | الـ Terminal اللي شغالة منه                    |
| `STAT`    | الحالة                                         |
| `START`   | اشتغلت امتى                                    |
| `TIME`    | قد إيه اخدت من الـ CPU وقت فعلي                |
| `COMMAND` | اسم الـ Process/الأمر                          |

---

### 2. `ps -af` — مع PID و PPID

```bash
ps -af
```

**بيعرض:** User | PID | PPID | TTY | Start Time | CPU Time | Command

> [!example] مثال على ناتج `ps -af`
> 
> ```
> USER    PID   PPID  TTY     STIME  TIME     CMD
> mostafa 5539  5500  pts/2   10:15  00:00:01 bash
> ```
> 
> يعني مصطفى فتح bash من pts/2 (Remote/Graphical Login)

---

### 3. `pstree` — عرض في شكل Tree

```bash
pstree
```

> [!example] مثال على ناتج `pstree`
> 
> ```
> systemd─┬─ModemManager
>         ├─NetworkManager───dhclient
>         ├─gdm───Xorg
>         ├─sshd───bash───less───ps
>         └─vmware-tools
> ```
> 
> بيوريك مين اللي فتح مين بشكل واضح جداً

---

### 4. `pgrep` — البحث عن Process بالاسم

```bash
# بيجيب PID بتاع Process باسمها
pgrep firefox

# بيعمل kill للـ Process مباشرة باسمها
pkill firefox
```

> [!warning] خطورة `pkill`! لو عندك **أكتر من Instance** لنفس الـ Application:
> 
> ```bash
> pkill notepad   # هيقفّل كل النوت باد المفتوحة!
> ```
> 
> **الأفضل:**
> 
> ```bash
> pgrep firefox          # جيب الـ PID الأول
> kill <PID>             # اقفّل الـ Instance اللي عايزها بالـ PID
> ```


---

##  الـ Signals وأمر `kill`

### مبدأ عمل `kill`

> [!info] هنا `kill` لا يقتل مباشرة! الأمر `kill` بيبعت **Signal** للـ Process، مش بيقتلها مباشرة الـ Process هي اللي بتستقبل الـ Signal وبتتصرف بناءً عليه

---

### عرض كل الـ Signals المتاحة

```bash
kill -l
```

---

### أهم 3 Signals محتاجهم كـ SysAdmin

| رقم السيجنال | الاسم     | الوظيفة                                                                     |
| ------------ | --------- | --------------------------------------------------------------------------- |
| **1**        | `SIGHUP`  | بتخلي الـ Process تعمل **Reload لملف الـ Config** بتاعها (بدون إعادة تشغيل) |
| **9**        | `SIGKILL` | **قتل فوري** — بتطير رقبة الـ Process على طول                               |
| **15**       | `SIGTERM` | **إيقاف مؤدب** — بتسأل الـ Process تقفل (الـ Default)                       |

> [!important] الفرق بين Signal 9 و Signal 15 — مهم جداً!

#### Signal 15 (SIGTERM) — الـ Default

```bash
kill 5539        # نفس kill -15 5539
kill -15 5539
kill -SIGTERM 5539
```

- بتبعت طلب مؤدب: "لو سمحت اقفلي"
- الـ Process بتاخد وقتها تحفظ البيانات وتقفل بأمان
- **بنت ناس** — بتعمل Graceful Shutdown

#### Signal 9 (SIGKILL) — الـ Deadly Signal

```bash
kill -9 5539
kill -SIGKILL 5539
```

- بتقتلها من غير ما تسألها
- **ممكن يحصل Data Loss!** لو كانت لسه بتكتب على الديسك
- استخدمها بس لما الـ Process مش بتستجيب لـ Signal 15

> [!danger] قاعدة مهمة **دايماً جرب Signal 15 الأول** لو الـ Process مش بتستجيب، ساعتها استخدم Signal 9 متخليش Signal 9 هي الـ Default بتاعك عشان ممكن تخسر بيانات!

---

### مثال عملي — الفرق بين Signal 15 و Signal 9 على nano

```bash
# افتح nano
nano

# في Terminal تاني، اجيب PID بتاع nano
ps aux | grep nano
# PID = 7376 مثلاً

# Signal 15 — الإيقاف المؤدب
kill 7376
# nano بيقفل وبيديك فرصة تحفظ — بيرجع للـ Terminal بشكل نظيف

# افتح nano تاني
nano

# Signal 9 — القتل الفوري
kill -9 7376
# nano بيقفل بدون ما يكمل أي حاجة — ممكن مش يعمل cleanup صح
```

---

### استخدام Signals بشكل عملي

```bash
# الصيغة العامة
kill -<signal_number> <PID>
kill -<SIGNAL_NAME> <PID>

# أمثلة
kill -1 1234        # SIGHUP - Reload config
kill -9 1234        # SIGKILL - Force kill
kill -15 1234       # SIGTERM - Graceful kill (Default)

# باستخدام pgrep مع kill
kill $(pgrep firefox)
```

---

---

## 🔄 Foreground و Background

### المشكلة

لما بتشغّل Application من الـ Terminal:

```bash
firefox
```

الـ Terminal بيتحجز كله للـ Firefox! مش تقدر تكتب أي أمر تاني

---

### الحل: تشغيل في الـ Background

```bash
firefox &
```

الـ `&` في الآخر بتشغّل الـ Application في الـ **Background** ← الـ Terminal بيرجع حر فوراً

---

### أوامر إدارة الـ Background/Foreground

```bash
# عرض كل الـ Jobs (Processes) الشغالة في الـ Background
jobs
# الناتج: [1]+  Running    firefox &

# إرجاع Process من الـ Background للـ Foreground
fg %1        # رقم الـ Job في الـ Background
fg 1         # نفس الشيء

# إرسال Process من الـ Foreground للـ Background
# أولاً: عمل Pause لها
Ctrl + Z     # بيعمل Pause (Stopped) للـ Process
# ثانياً: إرسالها للـ Background وهي شغالة
bg %1        # بتشغّلها في الـ Background بعد الـ Pause
```

---

### اختصارات الـ Keyboard المهمة

|الاختصار|الوظيفة|
|---|---|
|`Ctrl + C`|**Terminate** — بيبعت `SIGINT` للـ Process ويوقفها نهائياً|
|`Ctrl + Z`|**Pause/Suspend** — بيعمل `SIGTSTP` ويوقفها مؤقتاً|

---

### مثال عملي كامل

```bash
# 1. تشغيل Firefox في الـ Background
firefox &
# [1] 7890  ← رقم الـ Job [1] والـ PID 7890

# 2. عرض الـ Jobs
jobs
# [1]+  Running    firefox &

# 3. إرجاعها للـ Foreground
fg %1
# Terminal بيتحجز لـ Firefox تاني

# 4. إرسالها للـ Background تاني
Ctrl + Z    # Pause أولاً
# [1]+  Stopped    firefox

jobs
# [1]+  Stopped    firefox

bg %1       # تشغيلها في الـ Background
# [1]+  Running    firefox &

# 5. إيقافها نهائياً
kill %1     # أو kill <PID>
# أو
Ctrl + C    # لو في الـ Foreground
```

---

## 📊 ملخص كل الأوامر

```bash
# ===== عرض الـ Processes =====
ps                    # Processes من الـ Terminal الحالي
ps ax                 # كل الـ Processes من كل الـ Terminals  
ps aux                # كل الـ Processes تفصيلية
ps -af                # مع PID و PPID
pstree                # في شكل Tree

# ===== البحث والـ Kill =====
pgrep <name>          # جيب PID بالاسم
pkill <name>          # اقفّل بالاسم (خطر لو أكتر من Instance!)
kill <PID>            # Signal 15 (Default)
kill -9 <PID>         # Force Kill
kill -1 <PID>         # Reload Config
kill -l               # عرض كل الـ Signals

# ===== Background/Foreground =====
<command> &           # شغّل في الـ Background
jobs                  # عرض الـ Jobs
fg %<n>               # Foreground
bg %<n>               # Background
Ctrl + Z              # Pause
Ctrl + C              # Terminate
```

---



---

## 👻 Foreground vs Background — وال Daemon

### Foreground Process

- أنت شايفها وبتتعامل معاها مباشرة
- لو الـ Terminal اتقفل → الـ Process اتقفلت

### Background Process (Daemon)

- شغالة في الخلفية، مش مرتبطة بـ Terminal
- في الـ TTY column بتلاقي علامة `?`

> [!info] ليه بيسموها Daemon؟ كلمة **Daemon** يعني عفريت/شيطان — لأنك ما بتشوفوش، بس تأثيره بيبان عليك (زي ما بيقول، بيوسوس في ودانك)
> 
> في Windows بيسموها **Service**

> [!important] الفرق بين Daemon و Service
> 
> - **Daemon** = أي Process شغالة في الـ Background
> - **Service** = عادةً Process بتستنى Request من يوزر (بتـ Listen على Port)
>     - SSH بيستنى Connection عشان يدي Remote Access
>     - Apache Web Server بيستنى Connection عشان يعرض Web Page
>     - FTP Server بيستنى Connection عشان ينقل ملفات
> 
> **لكن:** ممكن تشغّل أي Application خاص بيك كـ Daemon حتى لو مش بتستنى Connections من بره

---

### السؤال المهم: لو الـ Parent اتقفل، إيه اللي بيحصل للـ Background Process؟

> [!example] سيناريو عملي
> 
> 1. Firefox شغالة في الـ Background من الـ Terminal
> 2. عملت `kill` لـ Firefox → اشتغلت شوية وبعدين ظهرت تاني
> 3. **السبب:** لما عملت Terminate لـ Firefox، الـ Control بتاعها انتقل لـ systemd
> 4. systemd أعاد تشغيلها أوتوماتيك (لأنها مسجّلة كـ Service)

> [!info] قاعدة مهمة لو Process شغالة في الـ Background وعملت Terminate لـ Parent بتاعها:
> 
> - الـ Control بيروح لـ **systemd** (في RHEL 7+)
> - أو لـ **init** (في RHEL 6-)
> 
> لو انت شغّلت الـ Process من الـ Terminal في الـ Background وقفّلت الـ Terminal:
> 
> - الـ Control بيروح لـ systemd
> - الـ Process **مش هتقف** (هتفضل شغالة)
> 
> مثال: `service sshd restart` من Terminal → لو قفّلت الـ Terminal → SSH **مش** هيقف

---

##  تأكيد مثال الـ Parent-Child Termination

> [!example] إثبات عملي
> 
> ```bash
> # فتح nano من الـ Terminal
> nano myfile
> 
> # في Terminal تاني، اجيب PID بتاع nano وPPID بتاعه
> ps -af
> # PPID بتاع nano = رقم الـ bash (Terminal)
> 
> # اعمل kill للـ bash (الـ Parent)
> kill -t <bash_PID>
> # النتيجة: nano اتقفل أوتوماتيك لأن الـ Parent بتاعه اتقفل
> ```
> 
> **النتيجة:** لما الـ Parent بيتوقف، الـ Child بيتوقف معاه

---

##  أمر `top` — مراقبة الـ System في Realtime

```bash
top
```

> [!tip] `top` هو Task Manager بتاع Linux

### ما بيعرضه `top`

**الـ Header:**

|المعلومة|الوصف|
|---|---|
|**Uptime**|الجهاز شغال من امتى|
|**Users**|كم Login مفتوح (Sessions)|
|**Load Average**|اللود على الجهاز في آخر 1 دقيقة / 5 دقائق / 15 دقيقة|
|**Tasks**|كم Process شغالة / نايمة / Stopped / Zombie|
|**%CPU**|استهلاك CPU بالنسبة لـ User / System / Nice|
|**Memory**|RAM الكلية / المستخدمة / الفاضية / الـ Cache|
|**Swap**|الـ Virtual Memory|

---

### ⚠️ الـ Zombie Process

> [!warning] الـ Zombie Process لو شفت في `top` إن عندك **Zombie Process** → في **مشكلة** على السيستم
> 
> **الـ Zombie Process هي:**
> 
> - Process خلصت بس الـ Kernel مش قادر يعرف هي شغالة ولا لأ
> - بتستهلك Resources وهي مش شغالة فعلاً
> - مثل الـ "Undead" في الأفلام — لا حي ولا ميت

---

### التنقل في `top`

- ↑↓ للتنقل بين الـ Processes
- `q` للخروج
- `k` لإرسال Signal لـ Process من جوا `top`

---

### استخدام `top` لعمل Kill

```bash
# من جوا top:
# 1. حرّك المؤشر على الـ Process
# 2. اضغط k
# 3. هيسألك رقم الـ Process (هيقترح الـ Process اللي واقف عليها)
# 4. هيسألك رقم الـ Signal (Default = 15)
```

> [!note] ملاحظة اللي بيتحكم في الـ Priority في الـ top هو **Nice Value** مش الـ PR Value خليك فارق بين الاتنين

![[Pasted image 20260222141944.png]]

![[Pasted image 20260222142006.png]]

---

### عرض معلومات إضافية مع `ps`

```bash
# عرض PID, PPID, CPU, Memory, Nice Value, Command
ps -eo pid,ppid,%cpu,%mem,ni,comm

# تصفية لـ Process معينة
ps -eo pid,ppid,%cpu,%mem,ni,comm | grep firefox
```

---

## 🎯 Nice Value — التحكم في الأولوية

### ما هو الـ Nice Value؟

> الـ **Nice Value** هو القيمة اللي بتتحكم في **Priority** (الأولوية) بتاعة الـ Process

**القيم المتاحة:**

| القيمة  | المعنى                               |
| ------- | ------------------------------------ |
| **0**   | الـ Default — أولوية عادية           |
| **-20** | أعلى أولوية ممكنة (Highest Priority) |
| **+19** | أقل أولوية ممكنة (Lowest Priority)   |

---

### تذكر السهل: المنطق العكسي

> [!tip] تشبيه سهل للحفظ فكّر في واحد **عليه فلوس** ← بيجري وبيتنطط عشان يسد الديون → **ينفذ بسرعة** فكّر في واحد **معاه فلوس كتير** ← ماشي براحته مش مستعجل → **ينفذ بطيء**
> 
> - **-20** (عليه فلوس) = بيجري ← أعلى أولوية
> - **+19** (معاه فلوس) = ماشي براحته ← أقل أولوية

---

### صلاحيات تغيير الـ Nice Value

|المستخدم|ما يستطيع فعله|
|---|---|
|**User عادي**|يقلّل الأولوية فقط (من 0 → +19)|
|**User عادي**|❌ لا يستطيع رفع الأولوية (من 0 → -1 وما دون)|
|**Root**|يستطيع كل شيء (رفع وتنزيل)|
|**Root**|✅ يستطيع إرجاع الـ Priority لأي قيمة|

> [!warning] User عادي لو خفّض الـ Priority لو User عادي خفّض الـ Priority من 0 → +10 مثلاً **مش يقدر يرجعها لـ 0 تاني!** → محتاج Root

---

## ✅ استخدام `nice` — عند بدء تشغيل Process جديدة

```bash
# الصيغة العامة
nice -n <value> <command>

# أمثلة
nice -n 19 firefox          # تشغيل firefox بأقل أولوية
nice -n -20 firefox          # تشغيل firefox بأعلى أولوية (Root فقط)
nice -n 15 ./backup.sh       # تشغيل سكريبت الـ backup بأولوية أقل
```

> [!note] `nice` = بدء Process جديدة بـ Nice Value محدد

---

##  استخدام `renice` — تغيير Priority لـ Process شغالة

```bash
# الصيغة العامة
renice -n <value> <PID>

# أمثلة
renice -n 15 11850           # تقليل أولوية Firefox (PID = 11850)
renice -n -15 11850          # رفع أولوية Firefox (Root فقط)

# إيجاد PID ثم تغيير الـ Priority
ps aux | grep firefox        # إيجاد PID
renice -n 10 <PID>          # تغيير الأولوية
```

> [!note] `renice` = تغيير Nice Value لـ Process شغالة بالفعل

---

### الفرق بين nice و renice

||`nice`|`renice`|
|---|---|---|
|**متى نستخدمه**|قبل تشغيل الـ Process|بعد ما الـ Process بدأت|
|**المعرّف**|اسم الـ Command|الـ PID|
|**الصيغة**|`nice -n <val> <cmd>`|`renice -n <val> <PID>`|

---

### مثال عملي — ناتج الـ renice

```bash
renice -n -15 11850
# 11850 (process ID) old priority 0, new priority -15
```

---


---

---

## 📊 ملخص كل الأوامر

```bash
# ===== عرض الـ Processes =====
ps                          # من الـ Terminal الحالي
ps ax                       # كل الـ Processes
ps aux                      # كل الـ Processes تفصيلية
ps -af                      # مع PID و PPID
pstree                      # شجرة
ps -eo pid,ppid,%cpu,%mem,ni,comm   # أعمدة مخصصة

# ===== البحث والـ Kill =====
pgrep firefox               # جيب PID بالاسم
pkill firefox               # اقفّل بالاسم (خطر!)
kill <PID>                  # Signal 15 (Default)
kill -9 <PID>               # Force Kill
kill -1 <PID>               # Reload Config
kill -l                     # عرض كل الـ Signals

# ===== المراقبة في Realtime =====
top                         # Task Manager
htop                        # نسخة أحسن من top

# ===== الأولوية (Priority) =====
nice -n 19 ./script.sh      # تشغيل بأولوية أقل (قبل البدء)
nice -n -20 ./script.sh     # تشغيل بأولوية أعلى (Root)
renice -n 10 <PID>          # تغيير أولوية Process شغالة
renice -n -10 <PID>         # رفع أولوية Process شغالة (Root)

# ===== Background/Foreground =====
<command> &                 # تشغيل في Background
jobs                        # عرض الـ Jobs
fg %1                       # إرجاع للـ Foreground
bg %1                       # إرسال للـ Background
Ctrl + Z                    # Pause
Ctrl + C                    # Terminate
```

---


# # File Search (locate & find)



## أولاً: البحث عن Commands

|الأمر|الوظيفة|
|---|---|
|`whatis`|بيقولك الأمر بيعمل إيه|
|`whereis`|بيقولك مكان الـ binary والـ documentation|

---

## ثانياً: البحث عن Files

### 1. `locate`

```bash
locate network
```

- بيسيرش على فايلز بيحتوي على الكلمة دي في اسمه
- مش لازم تكتب الاسم كامل، ممكن جزء منه بس
- **ميزة:** سريع جداً لأنه بيسيرش في **database** مش في الـ filesystem نفسه

####  المشكلة مع locate

الـ database بتتحدث **تلقائياً مرة كل يوم** (في منتصف الليل)، فلو أضفت ملف جديد دلوقتي مش هيظهر.

**الحل:** تعمل update يدوي للـ database:

```bash
sudo updatedb
```

---

### 2. `find`

بيسيرش في **real-time** مباشرة في الـ filesystem (مش معتمد على database).

#### السينتاكس الأساسي

```bash
find [المكان] [الخيار] [القيمة]
```

#### البحث بالاسم

```bash
# بحث عادي (case-sensitive)
find /etc -name network

# بحث بـ wildcard
find /etc -name "network*"

# بحث بدون مراعاة الـ case (كبير/صغير)
find /etc -iname "network*"
```

#### البحث بالـ Permissions

```bash
find /etc -perm 777
```

#### البحث بالـ Owner

```bash
# بحث باليوزر
find /home -user ali

# بحث بالـ Group
find /home -group mostafa
```

#### البحث بوقت الـ Access

```bash
# ملفات اتفتحت في آخر 24 ساعة
find /home -atime -1

# ملفات أقدم من 24 ساعة
find /home -atime +1
```

#### البحث بالـ inode number

```bash
find / -inum [رقم الـ inode]
```

#### تنفيذ أمر على نتيجة البحث (`-exec`)

```bash
# نسخ الملفات اللي اتلقت لفولدر معين
find /etc -name "network*" -exec cp {} /work \;

# حذف الملفات
find /etc -name "network*" -exec rm {} \;

# تغيير الـ permissions
find /etc -name "network*" -exec chmod 755 {} \;
```

> **ملاحظة:** `{}` دي بتاخد مكان نتيجة البحث، و`\;` في الآخر ضرورية

---

---

## ملاحظات مهمة

### Spaces في اسم الملف

لو عايز تعمل ملف فيه مسافة في الاسم، عندك طريقتين:

```bash
# طريقة 1: quotes
touch "mostafa hammouda"

# طريقة 2: backslash (escape)
touch mostafa\ hammouda
```

> الـ `\` قبل أي حرف خاص بتقول للـ terminal "خد الحرف ده زي ما هو"

### Linux case-sensitive

الملف `Network` ≠ الملف `network` — دول ملفين مختلفين!



---
# # grep
---

```bash
grep root /etc/passwd
```

```bash

```


- بيدور على كلمة `root`
    
- داخل الملف `/etc/passwd`
    
- ويرجع **السطر كامل**
    

> ملحوظة مهمة  
> grep دايمًا بيرجع السطر كله مش الكلمة بس.

---

## 🔍 البحث في ملف واحد

```bash
grep test file1
```




✔ هيجيب أي سطر في الملف `file1` فيه كلمة `test`

---

## 🔎 تجاهل حالة الأحرف (small / capital)


```bash
grep -i test file1
```




- `test`
    
- `Test`
    
- `TEST`
    

كلهم هيتحسبوا.

---

## ❌ عرض السطور اللي **مش** فيها الكلمة

```bash
grep -v test file1
```




- `-v` = اعكس النتيجة  
    (هات السطور اللي **مافيهاش** الكلمة)
    

---

## 🔢 عرض رقم السطر

```bash
grep -n test file1
```




✔ هيعرض رقم السطر قبل النتيجة.

---

## 📂 البحث داخل Directory كامل

لو جربت كده:

```bash
grep root /etc
```




هيديك error لأن `/etc` فولدر.

---

## ✅ البحث بشكل recursive

```bash
grep -R root /etc
```




✔ هيبحث داخل:

- كل الملفات
    
- جوه كل الفولدرات
    
- اللي داخل `/etc`


---

##  تجاهل حالة الأحرف + recursive

```bash
grep -iR root /etc
```




---

##  عرض اسم الملف فقط (مش السطر)

```bash
grep -l root /etc/*
```




✔ الفرق هنا:

- هيعرض اسم الملف فقط
    
- مش هيعرض السطر اللي حصل فيه الماتش
    

---

---



# # Flatpak

## 🔍 البحث عن برامج

```bash
flatpak search <اسم البرنامج>
```

**مثال:**

```bash
flatpak search code
```

![[Pasted image 20260305003351.png]]
![[Pasted image 20260305003401.png]]

![[Pasted image 20260305003413.png]]



**نتيجة البحث تظهر:**

|العمود|المعنى|
|---|---|
|**Name**|اسم البرنامج|
|**Description**|وصف البرنامج|
|**Application ID**|المعرّف الفريد ⭐ (الأهم)|
|**Version**|النسخة / البرانش|
|**Remotes**|مصدر البرنامج (مثلاً: flathub)|


> [!TIP] مهم جداً **Application ID** هو الأهم! استخدمه دائماً بدل الاسم لأن بعض البرامج أسماؤها متشابهة

---

## 📥 تثبيت برنامج

### الطريقة الأولى - بالاسم:

```bash
flatpak install <اسم البرنامج>
```

### الطريقة الثانية - بالـ Application ID (الأفضل ✅):

```bash
flatpak install <application.id>
```

**مثال:**

```bash
flatpak install com.visualstudio.code
```

> اضغط **Yes** لتأكيد التثبيت

> [!WARNING] انتبه التثبيت عبر Flatpak قد يأخذ وقتاً أطول من apt/dnf لأنه يحمّل المكتبات معه

---

##  تشغيل البرامج

### الطريقة الأولى - من واجهة النظام:

افتح قائمة البرامج في سطح المكتب وابحث عنه عادياً

### الطريقة الثانية - من Terminal:

```bash
flatpak run <application.id>
```

**مثال:**

```bash
flatpak run org.processing.App
```

> [!NOTE] ملاحظة بعض البرامج قد لا تظهر في واجهة النظام، استخدم Terminal في هذه الحالة

---

## 📋 عرض البرامج المثبتة

```bash
flatpak list --app
```

يعرض لك كل البرامج المثبتة عندك مع Application ID الخاص بكل واحد

---

## 🗑️ حذف برنامج

```bash
flatpak uninstall <application.id>
```

> يحذف البرنامج مع كل مكتباته التي جاءت معه ✅

---

##  تحديث البرامج

### الطريقة الأولى - من Update Manager (إذا مدمج):

بعض التوزيعات (مثل Linux Mint) تدمج Flatpak مع مدير التحديثات تلقائياً

### الطريقة الثانية - من Terminal:

```bash
flatpak update
```

يبحث عن التحديثات ويثبتها لجميع برامج Flatpak

---

## ℹ️ معلومات عن برنامج معين

```bash
flatpak info <application.id>
```

**مثال:**

```bash
flatpak info com.obsproject.Studio
```

**يعرض لك:**

- Application ID
- المصدر (Ref)
- المعمارية (Architecture)
- البرانش (Branch)
- الرخصة (License)
- وغيرها

---

## 📝 ملخص الأوامر

```bash
# إضافة مستودع Flathub
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# البحث عن برنامج
flatpak search <اسم>

# تثبيت برنامج
flatpak install <application.id>

# تشغيل برنامج
flatpak run <application.id>

# عرض البرامج المثبتة
flatpak list --app

# حذف برنامج
flatpak uninstall <application.id>

# تحديث كل البرامج
flatpak update

# معلومات عن برنامج
flatpak info <application.id>
```

---

## 💡 نصائح مهمة

> [!TIP] استخدم Application ID دائماً أفضل من الاسم لأن الأسماء ممكن تتشابه بين برامج مختلفة

----

----
- لو فتحت الملف الى اسمه visodu
- هيفتحلك ملف هتقدر تحط فيه مثلا يوزر يقدر يعدل على كل حاجه كانه روت
![[Pasted image 20260811175258.png]]

- هنا ابانوب ممكن مثلا انه يضيف يوزر عادى بس لازم يضيف قبل الامر كلمه sudo وكمان يكتب الباسورد بتاع ابانوب ولكن لو شلت ابانوب من الملف ده مش هيقدر يضيف يوزرز عاد جدا 
![[Pasted image 20260811180017.png]]
علامه النسبه المئويه ده معنها ان اى حد فى الجروب  بتاع ابانوب هيقدر يعمل كل حاجه 

- كده هيقدر يضيف يوزر عادى اما لو شيلت الجروب مش هيقدر يضيف حد 
![[Pasted image 20260811180206.png]]
اما لو انته ضيفت ابانوب فى الجروب ده كا secondary groub كده هيقدر انه يضيف ناس عادى برضه



---
# 📝 ملاحظات Vim و Sudoers/visudo

---

## 1️⃣ أوضاع التحرير في Vim (Modes)

Vim بيشتغل بأوضاع مختلفة، وأهمهم اثنين للدخول في وضع الكتابة:

| الأمر | الوظيفة                                                                     |
| ----- | --------------------------------------------------------------------------- |
| `i`   | **Insert** – يبدأ الكتابة قبل مكان المؤشر (Cursor)                          |
| `a`   | **Append** – يبدأ الكتابة بعد مكان المؤشر                                   |
| `Esc` | يخرجك من أي وضع (Insert/Append/Visual...) ويرجعك لوضع الأوامر (Normal Mode) |

> 💡 **مثال:** لو المؤشر واقف على حرف `m` في كلمة `mostafa`، الضغط على `i` هيخليك تكتب قبل الـ `m`، أما `a` هيخليك تكتب بعده مباشرة.

---

## 2️⃣ التنقل داخل السطر

| الأمر       | الوظيفة            |
| ----------- | ------------------ |
| `0` (صفر)   | ينقلك لبداية السطر |
| `$` (دولار) | ينقلك لنهاية السطر |

> 💡 **مثال:** انت واقف في نص السطر، دوس `0` هترجع لأول حرف، ودوس `$` هتروح لآخر حرف في نفس السطر.

---

## 3️⃣ النسخ واللصق (Copy / Paste)

### نسخ سطر كامل:

```
Esc
yy
```

- `y` = yank (نسخ)
- `yy` = نسخ السطر اللي المؤشر واقف عليه بالكامل

### اللصق:

| الأمر      | الوظيفة                   |
| ---------- | ------------------------- |
| `p` (صغير) | يلصق **بعد** السطر الحالي |
| `P` (كبير) | يلصق **قبل** السطر الحالي |

> 💡 **مثال:** انت في السطر رقم 3 وعملت `yy`، لو دوست `p` هيتحط النسخة في السطر 4، ولو دوست `P` هيتحط في السطر 2 (قبل السطر الحالي).

---

## 4️⃣ البحث والاستبدال (Search & Replace)

### استبدال أول تكرار في كل سطر:

```
:%s/mostafa/mohammed
```

> 🔍 هنا هيستبدل **أول** كلمة `mostafa` يلاقيها في **كل سطر** بكلمة `mohammed` (لو تكررت الكلمة مرتين في نفس السطر، هيستبدل المرة الأولى بس).

### استبدال كل التكرارات في كل السطور:

```
:%s/mostafa/mohammed/g
```

> 🔍 الـ `g` (global) هنا معناها استبدال **كل** كلمة `mostafa` موجودة في **كل** السطور، حتى لو تكررت أكتر من مرة في نفس السطر.

---

## 5️⃣ الحذف (Delete)

| الأمر         | الوظيفة                                         |
| ------------- | ----------------------------------------------- |
| `Esc` ثم `x`  | يحذف الحرف اللي المؤشر واقف عليه                |
| `Esc` ثم `dw` | يحذف كلمة كاملة (من مكان المؤشر لحد آخر الكلمة) |

> 💡 **مثال:** لو المؤشر واقف على أول حرف في كلمة `mostafa` ودوست `dw`، هتتشال الكلمة كلها.

---

## 6️⃣ التراجع (Undo)

```
Esc
u
```

> 💡 لو حذفت سطر بالغلط أو عملت أي تعديل غلط، دوس `Esc` وبعدها `u` عشان ترجع آخر خطوة عملتها.

---

## 7️⃣ حذف عدة سطور مرة واحدة

```
Esc
:1,5d
```

> 🗑️ الأمر ده هيحذف من السطر رقم 1 لحد السطر رقم 5.

**الصيغة العامة:**

```
:<من سطر>,<لحد سطر>d
```

---

## 8️⃣ نسخ مجموعة سطور لمكان تاني

```
Esc
:1,5co 7
```

> 📋 هيعمل نسخ (copy) لأول 5 سطور (من 1 لـ 5) وحطهم بعد السطر رقم 7.

**الصيغة العامة:**

```
:<من سطر>,<لحد سطر>co <بعد السطر رقم>
```

---

## 9️⃣ ترقيم السطور (Line Numbers)

|الأمر|الوظيفة|
|---|---|
|`:set nu`|يظهر أرقام السطور|
|`:set nonu`|يخفي أرقام السطور|

---

## 🔟 الحفظ والخروج

|الأمر|الوظيفة|
|---|---|
|`:w`|حفظ فقط (write) بدون خروج|
|`:wq`|حفظ وخروج (write & quit)|
|`:q!`|خروج بدون حفظ (يتجاهل أي تعديلات)|

---

---

# 🔐 ملف Sudoers و visudo

## ما هو visudo؟

عند تنفيذ الأمر:

```bash
sudo visudo
```

بيتفتح ملف **`/etc/sudoers`** بمحرر نصوص (عادة Vim)، وده الملف اللي بيحدد **مين من المستخدمين ممكن يستخدم صلاحيات الروت** عن طريق كتابة كلمة `sudo` قبل الأوامر.

> ⚠️ **مهم:** استخدم `visudo` دايماً بدل ما تعدل الملف مباشرة، لأنه بيعمل فحص للصياغة (syntax check) قبل الحفظ، فلو حصل خطأ إملائي في الملف، هيرفض الحفظ ويمنعك من تبويظ صلاحيات النظام بالكامل.

---

## مثال 1: إضافة مستخدم عادي (User) يقدر يتصرف زي الروت

```
abanoub    ALL=(ALL:ALL) ALL
```

**الشرح:**

- المستخدم `abanoub` يقدر ينفذ أي أمر بصلاحيات الروت.
- **لازم** يكتب `sudo` قبل كل أمر.
- **لازم** يدخل الباسورد بتاعه هو (مش باسورد الروت) عند التنفيذ.

> 💡 **مثال عملي:** لو أبانوب عايز يضيف مستخدم جديد اسمه `karim`، هيكتب:
> 
> ```bash
> sudo useradd karim
> ```
> 
> وهيتطلب منه إدخال **باسورد أبانوب نفسه**.

> 🚫 **لو شيلنا سطر أبانوب من ملف sudoers**، مش هيقدر ينفذ أي أمر بصلاحيات الروت خالص، وهيظهرله رسالة إن اسمه مش موجود في ملف الـ sudoers.

---

## مثال 2: إعطاء صلاحيات لمجموعة كاملة (Group) عن طريق %

```
%abanoub    ALL=(ALL:ALL) ALL
```

**الشرح:**

- علامة `%` قبل الاسم معناها إن ده **اسم مجموعة (Group)** مش مستخدم واحد.
- أي شخص عضو في المجموعة `abanoub` هيقدر ينفذ أي أمر بصلاحيات الروت (زي إضافة يوزر جديد وغيره).

> 💡 **مثال عملي:** لو فيه 3 مستخدمين (`ali`, `sara`, `omar`) كلهم أعضاء في مجموعة `abanoub`، كل واحد فيهم يقدر يعمل:
> 
> ```bash
> sudo useradd newuser
> ```
> 
> بشرط إنه يكتب **باسورده هو** مش باسورد موحد للمجموعة.

> 🚫 **لو شيلنا المجموعة من الملف**، ولا حد من أعضائها هيقدر يضيف مستخدمين جدد أو ينفذ أوامر روت.

---

## مثال 3: إضافة مستخدم كـ Secondary Group

لو عايز تضيف مستخدم (زي `abanoub`) كعضو **إضافي (Secondary)** في مجموعة عندها صلاحيات sudo (زي مجموعة `sudo` الافتراضية في Ubuntu):

```bash
sudo usermod -aG sudo abanoub
```

**الشرح:**

- `-aG` معناها **Append to Group** (إضافة كمجموعة ثانوية بدون ما تشيله من مجموعته الأساسية).
- بعد التنفيذ، `abanoub` هيبقى عضو في مجموعة `sudo` بالإضافة لمجموعته الأصلية.
- ده هيدّيله نفس صلاحيات أي عضو تاني في المجموعة، يعني يقدر يضيف يوزرز عاديين ويستخدم `sudo` بشكل طبيعي.

> ✅ **ملحوظة:** الطريقة دي أسهل وأأمن من التعديل المباشر في ملف sudoers، لأنها بتستخدم الإعدادات الجاهزة المعرّفة مسبقاً لمجموعة `sudo`.

---

## ⚡ ملخص سريع لصيغ ملف sudoers

|الصيغة|المعنى|
|---|---|
|`username ALL=(ALL:ALL) ALL`|مستخدم واحد بصلاحيات كاملة|
|`%groupname ALL=(ALL:ALL) ALL`|كل أعضاء مجموعة بصلاحيات كاملة|
|`username ALL=(ALL:ALL) NOPASSWD: ALL`|صلاحيات كاملة بدون طلب باسورد|
|`username ALL=(ALL) /path/to/command`|صلاحية لتنفيذ أمر محدد بس|

---



- لو انته مثلا عايز تشيل جزء معين موجود فى ملف etc/passwd بشكل تلقائى ممكن انك تعمل script وتخليه يقطع الجزء ده بشكل تلقائى
- فى الامر cut بتقدر تستخدمه فى انك تقدر تقطع جزء معين زى الاتى 
```bash
cut -d ':' -f1 
```
- دى معناها انك اول لما تشوف دى  :   هاتلى اول عمود فيها فلو انته مثلا بتعمل الحركه فى فى etc/passwd هيظهر الاتى 
![[Pasted image 20260819172747.png|398]]
```bash
cut -d ':' -f3
```
- هنا لو قلت ان f3 هتلاقى انه بيجبلك تالت عمود
---

```bash
cut -d ':' -f1,3
```
- دى معنها انه هيجيب العمود الاول والتالت 
![[Pasted image 20260819172922.png|427]]

---
- هنا هنشرح امر الـ sed  

```bash
sed  "p" password
```
- دى معنها كانك بتقوله اظهرلى الملف الى اسمه باسورد
- هنا كلمه p معنها انك تعمل print   لو انته نسيتها كده مش هيطبع حاجه

```bash
sed  -n "2p" password
```
- دى معنها هات الـ line الى هوا رقم 2
![[Pasted image 20260819173648.png|613]]

```bash
sed  -n "2,4p" password
```
- هنا معناها انك تجيب من اول السطر التانى لحد السطر الرابع

---
```bash
sed  -n "/root/p" password
```
- دى معناها اطبعلى السطر الى فيه كلمه root
---
```bash
sed  -n "1,/news/p" password
```
- هنا معناها انك تجيب من اول سطر لحد السطر الى فيه كلمه news   
![[Pasted image 20260819174206.png|581]]

---
```bash
sed  -n "$p" password
```
- لو انته عايز تظهر اخر سطر

---
لو انته عايز تغير مثلا هنا فى السطور الى طلعت عايز تغير  :  وتخليها دى ,   يبقى تعمل الاتى 

```bash
sed   "s/:/,/" password
```
- كده هيغير كل : بدى , بس الى هى اول واحده فى السطر انما الى فى باقى السطر هيسيبه عادى 
![[Pasted image 20260819174820.png]]

---
```bash
sed   "s/:/,/g" password
```
- لو حطيت فى الاخر g كده هيغيره كله
![[Pasted image 20260819174938.png]]

---

- بس خلى بالك لو انته عملت cat على الملف بتاع password هتلاقى ان الـ :  لسه موجوده  
- لكن لو انته عايز تخلى التغير داخل الملف نفسه بعدما تعدله هتعمل الاتى 
```bash
sed  -i "s/:/,/g" password
```

---
```bash
sed  -n "1p:2p" password
```
- كده هيطبع السطر الاول والتانى بس 

---
```bash
sed   "1d" password
```
- كده هيسمح اول سطر فى الملف بس لو انته عايزه يسمحه فى الملف بشكل دائم مش مؤقت

```bash
sed  -i "1d" password
```



---
```bash
sed  -i "$d" password
```
- دى معنها امسحلى اخر سطر

---
```bash
sed  -i "1,3d" password
```
- بيمسح من واحد لحد تلاته

---
```bash
sed  -i "1d:3d" password
```
- كده هيمسح واحد و تلاته

---
```bash
sed  -i "1,/proxy/d" password
```
- هنا هيمسح من اول السطر الاول لحد السطر الى فيه بروكسى

---
```bash
awk '{print}' password
```
- دى معنها اطبع كل الى موجود فى ملف الباسورد

---
```bash
awk -F ','  '{print $1}' password
```
- هنا اول لما يشوف الباراميتر الى هوا ,  يطبع بس اول عمود علشان انته عملت $1
![[Pasted image 20260819181710.png|516]]

---
```bash
awk -F ','  '{print "LoginName : ", $1}' password
```
- هنا كده هيطبع كلمه loginname وبعدها الكلمه الى هى فى اول عمود
![[Pasted image 20260819182032.png]]

---
```bash
awk -F ','  '{print NR, $1}' password
```
- هنا هيطبع العمود الاول وكمان الارقام جنبها كما يلى 
![[Pasted image 20260819182150.png|648]]

---
```bash
awk -F ','  '{print NR ":: Login Name :: ", $1}' password
```

![[Pasted image 20260819182326.png|648]]

---

```bash
awk -F ','  '{print $0, $1}' password
```
- دى معنها اطبع السطر الى انا فيه هعمل كده
![[Pasted image 20260819182523.png|648]]

---
```bash
awk -F ','  '{print $1, NR , FS}' password
```
![[Pasted image 20260819182730.png|648]]

---

```bash
awk -F ','  'BEGIN{print "user Report: " }{print}' password
```

- هيكتب بس الكلمه دى فى اول سطر بس user Report: وبعدها هيطبع كل الكلمات الى فى الملف

![[Pasted image 20260819183134.png|643]]

---
```bash
awk -F ','  'BEGIN{print "user Report: " }{print NR " : $0"}' password
```
- هيظهر الاتى 
![[Pasted image 20260819183435.png|648]]

---

```bash
awk -F ','  'BEGIN{print "user Report: " }{print NR " : $0"} END {print "The End Of The Report"}' password
```
- هيظهر الاتى 
![[Pasted image 20260819183625.png|648]]

---
```bash
awk -F ','  'BEGIN{print "user Report: " }{print NR " : $0"} END {print " END the number of  record is : " , NR}' password
```
![[Pasted image 20260819183833.png|648]]

---
```bash
awk -F ':' '$1 == root {print $0} ' password
```
- هنا فى الامر ده اول عمود لو اول كلمه فيه هى روت هتبدا تطبع السطر بتاعها 
![[Pasted image 20260819184235.png|648]]

---
```bash
awk -F ':' -v user="ubunto" '$1 == user {print $0}' passowrd
```
- هنا انا عرفت يوزر وبعدها قولت لو اليوزر ده بيسازى الى بيظهر هتطبع السطر بتاعه 
![[Pasted image 20260819184553.png|648]]



----

- هنا لو انته عايز تعرف كل الانفيونمينت الى عندك هتعمل env
هنا لو انته عملت مثلا 
```bash
export mostafa=ls
```

وبعدها عملت 
```bash
$mostafa
```
- كده هيطبع كل الملفات الى فى المسار الى انته فيه كانك عملت ls علشان هوا حفظ كلمه مصطفى كانها هى ls بس فى السيشن دى بس لكن لو غيرت السيشن دى وجيت تكتب مصطفى تانى مش هتلاقيها 

- عندك ملف اسمه .bashrc   الملف ده بيتنفذ اول لما بتفتح الجهاز  هتدخل جوه الملف وهتعمل الاتى مثلا 
```bash
sudo vim .bashrc
```

,وبعدها اول لما تدخل هتكتب مثلا 
```
export mostafa=ls
```

![[Pasted image 20260815230019.png]]
هنا عملت المتغير ده كده بقى دائم التشغيل الامر ده وفى اى سيشن واول لما تكتب bash هينفذ الاوامر دى الى هى date and ls

![[Pasted image 20260815230205.png]]

![[Pasted image 20260815230426.png]]
- حتى هنا لما عمل login شغل الاوامر الى هى موجوده فى الـ bashrc الى مكتوبه هناك شغلها 


```bash
mostafa@mostafa-VMware-Virtual-Platform:~$ cat /etc/environment
PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin"
```
-  ده المسار الى بيروح يدور فيه على الاوامر الى المفروض الى انته المفروض بتكتبها 

- لو انته عايز تعدل على المسار ده ممكن تدخل على الاتى 
```bash
mostafa@mostafa-VMware-Virtual-Platform:~$ vim /etc/environment
```

----
- هنا هنتكلم عن الـ nginx  وعن النتورك 
- الـipconfig علشان تعرف الـ ip بتاعك الى انته شغال بيه فى النتورك ده فى الويندوز 
- اما فى اللينكس لو انته عايز تعمل كده ifconfig   هتلاقى i net ده الـ ip الداخلى بتاعك
- او برضه ip a  دى برضه بتجيب البيانات

---
اداه netstate  ده بتعرفك البورتات المفتوحه عندك
- هتكتب netstat -tuln  هيجبلك البوتات الى مفتوحه عندك فى الشبكه
- فى لينكس ufw ده بيكون الفايروول  فى لينكس 
- علشان تعرف حالته ufw status 
- علشان تفعله ufw enable
- لو انته عايز تسمح لبورت معينه هتعمل الاتى ufw allow 80/tcp

---
- هنا الـ  curl https://google.com  هنا انته بتشوف هل الموقع ده شغال ولا لا مثلا لو رجع 200 ولا 301 كده شغال 
- هنا ping بتبعت باكيت وبتشوف هل الموقع ده شغال ولا لا 
- ping google.com

----
انته لما الماشين تتعمل من امازون هيديك الـ privte ssh key  هتحطه فى ملف وهتعمل 
وبعدها هتخلى الملف chmod 400 mostafa.pem
- ssh -i "mostafa.pem"  hamada@ip "
- هتاخد الـ ip من الماشين من الراجل الى عمل الماشين وهتخليه يعملك يوزر وبتدخل 
بيهم الماشين بالشكل ده كده

- ssh -i "mostafa.pem"  hamada@ip "

---
- علشان تحمل الـ nginx هتعمل 
- sudo yum install nginx

---

- علشان تحمل كرون تاب هتعمل 
- sudo apt install crontab 
- الاداه دى علشان لو انته عايز حاجه تشتغل فى وقت معين

- crontab -e 
- وبعدها هيخيرك انك تختار vim or nano
- اول لما تدخل عليها فى اول هانه هتكون خاصه بالتوقيت والاخيره خاصه بالامر الى انته هتعمله
- كده بقا ممكن انك تحط الوقت الى انته عايز تعمل run لامر معين فى وقت معين 
![[Pasted image 20260816200222.png]]
- دى معناها ان كل دقيقيه يعمل رن للامر ده ls
- ![[Pasted image 20260816200309.png]]
- دى معناها كل ساعه 
![[Pasted image 20260816200339.png]]
- دى مع

![[Pasted image 20260816200349.png]]




---
![[Pasted image 20260816200404.png]]


---
![[Pasted image 20260816200438.png]]

---
![[Pasted image 20260816200515.png]]
- ده معناه ان فى يوم جمعه لانه الاسبوع بيبدا عندهم من يوم الاتنين فى يوم خمسه اكتوبر الساعه واحده وخمس دقايق  لازم علشان يشتغل يكون يوم الجمعه 

موقع crontab guru هيفمك الاداه

https://crontab.guru/#*/15_*_*_*_

---
ls -i /
ده بيجبلك الـ ionde number بتاع كل ملف 

- ls -Li
- ده برضه بيعرفك كل i node number بتاع 
---
الـ soft link بيكون كانه pointer بيشاور على الملف الاصلى 
هتعمل ln -s /etc/passwd     ./password

اتشرح بالتفصيل عن السوفت والهارد لينك 

- فى الهارد لينك لو خد نفس الـ i node number هياخد نفس البرمشن
- لو عملت تغير فى الملف الهارد لينك هيتعدل فى الاصلى 

---
كل نسخه فى لينكس ليها باكدج مانجر خاصه بيها زى apt or yum 


- هتنزل تول اسمها htop وبعدها nginx

---

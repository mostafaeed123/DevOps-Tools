## خطة الـ Phases للمشروع

قسمت الدوكيومنتيشن لـ 11 phase، كل واحدة مستقلة وبتبني على اللي قبلها:

|#|Phase|المحتوى|
|---|---|---|
|1|**Authentication & User Management**|Sign in / Sign up / Forgot & Reset password / Profile / No access|
|2|Dashboard Shell & Projects|الـ Layout والـ Navigation وإدارة المشاريع|
|3|Create Deployment|الفورم والـ API وتسجيل الـ deployment job|
|4|Database & Deployment State Machine|الجداول وحالات الـ deployment (PENDING → RUNNING)|
|5|Terraform Integration|إنشاء EC2 على AWS|
|6|Ansible Integration|تجهيز السيرفر (Docker, K8s environment)|
|7|Jenkins, Docker & Registry|الـ CI/CD pipeline ورفع الـ image|
|8|Kubernetes & Verification|الـ deploy والتأكد إن الـ replicas شغالة|
|9|Status, Logs & History|تتبع الحالة وتجميع الـ logs وسجل الـ deployments|
|10|AI Layer (LLM + RAG + Agents)|التوصيات والـ actions بموافقة المستخدم|
|11|Security, Testing & Final Docs|المراجعة النهائية والاختبارات|

قولي "كمل" وأكتبلك الـ phase اللي بعدها بنفس التفصيل.

---

## Phase 1: Authentication & User Management

### 1. الهدف

أي حد يستخدم المنصة لازم يعمل حساب ويسجل دخول، وكل صفحة بعد كده تتحمي بالـ authentication والـ role. الـ phase دي هي الأساس اللي باقي المنصة هتتبني عليه.

### 2. الصفحات (Routes)

|الصفحة|Route|الوصول|
|---|---|---|
|Sign in|`/login`|Public|
|Sign up|`/register`|Public|
|Forgot password|`/forgot-password`|Public|
|Reset password|`/reset-password?token=...`|Public (بتوكن)|
|Profile|`/profile`|لازم تكون مسجل دخول|
|No access|`/no-access`|أي حد مسجل دخول|

---

### 3. تفاصيل كل صفحة

#### 3.1 Sign in

**الحقول:** Email و Password.

**الـ Validation (في الـ Frontend والـ Backend):**

- الإيميل لازم يكون بصيغة صحيحة.
- الباسورد مش فاضي.

**الـ Flow:**

1. المستخدم يدخل الإيميل والباسورد ويضغط Sign in.
2. React يبعت `POST /api/auth/login`.
3. الـ Backend يدور على المستخدم بالإيميل ويقارن الباسورد بالـ `password_hash`.
4. لو صح، يرجّع Token وبيانات المستخدم (id, name, email, role).
5. React يخزن الـ session ويوديه على الـ Dashboard.

**الأخطاء:**

- بيانات غلط: رسالة عامة "Invalid email or password". متقولش أي واحد فيهم الغلط، عشان ما تسربش وجود الإيميل.
- أخطاء السيرفر: رسالة "Something went wrong, try again".

**عناصر إضافية:** لينك Forgot password؟ ولينك "Don't have an account? Sign up".

#### 3.2 Sign up

**الحقول:** Name, Email, Password, Confirm password.

**الـ Validation:**

- Name: مطلوب، من 2 لـ 50 حرف.
- Email: صيغة صحيحة وغير مستخدم قبل كده.
- Password: 8 حروف على الأقل، فيها حرف كبير وصغير ورقم (قاعدة مقترحة).
- Confirm password: لازم يطابق الـ Password.

**الـ Flow:**

1. React يبعت `POST /api/auth/register`.
2. الـ Backend يتأكد إن الإيميل مش موجود، ويعمل hash للباسورد، ويحفظ المستخدم بـ role افتراضي.
3. بعد النجاح: إما يسجل دخول تلقائي أو يحوله على `/login` برسالة نجاح.

**الأخطاء:** الإيميل مستخدم (409)، أو بيانات غير صالحة (400) مع رسالة تحت كل حقل.

#### 3.3 Forgot password

**الحقل:** Email.

**الـ Flow:**

1. المستخدم يدخل إيميله.
2. React يبعت `POST /api/auth/forgot-password`.
3. الـ Backend يولّد Token عشوائي، ويحفظ **hash** بتاعه مع تاريخ انتهاء (مثلاً 30 دقيقة)، ويبعت إيميل فيه اللينك: `/reset-password?token=...`.
4. الصفحة تعرض دايماً نفس الرسالة: "If this email exists, a reset link has been sent"، سواء الإيميل موجود أو لأ.

**ملاحظة أمان:** الرد الموحد بيمنع أي حد يخمّن الإيميلات المسجلة.

#### 3.4 Reset password

بتتفتح من اللينك في الإيميل: `/reset-password?token=...`

**الحقول:** New password و Confirm new password (التوكن بيتاخد من الـ URL).

**الـ Flow:**

1. React يقرا الـ token من الـ query string.
2. المستخدم يدخل الباسورد الجديد.
3. React يبعت `POST /api/auth/reset-password` بالـ token والباسورد.
4. الـ Backend يتأكد إن الـ token صحيح وما انتهتش صلاحيته وما اتستخدمش، ويحدّث الـ `password_hash`، ويعلّم الـ token كمستخدم.
5. يحوله على `/login` برسالة "Password updated".

**الحالات الخاصة:** لو الـ token ناقص أو منتهي أو مستخدم، تظهر رسالة "This link is invalid or expired" مع زرار لطلب لينك جديد.

#### 3.5 Profile

تلات أقسام في صفحة واحدة:

**أ) Edit profile:** تعديل Name و Email.

- `PATCH /api/users/me`
- لو الإيميل الجديد مستخدم، يرجع خطأ 409.

**ب) Change password:** Current password و New password و Confirm.

- `POST /api/auth/change-password`
- لازم الـ Current password يكون صح قبل التغيير.

**ج) Sign out:**

- يمسح الـ token/session من الـ Frontend، وفي الـ Backend يلغيه لو بنستخدم refresh tokens.
- يوديه على `/login`.

#### 3.6 No access page

بتظهر لما المستخدم يحاول يفتح route الـ role بتاعه مش مسموح له بيها (مثلاً Viewer يحاول يفتح صفحة خاصة بالـ Admin).

**المحتوى:** رسالة واضحة "You don't have permission to view this page" وزرار "Back to dashboard"، وممكن زرار Sign out.

**الفرق المهم:**

- مش مسجل دخول: يتحول على `/login`.
- مسجل دخول بس الـ role مش مسموح: يتحول على `/no-access`.

---

### 4. الـ Backend Endpoints

|Method|Endpoint|الوظيفة|
|---|---|---|
|POST|`/api/auth/register`|إنشاء حساب|
|POST|`/api/auth/login`|تسجيل دخول|
|POST|`/api/auth/logout`|تسجيل خروج|
|GET|`/api/auth/me`|بيانات المستخدم الحالي|
|POST|`/api/auth/forgot-password`|طلب لينك الريسيت|
|POST|`/api/auth/reset-password`|تعيين باسورد جديد بالتوكن|
|POST|`/api/auth/change-password`|تغيير الباسورد من البروفايل|
|PATCH|`/api/users/me`|تعديل الاسم والإيميل|

### 5. الـ Database

**جدول `users`** (زي الدوكيومنت مع إضافات بسيطة):

```
id, name, email (unique), password_hash, role, created_at, updated_at
```

**جدول `password_reset_tokens`** (جديد):

```
id, user_id, token_hash, expires_at, used_at, created_at
```

**الـ Roles المقترحة:** `admin` و `developer` و `viewer`. ده اقتراح مني، والدوكيومنت بس بيذكر وجود حقل `role` من غير تفاصيل، فلازم تحدد الأدوار الفعلية.

### 6. الـ Middleware في الـ Backend

- **`authenticate`**: يتحقق من الـ token ويحط بيانات المستخدم في الـ request. لو فاشل يرجع 401.
- **`authorize(...roles)`**: يتأكد إن الـ role مسموح. لو لأ يرجع 403.

### 7. الـ Frontend Guards

- **`ProtectedRoute`**: لو مفيش session يحول على `/login`.
- **`RoleRoute`**: لو الـ role مش مسموح يحول على `/no-access`.
- الـ Frontend يعالج 401 و 403 من الـ API بنفس الطريقة.

### 8. الأمان (إلزامي)

- تخزين الباسورد بـ **bcrypt أو argon2**، مش plain text ولا SHA بسيط.
- Reset token عشوائي قوي، ويتخزن **hashed**، وصلاحيته قصيرة، ويتستخدم مرة واحدة.
- **Rate limiting** على login و forgot-password ضد brute force.
- رسائل خطأ موحدة في login و forgot-password.
- الـ Validation في الـ Backend دايماً، حتى لو موجود في الـ Frontend.
- HTTPS في الـ production.
- لو بتستخدم cookies: `HttpOnly` و `Secure` و `SameSite`.

### 9. حالات الواجهة (UI States)

كل فورم لازم يغطي:

- **Loading:** الزرار معطل ومعاه spinner أثناء الطلب.
- **Error:** رسالة تحت الحقل أو فوق الفورم.
- **Success:** رسالة أو redirect.
- **Empty/Invalid:** زي الـ token المنتهي في Reset password.

### 10. ترتيب التنفيذ المقترح

1. جدول `users` و `password_reset_tokens`.
2. Register و Login في الـ Backend (hash + token).
3. Middleware الـ `authenticate` و `authorize`.
4. صفحات Sign in و Sign up في React.
5. الـ Guards وصفحة No access.
6. Forgot password و Reset password (الـ Backend + إعداد إرسال الإيميل + الصفحات).
7. صفحة Profile (تعديل البيانات وتغيير الباسورد و Sign out).
8. الاختبارات.

### 11. معايير القبول (Definition of Done)

- [ ]  مستخدم جديد يقدر يعمل حساب ويسجل دخول.
- [ ]  الباسورد متخزن hashed.
- [ ]  لينك الريسيت بيوصل بالإيميل، وبيشتغل مرة واحدة بس، وبينتهي بعد المدة.
- [ ]  المستخدم يقدر يعدل اسمه وإيميله ويغير الباسورد.
- [ ]  Sign out بيمسح الـ session ويمنع الوصول للصفحات المحمية.
- [ ]  مستخدم من غير صلاحية بيتحول على No access.
- [ ]  مستخدم غير مسجل بيتحول على Login.
- [ ]  كل الـ validations شغالة في الـ Frontend والـ Backend.

### 12. نقاط محتاجة قرارك

1. إيه الـ roles بالظبط وإيه صلاحية كل واحد؟
2. بعد Sign up: تسجيل دخول تلقائي ولا تأكيد إيميل الأول؟
3. الـ session: JWT في cookie ولا في localStorage؟ (الـ cookie أأمن)
4. خدمة إرسال الإيميل: SMTP أو SendGrid أو AWS SES؟ (بما إن المشروع على AWS، SES خيار طبيعي)


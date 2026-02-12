# 📋 نموذج البيانات - طلب ورد الصيدلية

## الطلب المرسول (Request)

### الـ Endpoint
```
POST /auth/pharmacy/register
```

### الرأس (Headers)
```
Content-Type: application/json
```

### جسم الطلب (Request Body)

```json
{
  "username": "pharmacyA",
  "email": "tahanyemad30@gmail.com",
  "phoneNumber": "01012345678",
  "password": "SecurePass123!",
  "role": "pharmacy",
  "pharmacyName": "Al-Shifa Pharmacy",
  "address": "Zagazig City",
  "location": {
    "coordinates": [31.5021, 30.5877]
  }
}
```

### شرح الحقول

| الحقل | النوع | المثال | الملاحظات |
|--------|--------|--------|----------|
| `username` | string | `pharmacyA` | اسم المستخدم (فريد) |
| `email` | string | `tahanyemad30@gmail.com` | البريد الإلكتروني (فريد) |
| `phoneNumber` | string | `01012345678` | رقم الهاتف (فريد، يجب أن يكون صحيحاً) |
| `password` | string | `SecurePass123!` | كلمة المرور (قوية، 8+ أحرف مع Upper/Lower/Number/Special) |
| `role` | string | `pharmacy` | دائماً "pharmacy" للصيدليات |
| `pharmacyName` | string | `Al-Shifa Pharmacy` | اسم الصيدلية |
| `address` | string | `Zagazig City` | عنوان الصيدلية |
| `location.coordinates` | array | `[31.5021, 30.5877]` | [latitude, longitude] بالترتيب |

---

## الرد الناجح (Success Response)

### كود الحالة
```
200 OK
```

### جسم الرد

```json
{
  "message": "User registered successfully. Please check your email to verify your account.",
  "user": {
    "_id": "68f513cf900810baea96335f",
    "username": "pharmacyA",
    "email": "tahanyemad30@gmail.com",
    "phoneNumber": "01012345678",
    "role": "pharmacy",
    "isEmailVerified": false,
    "createdAt": "2025-10-19T16:37:35.767Z",
    "updatedAt": "2025-10-19T16:37:35.767Z"
  }
}
```

### شرح الرد

| الحقل | النوع | الوصف |
|--------|--------|--------|
| `message` | string | رسالة تأكيد من الخادم |
| `user._id` | string | معرّف المستخدم الفريد |
| `user.username` | string | اسم المستخدم المسجل |
| `user.email` | string | البريد الإلكتروني المسجل |
| `user.phoneNumber` | string | رقم الهاتف المسجل |
| `user.role` | string | دور المستخدم (pharmacy) |
| `user.isEmailVerified` | boolean | حالة التحقق من البريد (false في البداية) |
| `user.createdAt` | string | وقت الإنشاء (ISO 8601) |
| `user.updatedAt` | string | آخر تحديث (ISO 8601) |

---

## الأخطاء المحتملة

### 1. البريد الإلكتروني موجود بالفعل

```json
{
  "statusCode": 409,
  "message": "User already exists with this email address",
  "error": "Conflict"
}
```

### 2. رقم الهاتف موجود بالفعل

```json
{
  "statusCode": 409,
  "message": "User already exists with this phone number",
  "error": "Conflict"
}
```

### 3. كلمة المرور ضعيفة

```json
{
  "statusCode": 400,
  "message": "Password does not meet requirements",
  "error": "Bad Request"
}
```

### 4. بيانات غير صحيحة

```json
{
  "statusCode": 400,
  "message": "Invalid email format",
  "error": "Bad Request"
}
```

### 5. إحداثيات غير صحيحة

```json
{
  "statusCode": 400,
  "message": "Invalid coordinates",
  "error": "Bad Request"
}
```

### 6. خطأ في الخادم

```json
{
  "statusCode": 500,
  "message": "Internal server error",
  "error": "Server Error"
}
```

---

## متطلبات كلمة المرور

يجب أن تحتوي كلمة المرور على:

- ✅ حرف كبير واحد على الأقل (A-Z)
- ✅ حرف صغير واحد على الأقل (a-z)
- ✅ رقم واحد على الأقل (0-9)
- ✅ رمز خاص واحد على الأقل (!@#$%^&*)
- ✅ 8 أحرف على الأقل

**أمثلة صحيحة:**
- `SecurePass123!`
- `Test@Pass#2024`
- `Pharmacy$123Rx`

**أمثلة خاطئة:**
- `password` ❌ (لا توجد أحرف كبيرة أو أرقام)
- `Pass123` ❌ (لا توجد رموز خاصة)
- `Pass!@` ❌ (أقل من 8 أحرف)

---

## متطلبات الإحداثيات

### Latitude (خط العرض)
- النطاق: **-90 إلى 90**
- مصر: 22° إلى 32°
- أمثلة: `30.0444`, `31.5021`

### Longitude (خط الطول)
- النطاق: **-180 إلى 180**
- مصر: 24° إلى 35°
- أمثلة: `31.2357`, `30.5877`

### أمثلة المدن المصرية

| المدينة | Latitude | Longitude |
|--------|----------|-----------|
| Cairo (القاهرة) | 30.0444 | 31.2357 |
| Giza (الجيزة) | 30.0131 | 31.2089 |
| Alexandria (الإسكندرية) | 31.2001 | 29.9187 |
| Zagazig (الزقازيق) | 30.5877 | 31.5021 |

---

## مثال على استخدام cURL

```bash
curl -X POST https://tiryak.vercel.app/auth/pharmacy/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "pharmacyA",
    "email": "tahanyemad30@gmail.com",
    "phoneNumber": "01012345678",
    "password": "SecurePass123!",
    "role": "pharmacy",
    "pharmacyName": "Al-Shifa Pharmacy",
    "address": "Zagazig City",
    "location": {
      "coordinates": [31.5021, 30.5877]
    }
  }'
```

---

## مثال على استخدام Dart/Flutter

```dart
// في البطبيق
final request = PharmacyRegisterRequestBody(
  username: 'pharmacyA',
  email: 'tahanyemad30@gmail.com',
  phoneNumber: '01012345678',
  password: 'SecurePass123!',
  role: 'pharmacy',
  pharmacyName: 'Al-Shifa Pharmacy',
  address: 'Zagazig City',
  location: PharmacyLocation(
    coordinates: [31.5021, 30.5877],
  ),
);

await authCubit.registerPharmacy(request);
```

---

## مثال على استخدام JavaScript/Axios

```javascript
const axios = require('axios');

const pharmacyData = {
  username: 'pharmacyA',
  email: 'tahanyemad30@gmail.com',
  phoneNumber: '01012345678',
  password: 'SecurePass123!',
  role: 'pharmacy',
  pharmacyName: 'Al-Shifa Pharmacy',
  address: 'Zagazig City',
  location: {
    coordinates: [31.5021, 30.5877]
  }
};

axios.post('https://tiryak.vercel.app/auth/pharmacy/register', pharmacyData)
  .then(response => {
    console.log('Registration successful:', response.data);
  })
  .catch(error => {
    console.error('Registration failed:', error.response.data);
  });
```

---

## تسلسل البيانات الكامل

```
1. المستخدم يملأ الخطوة الأولى
   ├── Username
   ├── Email
   ├── Phone Number
   └── Pharmacy Name

2. المستخدم يملأ الخطوة الثانية
   ├── Address
   ├── Latitude
   ├── Longitude
   ├── Password
   └── Confirm Password

3. التحقق من البيانات على الجانب العميل
   ├── تنسيق البريد الإلكتروني
   ├── رقم الهاتف
   ├── قوة كلمة المرور
   ├── مطابقة كلمات المرور
   ├── الإحداثيات
   └── الحقول المطلوبة

4. إرسال الطلب للخادم
   └── POST /auth/pharmacy/register

5. معالجة الخادم
   ├── التحقق من البيانات
   ├── التحقق من الفرادة (Email, Phone)
   ├── تشفير كلمة المرور
   ├── إنشاء سجل المستخدم
   └── إرسال بريد التحقق

6. الرد على العميل
   ├── النجاح → البيانات المسجلة
   └── الفشل → رسالة الخطأ
```

---

## ملاحظات مهمة

⚠️ **تأكد من:**
1. عدم تكرار البريد الإلكتروني
2. عدم تكرار رقم الهاتف
3. قوة كلمة المرور
4. صحة الإحداثيات الجغرافية
5. ملء جميع الحقول المطلوبة

✅ **تذكر:**
1. البريد سيحتاج للتحقق
2. البيانات ستُخزن بأمان
3. يمكن تحديث الملف الشخصي لاحقاً
4. يمكن استرجاع كلمة المرور إذا نسيتها

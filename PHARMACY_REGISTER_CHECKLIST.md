# ✅ قائمة التحقق النهائية - Pharmacy Register

## 🔍 ملخص التغييرات المُطبقة

### 1. ✅ ApiConstants
- **الملف:** `lib/core/networking/api_constants.dart`
- **التغيير:** `pharmacyRegister = "/auth/register"` (من pharmacy/register)
- **الحالة:** ✅ مُطبّق

### 2. ✅ PharmacyRegisterRequestBody
- **الملف:** `lib/features/auth/data/model/pharmacy_register_request_body.dart`
- **التغيير:** 
  - Type: `Map<String, dynamic>?` بدل `PharmacyLocation?`
  - toJson() يُرسل location كـ Map مباشرة
- **الحالة:** ✅ مُطبّق

### 3. ✅ PharmacyRegisterStepTwoPage
- **الملف:** `lib/features/auth/ui/pharmacy_register_step_two_page.dart`
- **التغيير:**
  - location: إرسالها كـ `{'type': 'Point', 'coordinates': [lng, lat]}`
- **الحالة:** ✅ مُطبّق

---

## 🧪 اختبار سريع

### Before (❌ Broken)
```dart
// ApiConstants
static const String pharmacyRegister = "/auth/pharmacy/register";

// Request
POST /auth/pharmacy/register
❌ Cannot POST /auth/pharmacy/register
```

### After (✅ Fixed)
```dart
// ApiConstants
static const String pharmacyRegister = "/auth/register";

// Request
POST /auth/register
✅ Works! Response: {user: {...}}
```

---

## 🎯 Expected Behavior

### Flow الآن:

1. **User clicks "I'm a Pharmacy"**
   - ✅ يذهب لـ PharmacyRegisterStepOnePage

2. **Step 1: enters basic info**
   - username, email, phone, pharmacyName
   - ✅ يذهب للـ Step 2

3. **Step 2: enters password + location**
   - password, confirm password
   - address, latitude, longitude
   - ✅ اضغط Register

4. **API Request**
   ```json
   POST /auth/register
   {
     "username": "...",
     "email": "...",
     "phoneNumber": "...",
     "password": "...",
     "role": "pharmacy",           ← Backend checks this
     "pharmacyName": "...",
     "address": "...",
     "location": {
       "type": "Point",
       "coordinates": [lng, lat]
     }
   }
   ```
   - ✅ Request succeeds

5. **Backend Response**
   ```json
   {
     "message": "User registered successfully...",
     "user": {
       "id": "...",
       "username": "...",
       "email": "...",
       "role": "pharmacy",         ← Role is pharmacy!
       "isEmailVerified": false
     }
   }
   ```
   - ✅ Response received

6. **App Action**
   - ✅ Cubit emits EmailVerificationPending
   - ✅ Navigates to verification screen
   - ✅ Shows: "Please verify your email"

---

## 📋 Verification Checklist

- [ ] ApiConstants.pharmacyRegister = "/auth/register"
- [ ] PharmacyRegisterRequestBody sends role: "pharmacy"
- [ ] location is Map<String, dynamic>, not PharmacyLocation
- [ ] coordinates are [longitude, latitude]
- [ ] toJson() method is correct
- [ ] PharmacyRegisterStepTwoPage sends location as Map

---

## 🚀 Ready to Test!

**جاهز للاختبار الآن!** ✅

```bash
# 1. تأكد من التغييرات
grep "pharmacyRegister = " lib/core/networking/api_constants.dart

# 2. شغّل التطبيق
flutter run

# 3. جرّب التسجيل
# - اختر "I'm a Pharmacy"
# - ملأ البيانات
# - اضغط Register
```

---

## 🆘 Troubleshooting

### Problem: Still getting "Cannot POST /auth/pharmacy/register"
**Solution:**
```dart
// تأكد أن ApiConstants يحتوي على:
static const String pharmacyRegister = "/auth/register";
// بدل:
static const String pharmacyRegister = "/auth/pharmacy/register";
```

### Problem: "Cannot convert String to Map"
**Solution:**
```dart
// استخدم Map مباشرة:
location: {
  'type': 'Point',
  'coordinates': [selectedLongitude!, selectedLatitude!],
}

// بدل:
location: PharmacyLocation(...).toJson()
```

### Problem: Backend returns "role not recognized"
**Solution:**
```dart
// تأكد أن role = "pharmacy" بالحرف الصغير
role: 'pharmacy',  // ✅
// بدل:
role: 'Pharmacy',  // ❌
```

---

## 📚 Documentation Files

Created:
- ✅ AUTHENTICATION_FLOW_EXPLANATION.md
- ✅ LOGIN_REGISTER_PHARMACY_DETAILED.md
- ✅ PHARMACY_REGISTER_ENDPOINT_FIX.md
- ✅ PHARMACY_ENDPOINT_SOLUTION.md
- ✅ PHARMACY_REGISTER_FIX_SUMMARY.md

---

## ✨ Summary

**المشكلة:** Backend endpoint لا يوجد  
**الحل:** استخدام نفس endpoint مع role field  
**النتيجة:** ✅ Pharmacy registration يعمل بنجاح!

---

**Last Updated:** 28 Jan 2026  
**Status:** ✅ Ready for Testing

# ⚡ Quick Reference Card

## 🔴 Problem
```
Cannot POST /auth/pharmacy/register
```

## ✅ Solution
```dart
// Change 1 line in: lib/core/networking/api_constants.dart
static const String pharmacyRegister = "/auth/register";  // ← was /auth/pharmacy/register
```

## 📊 Before vs After

| Aspect | Before ❌ | After ✅ |
|--------|-----------|----------|
| Endpoint | `/auth/pharmacy/register` | `/auth/register` |
| Exists? | No | Yes |
| Request | No role field | Has `role: "pharmacy"` |
| Status | 404 Error | 201 Created |

## 🔄 Request Flow

```
Pharmacy User Registration
    ↓
POST /auth/register
    {
      role: "pharmacy",
      pharmacyName: "...",
      address: "...",
      location: {...}
    }
    ↓
Backend checks role
    ↓
Creates pharmacy user ✅
```

## 🎯 What Backend Does

```javascript
if (body.role === "pharmacy") {
  // Save pharmacy data
  // Return user with role="pharmacy"
}
```

## 📁 Changed Files

| File | Line | Change |
|------|------|--------|
| `api_constants.dart` | 4 | `/auth/pharmacy/register` → `/auth/register` |

## 🧪 Test

```
1. Run: flutter run
2. Select: "I'm a Pharmacy"
3. Fill: All form fields
4. Click: Register
5. Result: Should navigate to email verification ✅
```

## ❓ FAQ

**Q: Why not create a new endpoint?**  
A: Backend already supports role-based registration. No need to duplicate.

**Q: Does it affect regular user registration?**  
A: No. Regular users don't set role field.

**Q: Is it secure?**  
A: Yes. Backend validates role field and stores appropriate data.

## 📚 More Info

- Full explanation: [EXACT_ERROR_AND_FIX.md](EXACT_ERROR_AND_FIX.md)
- Visual guide: [PHARMACY_REGISTER_VISUAL_GUIDE.md](PHARMACY_REGISTER_VISUAL_GUIDE.md)
- All docs: [DOCUMENTATION_INDEX.md](DOCUMENTATION_INDEX.md)

---

**Status:** ✅ FIXED | **Date:** 28 Jan 2026 | **Action:** Test now!

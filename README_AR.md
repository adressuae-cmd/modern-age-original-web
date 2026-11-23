# تشغيل نسخة Modern Age الأصلية داخل المتصفح — بدون إعادة تصميم

هذه **حزمة تشغيل** للنسخة الأصلية `MA 1 – President Simulator v1.0.164` الموجودة في ملف المستخدم XAPK. لا تعيد كتابة اللعبة، ولا تُعدّل APK، ولا تغيّر أنظمة الاقتصاد أو الوزارات أو رسومات اللعبة. الويب يعرض شاشة أندرويد الفعلية عبر بثّ تحكّم من `ws-scrcpy`.

## المطلوب

1. **خادم Linux بمعالج ARM64 أصلي** (مثل خادم Ampere/Graviton)، 4 أنوية، 8GB RAM أو أكثر، و20GB مساحة إضافية؛ دعم Android binderfs والميزات اللازمة لنواة redroid. بعض مزودي السحابة لا يوفرون هذه المتطلبات.
2. Docker Engine وDocker Compose plugin. تحتاج صلاحيات تشغيل containers ذات `privileged: true`؛ لا تشغّلها على خادم مشترك غير موثوق.
3. النسخة الأصلية `game/original.xapk` (تُوفّر بشكل خاص، ولا تُنشر في المستودع العام).

## التشغيل

```bash
chmod +x scripts/*.sh
./scripts/start.sh
```

بعد تثبيت ملفات اللعبة الأصلية الثلاثة، افتح على نفس الخادم `http://127.0.0.1:8000`. هذا مشروع إعداد تشغيل ولم يتم بعد اختبار التطبيق على خادم ARM64 فعلي.

**للتشغيل على iPhone عبر الإنترنت:** لا تفتح المنفذ 8000 للعامة، ولا تفتح ADB 5555. اربط الخادم وجهازك عبر Tailscale أو نفق خاص بالمصادقة و HTTPS. عرض الفيديو والتحكم على iOS يحتاج اختباراً.

## الحفظ والإيقاف

```bash
./scripts/status.sh
./scripts/stop.sh
docker compose up -d android web
```

الحفظ داخل Docker volume `modern-age-original_android_data`. **لا تنفّذ** `docker compose down -v` إلا إذا أردت حذف بيانات أندرويد.

## ما هو مثبت وما هو غير مثبت؟

- ✅ تم فحص XAPK الأصلي وتحديد حزمة `com.oxiwyle.modernage` وإصدار `1.0.164` وثلاثة split APK.
- ✅ توجد سكربتات لتثبيت APK الأصلي عبر `adb install-multiple` وتشغيله على Android.
- ⚠️ **لم نختبر تشغيل اللعبة فعلياً على خادم ARM64**. نجاحها غير مضمون حتى يتم الفحص.
- ⚠️ redroid عادةً بدون Google Play Services وقد تتعطل مزايا مرتبطة بها.
- ⚠️ هذه **ليست نسخة HTML5**؛ اللعبة الأصلية تعمل على Android في الخادم وتُبث عبر المتصفح.

## التشخيص

```bash
./scripts/status.sh
docker compose logs --tail=100 android web
docker compose --profile setup run --rm install_game
```

## التقنيات

- redroid — https://github.com/remote-android/redroid-doc
- ws-scrcpy — https://github.com/ioucode/ws-scrcpy

**تنبيه للوكيل:** لا تستبدل اللعبة بمحاكاة/واجهة مشابهة. لا تعدّل ملفات اللعبة أو تصميمها دون أمر صريح. لا ترفع XAPK/APK إلى المستودع العام. يقتصر هذا المستودع على سكربتات التشغيل.
#!/usr/bin/env bash
# 一键构建并签名「今天赚了吗」APK
# 用法：在项目根目录下运行  ZHUANLEMA_KS_PASS=你的密码 bash tools/build.sh
set -euo pipefail
cd "$(dirname "$0")/.."

APKTOOL=tools/apktool.jar
SIGNER=tools/uber-apk-signer.jar
KEYSTORE=signing/zhuanlema.jks
KS_PASS="${ZHUANLEMA_KS_PASS:-}"
KS_ALIAS="${ZHUANLEMA_KS_ALIAS:-zhuanlema}"

for f in "$APKTOOL" "$SIGNER" "$KEYSTORE"; do
  [ -f "$f" ] || { echo "缺少文件：$f（见 README.md）"; exit 1; }
done
[ -n "$KS_PASS" ] || { echo "请先设置签名密码：export ZHUANLEMA_KS_PASS=你的密码（见 README.md）"; exit 1; }

mkdir -p build dist

echo "1/2 编译……"
# 只把 Android 需要的文件交给 apktool，避免把 README、tools 等打进安装包
rm -rf build/src && mkdir -p build/src
cp -r AndroidManifest.xml apktool.yml assets res smali build/src/
java -jar "$APKTOOL" b build/src -o build/unsigned.apk

echo "2/2 对齐并签名……"
rm -rf build/signed
java -jar "$SIGNER" -a build/unsigned.apk -o build/signed \
  --ks "$KEYSTORE" --ksAlias "$KS_ALIAS" --ksPass "$KS_PASS" --ksKeyPass "$KS_PASS"

cp build/signed/unsigned-aligned-signed.apk dist/zhuanlema.apk
echo "完成：dist/zhuanlema.apk"

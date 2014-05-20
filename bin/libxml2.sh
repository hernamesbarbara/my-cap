#!/bin/bash

export VERSION=2.9.0

. `dirname $0`/functions.sh

setup /usr/local/include/libxml2/libxml/parser.h "echo $VERSION"
download ftp://xmlsoft.org/libxml2/libxml2-$VERSION.tar.gz
#build libxml2-$VERSION

# Cut from here down.
tar zxf libxml2-$VERSION.tar.gz
cd libxml2-$VERSION
patch -p1 <<EOF
diff --git a/threads.c b/threads.c
index f206149..7e85a26 100644
--- a/threads.c
+++ b/threads.c
@@ -146,6 +146,7 @@ struct _xmlRMutex {
 static pthread_key_t globalkey;
 static pthread_t mainthread;
 static pthread_once_t once_control = PTHREAD_ONCE_INIT;
+static pthread_once_t once_control_init = PTHREAD_ONCE_INIT;
 static pthread_mutex_t global_init_lock = PTHREAD_MUTEX_INITIALIZER;
 #elif defined HAVE_WIN32_THREADS
 #if defined(HAVE_COMPILER_TLS)
@@ -915,7 +916,7 @@ xmlCleanupThreads(void)
 #ifdef HAVE_PTHREAD_H
     if ((libxml_is_threaded)  && (pthread_key_delete != NULL))
         pthread_key_delete(globalkey);
-    once_control = PTHREAD_ONCE_INIT;
+    once_control = once_control_init;
 #elif defined(HAVE_WIN32_THREADS) && !defined(HAVE_COMPILER_TLS) && (!defined(LIBXML_STATIC) || defined(LIBXML_STATIC_FOR_DLL))
     if (globalkey != TLS_OUT_OF_INDEXES) {
         xmlGlobalStateCleanupHelperParams *p;
EOF
./configure
make
make install


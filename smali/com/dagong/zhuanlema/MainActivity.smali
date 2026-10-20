.class public Lcom/dagong/zhuanlema/MainActivity;
.super Landroid/app/Activity;
.source "MainActivity.java"


# instance fields
.field private web:Landroid/webkit/WebView;


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Landroid/app/Activity;-><init>()V

    return-void
.end method


# virtual methods
.method protected onCreate(Landroid/os/Bundle;)V
    .registers 6

    invoke-super {p0, p1}, Landroid/app/Activity;->onCreate(Landroid/os/Bundle;)V

    # web = new WebView(this)
    new-instance v0, Landroid/webkit/WebView;

    invoke-direct {v0, p0}, Landroid/webkit/WebView;-><init>(Landroid/content/Context;)V

    iput-object v0, p0, Lcom/dagong/zhuanlema/MainActivity;->web:Landroid/webkit/WebView;

    # page background matches the app (#FFF4D9) so there is no white flash
    const v1, -0xb27

    invoke-virtual {v0, v1}, Landroid/webkit/WebView;->setBackgroundColor(I)V

    invoke-virtual {v0}, Landroid/webkit/WebView;->getSettings()Landroid/webkit/WebSettings;

    move-result-object v1

    const/4 v2, 0x1

    invoke-virtual {v1, v2}, Landroid/webkit/WebSettings;->setJavaScriptEnabled(Z)V

    invoke-virtual {v1, v2}, Landroid/webkit/WebSettings;->setDomStorageEnabled(Z)V

    invoke-virtual {v1, v2}, Landroid/webkit/WebSettings;->setAllowFileAccess(Z)V

    const/4 v3, 0x0

    invoke-virtual {v1, v3}, Landroid/webkit/WebSettings;->setMediaPlaybackRequiresUserGesture(Z)V

    invoke-virtual {v1, v3}, Landroid/webkit/WebSettings;->setSupportZoom(Z)V

    # ignore the system font-size setting so the big numbers keep their layout
    const/16 v3, 0x64

    invoke-virtual {v1, v3}, Landroid/webkit/WebSettings;->setTextZoom(I)V

    # window.ZBridge (save certificate to gallery). Any failure here, including a class
    # verification error, is swallowed so the app still starts; the page then falls back
    # to "take a screenshot".
    :bridge_start
    new-instance v1, Lcom/dagong/zhuanlema/Bridge;

    invoke-direct {v1, p0}, Lcom/dagong/zhuanlema/Bridge;-><init>(Landroid/app/Activity;)V

    const-string v2, "ZBridge"

    invoke-virtual {v0, v1, v2}, Landroid/webkit/WebView;->addJavascriptInterface(Ljava/lang/Object;Ljava/lang/String;)V

    :bridge_end
    .catchall {:bridge_start .. :bridge_end} :bridge_failed

    goto :bridge_done

    :bridge_failed
    move-exception v1

    :bridge_done
    const-string v3, "file:///android_asset/index.html"

    invoke-virtual {v0, v3}, Landroid/webkit/WebView;->loadUrl(Ljava/lang/String;)V

    invoke-virtual {p0, v0}, Lcom/dagong/zhuanlema/MainActivity;->setContentView(Landroid/view/View;)V

    return-void
.end method

.method public onBackPressed()V
    .registers 3

    iget-object v0, p0, Lcom/dagong/zhuanlema/MainActivity;->web:Landroid/webkit/WebView;

    if-eqz v0, :exit

    invoke-virtual {v0}, Landroid/webkit/WebView;->canGoBack()Z

    move-result v1

    if-eqz v1, :exit

    invoke-virtual {v0}, Landroid/webkit/WebView;->goBack()V

    return-void

    :exit
    invoke-super {p0}, Landroid/app/Activity;->onBackPressed()V

    return-void
.end method

.method protected onResume()V
    .registers 2

    invoke-super {p0}, Landroid/app/Activity;->onResume()V

    iget-object v0, p0, Lcom/dagong/zhuanlema/MainActivity;->web:Landroid/webkit/WebView;

    if-eqz v0, :done

    invoke-virtual {v0}, Landroid/webkit/WebView;->onResume()V

    invoke-virtual {v0}, Landroid/webkit/WebView;->resumeTimers()V

    :done
    return-void
.end method

.method protected onPause()V
    .registers 2

    iget-object v0, p0, Lcom/dagong/zhuanlema/MainActivity;->web:Landroid/webkit/WebView;

    if-eqz v0, :done

    invoke-virtual {v0}, Landroid/webkit/WebView;->onPause()V

    :done
    invoke-super {p0}, Landroid/app/Activity;->onPause()V

    return-void
.end method

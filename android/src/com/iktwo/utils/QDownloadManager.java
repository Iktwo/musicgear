package com.iktwo.utils;

import android.content.Context;
import android.app.DownloadManager;
import android.app.DownloadManager.Request;
import android.net.Uri;
import android.util.Log;
import android.os.Environment;

public class QDownloadManager extends org.qtproject.qt5.android.bindings.QtActivity {
    private static final String TAG = "QDownloadManager";
    private static DownloadManager dm;
    private static QDownloadManager mInstance;

    public QDownloadManager() {
        mInstance = this;
    }

    public static void download(String url, String name) {
        Log.v(TAG, "download(" + url + ", " + name + ")");
        dm = (DownloadManager) mInstance.getSystemService(DOWNLOAD_SERVICE);
        Request request = new Request(Uri.parse(url));
        request.setTitle(name);
        request.setDescription(url);
        request.allowScanningByMediaScanner();
        request.setNotificationVisibility(Request.VISIBILITY_VISIBLE_NOTIFY_COMPLETED);
        request.setDestinationInExternalPublicDir(Environment.DIRECTORY_MUSIC, name + ".mp3");
        dm.enqueue(request);
    }
}

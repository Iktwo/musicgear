package com.iktwo.utils;

import android.app.DownloadManager;
import android.app.DownloadManager.Request;
import android.content.Context;
import android.net.Uri;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Environment;
import android.util.Log;

public class QDownloadManager extends org.qtproject.qt5.android.bindings.QtActivity
{
    private static final String TAG = "QDownloadManager";
    private static DownloadManager dm;
    private static ConnectivityManager cm;
    private static QDownloadManager m_instance;

    public QDownloadManager()
    {
        m_instance = this;
    }

    @Override
    protected void onStart()
    {
        super.onStart();
        m_instance = this;
    }

    public static void download(String url, String name)
    {
        Log.v(TAG, "download(" + url + ", " + name + ")");
        dm = (DownloadManager) m_instance.getSystemService(DOWNLOAD_SERVICE);
        Request request = new Request(Uri.parse(url));
        request.setTitle(name);
        request.setDescription(url);
        request.allowScanningByMediaScanner();
        request.setNotificationVisibility(Request.VISIBILITY_VISIBLE_NOTIFY_COMPLETED);
        request.setDestinationInExternalPublicDir(Environment.DIRECTORY_MUSIC, name + ".mp3");
        dm.enqueue(request);
    }

    public static String connectionType()
    {
        cm = (ConnectivityManager) m_instance.getSystemService(CONNECTIVITY_SERVICE);
        NetworkInfo netInfo = cm.getActiveNetworkInfo();
        return netInfo.getTypeName();
    }
}

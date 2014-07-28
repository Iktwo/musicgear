package com.iktwo.musicgear;

import android.app.DownloadManager;
import android.app.DownloadManager.Request;
import android.content.Context;
import android.content.Intent;
import android.os.Environment;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.Uri;
import android.util.DisplayMetrics;
import android.util.Log;
import android.widget.Toast;

import com.iktwo.musicgear.R;

public class MusicGear extends org.qtproject.qt5.android.bindings.QtActivity
{
    private static final String TAG = "MusicGear";
    private static DownloadManager dm;
    private static ConnectivityManager cm;
    private static MusicGear m_instance;

    public MusicGear()
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

    public static void share(String name, String url)
    {
        Intent share = new Intent(android.content.Intent.ACTION_SEND);
        share.setType("text/plain");
        share.addFlags(Intent.FLAG_ACTIVITY_CLEAR_WHEN_TASK_RESET);
        share.putExtra(Intent.EXTRA_SUBJECT, name);
        if (!name.isEmpty()) {
            share.putExtra(Intent.EXTRA_TEXT, name + " - " + url + " via Musicgear");
            m_instance.startActivity(Intent.createChooser(share, "Share " + name));
        } else {
            share.putExtra(Intent.EXTRA_TEXT, url + " via Musicgear");
            m_instance.startActivity(Intent.createChooser(share, "Share this music"));
        }

    }

    public static void toast(final String message)
    {
        m_instance.runOnUiThread(new Runnable() {
            public void run() {
                Toast.makeText(m_instance.getApplicationContext(), message, Toast.LENGTH_SHORT).show();
            }
        });
    }

    public static int getDPI()
    {
        DisplayMetrics dm = m_instance.getResources().getDisplayMetrics();
        return dm.densityDpi;
    }

    public static boolean isTablet()
    {
        return m_instance.getResources().getBoolean(R.bool.isTablet);
    }

    public static String connectionType()
    {
        cm = (ConnectivityManager) m_instance.getSystemService(CONNECTIVITY_SERVICE);
        NetworkInfo netInfo = cm.getActiveNetworkInfo();
        return netInfo.getTypeName();
    }
}

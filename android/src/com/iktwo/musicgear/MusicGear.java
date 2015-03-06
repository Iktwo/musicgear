package com.iktwo.musicgear;

import android.app.DownloadManager;
import android.app.DownloadManager.Request;
import android.content.Context;
import android.content.Intent;
import android.os.Environment;
import android.net.Uri;
import android.util.Log;
import android.widget.Toast;
import android.os.Bundle;
import android.telephony.PhoneStateListener;
import android.telephony.TelephonyManager;

import com.iktwo.musicgear.R;

public class MusicGear extends org.qtproject.qt5.android.bindings.QtActivity
{
    private static final String TAG = "MusicGear";
    private static DownloadManager dm;
    private static MusicGear m_instance;
    private boolean isPausedByCall = false;

    private PhoneStateListener phoneStateListener;
    private TelephonyManager telephonyManager;

    public MusicGear()
    {
        m_instance = this;
    }

    @Override
    protected void onStart()
    {
        super.onStart();
        m_instance = this;

        /*
        telephonyManager = (TelephonyManager) getSystemService(Context.TELEPHONY_SERVICE);
                phoneStateListener = new PhoneStateListener() {
                    @Override
                    public void onCallStateChanged(int state, String incomingNumber) {
                        // String stateString = "N/A";
                        Log.v(TAG, "Starting CallStateChange");
                        switch (state) {
                            case TelephonyManager.CALL_STATE_OFFHOOK:
                            case TelephonyManager.CALL_STATE_RINGING:
                                if (m_mediaPlayer != null) {
                                    pauseMedia();
                                    isPausedByCall = true;
                                }

                                break;
                            case TelephonyManager.CALL_STATE_IDLE:
                                // Phone idle. Start playing.
                                if (m_mediaPlayer != null) {
                                    if (isPausedByCall) {
                                        isPausedByCall = false;
                                        playMedia();
                                    }

                                }
                                break;
                        }

                    }
                };

                telephonyManager.listen(phoneStateListener, PhoneStateListener.LISTEN_CALL_STATE);
        */
    }

    @Override
    public void onDestroy() {
        if (phoneStateListener != null) {
            telephonyManager.listen(phoneStateListener, PhoneStateListener.LISTEN_NONE);
        }
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

    public static boolean isTablet()
    {
        return m_instance.getResources().getBoolean(R.bool.isTablet);
    }
}

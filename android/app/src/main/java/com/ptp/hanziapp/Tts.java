package com.ptp.hanziapp;

import android.annotation.TargetApi;
import android.app.Activity;
import android.speech.tts.TextToSpeech;
import android.speech.tts.TextToSpeech.OnInitListener;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.StringTokenizer;

import android.util.Log;
import android.widget.Toast;

/**
 * TtsPlugin
 */
@TargetApi(11)
public class Tts implements OnInitListener {

    static private Activity activity = null;
    static private TextToSpeech myTTS = null;
    static private String wordsToSpeak = null;
    static private int curStatus = TextToSpeech.ERROR;

    public Tts(Activity activity) {
        curStatus = TextToSpeech.ERROR;
        wordsToSpeak = null;
        if(this.activity!=null && this.activity.getLocalClassName() != activity.getLocalClassName() && myTTS!=null){
            myTTS.stop(); // 不管是否正在朗读TTS都被打断
            myTTS.shutdown(); // 关闭，释放资源
            myTTS = null;
        }
        if(myTTS==null){
            this.activity = activity;
            myTTS = new TextToSpeech(activity, this);
        }
    }

    public void onInit(int initStatus) {
        curStatus = initStatus;
        if (initStatus == TextToSpeech.ERROR) {
            Log.i("onInit","initStatus == TextToSpeech.ERROR");
            Toast.makeText(this.activity, "Sorry! Text To Speech failed...", Toast.LENGTH_LONG).show();
        } else if(initStatus == TextToSpeech.SUCCESS){
            Log.i("onInit","initStatus == TextToSpeech.SUCCESS");
            if(wordsToSpeak!=null){
                processSpeak(wordsToSpeak);
                Log.i("onInit",wordsToSpeak);
                wordsToSpeak = null;
            }
        }
    }

    void processSpeak(String text){
        myTTS.setLanguage(Locale.CHINA);
        int steplen = 100;
        int total = text.length();
        myTTS.speak((steplen>total)?text:text.substring(0,steplen), TextToSpeech.QUEUE_FLUSH, null);
        for(int i=steplen;i<total;i+=steplen){
            if(i+steplen>total){
                myTTS.speak(text.substring(i), TextToSpeech.QUEUE_ADD, null);
            } else {
                myTTS.speak(text.substring(i,i+steplen), TextToSpeech.QUEUE_ADD, null);
            }
        }
    }

    void speak(String text) {
        if(curStatus==TextToSpeech.SUCCESS) {
            Log.i("speak","initStatus == TextToSpeech.SUCCESS");
            processSpeak(text);
        } else {
            Log.i("speak","initStatus == TextToSpeech.ERROR");
            wordsToSpeak = text;
        }
    }

    void stop() {
        myTTS.stop(); // 不管是否正在朗读TTS都被打断
        myTTS.shutdown(); // 关闭，释放资源
        wordsToSpeak = null;
        myTTS = null;
    }

    Boolean isLanguageAvailable(String locale) {
        Boolean isAvailable = false;
        try {
            isAvailable = myTTS.isLanguageAvailable(stringToLocale(locale)) == TextToSpeech.LANG_COUNTRY_AVAILABLE;
        } finally {
            return isAvailable;
        }
    }

    Boolean setLanguage(String locale) {
        Boolean success = false;
        try {
            myTTS.setLanguage(stringToLocale(locale));
            success = true;
        } finally {
            return success;
        }

    }

    List<String> getAvailableLanguages() {
        Locale[] locales = Locale.getAvailableLocales();
        List<String> localeList = new ArrayList<String>();
        for (Locale locale : locales) {
            int res = myTTS.isLanguageAvailable(locale);
            if (res == TextToSpeech.LANG_COUNTRY_AVAILABLE) {
                localeList.add(locale.toString().replace("_", "-"));
            }
        }
        return localeList;
    }

    private Locale stringToLocale(String locale) {
        String l = null;
        String c = null;
        StringTokenizer tempStringTokenizer = new StringTokenizer(locale,"-");
        if(tempStringTokenizer.hasMoreTokens()){
            l = tempStringTokenizer.nextElement().toString();
        }
        if(tempStringTokenizer.hasMoreTokens()){
            c = tempStringTokenizer.nextElement().toString();
        }
        return new Locale(l,c);
    }
}

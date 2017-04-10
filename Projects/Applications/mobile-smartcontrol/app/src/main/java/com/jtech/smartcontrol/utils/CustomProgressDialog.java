package com.jtech.smartcontrol.utils;

import android.app.ProgressDialog;
import android.content.Context;

/**
 * Created by tjozsa on 3/7/2017.
 */

public class CustomProgressDialog{

    public static ProgressDialog progressDialog;

    public static void show(Context context, String message){
        progressDialog = new ProgressDialog(context);
        progressDialog.setIndeterminate(true);
        progressDialog.setProgressStyle(ProgressDialog.STYLE_SPINNER);
        progressDialog.setMessage(message);
        progressDialog.show();
    }
    public static void dismiss(){
        if (progressDialog.isShowing()){
            progressDialog.dismiss();
        }
    }

}

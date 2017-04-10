package com.example.odzo.ledcontrol_v2.helper;

import android.content.Context;
import android.content.SharedPreferences;

import com.example.odzo.ledcontrol_v2.R;

import java.io.StringWriter;

/**
 * Created by OdzO on 2017.01.21..
 */

public class SettingsValues{

    private static final String RED = ";255;0;0";
    private static final String GREEN = ";0;255;0";
    private static final String BLUE = ";0;0;255";

    private static SettingsValues mSettingsValue;
    private SharedPreferences sharedPref;
    //lehet hogy a contextből kiszedhetem a sharedprefet
    private Context context;


    public SettingsValues(SharedPreferences sharedPref, Context context){
        this.sharedPref = sharedPref;
        this.context = context;
    }

    public static SettingsValues getInstance(SharedPreferences sharedPref, Context context){
        if(mSettingsValue == null){
            mSettingsValue = new SettingsValues(sharedPref, context);
        }
        return mSettingsValue;
    }

    public static SettingsValues getInstance(){
        return mSettingsValue;
    }

    public String buildMessage(){
        StringWriter sw = new StringWriter();
        switch (sharedPref.getInt(context.getString(R.string.effect_value), 0)){
            case 0: //fix 1 color
                sw.append("fix");
                sw.append(getColor(1));
                break;
            case 1: //flash 1 color
                sw.append("flash1");
                sw.append(getColor(1));
                sw.append(";" + (int)(sharedPref.getFloat(context.getString(R.string.effect_speed), 1.0f)*2));
                break;
            case 2: //flash 2 color
                sw.append("flash2");
                sw.append(getColor(1));
                sw.append(getColor(2));
                sw.append(";" + (int)(sharedPref.getFloat(context.getString(R.string.effect_speed), 1.0f)*2));
                break;
            case 3: //carousel 1 color
                sw.append("carousel1");
                sw.append(getColor(1));
                sw.append(";" + (int)(sharedPref.getFloat(context.getString(R.string.effect_speed), 1.0f)*2));
                break;
            case 4: //carousel 2 color
                sw.append("carousel2");
                sw.append(getColor(1));
                sw.append(getColor(2));
                sw.append(";" + (int)(sharedPref.getFloat(context.getString(R.string.effect_speed), 1.0f)*2));
                break;
        }
        return sw.toString();
    }

    private String getColor(int selectorIndex){
        StringWriter sw = new StringWriter();
        switch (selectorIndex){
            case 1:
                switch (sharedPref.getInt(context.getString(R.string.color1_value), 0)){
                    case 0:
                        sw.append(RED);
                        break;
                    case 1:
                        sw.append(GREEN);
                        break;
                    case 2:
                        sw.append(BLUE);
                        break;
                    default:
                        sw.append(";");
                        sw.append(Integer.toString(sharedPref.getInt(context.getString(R.string.c_color1_red), 0)));
                        sw.append(";");
                        sw.append(Integer.toString(sharedPref.getInt(context.getString(R.string.c_color1_green), 0)));
                        sw.append(";");
                        sw.append(Integer.toString(sharedPref.getInt(context.getString(R.string.c_color1_blue), 0)));
                        break;
                }
                return sw.toString();
            case 2:
                switch (sharedPref.getInt(context.getString(R.string.color2_value), 0)){
                    case 0:
                        sw.append(RED);
                        break;
                    case 1:
                        sw.append(GREEN);
                        break;
                    case 2:
                        sw.append(BLUE);
                        break;
                    default:
                        sw.append(";");
                        sw.append(Integer.toString(sharedPref.getInt(context.getString(R.string.c_color2_red), 0)));
                        sw.append(";");
                        sw.append(Integer.toString(sharedPref.getInt(context.getString(R.string.c_color2_green), 0)));
                        sw.append(";");
                        sw.append(Integer.toString(sharedPref.getInt(context.getString(R.string.c_color2_blue), 0)));
                        break;
                }
                return sw.toString();
            default:
                return "";
        }
    }

}

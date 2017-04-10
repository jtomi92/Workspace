package com.example.odzo.ledcontrol_v2;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.Button;

import com.example.odzo.ledcontrol_v2.helper.BTConn;
import com.example.odzo.ledcontrol_v2.helper.SettingsValues;

public class MainActivity extends AppCompatActivity {

    private Button b_exit;
    private Button b_power;
    private SharedPreferences sharedPref;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        sharedPref = getSharedPreferences(getString(R.string.prefered_file_key), Context.MODE_PRIVATE);

        b_exit = (Button)findViewById(R.id.exitButton);
        b_exit.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {
                Exit();
            }
        });

        b_power = (Button)findViewById(R.id.power);
        if(sharedPref.getInt(getString(R.string.power_status), 0) == 0){
            b_power.setText("Turn on");
        }else{
            b_power.setText("Turn off");
        }

        SettingsValues.getInstance(sharedPref, this);
        BTConn.getInstance(this).setDevice(sharedPref.getString(getString(R.string.selected_device_name),"BT_device"));
        SharedPreferences.Editor editor = sharedPref.edit();
        editor.putInt(getString(R.string.connection_status), BTConn.getInstance().connect());
        editor.commit();
    }

    public void openSettings(View view) {
        Intent intent = new Intent(this, SettingsActivity.class);
        startActivity(intent);
    }

    public void powerOnOff(View view){
        int power_status = sharedPref.getInt(getString(R.string.power_status), 0);
        SharedPreferences.Editor editor = sharedPref.edit();
        if(power_status == 0){
            editor.putInt(getString(R.string.power_status), 1);
            editor.commit();
            BTConn.getInstance().send(SettingsValues.getInstance().buildMessage());
            b_power.setText("Turn off");
        }else{
            BTConn.getInstance().send("off");
            editor.putInt(getString(R.string.power_status), 0);
            editor.commit();
            b_power.setText("Turn on");
        }
    }

    private void Exit(){
        System.out.println("Closing application.");
        System.exit(0);
    }
}

package com.example.odzo.ledcontrol_v2;

import android.content.Context;
import android.content.SharedPreferences;
import android.graphics.Color;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.SeekBar;

public class CustomColorPickerActivity extends AppCompatActivity {

    private View colorBoard;
    private SeekBar red_bar;
    private SeekBar green_bar;
    private SeekBar blue_bar;

    SharedPreferences sharedPref;
    private int color_index;
    private int red_value;
    private int green_value;
    private int blue_value;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_custom_color_picker);

        color_index = getIntent().getIntExtra("extra_odzo_color_index",1);
        red_bar = (SeekBar)findViewById(R.id.seekBar1);
        green_bar = (SeekBar)findViewById(R.id.seekBar2);
        blue_bar = (SeekBar)findViewById(R.id.seekBar3);
        colorBoard = (View)findViewById(R.id.colorBoard);
        sharedPref = getSharedPreferences(getString(R.string.prefered_file_key), Context.MODE_PRIVATE);

        switch (color_index){
            case 1:
                red_value = sharedPref.getInt(getString(R.string.c_color1_red), 0);
                green_value = sharedPref.getInt(getString(R.string.c_color1_green), 0);
                blue_value = sharedPref.getInt(getString(R.string.c_color1_blue), 0);
                break;
            case 2:
                red_value = sharedPref.getInt(getString(R.string.c_color2_red), 0);
                green_value = sharedPref.getInt(getString(R.string.c_color2_green), 0);
                blue_value = sharedPref.getInt(getString(R.string.c_color2_blue), 0);
                break;
            default:
                red_value = 0;
                green_value = 0;
                blue_value = 0;
                break;
        }

        colorBoard.setBackgroundColor(Color.rgb(red_value,green_value,blue_value));
        red_bar.setProgress(red_value);
        green_bar.setProgress(green_value);
        blue_bar.setProgress(blue_value);


        red_bar.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            @Override
            public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {
                colorBoard.setBackgroundColor(Color.rgb(progress,green_value,blue_value));
                red_value = progress;
            }

            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {

            }

            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {

            }
        });

        green_bar.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            @Override
            public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {
                colorBoard.setBackgroundColor(Color.rgb(red_value,progress,blue_value));
                green_value = progress;
            }

            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {

            }

            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {

            }
        });

        blue_bar.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            @Override
            public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {
                colorBoard.setBackgroundColor(Color.rgb(red_value,green_value,progress));
                blue_value = progress;
            }

            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {

            }

            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {

            }
        });
    }

    public void saveCustomColor(View view){
        SharedPreferences.Editor editor = sharedPref.edit();
        switch (color_index){
            case 1:
                editor.putInt(getString(R.string.c_color1_red), red_value);
                editor.putInt(getString(R.string.c_color1_green), green_value);
                editor.putInt(getString(R.string.c_color1_blue), blue_value);
                editor.putString(getString(R.string.c_color1_status), "active");
                break;
            case 2:
                editor.putInt(getString(R.string.c_color2_red), red_value);
                editor.putInt(getString(R.string.c_color2_green), green_value);
                editor.putInt(getString(R.string.c_color2_blue), blue_value);
                editor.putString(getString(R.string.c_color2_status), "active");
                break;
            default:
                break;
        }
        editor.commit();
        setResult(RESULT_OK);
        finish();
    }

    public void cancelCustomColor(View view){
        setResult(RESULT_CANCELED);
        finish();
    }
}

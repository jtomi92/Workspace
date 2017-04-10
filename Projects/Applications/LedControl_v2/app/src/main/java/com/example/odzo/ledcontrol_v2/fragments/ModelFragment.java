package com.example.odzo.ledcontrol_v2.fragments;


import android.content.Context;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.SeekBar;
import android.widget.TextView;

import com.example.odzo.ledcontrol_v2.R;
import com.example.odzo.ledcontrol_v2.helper.BTConn;

public class ModelFragment extends Fragment {

    private SharedPreferences sharedPref;
    private View view;
    private SeekBar ledNumBar;
    private TextView ledNumVal;

    public static ModelFragment newInstance() {
        ModelFragment fragment = new ModelFragment();
        return fragment;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        sharedPref = getActivity().getSharedPreferences(getString(R.string.prefered_file_key), Context.MODE_PRIVATE);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        view = inflater.inflate(R.layout.fragment_model, container, false);

        ledNumVal = (TextView) view.findViewById(R.id.LedNumValue);
        ledNumVal.setText(Integer.toString(sharedPref.getInt(view.getContext().getString(R.string.led_number), 1)));

        ledNumBar = (SeekBar) view.findViewById(R.id.LedNumBar);
        ledNumBar.setProgress(sharedPref.getInt(view.getContext().getString(R.string.led_number), 1));
        ledNumBar.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            @Override
            public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {
                SharedPreferences.Editor editor = sharedPref.edit();
                editor.putInt(getString(R.string.led_number), progress);
                editor.commit();
                ledNumVal.setText(Integer.toString(sharedPref.getInt(view.getContext().getString(R.string.led_number), 1)));
            }

            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {

            }

            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {
                BTConn.getInstance().send("lednum;" + Integer.toString(sharedPref.getInt(view.getContext().getString(R.string.led_number), 1)));
            }
        });

        return view;
    }
}
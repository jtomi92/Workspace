package com.example.odzo.ledcontrol_v2.fragments;


import android.content.Context;
import android.content.SharedPreferences;
import android.graphics.Color;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.SeekBar;
import android.widget.Spinner;
import android.widget.TextView;

import com.example.odzo.ledcontrol_v2.R;
import com.example.odzo.ledcontrol_v2.helper.BTConn;
import com.example.odzo.ledcontrol_v2.helper.SettingsValues;

public class DisplayFragment extends Fragment {

    private SharedPreferences sharedPref;
    private View view;
    private Spinner spinner1;
    private ArrayAdapter<CharSequence> adapter1;
    private ArrayAdapter<CharSequence> adapter2;
    private Spinner spinner2;
    private SeekBar speedBar;
    private TextView speedBarVal;

    public static DisplayFragment newInstance() {
        DisplayFragment fragment = new DisplayFragment();
        return fragment;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        sharedPref = getActivity().getSharedPreferences(getString(R.string.prefered_file_key), Context.MODE_PRIVATE);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        view = inflater.inflate(R.layout.fragment_display, container, false);

        spinner1 = (Spinner) view.findViewById(R.id.spinner1);
        adapter1 = ArrayAdapter.createFromResource(view.getContext(), R.array.colors_array, android.R.layout.simple_spinner_item);
        adapter1.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        spinner1.setAdapter(adapter1);
        if(sharedPref.getString(getString(R.string.c_color1_status),"inactive").equals("active")){
            spinner1.setSelection(adapter1.getCount()-1);
        }else{
            spinner1.setSelection(sharedPref.getInt(getString(R.string.color1_value), 0));
        }
        spinner1.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {

            SharedPreferences.Editor editor = sharedPref.edit();
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                editor.putInt(getString(R.string.color1_value), position);
                editor.putString(getString(R.string.c_color1_status), "inactive");
                editor.commit();
                BTConn.getInstance().send(SettingsValues.getInstance().buildMessage());
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });

        spinner2 = (Spinner) view.findViewById(R.id.spinner2);
        adapter2 = ArrayAdapter.createFromResource(view.getContext(), R.array.colors_array, android.R.layout.simple_spinner_item);
        adapter2.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        spinner2.setAdapter(adapter2);
        if(sharedPref.getString(getString(R.string.c_color2_status),"inactive").equals("active")){
            spinner2.setSelection(adapter2.getCount()-1);
        }else{
            spinner2.setSelection(sharedPref.getInt(getString(R.string.color2_value), 0));
        }
        spinner2.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {

            SharedPreferences.Editor editor = sharedPref.edit();
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                editor.putInt(getString(R.string.color2_value), position);
                editor.putString(getString(R.string.c_color2_status), "inactive");
                spinner2.setBackgroundColor(Color.parseColor("#c9c9c9"));
                editor.commit();
                BTConn.getInstance().send(SettingsValues.getInstance().buildMessage());
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });

        Spinner effect_spinner = (Spinner) view.findViewById(R.id.spinner3);
        ArrayAdapter<CharSequence> adapter3 = ArrayAdapter.createFromResource(view.getContext(),
                R.array.effects_array, android.R.layout.simple_spinner_item);
        adapter3.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        effect_spinner.setAdapter(adapter3);
        effect_spinner.setSelection(sharedPref.getInt(getString(R.string.effect_value), 0));

        effect_spinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {

            SharedPreferences.Editor editor = sharedPref.edit();
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                editor.putInt(getString(R.string.effect_value), position);
                editor.commit();
                BTConn.getInstance().send(SettingsValues.getInstance().buildMessage());
                whatToShow();
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });

        speedBarVal = (TextView) view.findViewById(R.id.seekbarValue);
        speedBarVal.setText(Float.toString(sharedPref.getFloat(view.getContext().getString(R.string.effect_speed), 1.0f)));

        speedBar = (SeekBar) view.findViewById(R.id.seekBar4);
        speedBar.setProgress((int)(sharedPref.getFloat(view.getContext().getString(R.string.effect_speed), 1.0f)*2));
        speedBar.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            @Override
            public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {
                Float val = 0.5f * progress;
                SharedPreferences.Editor editor = sharedPref.edit();
                editor.putFloat(getString(R.string.effect_speed), val);
                editor.commit();
                speedBarVal.setText(Float.toString(sharedPref.getFloat(view.getContext().getString(R.string.effect_speed), 1.0f)));
            }

            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {

            }

            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {
                BTConn.getInstance().send(SettingsValues.getInstance().buildMessage());
            }
        });

        whatToShow();
        return view;
    }

    public void setCustomColorText(int index){
        switch (index){
            case 1:
                spinner1.setSelection(adapter1.getCount()-1);
                break;
            case 2:
                spinner2.setSelection(adapter2.getCount()-1);
                break;
            default:
                break;
        }
    }

    public boolean isCustomColorText(int index){
        switch (index){
            case 1:
                if(spinner1.getSelectedItemPosition() == adapter1.getCount()-1){
                    return true;
                }else{
                    return false;
                }
            case 2:
                if(spinner2.getSelectedItemPosition() == adapter2.getCount()-1){
                    return true;
                }else{
                    return false;
                }
            default:
                return true;
        }
    }

    private void whatToShow(){
        TextView tv2 = (TextView) view.findViewById(R.id.textView2);
        TextView tv4 = (TextView) view.findViewById(R.id.textView4);
        Spinner s2 = (Spinner) view.findViewById(R.id.spinner2);
        Button b2 = (Button) view.findViewById(R.id.b_custom2);
        switch (sharedPref.getInt(getString(R.string.effect_value), 0)){
            case 0: //fix 1 color
                tv2.setVisibility(View.GONE);
                s2.setVisibility(View.GONE);
                b2.setVisibility(View.GONE);
                speedBar.setVisibility(View.GONE);
                speedBarVal.setVisibility(View.GONE);
                tv4.setVisibility(View.GONE);
                break;
            case 1: //flash 1 color
                tv2.setVisibility(View.GONE);
                s2.setVisibility(View.GONE);
                b2.setVisibility(View.GONE);
                speedBar.setVisibility(View.VISIBLE);
                speedBarVal.setVisibility(View.VISIBLE);
                tv4.setVisibility(View.VISIBLE);
                break;
            case 2: //flash 2 color
                tv2.setVisibility(View.VISIBLE);
                s2.setVisibility(View.VISIBLE);
                b2.setVisibility(View.VISIBLE);
                speedBar.setVisibility(View.VISIBLE);
                speedBarVal.setVisibility(View.VISIBLE);
                tv4.setVisibility(View.VISIBLE);
                break;
            case 3: //carousel 1 color
                tv2.setVisibility(View.GONE);
                s2.setVisibility(View.GONE);
                b2.setVisibility(View.GONE);
                speedBar.setVisibility(View.VISIBLE);
                speedBarVal.setVisibility(View.VISIBLE);
                tv4.setVisibility(View.VISIBLE);
                break;
            case 4: //carousel 2 color
                tv2.setVisibility(View.VISIBLE);
                s2.setVisibility(View.VISIBLE);
                b2.setVisibility(View.VISIBLE);
                speedBar.setVisibility(View.VISIBLE);
                speedBarVal.setVisibility(View.VISIBLE);
                tv4.setVisibility(View.VISIBLE);
                break;
        }
    }
}
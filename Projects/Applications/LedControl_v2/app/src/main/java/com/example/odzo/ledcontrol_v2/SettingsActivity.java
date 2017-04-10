package com.example.odzo.ledcontrol_v2;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.design.widget.TabLayout;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.view.ViewPager;
import android.support.v7.app.AppCompatActivity;
import android.view.View;

import com.example.odzo.ledcontrol_v2.fragments.BluetoothFragment;
import com.example.odzo.ledcontrol_v2.fragments.DisplayFragment;
import com.example.odzo.ledcontrol_v2.fragments.ModelFragment;
import com.example.odzo.ledcontrol_v2.helper.BTConn;
import com.example.odzo.ledcontrol_v2.helper.SettingsValues;

public class SettingsActivity extends AppCompatActivity {

    private DisplayFragment df;
    private BluetoothFragment bf;
    private int CUSTOM_COLOR1_CODE = 1;
    private int CUSTOM_COLOR2_CODE = 2;
    private SharedPreferences sharedPref;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_settings);

        ViewPager viewPager = (ViewPager) findViewById(R.id.viewpager);
        viewPager.setAdapter(new SampleFragmentPagerAdapter(getSupportFragmentManager(), this));

        TabLayout tabLayout = (TabLayout) findViewById(R.id.sliding_tabs);
        tabLayout.setupWithViewPager(viewPager);

        sharedPref = getSharedPreferences(getString(R.string.prefered_file_key), Context.MODE_PRIVATE);
    }

    public class SampleFragmentPagerAdapter extends FragmentPagerAdapter {
        final int PAGE_COUNT = 3;
        private String tabTitles[] = new String[] { "Display", "Bluetooth", "Model" };
        private Context context;

        public SampleFragmentPagerAdapter(FragmentManager fm, Context context) {
            super(fm);
            this.context = context;
        }

        @Override
        public int getCount() {
            return PAGE_COUNT;
        }

        @Override
        public Fragment getItem(int position) {
            switch (position){
                case 0:
                    df = DisplayFragment.newInstance();
                    return df;
                case 1:
                    bf = BluetoothFragment.newInstance();
                    return bf;
                case 2:
                    return ModelFragment.newInstance();
                default:
                    return null;
            }
        }

        @Override
        public CharSequence getPageTitle(int position) {
            return tabTitles[position];
        }
    }

    public void showCustomColorPicker1(View view){
        Intent intent = new Intent(this, CustomColorPickerActivity.class);
        intent.putExtra("extra_odzo_color_index",1);
        startActivityForResult(intent,CUSTOM_COLOR1_CODE);
    }

    public void showCustomColorPicker2(View view){
        Intent intent = new Intent(this, CustomColorPickerActivity.class);
        intent.putExtra("extra_odzo_color_index",2);
        startActivityForResult(intent,CUSTOM_COLOR2_CODE);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == CUSTOM_COLOR1_CODE) {
            if (resultCode == RESULT_OK) {
                if(df.isCustomColorText(1)){
                    BTConn.getInstance().send(SettingsValues.getInstance().buildMessage());
                }else{
                    df.setCustomColorText(1);
                }
            }
        }else if (requestCode == CUSTOM_COLOR2_CODE) {
            if (resultCode == RESULT_OK) {
                if(df.isCustomColorText(2)){
                    BTConn.getInstance().send(SettingsValues.getInstance().buildMessage());
                }else{
                    df.setCustomColorText(2);
                }
            }
        }
    }

}

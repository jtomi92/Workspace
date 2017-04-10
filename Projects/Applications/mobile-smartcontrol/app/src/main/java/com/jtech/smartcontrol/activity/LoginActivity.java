package com.jtech.smartcontrol.activity;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;

import com.jtech.smartcontrol.R;
import com.jtech.smartcontrol.model.UserProfile;
import com.jtech.smartcontrol.utils.CustomProgressDialog;
import com.jtech.smartcontrol.utils.RestUtils;

import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;

public class LoginActivity extends AppCompatActivity {

    private final Context context = this;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.login_activity);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        setUpLoginInterface();

        SharedPreferences preferences = PreferenceManager.getDefaultSharedPreferences(context);
        String email = preferences.getString("email", "");
        if(!email.equalsIgnoreCase("")) {
            EditText editText = (EditText) findViewById(R.id.email_edit_text);
            editText.setText(email);
        }

        String password = preferences.getString("password", "");
        if(!password.equalsIgnoreCase("")) {
            EditText editText = (EditText) findViewById(R.id.password_edit_text);
            editText.setText(password);
        }

    }

    private void setUpLoginInterface(){
        final EditText emailEditText = (EditText) findViewById(R.id.email_edit_text);
        final EditText passwordEditText = (EditText) findViewById(R.id.password_edit_text);
        Button loginButton = (Button) findViewById(R.id.login_button);

        loginButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String email = emailEditText.getText().toString();
                String password = passwordEditText.getText().toString();

                new GetUserProfileTask(email, password).execute();
            }
        });
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        menu.add("Web Console");
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();
        if (item.getTitle().equals("Web Console")){
            Intent browserIntent = new Intent(Intent.ACTION_VIEW, Uri.parse("http://www.google.com"));
            startActivity(browserIntent);
        }

        if (item.getTitle().equals("Settings")){
            Intent intent = new Intent(context,ConfigurationActivity.class);
            startActivity(intent);
        }

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }



    private class GetUserProfileTask extends AsyncTask<Void, Void, UserProfile> {

        private String email = "";
        private String password = "";

        private GetUserProfileTask(String email, String password) {
            this.email = email;
            this.password = password;
        }

        @Override
        protected void onPreExecute() {
            CustomProgressDialog.show(LoginActivity.this,"Loading...");
            super.onPreExecute();
        }

        @Override
        protected UserProfile doInBackground(Void... params) {
            try {
                RestUtils.initialize(email,password);
                ResponseEntity<UserProfile> response = RestUtils.getRestTemplate().exchange(RestUtils.REST_GET_USERPROFILE_BY_NAME, HttpMethod.GET, RestUtils.getHttpEntity(),
                        UserProfile.class, email);
                return response.getBody();
            } catch (Exception e) {
                Log.e("RestUtils", e.getMessage(), e);
            }
            return null;
        }

        @Override
        protected void onPostExecute(UserProfile userProfile) {
            CustomProgressDialog.dismiss();
            if (userProfile != null){
                SharedPreferences preferences = PreferenceManager.getDefaultSharedPreferences(context);
                SharedPreferences.Editor editor = preferences.edit();
                editor.putString("email",email);
                editor.putString("password",password);
                editor.apply();

                Intent intent = new Intent(context,ComponentActivity.class);
                intent.putExtra("userprofile",userProfile);
                intent.putExtra("email",email);
                intent.putExtra("password",password);
                startActivity(intent);
            }
        }
    }
}

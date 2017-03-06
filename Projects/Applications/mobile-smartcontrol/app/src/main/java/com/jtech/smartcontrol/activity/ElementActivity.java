package com.jtech.smartcontrol.activity;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.Toast;

import com.jtech.smartcontrol.R;
import com.jtech.smartcontrol.model.Component;
import com.jtech.smartcontrol.model.Element;
import com.jtech.smartcontrol.model.Relay;
import com.jtech.smartcontrol.model.UserProfile;
import com.jtech.smartcontrol.utils.ComponentListAdapter;
import com.jtech.smartcontrol.utils.ElementListAdapter;
import com.jtech.smartcontrol.utils.RestUtils;

import java.util.LinkedList;
import java.util.List;

/**
 * Created by tjozsa on 3/4/2017.
 */

public class ElementActivity extends AppCompatActivity {

    private final Context context = this;
    private ListView listView;
    private RestUtils restUtils;
    private Component component;
    private String email;
    private String password;
    private UserProfile userProfile;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.element_activity);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        setUpFloatingActionButton();

        email = getIntent().getStringExtra("email");
        password = getIntent().getStringExtra("password");
        component = (Component) getIntent().getSerializableExtra("component");
        userProfile = (UserProfile) getIntent().getSerializableExtra("userprofile");

        restUtils = new RestUtils(email,password);

        listView = (ListView) findViewById(R.id.element_list_view);
        listView.setAdapter(new ElementListAdapter(context, component, email, password, userProfile));

    }

    @Override
    protected void onResume() {
        if (restUtils != null){
            List<Component> componentList = restUtils.getComponents(userProfile.getUserId());
            for (Component comp : componentList){
                if (comp.getComponentId().equals(component.getComponentId())){
                    component = comp;
                }
            }
            listView = (ListView) findViewById(R.id.element_list_view);
            listView.setAdapter(new ElementListAdapter(context, component, email, password, userProfile));
        }
        super.onResume();
    }


    public void setUpFloatingActionButton(){
        FloatingActionButton fab = (FloatingActionButton) findViewById(R.id.fab2);
        fab.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                AlertDialog.Builder builder = new AlertDialog.Builder(context);
                // Get the layout inflater
                LayoutInflater inflater = ElementActivity.this.getLayoutInflater();

                // Inflate and set the layout for the dialog
                // Pass null as the parent view because its going in the dialog layout
                final View v1 = inflater.inflate(R.layout.component_dialogbox, null);
                builder.setView(v1)
                        // Add action buttons
                        .setPositiveButton(R.string.ok, new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialog, int id) {
                                EditText editText = (EditText)v1.findViewById(R.id.component_edit_text);
                                String elementName = editText.getText().toString();
                                Element element = new Element();
                                element.setElementName(elementName);
                                element.setElementId(component.getElements().size()+1);
                                element.setSequence(component.getElements().size()+1);
                                element.setRelays(new LinkedList<Relay>());
                                component.addElement(element);

                                restUtils.updateComponent(component, userProfile.getUserId());
                                listView.setAdapter(new ElementListAdapter(context, component, email, password, userProfile));

                            }
                        })
                        .setNegativeButton(R.string.cancel, new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialog, int id) {

                            }
                        });
                builder.create();
                builder.show();
            }
        });
    }


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }
}

package com.jtech.smartcontrol.adapter;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.AsyncTask;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.EditText;
import android.widget.TextView;

import com.jtech.smartcontrol.R;
import com.jtech.smartcontrol.activity.ElementActivity;
import com.jtech.smartcontrol.model.Component;
import com.jtech.smartcontrol.model.UserProfile;
import com.jtech.smartcontrol.utils.AnimationUtils;
import com.jtech.smartcontrol.utils.CustomProgressDialog;
import com.jtech.smartcontrol.utils.RestUtils;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;

import java.util.List;

/**
 * Created by tjozsa on 2/27/2017.
 */

public class ComponentListAdapter extends BaseAdapter {

    Context context;
    List<Component> componentList;
    private String email;
    private String password;
    private UserProfile userProfile;
    private static LayoutInflater inflater = null;

    public ComponentListAdapter(Context context, List<Component> componentList, String email, String password, UserProfile userProfile) {
        // TODO Auto-generated constructor stub
        this.email = email;
        this.password = password;
        this.userProfile = userProfile;
        this.context = context;
        this.componentList = componentList;
        inflater = (LayoutInflater) context
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);
    }

    @Override
    public int getCount() {
        // TODO Auto-generated method stub
        return componentList.size();
    }

    @Override
    public Object getItem(int position) {
        // TODO Auto-generated method stub
        return componentList.get(position);
    }

    @Override
    public long getItemId(int position) {
        // TODO Auto-generated method stub
        return position;
    }

    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        // TODO Auto-generated method stub
        View vi = convertView;
        if (vi == null)
            vi = inflater.inflate(R.layout.component_list_item, null);
        TextView componentName = (TextView) vi.findViewById(R.id.component_name_text_view);
        componentName.setText(componentList.get(position).getComponentName());
        vi.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                v.startAnimation(AnimationUtils.buttonClick);
                Component component = componentList.get(position);
                Intent intent = new Intent(context, ElementActivity.class);
                intent.putExtra("email",email);
                intent.putExtra("password",password);
                intent.putExtra("userprofile",userProfile);
                intent.putExtra("component",component);
                context.startActivity(intent);
            }
        });

        vi.setOnLongClickListener(new View.OnLongClickListener() {
            @Override
            public boolean onLongClick(View v) {
                v.startAnimation(AnimationUtils.buttonClick);
                AlertDialog.Builder builder = new AlertDialog.Builder(context);
                // Inflate and set the layout for the dialog
                // Pass null as the parent view because its going in the dialog layout
                final View v1 = inflater.inflate(R.layout.component_dialogbox, null);
                EditText editText = (EditText) v1.findViewById(R.id.component_edit_text);
                editText.setText(componentList.get(position).getComponentName());
                builder.setView(v1)
                        // Add action buttons
                        .setPositiveButton(R.string.ok, new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialog, int id) {
                                EditText editText = (EditText) v1.findViewById(R.id.component_edit_text);
                                String componentName = editText.getText().toString();
                                Component component = componentList.get(position);
                                component.setComponentName(componentName);
                                new UpdateComponentTask(component, userProfile.getUserId(), email, password).execute();
                            }
                        })
                        .setNegativeButton(R.string.cancel, new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialog, int id) {

                            }
                        })
                        .setNeutralButton("Delete", new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialog, int which) {
                                new DeleteComponentTask(userProfile.getUserId(), componentList.get(position).getComponentId(), email, password).execute();
                                componentList.remove(position);
                            }
                        });
                builder.create();
                builder.show();

                return false;
            }
        });
        return vi;
    }

    private class UpdateComponentTask extends AsyncTask<Void, Void, Integer> {

        private Component component;
        private Integer userId;
        private String email;
        private String password;

        private UpdateComponentTask(Component component, Integer userId, String email, String password) {
            this.component = component;
            this.userId = userId;
            this.email = email;
            this.password = password;
        }

        @Override
        protected void onPreExecute() {
            CustomProgressDialog.show(context,"Loading...");
            super.onPreExecute();
        }

        @Override
        protected Integer doInBackground(Void... params) {
            try {
                RestUtils.initialize(email, password);
                HttpEntity<Object> httpEntity = new HttpEntity<Object>(component, RestUtils.getRequestHeaders());
                ResponseEntity<Integer> response = RestUtils.getRestTemplate().exchange(RestUtils.REST_UPDATE_COMPONENT, HttpMethod.PUT,
                        httpEntity, Integer.class, userId);
                return response.getBody();
            } catch (Exception e) {
                Log.e("RestUtils", e.getMessage(), e);
            }
            return 0;
        }

        @Override
        protected void onPostExecute(Integer response) {
            CustomProgressDialog.dismiss();
        }
    }


    private class DeleteComponentTask extends AsyncTask<Void, Void, Integer> {

        private Integer userId;
        private Integer componentId;
        private String email;
        private String password;

        public DeleteComponentTask(Integer userId, Integer componentId, String email, String password) {
            this.userId = userId;
            this.componentId = componentId;
            this.email = email;
            this.password = password;
        }

        @Override
        protected void onPreExecute() {
            CustomProgressDialog.show(context,"Loading...");
            super.onPreExecute();
        }

        @Override
        protected Integer doInBackground(Void... params) {
            try {
                RestUtils.initialize(email, password);
                ResponseEntity<Integer> responseEntity = RestUtils.getRestTemplate().exchange(RestUtils.REST_DELETE_COMPONENT, HttpMethod.PUT, RestUtils.getHttpEntity(), Integer.class, userId, componentId);
                return responseEntity.getBody();
            } catch (Exception e) {
                Log.e("RestUtils", e.getMessage(), e);
            }
            return 0;
        }

        @Override
        protected void onPostExecute(Integer response) {
            CustomProgressDialog.dismiss();
            ComponentListAdapter.this.notifyDataSetChanged();
        }
    }
}

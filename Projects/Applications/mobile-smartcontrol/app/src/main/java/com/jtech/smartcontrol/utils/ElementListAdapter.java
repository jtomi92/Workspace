package com.jtech.smartcontrol.utils;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.jtech.smartcontrol.R;
import com.jtech.smartcontrol.activity.RelayActivity;
import com.jtech.smartcontrol.model.Component;
import com.jtech.smartcontrol.model.Element;
import com.jtech.smartcontrol.model.UserProfile;

import java.util.List;

/**
 * Created by tjozsa on 3/4/2017.
 */

public class ElementListAdapter extends BaseAdapter {

    Context context;
    Component component;
    private String email;
    private String password;
    private UserProfile userProfile;
    private static LayoutInflater inflater = null;

    public ElementListAdapter(Context context, Component component, String email, String password, UserProfile userProfile) {
        // TODO Auto-generated constructor stub
        this.email = email;
        this.password = password;
        this.userProfile = userProfile;
        this.context = context;
        this.component = component;
        inflater = (LayoutInflater) context
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);
    }

    @Override
    public int getCount() {
        // TODO Auto-generated method stub
        return component.getElements().size();
    }

    @Override
    public Object getItem(int position) {
        // TODO Auto-generated method stub
        return component.getElements().get(position);
    }

    @Override
    public long getItemId(int position) {
        // TODO Auto-generated method stub
        return position;
    }

    @Override
    public View getView(final int position, View convertView, final ViewGroup parent) {
        // TODO Auto-generated method stub
        View vi = convertView;
        if (vi == null)
            vi = inflater.inflate(R.layout.element_list_item, null);
        TextView elementName = (TextView) vi.findViewById(R.id.element_name_text_view);
        elementName.setText(component.getElements().get(position).getElementName());
        vi.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Element element = component.getElements().get(position);
                Intent intent = new Intent(context, RelayActivity.class);
                intent.putExtra("component",component);
                intent.putExtra("element",element);
                intent.putExtra("email",email);
                intent.putExtra("password",password);
                intent.putExtra("userprofile",userProfile);
                context.startActivity(intent);
            }
        });

        vi.setOnLongClickListener(new View.OnLongClickListener() {
            @Override
            public boolean onLongClick(View v) {

                final AlertDialog.Builder builder = new AlertDialog.Builder(context);
                // Inflate and set the layout for the dialog
                // Pass null as the parent view because its going in the dialog layout
                final View v1 = inflater.inflate(R.layout.component_dialogbox, null);
                EditText editText = (EditText) v1.findViewById(R.id.component_edit_text);
                editText.setText(component.getElements().get(position).getElementName());
                builder.setView(v1)
                        // Add action buttons
                        .setPositiveButton(R.string.ok, new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialog, int id) {
                                EditText editText = (EditText) v1.findViewById(R.id.component_edit_text);
                                String elementName = editText.getText().toString();
                                Element element = component.getElements().get(position);
                                element.setElementName(elementName);
                                RestUtils restUtils = new RestUtils(email, password);
                                restUtils.updateComponent(component, userProfile.getUserId());
                            }
                        })
                        .setNegativeButton(R.string.cancel, new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialog, int id) {

                            }
                        })
                        .setNeutralButton("Delete", new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialog, int which) {
                                component.getElements().remove(position);
                                RestUtils restUtils = new RestUtils(email, password);
                                restUtils.updateComponent(component, userProfile.getUserId());
                                ElementListAdapter.this.notifyDataSetChanged();
                            }
                        });
                builder.create();
                builder.show();

                return false;
            }
        });
        return vi;
    }
}

package com.example.mapnews;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;

public class HomeActivity extends AppCompatActivity {

    Button toMaps;
    TextView countryChoice;
    String countrySelected = "Select a country";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_home);

        countryChoice = findViewById(R.id.countrySelected);

        toMaps = findViewById(R.id.toMaps);
        toMaps.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(HomeActivity.this, MapsActivity.class);
                intent.putExtra("Country selected", countrySelected);
                startActivity(intent);
            }
        });


        //To get the country selected from maps
        Bundle extras = getIntent().getExtras();
        if (extras != null) {
            countrySelected = extras.getString("Country selected");
            countryChoice.setText("Country selected: " + countrySelected);
        }
    }

}

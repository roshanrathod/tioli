
# tiolo
Flutter Web Application

Installation steps	

Since web support is still a technical preview, you need the latest in-development version of Flutter, also referred to as the master channel. In the root folder of the weather_app_flutter repository, run the following commands:
    flutter channel master
    flutter upgrade

The upgrade process may take a few minutes. Next, you will need to enable web support in your Flutter installation so that it is available to this and other apps you develop on this workstation:
    flutter config --enable-web
    flutter devices

Once web support is enabled, you will see a new Chrome device in the device list. Restart Visual Studio Code after running these commands to refresh the device list menu if you don’t see Chrome in that list yet.

To add web support to the weather app, you need to run this command in the top-level folder of the tioli repository:
    flutter create .
    flutter run -d chrome


Common issue which you can come accross

If came accross following issue:
'The current Flutter SDK version is 1.9.1+hotfix.6. Because app_name depends on shared_preferences >=0.5.4+9 which requires Flutter SDK version >=1.10.0 <2.0.0, version solving failed. pub get failed (1)'

    Run "flutter upgrade" and this should fix your issue

Then follow the above installation instructions


**Important

Before performing any command update the launch.json file so that you can run the application on web

Add "args": ["-d", "<device name from adb devices output>"] under configurations  
 
{
    "version": "x.x.x",
    "configurations": [
        {
            "name": "Flutter",
            "request": "launch",
            "type": "dart",
            "args": ["-d", "<device name from adb devices output>"]
        }
    ]
}


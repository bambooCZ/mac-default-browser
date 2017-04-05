# MacKeychainModule

> I am not a Obj-C++ guy, feel free to improve this

Node module for interaction with macOS default browser (aka handler for "http", "https" schemes).

## Building

```bash
cd MacDefaultBrowser ;
sudo npm install -g nw-gyp ;
nw-gyp configure --target=0.21.4 --arch=x64 ;
nw-gyp build --target=0.21.4;
```

Result will be in *build/Release* directory

## Usage example

```javascript
const MY_APP_ID = "com.mycompany.myapp";

var MacDefaultBrowser = require('./build/Release/MacDefaultBrowser.node');

var currentDefaultBrowser = MacDefaultBrowser.getDefaultBrowser();
if (currentDefaultBrowser != MY_APP_ID) {
    MacDefaultBrowser.setDefaultBrowser(MY_APP_ID);
}
```

## JavaScript API

### MacDefaultBrowser.getDefaultBrowser()

- Return value {String} - application ID of system's default browser

This method will get application ID of system's default browser

### MacDefaultBrowser.setDefaultBrowser(appId)

- Parameter {String} **appId** - Application ID of default browser
- Return value {bool} - Success? (Actually user can deny the request...)

This method will set system's default browser

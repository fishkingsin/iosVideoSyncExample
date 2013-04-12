#include "ofMain.h"
#include "testApp.h"

int main(){
	ofAppiPhoneWindow * iOSWindow = new ofAppiPhoneWindow();
	iOSWindow->enableRetinaSupport(); //enable retina!
	ofSetupOpenGL(iOSWindow, 480, 320, OF_FULLSCREEN);
	ofRunApp(new testApp);

//	ofSetupOpenGL(1024,768, OF_FULLSCREEN);			// <-------- setup the GL context
//
//	ofRunApp(new testApp);
}

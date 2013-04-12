#pragma once

#include "ofMain.h"
#include "ofxiPhone.h"
#include "ofxiPhoneExtras.h"
#include "ofxNetwork.h"
#include "ofxEasyRetina.h"
#include "ofxiOSEAGLView+retinaPatch.h"
class testApp : public ofxiPhoneApp{
	
    public:
        void setup();
        void update();
        void draw();
        void exit();
	
        void touchDown(ofTouchEventArgs & touch);
        void touchMoved(ofTouchEventArgs & touch);
        void touchUp(ofTouchEventArgs & touch);
        void touchDoubleTap(ofTouchEventArgs & touch);
        void touchCancelled(ofTouchEventArgs & touch);

        void lostFocus();
        void gotFocus();
        void gotMemoryWarning();
        void deviceOrientationChanged(int newOrientation);
		ofiPhoneVideoPlayer player;
		ofDirectory dir;
		ofxTCPClient tcpClient;
		bool weConnected;
		float connectTime , deltaTime ;
int port,currentVideoIdx;
string host;
	ofRectangle playerRect;
	
	ofxEasyRetina retina; //declare an ofxEasyRetina instance
};



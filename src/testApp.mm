#include "testApp.h"
#include "Settings.h"
//--------------------------------------------------------------
void testApp::setup(){	
	// initialize the accelerometer
	ofSetLogLevel(OF_LOG_VERBOSE);
	ofxAccelerometer.setup();
	
	//If you want a landscape oreintation 
	iPhoneSetOrientation(OFXIPHONE_ORIENTATION_LANDSCAPE_RIGHT);

//	ofSetWindowShape(1024 , 768);

	dir.allowExt("m4v");
	dir.listDir(ofxiPhoneGetDocumentsDirectory());

	ofBackground(127,127,127);
	currentVideoIdx = 0;
	if(dir.getFiles().size()>0)player.loadMovie(dir.getPath(currentVideoIdx));
	else
	{

	}
	player.play();
	player.setLoopState(OF_LOOP_NORMAL);
	// Get an integer and a string value
    port = Settings::getInt("Port" , 2838);
    host = Settings::getString("Host" , "192.168.6.133");
	
	weConnected = tcpClient.setup(host,port);
	//optionally set the delimiter to something else.  The delimter in the client and the server have to be the same
	tcpClient.setMessageDelimiter("\n");
	
	connectTime = 0;
	deltaTime = 0;
	
	tcpClient.setVerbose(true);
	playerRect.set(0,0,1024, player.getHeight()*(1024/player.getWidth()));
	playerRect.y = (ofGetHeight()*0.5)-playerRect.height*0.5;
	ofSetupScreen();

}

//--------------------------------------------------------------
void testApp::update(){
	if(prevVideoIndex!=currentVideoIdx)
	{
		player.stop();
		player.loadMovie(dir.getPath(currentVideoIdx));
		player.play();
		player.setLoopState(OF_LOOP_NORMAL);
		prevVideoIndex = currentVideoIdx;
	}
	if(player.isLoaded())player.update();
	//we are connected - lets send our text and check what we get back
	if(weConnected){
		unsigned long time = ofGetSystemTime();
		if(ofGetFrameNum()%10==0)tcpClient.send("timecode_"+ofToString(player.getPosition())+"_"+ofToString(time));
		string msg = tcpClient.receive();
		if(msg.find("video_")!=string::npos)
		{
			string sub = msg.substr(7,string::npos);
			ofLogVerbose()<< sub;
		}
		
		if(!tcpClient.isConnected()){
			weConnected = false;
		}
	}else{
		//if we are not connected lets try and reconnect every 5 seconds
		deltaTime = ofGetElapsedTimeMillis() - connectTime;
		
		if( deltaTime > 5000 ){
			weConnected = tcpClient.setup(host,port);
			connectTime = ofGetElapsedTimeMillis();
		}
		
	}
}

//--------------------------------------------------------------
void testApp::draw(){
	retina.setupScreenOrtho();
		if(player.isLoaded())player.getTexture()->draw(playerRect);
}

//--------------------------------------------------------------
void testApp::exit(){

}

//--------------------------------------------------------------
void testApp::touchDown(ofTouchEventArgs & touch){
	currentVideoIdx++;
	currentVideoIdx%=dir.getFiles().size();
	tcpClient.send("video_"+ofToString(currentVideoIdx));
}

//--------------------------------------------------------------
void testApp::touchMoved(ofTouchEventArgs & touch){
	int x = touch.x;
	int width = ofGetWidth();
	float pct = (float)x / (float)width;
	float speed = (2 * pct - 1) * 5.0f;

	player.setFrame(speed);
}

//--------------------------------------------------------------
void testApp::touchUp(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void testApp::touchDoubleTap(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void testApp::touchCancelled(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void testApp::lostFocus(){

}

//--------------------------------------------------------------
void testApp::gotFocus(){

}

//--------------------------------------------------------------
void testApp::gotMemoryWarning(){

}

//--------------------------------------------------------------
void testApp::deviceOrientationChanged(int newOrientation){
//	switch(newOrientation)
//	{
//		case OFXIPHONE_ORIENTATION_PORTRAIT:
////		case UIDeviceOrientationPortraitUpsideDown:
//			/* start special animation */
//			
//			/* start special animation */
////			iPhoneSetOrientation(OFXIPHONE_ORIENTATION_PORTRAIT);
//			
//			
//			playerRect.set(0,0,768, player.getHeight()*(768/player.getWidth()));
//			playerRect.y = (ofGetHeight()*0.5)-playerRect.height*0.5;
//			ofSetupScreen();
//			break;
//			
//		case OFXIPHONE_ORIENTATION_LANDSCAPE_LEFT:
//			
////			iPhoneSetOrientation(OFXIPHONE_ORIENTATION_LANDSCAPE_LEFT);
//			playerRect.set(0,0,1024, player.getHeight()*(1024/player.getWidth()));
//			playerRect.y = (ofGetHeight()*0.5)-playerRect.height*0.5;
//			break;
//		case OFXIPHONE_ORIENTATION_LANDSCAPE_RIGHT:
//
////			iPhoneSetOrientation(OFXIPHONE_ORIENTATION_LANDSCAPE_RIGHT);
//			/* start special animation */
//
			playerRect.set(0,0,1024, player.getHeight()*(1024/player.getWidth()));
			playerRect.y = (ofGetHeight()*0.5)-playerRect.height*0.5;
						ofSetupScreen();
//			break;
//			
//		default:
//			break;
//	};
}


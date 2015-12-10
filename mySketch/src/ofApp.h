#pragma once

#include "ofMain.h"
#include "ofxiOS.h"
#include "ofxiOSExtras.h"
#include "ofxFontStash.h"
#include "ofxThreadedImage.h"
#include "ofxAVString.h"

class ofApp : public ofxiOSApp {
    
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
    
    
    ofAppiOSWindow w;
    bool retina;
    
    //loading::::::::::::::::::::::
    void loading();
    bool wordsLoaded;
    bool loaded;
    int loadingCounter;
    long timer;
    
    //start
    bool start;
    int startRad, helloRad;
    
    //words:::::::::::::::::::::::
    ifstream fin; //file stream
    vector <string> words;
    int wordCounter, oldWord;
    int fontSize;
    int touchTot;
    float opacityX, opacityY, opacity;
    ofRectangle bounds;
    ofxFontStash font;
    ofxAVString avs, avsLoad;
    ofTrueTypeFont fontAvs;
    ofPoint touchPos;
    ofPoint offset;
    
    bool carla;
    bool winLose, lose;
    bool avsPlay = false;
    bool touchUpDown;
    bool redBg, redBgStart, blackBg;
    
    //images::::::::::::::::::::::
    ofxThreadedImage image[6];
    int imageCounter;
    bool imgLoaded;
    void resize(int imgN);
    
    //sounds::::::::::::::::::::::
    ofxiOSSoundPlayer snd;
    bool sndLoaded;
    
};



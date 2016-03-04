#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){
    ofSetFrameRate(60);
    ofBackground(255);
    ofEnableSmoothing();
    ofSetCircleResolution(200);
    ofSetSphereResolution(24);
    imageCounter = 100;
    
    //loading
    imgLoaded = false;
    wordsLoaded = false;
    sndLoaded = false;
    loaded = false;
    loadingCounter = 0;
    
    wordCounter = 0;
    carla = false;
    winLose = false;
    lose = false;
    avsPlay = true;
    redBg = false;
    blackBg = false;
    redBgStart = true;
    touchUpDown = 1;
    
    start = false;
    startRad = 0;
    helloRad = 0;
    
    //get retina support
    if(w.isRetinaEnabled()){
        cout << "retina" << endl;
        retina = true;
    }
    else{
        cout << "non retina" << endl;
        retina = false;
    }
    
    //setup fint for loading text
    if(retina)fontAvs.load("font/Moon Flower.ttf", 36);
    else fontAvs.load("font/Moon Flower.ttf", 36*1.3);
    avsLoad.setup("Please Wait");
    
    end = false;
    
}

//--------------------------------------------------------------
void ofApp::update(){
    
    
    if(loaded){
        //keep pressed to start
        if(!start){
            if(touchTot == 1){
                startRad+=20;
                if(startRad > ofGetWidth()){
                    start = true;
                    wordCounter++; //then start the whole shabang
                }
            }
            else{
                if(startRad>0)startRad -= 50;
                if(startRad<50) startRad = 0;
            }
        }
        
        
        
        //opacity and offset:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        offset.y = -100;//-60 - pressure;
        if(!retina) offset.y *=2.;
        if(touchPos.x > ofGetWidth()/2) opacityX = ofMap(touchPos.x, ofGetWidth()/2, ofGetWidth(), 255, 0);
        else opacityX = ofMap(touchPos.x, ofGetWidth()/2, 0, 255, 0);
        if(touchPos.y > ofGetHeight()/2) opacityY = ofMap(touchPos.y, ofGetHeight()/2, ofGetHeight(), 255, 0);
        else opacityY = ofMap(touchPos.y, ofGetHeight()/2, 0, 255, 0);
        opacity = ofMap(opacityX*opacityY, 0, 255*255, 0, 255);
        
        
        //images and sound cues:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        for(int i = 0; i < 6; i++){
            if(words[wordCounter] == "[image"+ofToString(i)+"]"){
                imageCounter = i;
                if(i == 0) {
                    carla = false;//turn off text on t.up
                    winLose = false;
                }
                resize(i);
                ofSetColor(255, 255, 255,255);
                wordCounter++;
                cout<< "image"+ofToString(i)+".jpg"<<endl;
            }
        }
        
        if(words[wordCounter] == "Bye now."){//stop photos
            imageCounter = 100;
        }
        
        else if(words[wordCounter] == "[snd1]"){//play snd
            if(snd.isPlaying()==false){
                snd.play();
                cout<<"snd"<<endl;
                wordCounter++;
            }
        }
        else if(words[wordCounter] == "[updown]"){//touch up down change
            redBg = true; // red background
            blackBg = !blackBg;
            
            touchUpDown = !touchUpDown;
            wordCounter++;
            
            if(touchUpDown == 0){
                fontSize = (ofGetWidth() / int(words[wordCounter].size()))+30;
                if(!retina) fontSize *= 1.1;
                bounds = font.getBBox(words[wordCounter], fontSize, touchPos.x, touchPos.y);
            }
        }
        else if(words[wordCounter] == "Carla"){//touch up down change
            touchUpDown = 1;
            carla= true;
        }
        else if(words[wordCounter] == "Here, choose:"){//touch up down change
            carla= false;
            winLose = true;
        }
        /* else if(words[wordCounter] == "I’m sorry" && lose){
         wordCounter+=3; //+=7 wordsOld
         }*/
        else if(lose && words[wordCounter] == "you clearly"){
            carla = true;
        }
        else if(words[wordCounter] == "I’m sorry" && !lose){
            carla = true;
        }
        else if(words[wordCounter] == "We learnt" or words[wordCounter] == "Just"){
            carla = false;
        }
        else if(words[wordCounter] == "[exit]"){//touch up down change
            //::exit(0);
            wordCounter++;
            end = true;
        }
    }
    //cout << "font size = " << fontSize << endl;
    
}

//--------------------------------------------------------------
void ofApp::draw(){
    
    if(loaded){
        ofBackground(255);
        ofSetColor(255, 255, 255,255);
        
        
        if(!redBg){
            
            
            if(touchTot == touchUpDown && !winLose){//if touches are just 1/0:::::::::::::::::::::::::::::::::::::::::::::::::::::
                
                //resize if too big to prevent cutting - dirty hack
                if(fontSize > 720) {
                    fontSize = 720;
                    bounds = font.getBBox(words[wordCounter], fontSize, touchPos.x, touchPos.y);
                }
                
                
                ofSetColor(20, opacity);
                if(blackBg){
                    ofBackground(20);
                    ofSetColor(255, opacity);
                    
                }
                
                //special display settings for specific words////////////////
                if(words[wordCounter] == "multi" or words[wordCounter] == "text"){
                    ofBackground(220,20,20);
                    ofSetColor(220, 200, 200, 255);
                }
                if(words[wordCounter] == "One" or words[wordCounter] == "touch." or words[wordCounter] == "TRUE"){
                    ofSetColor(255, 50, 50, 255);
                }
                if(words[wordCounter] == "multi"){
                    for(int i =0; i < 5; i++){
                        font.draw(words[wordCounter], fontSize, touchPos.x-bounds.width/2 + ofRandom(30.), touchPos.y+bounds.height/2 + offset.y+ ofRandom(30.));
                    }
                }
                //standard layout////////////////////////////////////////////
                else{
                    //draw strin
                    font.draw(words[wordCounter], fontSize, touchPos.x-bounds.width/2, touchPos.y+bounds.height/2 + offset.y);
                }
                
            }
            
            else if(touchTot == 0){ //if no touch:::::::::::::::::::::::::::
                
                if (imageCounter >= 0 && imageCounter < 100 ) {//if we display images
                    //image
                    ofSetColor(255, 255, 255,255);
                    image[imageCounter].draw(ofGetWidth()/2 - image[imageCounter].getWidth()/2, ofGetHeight()/2 - image[imageCounter].getHeight()/2);
                }
                if(carla){  //touch up/down text mode
                    ofBackground(20);
                    ofSetColor(220, 200);
                    fontSize = (ofGetWidth() / int(words[wordCounter].size()))+30;
                    if(!retina) fontSize *= 1.5;
                    bounds = font.getBBox(words[wordCounter], fontSize, ofGetWidth()/2, ofGetHeight()/2);
                    font.draw(words[wordCounter], fontSize, ofGetWidth()/2-bounds.width/2, ofGetHeight()/2+bounds.height/2);
                    
                }
                if(words[wordCounter] == "I’m sorry" && lose){
                    wordCounter+=3; //+=7 wordsOld
                }
                
            }
            //winLose:::::::::::::::::::::::::::::::::::::::::::::::::::::
            if (winLose) {
                ofSetColor(255, 50, 50, 255);
                //ofSetLineWidth(2);
                
                fontSize = 72;
                if(!retina) fontSize *= 1.1;
                //ofNoFill();
                //ofDrawCircle(ofGetWidth()/2, ofGetHeight()*(0.2), 40);
                bounds = font.getBBox("WIN", fontSize, touchPos.x, touchPos.y);
                font.draw("WIN", fontSize, ofGetWidth()/2-bounds.width/2, ofGetHeight()*(0.2)+bounds.height/2);
                //ofDrawCircle(ofGetWidth()/2, ofGetHeight()*(0.8), 40);
                bounds = font.getBBox("LOSE", fontSize, touchPos.x, touchPos.y);
                font.draw("LOSE", fontSize, ofGetWidth()/2-bounds.width/2, ofGetHeight()*(0.8)+bounds.height/2);
                
                if(ofDist(touchPos.x, touchPos.y, ofGetWidth()/2, ofGetHeight()*(0.2)) < fontSize){
                    ofFill();
                    ofSetColor(255, 50, 50, 255);
                    ofDrawRectangle(0, 0, ofGetWidth(), ofGetHeight());
                    //ofDrawCircle(ofGetWidth()/2, ofGetHeight()*(0.2), 40);
                    ofSetColor(255);
                    bounds = font.getBBox("WIN", fontSize, touchPos.x, touchPos.y);
                    font.draw("WIN", fontSize, ofGetWidth()/2-bounds.width/2, ofGetHeight()*(0.2)+bounds.height/2);
                }
                else if(ofDist(touchPos.x, touchPos.y, ofGetWidth()/2, ofGetHeight()*(0.8)) < fontSize){
                    ofFill();
                    ofSetColor(255, 50, 50, 255);
                    ofDrawRectangle(0, 0, ofGetWidth(), ofGetHeight());
                    //ofDrawCircle(ofGetWidth()/2, ofGetHeight()*(0.8), 40);
                    ofSetColor(255);
                    bounds = font.getBBox("LOSE", fontSize, touchPos.x, touchPos.y);
                    font.draw("LOSE", fontSize, ofGetWidth()/2-bounds.width/2, ofGetHeight()*(0.8)+bounds.height/2);
                }
                
            }
            
            //avs string effect:::::::::::::::::::::::::::::::::::::::::::::::
            if(words[wordCounter] == "Hello."){
                //ofBackground(255, 50, 50, 255);
                ofSetColor(220, 20, 20, 220);
                if(helloRad<ofGetWidth()*ofGetHeight()) helloRad += 50;
                ofDrawCircle(ofGetWidth()/2, ofGetHeight()/2, helloRad);
                
                if(avsPlay)avs.play(0, 1000, 1000);
                avsPlay = false;
                ofSetColor(255);
                fontAvs.drawString(avs, ofGetWidth()/2-fontAvs.stringWidth(words[wordCounter])/2, ofGetHeight()/2+fontAvs.stringHeight(words[wordCounter])/2);
            }
            //start:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
            if(!start){
                ofSetColor(255);
                ofDrawCircle(ofGetWidth()/2, ofGetHeight()/2, startRad);
            }
        }
        
        
        else{//if redbg - red background animation
            if(redBgStart){
                timer = ofGetElapsedTimeMillis();
                redBgStart = false;
            }
            //for(int i = 0; i < 100; i++){
            
            //                    ofSetColor(220, 20, 20, 220);
            //                    ofDrawCircle(ofGetWidth()/2, ofGetHeight()/2, (ofGetElapsedTimeMillis()-timer)*2);
            if(ofGetElapsedTimeMillis()%2 == 0) ofBackground(20);
            else ofBackground(255);
            
            //}
            
            if (ofGetElapsedTimeMillis()-timer >= 200) {
                redBg = false;
                redBgStart = true;
            }
        }
    }
    
    else{//if loading:::::::::::::::::::::::::::::::::::::::::::::::::::::
        //draw Please Wait animation
        ofSetColor(20, 220);
        
        if(avsPlay){
            avsLoad.play(0, 5, 150);
            timer = ofGetElapsedTimeMillis();
            avsPlay = false;
        }
        
        fontAvs.drawString(avsLoad, ofGetWidth()/2-fontAvs.stringWidth("Please Wait")/2, ofGetHeight()/2+fontAvs.stringHeight("Please Wait")/2);
        
        if (ofGetElapsedTimeMillis()-timer >= 450) {
            loading();
        }
    }
    
    
    
}

//--------------------------------------------------------------
void ofApp::exit(){
}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs & touch){
    
    
    if(start && !redBg && !end){
        //pressure = touch.pressure;
        touchPos.x = touch.x;
        touchPos.y = touch.y;
        //cout << touch.pressure << endl;
        touchTot = touch.numTouches;
        if(touchTot==1 and carla){
            wordCounter++;
        }
        
        //        if(words[wordCounter] == "Hello."){//touch up down change
        //            wordCounter++;
        //        }
        
        fontSize = (ofGetWidth() / int(words[wordCounter].size()))+30;
        if(!retina) fontSize *= 1.1;
        bounds = font.getBBox(words[wordCounter], fontSize, touchPos.x, touchPos.y);
    }
    //cout<<fontSize<<endl;
    touchTot = touch.numTouches;
}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs & touch){
    
    if(start && !redBg){
        //pressure = touch.pressure;
        touchPos.x = touch.x;
        touchPos.y = touch.y;
        //cout << touch.pressure << endl;
        touchTot = touch.numTouches;
    }
    
}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs & touch){
    
    
    if(start && !redBg){
        //pressure = touch.pressure;
        touchPos.x = touch.x;
        touchPos.y = touch.y;
        //cout << touch.pressure << endl;
        
        if(touchTot == 1 && !winLose && !end){
            wordCounter++;
        }
        //win/lose
        if(winLose){
            if(ofDist(touch.x, touch.y, ofGetWidth()/2, ofGetHeight()*(0.2)) < fontSize){
                winLose = false;
                wordCounter+=7;//step five words ahead
            }
            else if(ofDist(touch.x, touch.y, ofGetWidth()/2, ofGetHeight()*(0.8)) < fontSize){
                winLose = false;
                lose = true;
                wordCounter++;
            }
        }
        
        //touch up down inverted (text displays on touch up)
        if(touchUpDown == 0){
            fontSize = (ofGetWidth() / int(words[wordCounter].size()))+30;
            if(!retina) fontSize *= 1.1;
            bounds = font.getBBox(words[wordCounter], fontSize, touchPos.x, touchPos.y);
        }
    }
    //cout<<fontSize<<endl;
    touchTot = touch.numTouches;
    
}

//--------------------------------------------------------------
void ofApp::touchDoubleTap(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void ofApp::touchCancelled(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void ofApp::lostFocus(){
    snd.stop();
    
}

//--------------------------------------------------------------
void ofApp::gotFocus(){
    
    
}

//--------------------------------------------------------------
void ofApp::gotMemoryWarning(){
    
}

//--------------------------------------------------------------
void ofApp::deviceOrientationChanged(int newOrientation){
    printf("orientation changed to %i\n", newOrientation);
    
    //    if(imageCounter <= 5){
    
    if (newOrientation == OF_ORIENTATION_90_LEFT){
        ofSetOrientation(OF_ORIENTATION_90_LEFT);
        if(imageCounter <= 5){
            if(image[imageCounter].getWidth() > image[imageCounter].getHeight()){
                image[imageCounter].resize(ofGetWidth(), (image[imageCounter].getHeight()/image[imageCounter].getWidth()*ofGetWidth()));
            }
            
            else{
                image[imageCounter].resize((image[imageCounter].getWidth()/image[imageCounter].getHeight()*ofGetHeight()), ofGetHeight());
            }
        }
    }
    else if (newOrientation == OF_ORIENTATION_90_RIGHT){
        ofSetOrientation(OF_ORIENTATION_90_RIGHT);
        if(imageCounter <= 5){
            if(image[imageCounter].getWidth() > image[imageCounter].getHeight()){
                image[imageCounter].resize(ofGetWidth(), (image[imageCounter].getHeight()/image[imageCounter].getWidth()*ofGetWidth()));
            }
            else{
                image[imageCounter].resize((image[imageCounter].getWidth()/image[imageCounter].getHeight()*ofGetHeight()), ofGetHeight());
            }
        }
        
    }
    else if (newOrientation == OF_ORIENTATION_180){
        ofSetOrientation(OF_ORIENTATION_180);
        if(imageCounter <= 5){
            if(image[imageCounter].getWidth() > image[imageCounter].getHeight()){
                image[imageCounter].resize(ofGetWidth(), (image[imageCounter].getHeight()/image[imageCounter].getWidth()*ofGetWidth()));
            }
            else{
                image[imageCounter].resize((image[imageCounter].getWidth()/image[imageCounter].getHeight()*ofGetHeight()), ofGetHeight());
            }
        }
    }
    else if (newOrientation == OF_ORIENTATION_DEFAULT){
        ofSetOrientation(OF_ORIENTATION_DEFAULT);
        if(imageCounter <= 5){
            if(image[imageCounter].getWidth() > image[imageCounter].getHeight()){
                image[imageCounter].resize(ofGetWidth(), (image[imageCounter].getHeight()/image[imageCounter].getWidth()*ofGetWidth()));
            }
            else{
                image[imageCounter].resize((image[imageCounter].getWidth()/image[imageCounter].getHeight()*ofGetHeight()), ofGetHeight());
            }
        }
    }
    //    }
}
void ofApp::resize(int imgN){
    if(image[imgN].getWidth() > image[imgN].getHeight()){
        image[imgN].resize(ofGetWidth(), (image[imgN].getHeight()/image[imgN].getWidth()*ofGetWidth()));
    }
    else{
        image[imgN].resize((image[imgN].getWidth()/image[imgN].getHeight()*ofGetHeight()), ofGetHeight());
    }
    
}

void ofApp::loading(){
    //loading
    if(!imgLoaded and !wordsLoaded and !sndLoaded){
        
        image[loadingCounter].load("images/image"+ofToString(loadingCounter)+".jpg");
        cout<< "image "+ofToString(loadingCounter)+" load"<<endl;
        
        loadingCounter++;
        
        if(loadingCounter>=6){
            imgLoaded = true;
        }
    }
    if(imgLoaded and !wordsLoaded and !sndLoaded){
        //load words from txt file:::::::::::::::::::::::::::::::::::::::::::::::::::::::
        fin.open( ofToDataPath("words/words.txt").c_str() ); //open your text file
        if (fin.is_open()) {
            while(fin) //as long as theres still text to be read
            {
                string str; //declare a string for storage
                getline(fin, str); //get a line from the file, put it in the string
                words.push_back(str); //push the string onto a vector of strings
            }
        }else {
            cout << "error: unable to open file." << endl;
        }
        //font and text display:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        fontSize = 36;
        if(!retina) fontSize *= 1.1;
        font.setup("font/Moon Flower.ttf");
        
        wordCounter=0;
        loadingCounter++;
        wordsLoaded = true;
        avs.setup("Hello.");
        
    }
    
    
    if(imgLoaded and wordsLoaded and !sndLoaded){
        //sound file:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        snd.load("sounds/one_last_lemon_tea.mp3");
        snd.setVolume(0.9);
        sndLoaded = true;
        loadingCounter++;
    }
    if(sndLoaded and imgLoaded and wordsLoaded) loaded = true;
    
    avsPlay = true;
    
}

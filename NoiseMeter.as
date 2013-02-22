package {
	import flash.display.*;
	import flash.text.*;
	
	import flash.events.ActivityEvent; 
	import flash.events.StatusEvent; 
	import flash.events.TimerEvent;
	import flash.events.MouseEvent;
	import flash.utils.*;
	import flash.media.Microphone;
	import flash.media.SoundTransform;
	
	import Debug;
	
	import PreferencesPane;
	
	public class NoiseMeter extends Sprite {
		// Attribute
		private var txt:TextField = new TextField();
		private var mic:Microphone = Microphone.getMicrophone();
		private var micTimer:Timer = new Timer(1000);
		private var _yellowLimit:Number = 1;
		private var _redLimit:Number = 2;
		private var btn_openPreferencesPane:Sprite = new Sprite();
		private var malus_points:Number = 0;
		private var yellow_counter:Number = 0;
		private var startDuration:uint = 0;
		private var nowDuration:uint = 0;
		private var txt_countDown:TextField = new TextField();
		private var txt_malus_points:TextField = new TextField();
	
		//Konstruktor
		public function NoiseMeter() {
			stage.color = 0x000000;
			
			
			// Textfeld
			/*var txtFormat:TextFormat = new TextFormat();
			txtFormat.color = 0xFF0000;
			*/
			txt.selectable = false;
			txt.autoSize = TextFieldAutoSize.CENTER;
			txt.text = "Hello World";
			//txt.setTextFormat(txtFormat);
			txt.x = stage.stageWidth/2 - txt.width/2;
			txt.y = stage.stageHeight/10 - txt.height/2;
			txt.background = true;
			addChild(txt);
			
			// Mikrofon
			/*
			var deviceArray:Array = Microphone.names; 
			trace("Available sound input devices:"); 
			for (var i:int = 0; i < deviceArray.length; i++) 
			{ 
			    trace(" " + deviceArray[i]); 
			}
			*/ 
			  
			mic.gain = 100; 
			mic.rate = 11; 
			mic.setUseEchoSuppression(true); 
			mic.setLoopBack(true); 
			mic.setSilenceLevel(0);
			mic.soundTransform = new SoundTransform(0, 0);
			     
			mic.addEventListener(ActivityEvent.ACTIVITY, this.onMicActivity); 
			mic.addEventListener(StatusEvent.STATUS, this.onMicStatus);
			micTimer.addEventListener(TimerEvent.TIMER, this.timerHandler);
			     
			var micDetails:String = "Sound input device name: " + mic.name + '\n'; 
			micDetails += "Gain: " + mic.gain + '\n'; 
			micDetails += "Rate: " + mic.rate + " kHz" + '\n'; 
			micDetails += "Muted: " + mic.muted + '\n'; 
			micDetails += "Silence level: " + mic.silenceLevel + '\n'; 
			micDetails += "Silence timeout: " + mic.silenceTimeout + '\n'; 
			micDetails += "Echo suppression: " + mic.useEchoSuppression + '\n'; 
			txt.text = micDetails;
			
			// Einstellen der Grenzwerte
			var txt_pref_btn_label:TextField = new TextField();
			txt_pref_btn_label.text = "Einstellungen";
			txt_pref_btn_label.multiline = false;
			txt_pref_btn_label.mouseEnabled = false;
			txt_pref_btn_label.autoSize = TextFieldAutoSize.CENTER;
			btn_openPreferencesPane.addChild(txt_pref_btn_label);
			btn_openPreferencesPane.opaqueBackground = 0x333333;
			btn_openPreferencesPane.x = 5;
			btn_openPreferencesPane.height = txt_pref_btn_label.textHeight;
			btn_openPreferencesPane.width = 35;
			btn_openPreferencesPane.buttonMode = true;
			addChild(btn_openPreferencesPane);
			btn_openPreferencesPane.addEventListener(MouseEvent.CLICK, this.openPreferencesPane);
			
			// Count Down
			this.startDuration = getTimer();
			this.txt_countDown.x = stage.width;
			this.txt_countDown.autoSize = TextFieldAutoSize.RIGHT;
			this.txt_countDown.width = 5;
			this.txt_countDown.textColor = 0x555555;
			addChild(this.txt_countDown);
			
			// Anzeige Strafpunkte
			this.txt_malus_points.x = stage.width-95-this.txt_countDown.textWidth;
			this.txt_malus_points.width = 80;
			this.txt_malus_points.textColor = 0x555555;
			this.txt_malus_points.text = "Strafpunkte: " + String(this.malus_points);
			addChild(this.txt_malus_points);
		}
		
		// Methoden und Event Handler
		private function onMicActivity(event:ActivityEvent):void { 
	    	this.micTimer.start();
	    } 
	   
	   	private function onMicStatus(event:StatusEvent):void { 
	      	trace("status: level=" + event.level + ", code=" + event.code);
	    }
	    
	    private function timerHandler(event:TimerEvent):void {
	    	this.txt_malus_points.text = "Strafpunkte: " + String(this.malus_points);
	    	this.nowDuration = getTimer();
	    	this.txt_countDown.text = String(300-int((this.nowDuration-this.startDuration)/1000));
		    this.txt.text = "mic level: " + this.mic.activityLevel;
		    if(this.mic.activityLevel >= this._redLimit) {
			    // red light
			    this.txt.text = "Ihr seid zu laut! (mic level: " + this.mic.activityLevel + ")";
			    this.txt.backgroundColor = 0xFF0000;
			    this.malus_points++;
			    this.startDuration = getTimer();
		    } else {
			    if(this.mic.activityLevel >= this._yellowLimit) {
				    // yellow light
				    this.txt.text = "Grenzwertig! (mic level: " + this.mic.activityLevel + ")";
				    this.txt.backgroundColor = 0xFFFF00;
				    yellow_counter++;
				    // Nach dreimaligem gelben Lärm, gibt's einen Minuspunkt
				    if(this.yellow_counter >= 3) {
				    	this.malus_points++;
				    	this.yellow_counter = 0;
				    }
				    this.startDuration = getTimer();
			    } else {
				    // green light
				    this.txt.text = "Super Lautstärke. :-) (mic level: " + this.mic.activityLevel + ")";
				    this.txt.backgroundColor = 0x00FF00;
				    if(int((this.nowDuration-this.startDuration)/1000)/60 >= 5) {
				    	this.startDuration = getTimer();
				    	this.malus_points--;
				    }
			    }
		    }
		    //Debug.log("malus_points: "+this.malus_points);
	    }
		
	    private function openPreferencesPane(event:MouseEvent):void {
	    	var prefs:PreferencesPane = new PreferencesPane(this._yellowLimit, this._redLimit);
	    	prefs.height = 60;
	    	prefs.width = 100;
	    	this.addChild(prefs);
	    }
	    
	    // Setter und Getter
	    public function set yellowLimit(limit:Number):void {
	    	_yellowLimit = limit;
	    }
	    
	    public function get yellowLimit():Number {
	    	return _yellowLimit;
	    }
	    
	    public function set redLimit(limit:Number):void {
	    	_redLimit = limit;
	    }
	    
	    public function get redLimit():Number {
	    	return _redLimit;
	    }
	}
}
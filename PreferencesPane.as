package {
	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	import mx.messaging.*

	public class PreferencesPane extends Sprite {
		// Attribute
		private var txt_yellow_limit:TextField = new TextField();
		private var txt_yellow_limit_label:TextField = new TextField();
		private var txt_red_limit:TextField = new TextField();
		private var txt_red_limit_label:TextField = new TextField();
		private var btn_close:Sprite = new Sprite();

		//Konstruktor
		public function PreferencesPane(_yellow_limit:Number, _red_limit:Number) {
			this.opaqueBackground = 0x555555;
			
			txt_yellow_limit_label.text = "Grenze Mittellaut:";
			txt_yellow_limit_label.x = 5;
			txt_yellow_limit_label.width = 100;
			this.addChild(txt_yellow_limit_label);
			
			txt_yellow_limit.x = 100;
			txt_yellow_limit.width = 50;
			txt_yellow_limit.border = true;
			txt_yellow_limit.height = txt_yellow_limit_label.textHeight+4;
			txt_yellow_limit.width = 30;
			txt_yellow_limit.type = TextFieldType.INPUT;
			txt_yellow_limit.text = String(_yellow_limit);
			this.addChild(txt_yellow_limit);
			
			txt_red_limit_label.text = "Grenze zu laut:";
			txt_red_limit_label.x = 5;
			txt_red_limit_label.y = txt_yellow_limit.y + txt_yellow_limit.height + 10;
			txt_red_limit_label.width = 100;
			this.addChild(txt_red_limit_label);
			
			txt_red_limit.x = 100;
			txt_red_limit.y = txt_yellow_limit.y + txt_yellow_limit.height + 10;
			txt_red_limit.width = 50;
			txt_red_limit.border = true;
			txt_red_limit.height = txt_red_limit_label.textHeight+4;
			txt_red_limit.width = 30;
			txt_red_limit.type = TextFieldType.INPUT;
			txt_red_limit.text = String(_red_limit);
			this.addChild(txt_red_limit);
			
			var txt_close:TextField = new TextField();
			txt_close.text = "okay";
			txt_close.width = txt_close.textWidth+4;
			txt_close.height = txt_close.textHeight+4;
			txt_close.border = true;
			txt_close.mouseEnabled = false;
			txt_close.autoSize = TextFieldAutoSize.CENTER;
			btn_close.addChild(txt_close);
			btn_close.buttonMode = true;
			btn_close.y = this.height-txt_close.height;
			btn_close.x = this.width-txt_close.width;
			btn_close.addEventListener(MouseEvent.CLICK, this.closePrefPane);
			this.addChild(btn_close);
		}
		
		private function closePrefPane(event:MouseEvent):void {
			var theparent:Object = this.parent;
			theparent.yellowLimit = Number(this.txt_yellow_limit.text);
			theparent.redLimit = Number(this.txt_red_limit.text);
			this.parent.removeChild(this);
		}
	}
}
package com.bumpslide.ui.skin.defaults
{

	import com.bumpslide.ui.Box;
	import com.bumpslide.ui.Component;
	import com.bumpslide.ui.PixelIcon;
	import com.bumpslide.util.Align;

	import flash.text.TextFormatAlign;

	/**
	 * Button with a checkbox on it 
	 *
	 * @author David Knape
	 */
	public class DefaultCheckboxSkin extends DefaultButtonSkin
	{

		public var checkBox:Box;

		public var check:Component;

		override protected function addChildren():void
		{
			super.addChildren();

			// hide the background (make it like the hit area)
			background.alpha = 0;

			checkBox = addChild( new Box( 0xcccccc, 16, 16, 0, 0, 0, 0 ) ) as Box;
			checkBox.filters = [ Style.BEVEL_FILTER_INSET ];

			check = addChild( new PixelIcon( [ '*   *', ' * *', '  * ', ' * *', '*   *' ] ) ) as PixelIcon;
		}


		override protected function draw():void
		{
			super.draw();

			checkBox.width = checkBox.height = background.height;

			Align.center( check, checkBox.width );
			Align.middle( check, checkBox.height );
		}


		override public function _off():void
		{
			checkBox.borderColor = Style.INPUT_BORDER;
			checkBox.backgroundColor = Style.INPUT_BACKGROUND;
			check.visible = false;
		}


		override public function _over():void
		{
			checkBox.borderColor = Style.INPUT_FOCUS_BORDER;
			checkBox.backgroundColor = Style.INPUT_FOCUS_BACKGROUND;
			check.visible = true;
			colorize( check, Style.BUTTON_LABEL_OVER );
		}


		override public function _selected():void
		{
			checkBox.borderColor = Style.INPUT_FOCUS_BORDER;
			checkBox.backgroundColor = Style.INPUT_BACKGROUND;
			check.visible = true;
			colorize( check, Style.BUTTON_LABEL );
		}


		override public function _down():void
		{
			checkBox.borderColor = Style.INPUT_FOCUS_BORDER;
			checkBox.backgroundColor = Style.INPUT_BACKGROUND;
			check.visible = true;
			colorize( check, Style.BUTTON_LABEL );
		}
	}
}

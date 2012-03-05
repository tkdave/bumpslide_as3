package com.bumpslide.ui.skin.touch
{

	import com.bumpslide.ui.Panel;
	import com.bumpslide.ui.Box;
	import com.bumpslide.ui.skin.BasicSliderSkin;


	/**
	 * TouchScrollSkin
	 *
	 * @author David Knape
	 */
	public class TouchScrollSkin extends BasicSliderSkin
	{
		private var handleShape : Box;
		
		
		override protected function addChildren():void 
		{
			//logEnabled = true;
			
			// Use panel to control padding around background art
			background = add( Box, { backgroundAlpha: 0, cacheAsBitmap:true }); 
			
			handleShape = new Box( 0x888888 );
			handleShape.borderPixelHinting = true;
						
			handle = new Panel( handleShape, "2 1", 0x000000, 0);
			handle.cacheAsBitmap = true;
			
			addChild( handle );
		}

		public function set handleColor( c:uint ) {
			handleShape.backgroundColor = c;
		}

		override protected function draw():void
		{
			
			if(hostComponent && hasChanged(VALID_SIZE)) {
				handleShape.cornerRadius = hostComponent.isVertical ? hostComponent.width / 2 : hostComponent.height / 2;
			}
			
			super.draw();
			
			
		}


	}
}

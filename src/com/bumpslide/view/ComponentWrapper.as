package com.bumpslide.view 
{
	import com.bumpslide.tween.Fade;
	import com.bumpslide.ui.IResizable;
	import com.bumpslide.view.BasicView;

	import flash.display.DisplayObject;

	/**
	 * IView implementation that uses TweenLite to fadeIn/fadeOut
	 * 
	 * This view is designed to wrap any display object and facilitate
	 * display management from a ViewStack.
	 * 
	 * If the content is a Bumpslide UI Component, this 
	 */
	public class ComponentWrapper extends BasicView 
	{

		public var content:DisplayObject;
		
		public function ComponentWrapper( childContent:DisplayObject) 
		{
			content = addChild(childContent);
			super();
		}

		
		override protected function draw():void 
		{
			if(hasChanged(VALID_SIZE)) {
				if(content is IResizable) {
					(content as IResizable).setSize(width, height);
				} else {
					content.width = width;
					content.height = height;
				}
			}
			super.draw();
		}

		
		override public function destroy():void 
		{
			super.destroy();
			destroyChild(content);
			Fade.Cancel(this);
		}

		
		override public function transitionIn():void 
		{
			super.transitionIn();
			Fade.In(this, 0, .4, transitionInComplete);
		}		

		
		override public function transitionOut():void 
		{			
			super.transitionOut();	
			Fade.Out(this, 0, .2, transitionOutComplete);
		}
	}
}
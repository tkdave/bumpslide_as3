package com.bumpslide.ui
{

	import com.bumpslide.data.constant.Direction;


	/**
	 * HBox
	 *
	 * @author David Knape
	 */
	dynamic public class HBox extends Container
	{

		public function HBox( children:Array = null, spacing:Number=10)
		{
			super( Direction.HORIZONTAL, 10 );
			if(children) this.children = children;
		}
	}
}

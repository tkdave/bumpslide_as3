package com.bumpslide.ui
{

	import com.bumpslide.data.constant.Direction;


	/**
	 * VBox
	 *
	 * @author David Knape
	 */
	dynamic public class VBox extends Container
	{

		public function VBox( children:Array = null, spacing:Number=10)
		{
			super( Direction.VERTICAL, spacing);
			if(children) this.children = children;
			
		}

	}
}

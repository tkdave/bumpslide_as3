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

		public function VBox( children:Array = null)
		{
			super( Direction.VERTICAL );
			if(children) this.children = children;
		}

	}
}

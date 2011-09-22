package
{

	import com.bumpslide.ui.Application;
	import com.bumpslide.ui.Box;
	import com.bumpslide.ui.Grid;
	import com.bumpslide.util.LoremIpsum;

	/**
	 * DragScrollTest
	 *
	 * @author David Knape
	 */
	public class DragScrollTest extends Application
	{

		private var bg:Box;

		private var grid:Grid;
		
		
		override protected function addChildren():void
		{
			super.addChildren();
			
			
			addChild( bg = new Box() );			
			addChild( grid = new Grid() );
						
			grid.dataProvider = LoremIpsum.IMAGES;
		}
		
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
		}
		
		override protected function draw():void
		{
			var pad:Number = 10;
			
			grid.move(pad, pad);
			grid.setSize(width - 
			grid.setSize( width, height );
			super.draw();
		}
		
	}
}

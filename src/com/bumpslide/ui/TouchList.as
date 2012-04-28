/**
 * This code is part of the Bumpslide Library maintained by David Knape
 * Fork me at http://github.com/tkdave/bumpslide_as3
 *
 * Copyright (c) 2012 by Bumpslide, Inc.
 * http://www.bumpslide.com/
 *
 * This code is released under the open-source MIT license.
 * See LICENSE.txt for full license terms.
 * More info at http://www.opensource.org/licenses/mit-license.php
 */
package com.bumpslide.ui
{

    import com.bumpslide.tween.FTween;
    import com.bumpslide.ui.behavior.DragScrollBehavior;
    import com.bumpslide.ui.skin.touch.TouchScrollSkin;


    /**
     * List/Grid Component setup for touch-style interaction
     *
     * This is still using mouse events.
     *
     * @author David Knape, http://bumpslide.com/
     */
    public class TouchList extends Grid
    {
        private var touchBehavior:DragScrollBehavior;

        public function TouchList()
        {
            super();

            //fixedColumnCount = 1;
            //gap = 4;
            scrollbarWidth = 6;

            // enable dragging
            touchBehavior = DragScrollBehavior.init(this, layout);

            // add touch-style scroll bar
            scrollbar.skinClass = TouchScrollSkin;

            // tweak the advanced layout options
            with (layout) {
                scrollTweenEaseFactor = .3;
                renderInBatches = true;
                renderBatchPageCount = 2;
                addEventListener(Event.RENDER, onGridRender);
            }
        }

        // update scrollbar
        private function onGridRender(event:Event):void
        {
            if (scrollbar.visible) {
                scrollbar.value = layout.offset;
                FTween.easeOut(scrollbar, 'alpha', .85, .2, { onComplete:fadeOutScrollbar });
            }
        }

        private function fadeOutScrollbar():void
        {
            FTween.easeIn(scrollbar, 'alpha', .5, .2, { delay:1000 });
        }
    }
}

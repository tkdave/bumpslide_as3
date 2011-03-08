/**
 * This code is part of the Bumpslide Library maintained by David Knape
 * Fork me at http://github.com/tkdave/bumpslide_as3
 * 
 * Copyright (c) 2010 by Bumpslide, Inc. 
 * http://www.bumpslide.com/
 *
 * This code is released under the open-source MIT license.
 * See LICENSE.txt for full license terms.
 * More info at http://www.opensource.org/licenses/mit-license.php
 */

package com.bumpslide.util {
	/**
	 * Some Lorem Ipsum Text
	 * 
	 * @author David Knape
	 */
	public class LoremIpsum {
		
		
		public static var COLORS:Array = [  
			0x81B3C3,  
			0xDF6559,  
			0xF9D574,  
			0xF29F43,  
			0x253C4B,  
			0xffffff];
			
		public static var BIRDS:Array = [ 	
			'Anseriformes—waterfowl',		
			'Galliformes—fowl',
			'Charadriiformes—gulls, button-quails, plovers and allies',
			'Gaviiformes—loons',
			'Podicipediformes—grebes',
			'Procellariiformes—albatrosses, petrels, and allies',
			'Sphenisciformes—penguins',
			'Pelecaniformes—pelicans and allies',
			'Phaethontiformes—tropicbirds',
			'Ciconiiformes—storks and allies',
			'Cathartiformes—New World vultures',
			'Phoenicopteriformes—flamingos',
			'Falconiformes—falcons, eagles, hawks and allies',
			'Gruiformes—cranes and allies',
			'Pteroclidiformes—sandgrouse',
			'Columbiformes—doves and pigeons',
			'Psittaciformes—parrots and allies',
			'Cuculiformes—cuckoos and turacos',
			'Opisthocomiformes—hoatzin',
			'Strigiformes—owls',
			'Caprimulgiformes—nightjars and allies',
			'Apodiformes—swifts and hummingbirds',
			'Coraciiformes—kingfishers and allies',
			'Piciformes—woodpeckers and allies',
			'Trogoniformes—trogons',
			'Coliiformes—mousebirds',
			'Passeriformes—passerines' 
		];
		
		public static var ITEMS:Array = [
			"Lorem Ipsum",
			"Consectetuer",
			"Aenean Volutpat",
			"Suspendisse",
			"Maecenas Nec",
			"Quisque",
			"Facilisis"
		];
		
		// most "interesting" creative commons photos on flickr with search keyword ('photoshop')
		public static var IMAGES:Array = ['http://farm5.static.flickr.com/4057/4315145017_ea28fabda0.jpg',
			'http://farm3.static.flickr.com/2587/3894970025_797612bdd8.jpg',
			'http://farm3.static.flickr.com/2605/3667880356_02c4707471.jpg',
			'http://farm4.static.flickr.com/3312/3650717808_46054cc96a.jpg',
			'http://farm4.static.flickr.com/3566/3496095474_6f60f8fd33.jpg', // 4 - Square (lighthouse)
			'http://farm4.static.flickr.com/3347/3411775886_fcf0af1a42.jpg', // 5 - Horizontal (tilt shift cars)
			'http://farm4.static.flickr.com/3646/3306656930_4187b98452.jpg',
			'http://farm4.static.flickr.com/3344/3215868087_cce5882430.jpg',
			'http://farm4.static.flickr.com/3012/3017515135_2b8ab4f3a4.jpg',
			'http://farm4.static.flickr.com/3051/2952609526_9fd245dfcd.jpg',
			'http://farm4.static.flickr.com/3148/2843932314_8aa5597b68.jpg',
			'http://farm4.static.flickr.com/3177/2842941601_66ef8dd667.jpg',
			'http://farm4.static.flickr.com/3274/2812682461_3b00ed08ff.jpg',
			'http://farm4.static.flickr.com/3044/2805475704_9a03215453.jpg',
			'http://farm4.static.flickr.com/3254/2408535634_f9953a5dbf.jpg',
			'http://farm3.static.flickr.com/2168/2208867228_b5ccdca0be.jpg',
			'http://farm3.static.flickr.com/2164/2166043959_dc2ec8e8a1.jpg',
			'http://farm3.static.flickr.com/2388/2086852016_5a58dd1881.jpg',
			'http://farm3.static.flickr.com/2032/1979443914_355cc1996b.jpg',
			'http://farm3.static.flickr.com/2276/1566967053_6776208e72.jpg',
			'http://farm1.static.flickr.com/157/384323992_5fe67df84d.jpg',
			'http://farm1.static.flickr.com/105/304640554_5029c0ec66.jpg',
			'http://farm1.static.flickr.com/42/106957481_001a4604f7.jpg',
			'http://farm1.static.flickr.com/32/55582632_0ee7885f06.jpg',
			'http://farm1.static.flickr.com/2/2363345_da147122ff.jpg',
			'http://farm3.static.flickr.com/2192/2485992852_afa8372b44.jpg',
			'http://farm3.static.flickr.com/2634/4136823759_9d9c860e5c.jpg',
			'http://farm4.static.flickr.com/3620/3664742198_784c6db9eb.jpg',
			'http://farm4.static.flickr.com/3387/3599784525_8951cb70ec.jpg',
			'http://farm3.static.flickr.com/2466/3597080409_4c27df9ec2.jpg',
			'http://farm4.static.flickr.com/3361/3411746271_3cabded63e.jpg',
			'http://farm4.static.flickr.com/3659/3387530824_e058ed6b55.jpg',
			'http://farm4.static.flickr.com/3026/3253171814_8011d90128.jpg',
			'http://farm4.static.flickr.com/3209/3045853162_f6af47aa7e.jpg',
			'http://farm2.static.flickr.com/1143/525401952_93d80229ec.jpg',
			'http://farm1.static.flickr.com/167/480467788_6670dc77b8.jpg',
			'http://farm1.static.flickr.com/193/449052129_542ba9b0b1.jpg',
			'http://farm1.static.flickr.com/134/358919966_e1381c1dc4.jpg'
		];
		
		// small (240) versions of IMAGES
		public static function get THUMBNAILS():Array {
			return IMAGES.map( Delegate.map( function (url:String):String { return url.replace('.jpg', '_m.jpg'); } ) );
		}
		
		
		public static const TITLE:String = "Lorem Ipsum";
		
		public static const SENTENCE:String = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit.";
		
		public static const TEXT:String = SENTENCE + " Curabitur hendrerit eros vel est. Vestibulum non nunc. " +
			"Proin et dolor id dolor pellentesque facilisis. " +
			"Nulla a nulla. Vestibulum gravida odio nec lacus. Praesent tellus nibh, imperdiet in, volutpat vitae, " +
			"facilisis sit amet, justo. Integer neque. Fusce dolor. Nunc ligula. Aliquam erat volutpat. " +
			"Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Maecenas egestas diam. Cras lobortis nibh " +
			"in est. Sed auctor sapien sagittis tellus. Donec sapien ligula, euismod sollicitudin, aliquam vitae, " +
			"fringilla ut, elit.\n" +
			"\n" +
			"Aenean volutpat risus a nibh. Praesent feugiat volutpat eros. Nunc vitae neque " +
			"vel felis porta pulvinar. Integer tortor tortor, mattis id, volutpat in, consectetuer a, ante. " +
			"Praesent suscipit elit nec arcu. Sed blandit cursus neque. Curabitur a mi. Pellentesque tellus dui, " +
			"ultricies nec, tristique sit amet, interdum eget, velit. Suspendisse imperdiet. Pellentesque habitant " +
			"morbi tristique senectus et netus et malesuada fames ac turpis egestas. Vestibulum accumsan dui sit " +
			"amet quam. Cras ullamcorper faucibus odio. Suspendisse consectetuer. Nulla facilisi. Duis est quam, " +
			"pulvinar nec, lacinia id, cursus in, dui.\n" +
			"\n" +
			"Suspendisse id neque pharetra augue ultricies semper. " +
			"Morbi fringilla dictum sem. Donec suscipit felis ac magna. Donec a felis. Nulla facilisi. Sed vitae " +
			"augue id enim luctus auctor. Maecenas venenatis suscipit eros. Nunc suscipit nulla in erat. Class aptent " +
			"taciti sociosqu ad litora torquent per conubia nostra, per inceptos hymenaeos. Quisque ultrices, tellus vel " +
			"ultrices fermentum, sem lorem egestas metus, ut lacinia urna lorem nec mi.\n" +
			"\n" +
			"Maecenas nec ante a velit " +
			"suscipit ultrices. Vestibulum sed tortor fermentum mauris accumsan rutrum. Cras in risus. In hac habitasse " +
			"platea dictumst. Nunc massa. Duis gravida, enim at feugiat iaculis, nisl metus pharetra enim, ut posuere " +
			"arcu ante vitae enim. Donec pulvinar justo sit amet sem. In elementum sodales nisl. Duis eget pede eu magna " +
			"porta feugiat. Sed quis neque. Etiam nec nunc. Nulla convallis nibh vel ante. Praesent viverra. Integer " +
			"elementum arcu vitae leo. Nullam quis sapien. Ut vel ipsum a nulla sagittis ultricies. Phasellus bibendum, " +
			"mauris id ultricies lobortis, nunc nisi fermentum nisi, vulputate pulvinar arcu ipsum eget eros. " +
			"Vivamus faucibus.\n" +
			"\n" +
			"Quisque vel nisl. Curabitur adipiscing risus quis sem. Proin tortor neque, vestibulum et, sagittis " +
			"lacinia, volutpat eu, eros. Maecenas scelerisque sem in erat. Curabitur vehicula, elit quis tristique " +
			"venenatis, quam tortor interdum nisi, eget rhoncus arcu ipsum et enim. Lorem ipsum dolor sit amet, " +
			"consectetuer adipiscing elit. Mauris metus. Praesent egestas condimentum nisi. Mauris ullamcorper " +
			"pede at turpis. Integer pellentesque ultrices augue. Vivamus facilisis lacus nec neque. Vivamus " +
			"cursus ligula. Pellentesque commodo. Curabitur et purus.";
	
		public static const DATA:Array = [
			{ id:1, name:"Anseriformes", description:"waterfowl" },		
			{ id:2, name:"Galliformes", description:"fowl" },
			{ id:3, name:"Charadriiformes", description:"gulls, button-quails, plovers and allies" },
			{ id:4, name:"Gaviiformes", description:"loons" },
			{ id:5, name:"Podicipediformes", description:"grebes" },
			{ id:6, name:"Procellariiformes", description:"albatrosses, petrels, and allies" },
			{ id:7, name:"Sphenisciformes", description:"penguins" },
			{ id:8, name:"Pelecaniformes", description:"pelicans and allies" },
			{ id:9, name:"Phaethontiformes", description:"tropicbirds" },
			{ id:10, name:"Ciconiiformes", description:"storks and allies" },
			{ id:11, name:"Cathartiformes", description:"New World vultures" },
			{ id:12, name:"Phoenicopteriformes", description:"flamingos" },
			{ id:13, name:"Falconiformes", description:"falcons, eagles, hawks and allies" },
			{ id:14, name:"Gruiformes", description:"cranes and allies" },
			{ id:15, name:"Pteroclidiformes", description:"sandgrouse" },
			{ id:16, name:"Columbiformes", description:"doves and pigeons" },
			{ id:17, name:"Psittaciformes", description:"parrots and allies" },
			{ id:18, name:"Cuculiformes", description:"cuckoos and turacos" },
			{ id:19, name:"Opisthocomiformes", description:"hoatzin" },
			{ id:20, name:"Strigiformes", description:"owls" },
			{ id:21, name:"Caprimulgiformes", description:"nightjars and allies" },
			{ id:22, name:"Apodiformes", description:"swifts and hummingbirds" },
			{ id:23, name:"Coraciiformes", description:"kingfishers and allies" },
			{ id:24, name:"Piciformes", description:"woodpeckers and allies" },
			{ id:25, name:"Trogoniformes", description:"trogons" },
			{ id:26, name:"Coliiformes", description:"mousebirds" },
			{ id:27, name:"Passeriformes", description:"passerines" }
		];
		
	}
}

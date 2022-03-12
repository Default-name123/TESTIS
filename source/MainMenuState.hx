package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;

using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.4.2'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	
	var optionShit:Array<String> = [
		'blaster',
		'options'
	];

	var magenta:FlxSprite;
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement);
		FlxCamera.defaultCameras = [camGame];

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

				
		var bg:FlxSprite = new FlxSprite(0).loadGraphic(Paths.image('menuBG'));
								  
											   
					
					
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		for (i in 0...optionShit.length)
		{
																		  
			var menuItem:FlxSprite = new FlxSprite(40, 80 + (i * 200));
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID=i;
							
			menuItems.add(menuItem);
												   
									 
			menuItem.scrollFactor.set();
			menuItem.antialiasing = true;
															 
			menuItem.updateHitbox();
		}

		FlxG.camera.follow(camFollowPos, null, 1);



		changeItem();


		#if mobileC
		addVirtualPad(UP_DOWN, A_B_C);
		#end

		super.create();
	}


	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

		

					menuItems.forEach(function(spr:FlxSprite)
					{
					
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								var daChoice:String = optionShit[curSelected];

								switch (daChoice)
								{
									case 'blaster':
										loadWeek();
						 
														  
					   
																  
						
														 
									case 'options':
										MusicBeatState.switchState(new options.OptionsState());
								}
							});
						
					});
			
			}
			else if (FlxG.keys.justPressed.SEVEN #if mobileC || _virtualpad.buttonC.justPressed #end)
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
	        #end
		}

		super.update(elapsed);

		
	}
	function loadWeek()
		{
		
			PlayState.storyPlaylist = ['blaster'];
			PlayState.isStoryMode = true;
			PlayState.storyDifficulty = 1;
			PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() , PlayState.storyPlaylist[0].toLowerCase());
			PlayState.campaignScore = 0;
			PlayState.campaignMisses = 0;
			LoadingState.loadAndSwitchState(new PlayState(), true);
			FreeplayState.destroyFreeplayVocals();
		   
		
		}


	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected ==-1)
			curSelected = 1;
		else if (curSelected ==2)
			curSelected = 0;
		
		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			
			
			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				
		});
	}
}

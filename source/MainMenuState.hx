package;

import flixel.input.gamepad.FlxGamepad;
import Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
#if newgrounds 
import io.newgrounds.NG;
#end
import lime.app.Application;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	#if !switch
	var optionShit:Array<String> = ['story mode', 'freeplay', 'options'];
	#else
	var optionShit:Array<String> = ['story mode', 'freeplay'];
	#end

	var newGaming:FlxText;
	var newGaming2:FlxText;
	public static var firstStart:Bool = true;

	public static var nightly:String = "";

	public static var kadeEngineVer:String = "1.5.4" + nightly;
	public static var gameVer:String = "0.2.0";

	var magenta:FlxSprite;
	var camFollow:FlxObject;
	public static var finishedFunnyMove:Bool = false;

	override function create()
	{
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('BG'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.10;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('BG'));
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0.10;
		magenta.setGraphicSize(Std.int(magenta.width * 1.1));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = true;
		magenta.color = 0xFFfd719b;
		add(magenta);
		// magenta.scrollFactor.set();

		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets');
		
		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(-700, FlxG.height * 1.7);
			menuItem.setGraphicSize(Std.int(menuItem.width * -10));
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
			menuItem.antialiasing = true;
			if (firstStart)
				FlxTween.tween(menuItem,{y: 40 + (i * 140)},1 + (i * 0.25) ,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween)
					{ 
						finishedFunnyMove = true; 
						changeItem();
					}});
			else
				menuItem.y = 40 + (i * 140);
		}
		
		var dipsy:FlxSprite = new FlxSprite(0).loadGraphic(Paths.image('Dipsy')); //Dipsy Object Don't Delete!
		dipsy.x = 600;
		dipsy.y = 200;
		dipsy.scrollFactor.set(0, 0.05);
		dipsy.updateHitbox();
		dipsy.antialiasing = true;
		dipsy.frames = Paths.getSparrowAtlas("Dipsy");
		dipsy.animation.addByPrefix('idle', "Dipsy", 24, true);
		dipsy.animation.play('idle');
		dipsy.alpha = 0.94;
		add(dipsy);

		var noiseeffect:FlxSprite = new FlxSprite(0, 0); //Effect For Menu Don't Delete!
		var nvs:FlxSprite = new FlxSprite(0, 0);
		var noise:FlxSprite = new FlxSprite(0, 0);
		var blackouts:FlxSprite = new FlxSprite(0, 0);
		noiseeffect = new FlxSprite(0).loadGraphic(Paths.image('noiseeffect'));
		nvs = new FlxSprite(0).loadGraphic(Paths.image('nvs'));
		noise = new FlxSprite(0).loadGraphic(Paths.image('noise'));
		blackouts = new FlxSprite(0).loadGraphic(Paths.image('blackouts'));
		noiseeffect.antialiasing = true;
		nvs.antialiasing = true;
		noise.antialiasing = true;
		blackouts.antialiasing = true;
        noiseeffect.scrollFactor.set(0, 0);
		nvs.scrollFactor.set(0, 0);
		noise.scrollFactor.set(0, 0);
		blackouts.scrollFactor.set(0, 0);
		noiseeffect.frames = Paths.getSparrowAtlas("noiseeffect");
		nvs.frames = Paths.getSparrowAtlas("nvs");
		noise.frames = Paths.getSparrowAtlas("nvs");
		noiseeffect.animation.addByPrefix('idle', "NVS_EFFECT", 18, true);
		nvs.animation.addByPrefix('idle', "NVS_EFFECT", 24, true);
		noise.animation.addByPrefix('idle', "NVS_EFFECT", 24, true);
		noiseeffect.animation.play('idle');
		nvs.animation.play('idle');
		noise.animation.play('idle');
		noiseeffect.alpha = 0.4;
		nvs.alpha = 0.18;
		noise.alpha = 0.12;
		blackouts.alpha = 0.82;
		add(noiseeffect);
		add(nvs);
		add(noise);
		add(blackouts);

		firstStart = false;

		FlxG.camera.follow(camFollow, null, 0.20 * (20 / FlxG.save.data.fpsCap));

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, gameVer +  (Main.watermarks ? " FNF - " + kadeEngineVer + " Kade Engine" : ""), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();


		if (FlxG.save.data.dfjk)
			controls.setKeyboardScheme(KeyboardScheme.Solo, true);
		else
			controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);

		changeItem();
                #if android
		addVirtualPad(UP_DOWN, A_B);
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
			var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

			if (gamepad != null)
			{
				if (gamepad.justPressed.DPAD_UP)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeItem(-1);
				}
				if (gamepad.justPressed.DPAD_DOWN)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeItem(1);
				}
			}

			if (controls.UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				FlxG.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{
					fancyOpenURL("https://ninja-muffin24.itch.io/funkin");
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));
					
					if (FlxG.save.data.flashing)
						FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 1.3, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							if (FlxG.save.data.flashing)
							{
								FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
								{
									goToState();
								});
							}
							else
							{
								new FlxTimer().start(1, function(tmr:FlxTimer)
								{
									goToState();
								});
							}
						}
					});
				}
			}
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.x = 60;
		});
	}
	
	function goToState()
	{
		var daChoice:String = optionShit[curSelected];

		switch (daChoice)
		{
			case 'story mode':
				FlxG.switchState(new StoryMenuState());
				trace("Story Menu Selected");
			case 'freeplay':
				FlxG.switchState(new FreeplayState());

				trace("Freeplay Menu Selected");

			case 'options':
				FlxG.switchState(new OptionsMenu());
		}
	}

	function changeItem(huh:Int = 0)
	{
		if (finishedFunnyMove)
		{
			curSelected += huh;

			if (curSelected >= menuItems.length)
				curSelected = 0;
			if (curSelected < 0)
				curSelected = menuItems.length - 1;
		}
		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected && finishedFunnyMove)
			{
				spr.animation.play('selected');
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
			}

			spr.updateHitbox();
		});
	}
}

package;

// STOLEN FROM HAXEFLIXEL DEMO LOL
import flixel.system.FlxAssets.FlxShader;

enum WiggleEffectType
{
	DREAMY;
	WAVY;
	HEAT_WAVE_HORIZONTAL;
	HEAT_WAVE_VERTICAL;
	FLAG;
}

class WiggleEffect
{
	public var shader(default, null):WiggleShader = new WiggleShader();
	public var effectType(default, set):WiggleEffectType = DREAMY;
	public var waveSpeed(default, set):Float = 0;
	public var waveFrequency(default, set):Float = 0;
	public var waveAmplitude(default, set):Float = 0;

	public function new():Void
	{
		shader.uTime.value = [0];
	}

	public function update(elapsed:Float):Void
	{
		shader.uTime.value[0] += elapsed;
	}

	function set_effectType(v:WiggleEffectType):WiggleEffectType
	{
		effectType = v;
		shader.effectType.value = [WiggleEffectType.getConstructors().indexOf(Std.string(v))];
		return v;
	}

	function set_waveSpeed(v:Float):Float
	{
		waveSpeed = v;
		shader.uSpeed.value = [waveSpeed];
		return v;
	}

	function set_waveFrequency(v:Float):Float
	{
		waveFrequency = v;
		shader.uFrequency.value = [waveFrequency];
		return v;
	}

	function set_waveAmplitude(v:Float):Float
	{
		waveAmplitude = v;
		shader.uWaveAmplitude.value = [waveAmplitude];
		return v;
	}
}

class WiggleShader extends FlxShader
{
	@:glFragmentSource('
		#pragma header
		//uniform float tx, ty; // x,y waves phase
		uniform float uTime;
		
		const int EFFECT_TYPE_DREAMY = 0;
		const int EFFECT_TYPE_WAVY = 1;
		const int EFFECT_TYPE_HEAT_WAVE_HORIZONTAL = 2;
		const int EFFECT_TYPE_HEAT_WAVE_VERTICAL = 3;
		const int EFFECT_TYPE_FLAG = 4;
		
		uniform int effectType;
		
		/**
		 * How fast the waves move over time
		 */
		uniform float uSpeed;
		
		/**
		 * Number of waves over time
		 */
		uniform float uFrequency;
		
		/**
		 * How much the pixels are going to stretch over the waves
		 */
		uniform float uWaveAmplitude;

		vec2 sineWave(vec2 pt)
		{
			float deltaX = 0.0;
			float deltaY = 0.0;
			
			if (effectType == EFFECT_TYPE_DREAMY) 
			{
				float deltaX = sin(pt.y * uFrequency + uTime * uSpeed) * uWaveAmplitude;
                deltaX; // * (pt.y - 1.0); // <- Uncomment and remove the first semicolon to stop bottom part of the screen from moving
			}
			else if (effectType == EFFECT_TYPE_WAVY) 
			{
				float offsetY = sin(pt.x * uFrequency + uTime * uSpeed) * uWaveAmplitude;
				deltaY; // * (pt.y - 1.0); // <- Uncomment and remove the first semicolon to stop bottom part of the screen from moving
			}
			else if (effectType == EFFECT_TYPE_HEAT_WAVE_HORIZONTAL)
			{
				deltaX = sin(pt.x * uFrequency + uTime * uSpeed) * uWaveAmplitude;
			}
			else if (effectType == EFFECT_TYPE_HEAT_WAVE_VERTICAL)
			{
				deltaY = sin(pt.y * uFrequency + uTime * uSpeed) * uWaveAmplitude;
			}
			else if (effectType == EFFECT_TYPE_FLAG)
			{
				deltaY = sin(pt.y * uFrequency + 10.0 * pt.x + uTime * uSpeed) * uWaveAmplitude;
				deltaX = sin(pt.x * uFrequency + 5.0 * pt.y + uTime * uSpeed) * uWaveAmplitude;
			}
			
			return vec2(pt.x + deltaX, pt.y + deltaY);
		}

		void main()
		{
			vec2 uv = sineWave(openfl_TextureCoordv);
			gl_FragColor = texture2D(bitmap, uv);
		}')
	public function new()
	{
		super();
	}
}

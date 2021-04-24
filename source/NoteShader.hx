package;

import flixel.system.FlxAssets.FlxShader;

// This shader does shit

class NoteEffect
{
	public var shader(default, null):NoteShader = new NoteShader();
	//public var shaderType(default, set):Float = 0;
	//public var windowSizeY(default, set):Float = 0;

	public function new():Void
	{

	}

	//function set_shaderType(v:Float):Float
	//{
	//	windowSizeY = v;
	//	shader.data[1].value = [windowSizeY];
	//	return v;
	//}
	//
	//function set_windowSizeY(v:Float):Float
	//{
	//	windowSizeY = v;
	//	shader.data[0].value = [windowSizeY];
	//	return v;
	//}
}

class NoteShader extends FlxShader
{ 
	public function new()
	{
		super();
	}

	@:glFragmentSource('
		#pragma header
		// uniform float uWindowSizeY;
        // uniform float uShaderType;

        // vec2 normY = gl_FragCoord.y/uWindowSizeY;

		void main()
		{
			vec4 base = texture2D(bitmap, openfl_TextureCoordv);
			gl_FragColor = base;   // vec4(base.a / 2, base.rgb) // vec4(base.a * uShaderType * (6 * normY - 2), base.rgb) 
		}')
}

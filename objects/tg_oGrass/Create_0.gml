debugMode = false

#region Scripts tg_Classes and tg_functions
/// tg_Classes (antes em outro Script com esse nome)
BladeInfo = function() constructor {
	baseThickness = 0;
	topThickess = 0;
	height = 0;
	divs = 0;
	baseColour = c_gray;
	tipColour = c_white;
	bend = 0;
	stiffnessSpread = 0;
}


/// tg_functions
/// Feather disable GM2010

/// @func VertexCreateBlade
/// @param {Id.VertexBuffer} _vb
/// @param {Real} _x
/// @param {Real} _y
/// @param {BladeInfo} _bladeInfo
Vertex_createBlade = function(_vb, _x, _y, _bladeInfo) {
	var _p = 0;
	var _bend = 0;
	
	// Texcoord variables (use as extra parameters)
	var _texA = random(_bladeInfo.stiffnessSpread);
	var _texB = 0;
	
	// Base
	// tri A
	vertex_position_3d(_vb, _x - _bladeInfo.baseThickness / 2, _y, -_y);
	vertex_color(_vb, _bladeInfo.baseColour, 1);
	vertex_texcoord(_vb, _texA, _texB);
	vertex_normal(_vb, _x, _y, _bladeInfo.height);
	
	vertex_position_3d(_vb, _x + _bladeInfo.baseThickness / 2, _y, -_y);
	vertex_color(_vb, _bladeInfo.baseColour, 1);
	vertex_texcoord(_vb, _texA, _texB);
	vertex_normal(_vb, _x, _y, _bladeInfo.height);
	
	// Divisions
	var _divs = _bladeInfo.divs, _h, _w, _c, _lastX = _x + _bladeInfo.baseThickness / 2, _lastY = _y, _lastColour = _bladeInfo.baseColour, _xx;
	for (var d = 0; d < _divs; d ++) {
		_p = (1 + d) / (1 + _divs);					// 0-1 from base to tip (exclusive)
		_h = _bladeInfo.height * _p;				// height at this level
		_w = _bladeInfo.baseThickness * (1 - _p);	// width at this level
		_c = merge_color(_bladeInfo.baseColour, _bladeInfo.tipColour, _p);
		_bend = TGEaseInCubic(_p) * _bladeInfo.bend;
		
		_xx = _x + _bend;
		
		vertex_position_3d(_vb, _xx - _w / 2, _y - _h, -_y);
		vertex_color(_vb, _c, 1);
		vertex_texcoord(_vb, _texA, _texB);
		vertex_normal(_vb, _x, _y, _bladeInfo.height);
	
		// tri B
		vertex_position_3d(_vb, _xx - _w / 2, _y - _h, -_y);
		vertex_color(_vb, _c, 1);
		vertex_texcoord(_vb, _texA, _texB);
		vertex_normal(_vb, _x, _y, _bladeInfo.height);
	
		vertex_position_3d(_vb, _xx + _w / 2, _y - _h, -_y);
		vertex_color(_vb, _c, 1);
		vertex_texcoord(_vb, _texA, _texB);
		vertex_normal(_vb, _x, _y, _bladeInfo.height);
	
		vertex_position_3d(_vb, _lastX, _lastY, -_y);
		vertex_color(_vb, _lastColour, 1);
		vertex_texcoord(_vb, _texA, _texB);
		vertex_normal(_vb, _x, _y, _bladeInfo.height);
		
		// tri A
		vertex_position_3d(_vb, _xx - _w / 2, _y - _h, -_y);
		vertex_color(_vb, _c, 1);
		vertex_texcoord(_vb, _texA, _texB);
		vertex_normal(_vb, _x, _y, _bladeInfo.height);
	
		vertex_position_3d(_vb, _xx + _w / 2, _y - _h, -_y);
		vertex_color(_vb, _c, 1);
		vertex_texcoord(_vb, _texA, _texB);
		vertex_normal(_vb, _x, _y, _bladeInfo.height);
		
		_lastX = _xx + _w / 2;
		_lastY = _y - _h;
		_lastColour = _c;
	}
	
	_p = 1;
	_bend = _bladeInfo.bend;
	
	// Top
	var _topThickness = _bladeInfo.topThickness;
	if (_topThickness <= 0) {
		vertex_position_3d(_vb, _x + _bend, _y - _bladeInfo.height, -_y);
		vertex_color(_vb, _bladeInfo.tipColour, 1);
		vertex_texcoord(_vb, _texA, _texB);
		vertex_normal(_vb, _x, _y, _bladeInfo.height);
	}
	else {
		vertex_position_3d(_vb, (_x - _topThickness / 2) + _bend, _y - _bladeInfo.height, -_y);
		vertex_color(_vb, _bladeInfo.tipColour, 1);
		vertex_texcoord(_vb, _texA, _texB);
		vertex_normal(_vb, _x, _y, _bladeInfo.height);
		
		// tri B
		vertex_position_3d(_vb, _lastX, _lastY, -_y);
		vertex_color(_vb, _lastColour, 1);
		vertex_texcoord(_vb, _texA, _texB);
		vertex_normal(_vb, _x, _y, _bladeInfo.height);
		
		vertex_position_3d(_vb, (_x - _topThickness / 2 + _bend), _y - _bladeInfo.height, -_y);
		vertex_color(_vb, _bladeInfo.tipColour, 1);
		vertex_texcoord(_vb, _texA, _texB);
		vertex_normal(_vb, _x, _y, _bladeInfo.height);
		
		vertex_position_3d(_vb, (_x + _topThickness / 2 + _bend), _y - _bladeInfo.height, -_y);
		vertex_color(_vb, _bladeInfo.tipColour, 1);
		vertex_texcoord(_vb, _texA, _texB);
		vertex_normal(_vb, _x, _y, _bladeInfo.height);
	}
}





/// Easing functions
/// Source: https://easings.net
TGEaseInCubic = function(_val) {
	return _val * _val * _val;
}

#endregion

#region Create normal do obj
// Get player
playerInst = undefined;

if (object_exists(playerObject)) {
	playerInst = instance_find(playerObject, 0);
}

// Culling bounds
cullX1 = x;
cullY1 = y;
cullX2 = x + sprite_width;
cullY2 = y + sprite_height;

// Define format
vertex_format_begin();

vertex_format_add_position_3d();
vertex_format_add_color();
vertex_format_add_custom(vertex_type_float2, vertex_usage_texcoord); // Stiffness, colour variation
vertex_format_add_custom(vertex_type_float3, vertex_usage_normal); // Grass base position (xy) and total height

vfMain = vertex_format_end();

// Create vbuff
Generate = function () {
	vbMain = vertex_create_buffer();

	vertex_begin(vbMain, vfMain);

	var _bladeInfo = new BladeInfo();
	_bladeInfo.baseThickness = bladeBaseThickness;
	_bladeInfo.topThickness = bladeTopThickness;
	_bladeInfo.height = bladeHeight;
	_bladeInfo.divs = bladeDivs;
	_bladeInfo.baseColour = bladeBaseColour;
	_bladeInfo.tipColour = bladeTipColour;
	_bladeInfo.bend = bladeBend;
	_bladeInfo.stiffnessSpread = stiffnessSpread;

	var _x, _y, _len, _dir, _size = max(sprite_width, sprite_height);
	for (var _rx = 0; _rx <= sprite_width; _rx += bladeDist * xToYDistRatio) {
		for (var _ry = 0; _ry <= sprite_height; _ry += bladeDist) {
			// Distance to center
			var _dist = point_distance(_rx, _ry, sprite_width / 2, sprite_height / 2) / _size;
			if (random(0.5) < _dist * centerFocus) {
				continue;
			}
			
			// Final grass blade position
			_len = point_distance(0, 0, _rx, _ry);
			_dir = point_direction(0, 0, _rx, _ry);
			_x = x + lengthdir_x(_len, _dir + image_angle);
			_y = y + lengthdir_y(_len, _dir + image_angle);
			
			// Change blade info to pass into function
			_bladeInfo.bend = bladeBend + random_range(-bladeBendJitter / 2, bladeBendJitter / 2);
			_bladeInfo.baseThickness = bladeBaseThickness + random_range(-bladeBaseJitter / 2, bladeBaseJitter / 2);
			_bladeInfo.height = bladeHeight + random_range(-bladeHeightJitter / 2, bladeHeightJitter / 2);
		
			Vertex_createBlade(vbMain,
				_x + random_range(-bladePositionJitter / 2, bladePositionJitter / 2),
				_y + random_range(-bladePositionJitter / 2, bladePositionJitter / 2),
				_bladeInfo);
			
			// Set cull bounds
			cullX1 = min(_x, cullX1);
			cullY1 = min(_y, cullY1);
			cullX2 = max(_x, cullX2);
			cullY2 = max(_y, cullY2);
		}
	}

	vertex_end(vbMain);
}

Generate();

// Create manager
if (!instance_exists(tg_oManager)) {
	instance_create_depth(0, 0, 0, tg_oManager);
	
	// Debug
	if (debugMode) {
		DebugRefresh = function() {
			with (tg_oGrass) {
				if (other.id != self.id) {
					var _vars = struct_get_names(other);
					var _count = array_length(_vars);
					for (var i = 0; i < _count; i ++) {
						var _name = _vars[i];
						show_debug_message("\n" + _name);
						if (_name != "Generate" && _name != "vbMain" && _name != "vfMain" && _name != "x" && _name != "y" && _name != "sprite_width" && _name != "sprite_height" && _name != "image_xscale" && _name != "image_yscale") {
							variable_struct_set(self, _name, struct_get(other, _name));
						}
					}
				}
				
				Generate();
			}
		}
		
		dbg_view($"TouchGrass - Click Refresh to apply changes", true);
		dbg_button("Refresh", DebugRefresh);
		dbg_section("Properties");
		dbg_slider_int(ref_create(self, "bladeDist"), 1, 50, "Blade Distance");
		dbg_slider(ref_create(self, "xToYDistRatio"));
		dbg_slider_int(ref_create(self, "bladeBaseThickness"), 1, 100, "Base Thickness");
		dbg_slider_int(ref_create(self, "bladeTopThickness"), 1, 20, "Top Thickness");
		dbg_slider_int(ref_create(self, "bladeHeight"), 1, 100, "Height");
		dbg_slider_int(ref_create(self, "bladeDivs"), 0, 32, "Divs");
		dbg_color(ref_create(self, "bladeBaseColour"), "Base Colour");
		dbg_color(ref_create(self, "bladeTipColour"), "Tip Colour");
		dbg_slider_int(ref_create(self, "bladeBend"), -100, 100, "Bend");
		dbg_section("Jitters");
		dbg_slider_int(ref_create(self, "bladePositionJitter"), 1, 100, "Position Jitter");
		dbg_slider_int(ref_create(self, "bladeBendJitter"), 1, 100, "Bend Jitter");
		dbg_slider_int(ref_create(self, "bladeBaseJitter"), 1, 100, "Base Jitter");
		dbg_slider_int(ref_create(self, "bladeHeightJitter"), 1, 100, "Height Jitter");
		dbg_section("Collisions");
		dbg_slider_int(ref_create(self, "playerRadius"), 1, 200, "Collider Radius");
		dbg_slider_int(ref_create(self, "collisionXOffset"), -50, 50, "Collider X Offset");
		dbg_slider_int(ref_create(self, "collisionYOffset"), -50, 50, "Collider Y Offset");
		dbg_slider_int(ref_create(self, "collisionBend"), 1, 100, "Collision Bend");
		dbg_slider(ref_create(self, "collisionYBend"), 0, 1, "Collision Y Bend");
		dbg_section("Wind 1");
		dbg_slider(ref_create(self, "wind1Power"), 0, 50);
		dbg_slider(ref_create(self, "wind1Speed"), 0, 50);
		dbg_slider_int(ref_create(self, "wind1Direction"), 0, 360);
		dbg_slider_int(ref_create(self, "wind1Scale"), 10, 10000);
		dbg_slider(ref_create(self, "stiffnessSpread"), 0, 1);
	}
}

if (!debugMode) vertex_freeze(vbMain);

// Shader uniforms
uniPlayerPos = tg_oManager.uniPlayerPos;
uniPlayerRadius = tg_oManager.uniPlayerRadius;
uniCollisionBend = tg_oManager.uniCollisionBend;
uniYOffset = tg_oManager.uniYOffset;

uniWind1Power = tg_oManager.uniWind1Power;
uniWind1Speed = tg_oManager.uniWind1Speed;
uniWind1Scale = tg_oManager.uniWind1Scale;
uniTime = tg_oManager.uniTime;

grassTime = 0;
#endregion

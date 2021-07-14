--ease.xml
xero()
	
local sqrt = math.sqrt
local sin = math.sin
local asin = math.asin
local cos = math.cos
local pow = math.pow
local exp = math.exp
local pi = math.pi
local abs = math.abs

flip = setmetatable({}, {
	__call = function(self, fn)
		self[fn] = self[fn] or function(x) return 1 - fn(x) end
		return self[fn]
	end
})

function with1param(fn, defaultparam1)
	local function params(param1)
		return function(x)
			return fn(x, param1)
		end
	end
	local default = params(defaultparam1)
	return setmetatable({
		params = params,
		param = params,
	}, {
		__call = function(self, x)
			return default(x)
		end
	})
end

function with2params(fn, defaultparam1, defaultparam2)
	local function params(param1, param2)
		return function(x)
			return fn(x, param1, param2)
		end
	end
	local default = params(defaultparam1, defaultparam2)
	return setmetatable({
		params = params,
		param = params,
	}, {
		__call = function(self, x)
			return default(x)
		end
	})
end

function bounce(t) return 4 * t * (1 - t) end
function tri(t) return 1 - abs(2 * t - 1) end
function bell(t) return inOutQuint(tri(t)) end
function pop(t) return 3.5 * (1 - t) * (1 - t) * sqrt(t) end
function tap(t) return 3.5 * t * t * sqrt(1 - t) end
function pulse(t) return t < .5 and tap(t * 2) or -pop(t * 2 - 1) end

function spike(t) return exp(-10 * abs(2 * t - 1)) end
function inverse(t) return t * t * (1 - t) * (1 - t) / (0.5 - t) end

local function popElasticInternal(t, damp, count)
	return (1000 ^ -(t ^ damp) - 0.001) * sin(count * pi * t)
end

local function tapElasticInternal(t, damp, count)
	return (1000 ^ -((1 - t) ^ damp) - 0.001) * sin(count * pi * (1 - t))
end

local function pulseElasticInternal(t, damp, count)
	if t < .5 then
		return tapElasticInternal(t * 2, damp, count)
	else
		return -popElasticInternal(t * 2 - 1, damp, count)
	end
end

popElastic = with2params(popElasticInternal, 1.4, 6)
tapElastic = with2params(tapElasticInternal, 1.4, 6)
pulseElastic = with2params(pulseElasticInternal, 1.4, 6)

impulse = with1param(function(t, damp)
	t = t ^ damp
	return t * (1000 ^ -t - 0.001) * 18.6
end, 0.9)

function instant() return 1 end

if FUCK_EXE then

	function linear(t) return t end
	function inSine(x) return 1 - cos(x * (pi * 0.5)) end
	function outSine(x) return sin(x * (pi * 0.5)) end
	function inOutSine(x) return 0.5 - 0.5 * cos(x * pi) end
	function inQuad(t) return t * t end
	function outQuad(t) return -t * (t - 2) end
	function inOutQuad(t)
		t = t * 2
		if t < 1 then
			return 0.5 * t ^ 2
		else
			return 1 - 0.5 * (2 - t) ^ 2
		end
	end
	function inCubic(t) return t * t * t end
	function outCubic(t) return 1 - (1 - t) ^ 3 end
	function inOutCubic(t)
		t = t * 2
		if t < 1 then
			return 0.5 * t ^ 3
		else
			return 1 - 0.5 * (2 - t) ^ 3
		end
	end
	function inQuart(t) return t * t * t * t end
	function outQuart(t) return 1 - (1 - t) ^ 4 end
	function inOutQuart(t)
		t = t * 2
		if t < 1 then
			return 0.5 * t ^ 4
		else
			return 1 - 0.5 * (2 - t) ^ 4
		end
	end
	function inQuint(t) return t ^ 5 end
	function outQuint(t) return 1 - (1 - t) ^ 5 end
	function inOutQuint(t)
		t = t * 2
		if t < 1 then
			return 0.5 * t ^ 5
		else
			return 1 - 0.5 * (2 - t) ^ 5
		end
	end
	function inExpo(t) return 1000 ^ (t - 1) - 0.001 end
	function outExpo(t) return 1.001 - 1000 ^ -t end
	function inOutExpo(t)
		t = t * 2
		if t < 1 then
			return 0.5 * 1000 ^ (t - 1) - 0.0005
		else
			return 1.0005 - 0.5 * 1000 ^ (1 - t)
		end
	end
	function inCirc(t) return 1 - sqrt(1 - t * t) end
	function outCirc(t) return sqrt(-t * t + 2 * t) end
	function inOutCirc(t)
		t = t * 2
		if t < 1 then
			return 0.5 - 0.5 * sqrt(1 - t * t)
		else
			t = t - 2
			return 0.5 + 0.5 * sqrt(1 - t * t)
		end
	end
	function inBounce(t) return 1 - outBounce(1 - t) end
	function outBounce(t)
		if t < 1 / 2.75 then
			return 7.5625 * t * t
		elseif t < 2 / 2.75 then
			t = t - 1.5 / 2.75
			return 7.5625 * t * t + 0.75
		elseif t < 2.5 / 2.75 then
			t = t - 2.25 / 2.75
			return 7.5625 * t * t + 0.9375
		else
			t = t - 2.625 / 2.75
			return 7.5625 * t * t + 0.984375
		end
	end
	function inOutBounce(t)
		if t < 0.5 then
			return inBounce(t * 2) * 0.5
		else
			return outBounce(t * 2 - 1) * 0.5 + 0.5
		end
	end

	function outElasticInternal(t, a, p)
		return a * pow(2, -10 * t) * sin((t - p / (2 * pi) * asin(1/a)) * 2 * pi / p) + 1
	end
	local function inElasticInternal(t, a, p)
		return 1 - outElasticInternal(1 - t, a, p)
	end
	function inOutElasticInternal(t, a, p)
		return t < 0.5
			and  0.5 * inElasticInternal(t * 2, a, p)
			or  0.5 + 0.5 * outElasticInternal(t * 2 - 1, a, p)
	end
	inElastic = with2params(inElasticInternal, 1, 0.3)
	outElastic = with2params(outElasticInternal, 1, 0.3)
	inOutElastic = with2params(inOutElasticInternal, 1, 0.3)

	function inBackInternal(t, a) return t * t * (a * t + t - a) end
	function outBackInternal(t, a) t = t - 1 return t * t * ((a + 1) * t + a) + 1 end
	function inOutBackInternal(t, a)
		return t < 0.5
			and  0.5 * inBackInternal(t * 2, a)
			or  0.5 + 0.5 * outBackInternal(t * 2 - 1, a)
	end
	inBack = with1param(inBackInternal, 1.70158)
	outBack = with1param(outBackInternal, 1.70158)
	inOutBack = with1param(inOutBackInternal, 1.70158)

else

	local t = Tweens

	function linear(x) return t.linear(x) end
	function inSine(x) return t.insine(x) end
	function outSine(x) return t.outsine(x) end
	function inOutSine(x) return t.inoutsine(x) end
	function inQuad(x) return t.inquad(x) end
	function outQuad(x) return t.outquad(x) end
	function inOutQuad(x) return t.inoutquad(x) end
	function inCubic(x) return t.incubic(x) end
	function outCubic(x) return t.outcubic(x) end
	function inOutCubic(x) return t.inoutcubic(x) end
	function inQuart(x) return t.inquart(x) end
	function outQuart(x) return t.outquart(x) end
	function inOutQuart(x) return t.inoutquart(x) end
	function inQuint(x) return t.inquint(x) end
	function outQuint(x) return t.outquint(x) end
	function inOutQuint(x) return t.inoutquint(x) end
	function inExpo(x) return t.inexpo(x) end
	function outExpo(x) return t.outexpo(x) end
	function inOutExpo(x) return t.inoutexpo(x) end
	function inCirc(x) return t.incircle(x) end
	function outCirc(x) return t.inoutcircle(x) end
	function inOutCirc(x) t.inoutcircle(x) end
	function inBounce(x) return t.inbounce(x) end
	function outBounce(x) return t.outbounce(x) end
	function inOutBounce(x) return t.inoutbounce(x) end
	function inElastic(x) return t.inelastic(x) end
	function outElastic(x) return t.outelastic(x) end
	function inOutElastic(x) return t.inoutelastic(x) end
	function inBack(x) return t.inback(x) end
	function outBack(x) return t.outback(x) end
	function inOutBack(x) return t.inoutback(x) end

	-- TODO: Work with Kid to implement template's "internal" eases
	-- using OutFox's faster tweens

end
return Def.Actor {}

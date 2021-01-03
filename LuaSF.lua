--[[
	------------------------------------------
	change "LuaStat" in your project
	if you need specific another directory
	------------------------------------------

	THIS PROGRAM is developed by Hubert Ronald
	https://sites.google.com/view/liasoft/home
	Feel free to distribute and modify code,
	but keep reference to its creator
	The MIT License (MIT)
	
	Copyright (C) 2017 Hubert Ronald
	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:
	The above copyright notice and this permission notice shall be included in
	all copies or substantial portions of the Software.
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
	THE SOFTWARE.

	------------------------------------------
]]

-- math functions
local rand = math.random
local ln = math.log		-- natural logarithm
local sqrt = math.sqrt
local pi = math.pi
local exp = math.exp		-- e exponent
local pow = math.pow

-- non-math functions
local ipairs = ipairs
local table_sort = table.sort

-- sum array function
local function sumF(array)
	local s = 0
	for _, v in ipairs(array) do s=s+v end
	return s
end

-- average array function
local function avF(array)
	local s = sumF(array)
	return s/#array
end

-- (n-1) standard deviation
local function stvF(array)
	local xp, sq = avF(array), 0
	for _,v in ipairs(array) do sq = sq + (v - xp)^2 end
	return (sq/(#array-1))^0.5
end

local function frecuencyF(array)
	local list, frec = {}, {g={},c={}}	-- group, count
	for k,v in ipairs(array) do
		list[k] = v
	end
	table_sort(list)
	frec.g[1], frec.c[1] = list[1], 1
	
	for i=2, #list do
		if frec.g[#frec.g]==list[i] then
			frec.c[#frec.c] = frec.c[#frec.c] + 1
		else
			frec.c[#frec.c+1], frec.g[#frec.g+1] = 1, list[i]
		end
	end
	return frec
end

local function normalVA(mu, sig)
	-- normal standar: mu=0,sig=1
	-- method schmeiser
	local mu, sig, r = mu or 0, sig or 1, rand()
	local z = (r^0.135 - (1-r)^0.135)/0.1975
	return z*sig + mu
end

local function normal_inv_D(p, mu, sig)
	-- nomal standar mu=0,sig=1, p~[0,1]: (probability)
	-- method schmeiser
	local mu, sig, p = mu or 0, sig or 1, p or 0.5 -- 'p' parameter fixed
	local z = (p^0.135 - (1-p)^0.135)/0.1975
	return z*sig + mu
end

local function bernoulliVA(p)
	if rand()<= p then
		return 1
	else
		return 0
	end
end

local function unifVA(min,max)
	return (max-min)*rand() + min
end

local function expoVA(beta) 
	return (-1/beta)*ln(1.0-rand())
end

local function weibullVA(alpha,beta)
	return alpha*(-ln(1.0-rand()))^(1/beta)
end

local function erlangVA(n, lambda)
	local VaErlang = 0
	for i=1, n do
		VaErlang = VaErlang + expoVA(lambda)
	end
	return VaErlang
end
	
local function trianVA(a,b,c)
	local a,b,c = a or 1, b or 2, c or 3
	if rand() <= (b-a)/(c-1) then
		return a + ((b-a)*(c-a)*r)^0.5
	else
		return c - ((c-b)*(c-a)*(1-r))^0.5
	end
end

local function binomialVA(n,p)
	local n, p , va = n or 1, p or 0.5, 0
	-- convolution method
	for i=1,n do va=va+bernoulliVA(p) end
	return va
end

local function poissonVA(lamba)
	local t, va, lamba = 0, 0, lamba or 0.5
	-- convolution method
	while true do
		t = t+expoVA(lamba)
		if t <= 1 then
			va = va + 1
		else
			break
		end
	end
	return va
end

local function geometricVA(p)
	--[[
		------------------------------------------------------------
		-- See details in:
		-- https://math.stackexchange.com/questions/485448/prove-the-way-to-generate-geometrically-distributed-random-numbers
		------------------------------------------------------------
	]]
	local U = 1-rand()
	local va = ln(U)/ln(1-p)
	return va
end

	
local function chiSquareVA(n)
	local va = 0
	for i=1, n do va = va + normalVA() end
	return va^0.5
end

local function gamVA(alpha, lamba)
	--[[
		------------------------------------------------------------
		-- generator using Marsaglia and Tsang method
		-- See details in the work of [Marsaglia and Tsang (2000)].
		-- check this paper:
		-- http://www.ijcse.com/docs/INDJCSE14-05-06-048.pdf
		------------------------------------------------------------
	]]
	local alpha, lamba = alpha or 0.5, lamba or 0.5
	local va=0
	if alpha >= 1 then
		local d=alpha-1/3
		local c=1/(9*d)^.5
		while (true) do
			local Z=normalVA()
			if Z>-1/c then
				local V=(1+c*Z)^3
				local U=1-rand()
				if ln(U)<0.5*Z^2+d-d*V+d*ln(V) then
					va=d*V/lamba
					break
				end
			end
		end
		
	elseif alpha>0 and alpha<1 then
		va=gamVA(alpha+1,lamba)
		va=va*rand()^(1/alpha)
	else print("alpha must be > 0") end
	return va
end

local function lognoVA(m, s)
	--[[
		------------------------------------------------------------
		-- Took
		-- See details in these links
		-- http://stackoverflow.com/questions/23699738/how-to-create-a-random-number-following-a-lognormal-distribution-in-excel
		-- http://blogs.sas.com/content/iml/2014/06/04/simulate-lognormal-data-with-specified-mean-and-variance.html
		------------------------------------------------------------
	]]
	local m, s = m or 0, s or 1
	-- Next step is to scale the mean and standard deviation
	local mean = ln( m^2 / sqrt( m^2 + s^2 ))
	local sd = sqrt( ln(( m^2 + s^2 ) / m^2 ))
	
	local x = normal_inv_D(rand, mean, sd)
	return exp(x)
end

return {
	sumF=sumF,
	avF=avF,
	stvF=stvF,
	frecuencyF=frecuencyF,
	nomalVA=nomalVA,
	normal_inv_D=normal_inv_D,
	bernoulliVA=bernoulliVA,
	unifVA=unifVA,
	expoVA=expoVA,
	weibullVA=weibullVA,
	erlangVA=erlangVA,
	trianVA=trianVA,
	binomialVA=binomialVA,
	geometricVA=geometricVA,
	poissonVA=poissonVA,
	chiSquareVA=chiSquareVA,
	gamVA=gamVA,
	lognoRandVA=lognoRandVA,
}

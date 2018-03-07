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
local dirLuaStat = "LuaStat"

return {
	
-- math functions
rand = math.random,
ln = math.log,		-- natural logarithm
sqrt = math.sqrt,
pi = math.pi,
exp = math.exp,		-- e exponent	
pow = math.pow,	

-- sum array function
sumF = function (array)
	local s = 0
	for _,v in pairs(array) do s=s+v end
	return s
end,

-- average array function
avF = function (array)
	local st = require(dirLuaStat) -- auto reference
	local s = st.sumF(array)
	return s/#array
end,

-- (n-1) standar desviation
stvF = function(array)
	local st =require(dirLuaStat) -- auto reference
	local xp, sq = st.avF(array), 0
	for _,v in pairs(array) do sq = sq + (v - xp)^2 end
	return (sq/(#array-1))^0.5
end,

frecuencyF = function(array)
	local list, frec = array, {g={},c={}}	-- group, count
	table.sort(list)
	frec.g[1], frec.c[1] = list[1], 1
	
	for i=2, #list do
		if frec.g[#frec.g]==list[i] then
			frec.c[#frec.c] = frec.c[#frec.c] + 1
		else
			frec.c[#frec.c+1], frec.g[#frec.g+1] = 1, list[i]
		end
	end
	return frec
end,

normalD = function (mu, sig)
	-- normal standar: mu=0,sig=1
	-- method schmeiser
	local st = require(dirLuaStat) -- auto reference
	local mu, sig, r = mu or 0, sig or 1, st.rand()
	local z = (r^0.135 - (1-r)^0.135)/0.1975
	return z*sig + mu
end,

normal_inv_D = function (p, mu, sig)
	-- nomal standar mu=0,sig=1, p~[0,1]: (probability)
	-- method schmeiser
	local mu, sig, p = mu or 0, sig or 1, 0.5
	local z = (p^0.135 - (1-p)^0.135)/0.1975
	return z*sig + mu
end,

bernoulliD = function (p) local st = require(dirLuaStat) if st.rand()<= p then return 1 else return 0 end end,
unifD = function (min,max) local st = require(dirLuaStat); return (max-min)*st.rand() + min end,
expoD = function (beta) local st = require(dirLuaStat); return (-1/beta)*st.ln(st.rand()) end,
weibullD = function (alpha,beta) local st = require(dirLuaStat); return alpha*(-st.ln(st.rand()))^(1/beta) end,

erlangD = function(n, lambda)
	local st = require(dirLuaStat)	-- auto reference
	local VaErlang = 0
	for i=1, n do VaErlang = VaErlang + st.expoD(lambda) end
	return VaErlang
end,
	
trianD = function(a,b,c)
	local st = require(dirLuaStat)	-- auto reference
	local a,b,c = a or 1, b or 2, c or 3
	if st.rand() <= (b-a)/(c-1) then
		return a + ((b-a)*(c-a)*r)^0.5
	else
		return c - ((c-b)*(c-a)*(1-r))^0.5
	end
end,

binomialD = function(n,p)
	local st = require(dirLuaStat) -- auto reference
	local n, p , va = n or 1, p or 0.5, 0
	-- convolution method
	for i=1,n do va=va+st.bernoulliD(p) end
	return va
end,

poissonD = function(lamba)
	local st = require(dirLuaStat) -- auto reference
	local t, va, lamba = 0, 0, lamba or 0.5
	-- convolution method
	while true do
		t = t+st.expoD(1/lamba)
		if t <= 1 then va = va + 1 else break end
	end
	return va
end,

geometricD = function (p)
	--[[
		------------------------------------------------------------
		-- See details in:
		-- https://math.stackexchange.com/questions/485448/prove-the-way-to-generate-geometrically-distributed-random-numbers
		------------------------------------------------------------
	]]
	local st = require(dirLuaStat) -- auto reference
	local U = st.rand()
	local va = st.ln(U)/st.ln(1-p)
	return va
end,

	
chiSquare = function(n)
	local st = require(dirLuaStat) -- auto reference
	local va = 0
	for i=1, n do va = va + st.normalD() end
	return va^0.5

end,

gamRand = function(alpha, lamba)
	--[[
		------------------------------------------------------------
		-- generator using Marsaglia and Tsang method
		-- See details in the work of [Marsaglia and Tsang (2000)].
		-- check this paper:
		-- http://www.ijcse.com/docs/INDJCSE14-05-06-048.pdf
		------------------------------------------------------------
	]]
	local st = requiere(dirLuaStat) -- auto reference
	local alpha, lamba = alpha or 0.5, lamba or 0.5
	local va=0
	if alpha >= 1 then
		local d=alpha-1/3
		local c=1/(9*d)^.5
		while (true) do
			local Z=st.normalD()
			if Z>-1/c then
				local V=(1+c*Z)^3
				local U=st.rand()
				if st.ln(U)<0.5*Z^2+d-d*V+d*st.ln(V) then
					va=d*V/lamba
					break
				end
			end
		end
		
	elseif alpha>0 and alpha<1 then
		va=st.gamRand(alpha+1,lamba)
		va=va*st.rand()^(1/alpha)
	else print("alpha must be > 0") end
	return va
end,

lognoRand = function(m, s)
	--[[
		------------------------------------------------------------
		-- Took
		-- See details in these links
		-- http://stackoverflow.com/questions/23699738/how-to-create-a-random-number-following-a-lognormal-distribution-in-excel
		-- http://blogs.sas.com/content/iml/2014/06/04/simulate-lognormal-data-with-specified-mean-and-variance.html
		------------------------------------------------------------
	]]
	local st = require(dirLuaStat) -- auto reference
	local m, s = m or 0, s or 1
	-- Next step is to scale the mean and standard deviation
	local mean = st.ln( m^2 / st.sqrt( m^2 + s^2 ))
	local sd = st.sqrt( st.ln(( m^2 + s^2 ) / m^2 ))
	
	local x = st.normal_inv_D(st.rand, mean, sd)
	return st.exp(x)
end,
}

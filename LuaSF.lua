--[[
	------------------------------------------
	-- change "LuaStat" in your project
	-- if you need specific another directory
	------------------------------------------
]]
local dirLuaStat = "LuaStat"

return {
	
-- math functions
rand = math.random,
ln = math.log,

-- sum array function
sumF = function (array)
	local s = 0
	for _,v in pairs(array) do s=s+v end
	return s
end,

-- average array function
avF = function (array)
	local st = requiere(dirLuaStat) -- auto reference
	local s = st.sumF(array)
	return s/#array
end,

-- (n-1) standar desviation
stvF = function(array)
	local st =requiere(dirLuaStat) -- auto reference
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
	local mu, sig = mu or 0, sig or 1
	local z = (p^0.135 - (1-p)^0.135)/0.1975
	return z*sig + mu
end,

bernoulliD = function (p) local st = require(dirLuaStat) if st.rand()<= p then return 1 else return 0 end end,
unifD = function (min,max) local st = require(dirLuaStat); return (max-min)*st.rand() + min end,
expoD = function (beta) local st = require(dirLuaStat); return (-1/beta)*ln(st.rand()) end,
weibullD = function (alpha,beta) local st = require(dirLuaStat); return alpha*(-ln(st.rand()))^(1/beta) end,

trianD = function(a,b,c)
	local st = require(dirLuaStat)	-- auto reference
	if st.rand() <= (b-a)/(c-1) then
		return a + ((b-a)*(c-a)*r)^0.5
	else
		return c - ((c-b)*(c-a)*(1-r))^0.5
	end
end,

binomialD = function(n,p)
	local st = requiere(dirLuaStat) -- auto reference
	local va = 0
	-- convolution method
	for i=1,n do va=va+st.bernoulliD(p) end
	return va
end,

poissonD = function(lamba)
	local st = requiere(dirLuaStat) -- auto reference
	local t, va = 0, 0
	-- convolution method
	while true do
		t = t+st.expoD(1/lamba)
		if t <= 1 then va = va + 1 else break end
	end
	return va
end,

chiSquare = function(n)
	local st = requiere(dirLuaStat) -- auto reference
	local va = 0
	for i=1, n do va = va + st.normalD() end
	return va^0.5

end,

gamRand = function(alpha, lamba)
	-- generator using Marsaglia and Tsang method
	-- See details in the work of [Marsaglia and Tsang (2000)].
	local st = requiere(dirLuaStat) -- auto reference
	local va=0
	if alpha >= 1 then
		local d=alpha-1/3
		local c=1/(9*d)^.5
		while true
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
	else print("alpha > 0")
	end
	return va
end,

}

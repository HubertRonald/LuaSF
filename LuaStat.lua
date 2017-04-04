--[[
--------------------------------------------
-- change "LuaStat" in your project
-- if you need specific another directory
--------------------------------------------
]]
local dirLuaStat = "LuaStat"

return {
	
-------------------
-- math functions
-------------------
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
	local mu, sig, r = mu or 0, sig or 1, rand()
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

bernoulliD = function (p) if rand()<= p then return 1 else return 0 end end,
unifD = function (min,max) return (max-min)*rand() + min end,
expoD = function (beta) return (-1/beta)*ln(rand()) end,
weibullD = function (alpha,beta) return alpha*(-ln(rand()))^(1/beta) end,

trianD = function(a,b,c)
	if rand() <= (b-a)/(c-1) then
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
}

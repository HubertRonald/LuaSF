#LuaSF : Lua Statistics Functions
# LuaSF
*Lua Statistics Functions* (LuaStat) is a small library which offers a clean, minimalistic but powerful API for discrete and continuous Pseudo-random variables mainly.

## Usage
Add [LuaSF.lua](https://github.com/HubertRonald/LuaSF/blob/master/LuaStat.lua) file inside your project.<br/>
Call it using __require__ function.</br>
It will return a table containing a set of functions.

## Full API Overview

* sumF = function (array)                 : Sum Array
* avF = function (array)                  : Average Array
* stvF = function(array)                  : (n-1) Standar Desviation
* frecuencyF = function(array)            : Frecuency Distribution
* nomalD = function (mu, sig)             : Normal Distribution
* normal_inv_D = function (p, mu, sig)    : Normal-Inverse Gaussian Distribution (NIG)
* bernoulliD = function (p)               : Bernoulli Distribution
* unifD = function (min,max)              : Uniform Distribution
* expoD = function (beta)                 : Exponential Distribution
* weibullD = function (alpha,beta)        : Weibull Distribution
* trianD = function(a,b,c)                : Triangular Distribution
* binomialD = function(n,p)               : Binomial Distribution
* poissonD = function(lamba)              : Poisson Distribution
* chiSquare = function(n)                 : ChiSquare Distribution

## Sample

```
--[[
--------------------------------------------
  sample
  twice two dice
--------------------------------------------
]]
local st = require("LuaStat")

local mList={}
for i=1,10000 do mList[i]=st.rand(1,6)+st.rand(1,6) end
local frecu = st.frecuencyF(mList)

-- report
for i=1, #frecu.c do
	print("Frecuency - Sum Number:",frecu.g[i],frecu.c[i])
end
--------------------------------------------
```
Normal Distribution for Quality Control Sample
<p align="left">
  <img src="https://en.wikipedia.org/wiki/File:NormalDist1.96.png#/media/File:NormalDist1.96.png" width="350"/>
</p>
```
local a=5/100
print(st.normal_inv_D(a/2))
print(st.normal_inv_D(1-a/2))
```

## Built With

* [Visual Studio Code](https://code.visualstudio.com/) - The web framework used

## Authors

* **Hubert Ronald** - *Initial work* - [HubertRonald](https://github.com/HubertRonald)

See also the list of [contributors](https://github.com/HubertRonald/LuaSF/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

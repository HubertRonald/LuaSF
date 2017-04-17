# LuaSF : Lua Statistics Functions
# LuaSF
*Lua Statistics Functions* (LuaSF) is a small library which offers a clean, minimalistic but powerful API for discrete and continuous Pseudo-random variables mainly.

## Usage
Add [LuaSF.lua](https://github.com/HubertRonald/LuaSF/blob/master/LuaSF.lua) file inside your project.<br/>
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
* gamRand = function(alpha, lamba)	  : Gamma Distribution
* lognoRand = function(m, s)		  : Log-normal Distribution

## Sample

Experiment Twice Two Dice
<p align="left">
  <img src="https://cloud.githubusercontent.com/assets/7612715/24643736/6b0dbf8c-18d5-11e7-955a-f1ab05233489.png" width="700"/>
</p>

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
  <img src="https://cloud.githubusercontent.com/assets/7612715/24643414/6e2b2a3a-18d3-11e7-9edd-9eb54d7744ca.png" width="350"/>
</p>

```
-- Normal Distribution Probability
local a=5/100
print(st.normal_inv_D(a/2))
print(st.normal_inv_D(1-a/2))
--[[
--------------------------------------------
  Print:
 	-1.9688213737864
	1.9688213737864
--------------------------------------------
]]
```

## Built With

* [Visual Studio Code](https://code.visualstudio.com/) - The web framework used

## Authors

* **Hubert Ronald** - *Initial work* - [HubertRonald](https://github.com/HubertRonald)

See also the list of [contributors](https://github.com/HubertRonald/LuaSF/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

local stats = require("luasf")

print("Probability helper examples")
print("Factorial 5!:", stats.factorial(5))

print("Ordered selections without repetition")
print("Race podiums with 8 runners and 3 medals:", stats.permutations(8, 3))

print("Ordered selections with repetition")
print("4-digit PINs using digits 0-9:", stats.permutations_with_repetition(10, 4))

print("Unordered selections without repetition")
print("Committees of 3 people from 10 candidates:", stats.combinations(10, 3))

print("Unordered selections with repetition")
print("3 scoops from 5 ice cream flavors:", stats.combinations_with_repetition(5, 3))

print("Distinct permutations of repeated items")
print("Letters in MISSISSIPPI-style counts {4, 4, 2, 1}:", stats.multiset_permutations({4, 4, 2, 1}))

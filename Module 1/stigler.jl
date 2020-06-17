#You might need to run "Pkg.add(...)" before using these packages
using DataFrames, CSV, NamedArrays

#Load the data file (ref: Boyd/263)
raw = CSV.read("stigler.csv");

# turn DataFrame into an array
diet_array = convert(Array,raw);

# the names of the DataFrame (header) are the nutrients
nutrients = names(raw[2:end]);

# create a list of foods from the diet array
foods = diet_array[2:end,1];# create a dictionary of the minimum daily requirements of each nutrient
min_daily_req = Dict(zip(nutrients,diet_array[1,2:end]));

# create a NamedArray that specifies how much of each nutrient each food provides
using NamedArrays
food_nutrient_matrix = diet_array[2:end,2:end]

# rows are foods, columns are nutrients
food_nutrient_array = NamedArray(food_nutrient_matrix, (foods, nutrients), ("foods","nutrients"))

using JuMP,  Clp
m = Model(Clp.Optimizer) # create model


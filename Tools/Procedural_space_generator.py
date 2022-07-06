# This script generates instances of "Local_space_system" nodes with coords
# generated in Gaussian (normal) distribution.

import re, random

# Keep under 10k per batch.
system_number = 10000
mean = 0.0
deviation = 2.0


galaxy_size = [1, 1, 1]

file_name = "Procedural_space_generator_result.txt"

ID = 0
file_body = ''

seed1 = 10000
seed2 = 20000
seed3 = 30000

# Adding three different generators for the sake of consistency of distributions each way.

rng_x = random.Random(seed1)
rng_y = random.Random(seed2)
rng_z = random.Random(seed3)



if system_number >= 100000:
	print('Generating', system_number, 'systems. Output skipped...')

# Create zones to spawn stellar systems in.
for system in range(system_number):

	# Make up a position.
	pos_x = (rng_x.gauss(mean, deviation)*0.2)*galaxy_size[0]
	pos_y = (rng_y.gauss(mean, deviation)*0.2)*galaxy_size[1]
	pos_z = (rng_z.gauss(mean, deviation)*0.2)*galaxy_size[2]
	
	# Make up a name.
	regex = re.compile("[^a-zA-Z]+")
	regex_space = re.compile("[\\s]+")
	
	# Part 1
	# Bigrams
	name_part_1_components = []
	name_part_1_hash = str(abs(hash(pos_x)))
	for pair in range(0, len(name_part_1_hash)-1, 2):
		name_part_1_components.append((name_part_1_hash[pair : pair+2]))

	
	name_part_1 = ""
	for part in name_part_1_components:
		name_part_1 += chr(int(part))
	
	space_replace_1 = chr(rng_x.randint(65,90))
	result_1 = regex_space.sub(string=name_part_1, repl=space_replace_1)
	result_1 = regex.sub(string=result_1, repl="")
	if not result_1: 
		result_1 = chr(rng_x.randint(65,90))+chr(rng_y.randint(65,90))+chr(rng_z.randint(65,90))
	
	# Part 2
	# Bigrams
	name_part_2_components = []
	name_part_2_hash = str(abs(hash(pos_x)))
	for pair in range(0, len(name_part_2_hash)-1, 2):
		name_part_2_components.append((name_part_2_hash[pair : pair+2]))
		
	name_part_2 = ""
	for part in name_part_2_components:
		name_part_2 += chr(int(part))

	space_replace_2 = chr(rng_y.randint(65,90))
	result_2 = regex_space.sub(string=name_part_2, repl=space_replace_2)
	result_2 = regex.sub(string=result_2, repl="")
	if not result_2:
		result_2 = chr(rng_x.randint(65,90))+chr(rng_y.randint(65,90))+chr(rng_z.randint(65,90))
	
	# Finalize data.
	name = result_1.upper()[0:3]+"-"+result_2.upper()[0:3]+"-"+str(abs(hash(pos_z)))[0:3]
	pos = [pos_x, pos_y, pos_z]
	
	# Roll system ID.
	ID += 1

	str0 = '\n\n'
	str1 = '[node name="'+name+'" type="Area" parent="." instance=ExtResource( 1 )]\n'
	str2 = 'transform = Transform( 1, 0, 0, 0, 1, 0, 0, 0, 1, '+str(pos_x)+', '+str(pos_y)+', '+str(pos_z)+')\n'
	str3 = 'script = ExtResource( 2 )'
	
	file_body += str0+str1+str2+str3
	
# Print the output to the command line and to the file.
if system_number < 100000:
	print(file_body)
else:
	print('Saving', system_number, 'systems. Output skipped.')
	
print(file_body, file=open(file_name, "w"))
	
#[node name="Local_space_system" type="Area" parent="." instance=ExtResource( 1 )]
# transform = Transform( 1, 0, 0, 0, 1, 0, 0, 0, 1, -3.4566e+17, -5.84979e+16, -6.59702e+17 )
# script = ExtResource( 2 )
	
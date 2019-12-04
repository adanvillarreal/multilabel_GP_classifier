# Multilabel Genetic Programming Classifier
A multilabel genetic programming classifier based on GPLab

## Dependencies
- MATLAB
- GPLab
- MATLAB's Parallel Computing Toolbox (optional, but highly recommended)

## Structure
This repository started as a identical copy of the GPLab source. The following functions where added:
- MLC.m: Set's up the params and state for the defined attributes (data, generations, population size, etc.). GPLab is then called with these params.
- MLCHamming.m: Fitness function to be used by the MLC. Basic implementation of Hamming Distance.
- MLCExperiment.m: Script that orchestrates experiments for different runs of the MLC function and compiles results in graphs.
- fileLoader.m: Transforms an ARFF file and XML file (the dataset in MULAN format) to it's matrix representation (X, Y and corresponding labels)

## Running MLC
The input data for the MLC follows the MULAN format (http://mulan.sourceforge.net/format.html). 
### Input
- arfffile: path to the ARFF file with training data
- xmlfile: path to the XML file with labels
- arfftest: path to the ARFF file with testing data
- generations: number of generations
- popSize: number of individuals in the population
- savename: where to store the state every 10 generations
- relational_primitives: boolean indicating if relational primitives or arithmetic primitives should be used.
## Output
Returns a tuple with the best individual and the last state. A directory will be created with a snapshot of the state every 10 generations.

#!/bin/bash
set -e

# 0. Clean the environment 
rm -rf and2 and2.gcno and2.gcda and3 and3.gcno and3.gcda and4 and4.gcno and4.gcda
rm -rf or2 or2.gcno or2.gcda or3 or3.gcno or3.gcda or4 or4.gcno or4.gcda

# 1. Create executable:

chmod +x build.sh
./build.sh

chmod +x build_refactor.sh
./build_refactor.sh

# 2. Run AND only chain 

chmod +x run_and2_suites.sh
./run_and2_suites.sh

chmod +x run_and3_suites.sh
./run_and3_suites.sh

chmod +x run_and4_suites.sh
./run_and4_suites.sh

# 3. Run OR only chain 

chmod +x run_or2_suites.sh
./run_or2_suites.sh

chmod +x run_or3_suites.sh
./run_or3_suites.sh

chmod +x run_or4_suites.sh
./run_or4_suites.sh

# 4. Clean the environment 
rm -rf and2 and2.gcno and2.gcda and3 and3.gcno and3.gcda and4 and4.gcno and4.gcda
rm -rf or2 or2.gcno or2.gcda or3 or3.gcno or3.gcda or4 or4.gcno or4.gcda

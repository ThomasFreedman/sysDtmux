#!/bin/bash
export PROJECT=# URL to github repo to clone
export BUILD_DIR=# Path to your build directory
export BIN=# Replace with path to where binaries are copied
export SUB=# subdirectory of cloned repo under BUILD_DIR
export BUILD_TYPE="Release" # Build type Release | Debug
export UPDATE=0 # If set to 0 wipe and clone repo fresh
export TAG= 2.0.170606 # Github tag to pull
export DAT=_Built-6-17_$TAG # Append this to binaries built

#read -p "Press [Enter] key to continue..." # Insert where you want to pause script
cd $BUILD_DIR

if [ $UPDATE -eq 0 ]; then
##################################################################################################
# Clone the project
##################################################################################################
   rm -rf *
   echo "Clone $PROJECT project..."
   time git clone $PROJECT
   time git submodule update --init --recursive
else
##################################################################################################
# Just get the latest or tagged / commit changes
##################################################################################################
   echo "Updating source from git..."
   git fetch
   time git checkout $TAG
   time git pull origin $TAG
fi
##################################################################################################
# Build the GRAPHENE witness node and CLI wallet.                                        #
##################################################################################################
cd $SUB
time git submodule update --init --recursive
cmake -DCMAKE_BUILD_TYPE=$BUILD_TYPE .
time make

cp $BUILD_DIR/$SUB/programs/cli_wallet/cli_wallet $BIN/cli_wallet$DAT
cp $BUILD_DIR/$SUB/programs/witness_node/witness_node $BIN/witness_node$DAT
pushd $BIN
rm -rf witness_node cli_wallet
ln -s witness_node$DAT witness_node
ln -s cli_wallet$DAT cli_wallet
popd

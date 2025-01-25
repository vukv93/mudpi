version=publishberry
apt install -y libjack-jackd2-dev libsndfile-dev libsamplerate-dev libreadline-dev
git clone -b $version --recursive https://github.com/vukv93/enjam /root/src/enjam
cd /root/src/enjam
make CC=$HOME/opt/bin/clang CXX=$HOME/opt/bin/clang++
# @todo[250105_202638] Provide releaseables, install.
# @todo[250106_143900] Standalone garage blueprint

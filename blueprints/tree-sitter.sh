git clone --recursive https://github.com/tree-sitter/tree-sitter $HOME/src/tree-sitter
cd $HOME/src/tree-sitter
. "$HOME/.cargo/env"
cargo build --release
cargo install --path cli

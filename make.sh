mkdir -p build
ghc -no-keep-hi-files -no-keep-o-files src/Main.hs src/Parse.hs src/Eval.hs src/Map.hs -o ./build/formscript

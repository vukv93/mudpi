#!/usr/bin/env runhaskell
import Text.Pandoc.JSON
main :: IO ()
main = toJSONFilter nouua
nouua :: Block -> Block
-- @todo[250123_064839] Use generated *.png's for pdf output.
-- @todo[250123_065222] Full book build system.
nouua (Image a i t) = nil
nouua x = x

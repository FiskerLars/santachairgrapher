module Main where

import System.Environment

import Lib
import Paper


main :: IO ()
main = getArgs >>= openURL.head >>= putStrLn.show.(parsePaper "id1")

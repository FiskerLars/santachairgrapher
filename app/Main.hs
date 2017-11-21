module Main where

import System.Environment

import Lib
import Paper

publicationListPage = "http://santachair.offis.de/santachair/publications"
cookiePaperId = "http://santachair.offis.de/santachair/publication/168"

main :: IO ()
main = openURL publicationListPage
  >>= (\page -> getReferencingPapers page cookiePaperId >>= putStrLn.show)

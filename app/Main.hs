module Main where

import System.Environment

import Lib
import Paper
import CookieList (cookieSum)

publicationListPage = "http://santachair.offis.de/santachair/publications"
cookiePaperId = "http://santachair.offis.de/santachair/publication/165/"

main :: IO ()
main = do cl <- seq "a" (cookieAssignments publicationListPage cookiePaperId)
          seq (putStrLn $ show cl) (putStrLn $ "\nCookieSum = " ++ (show $ cookieSum cl))

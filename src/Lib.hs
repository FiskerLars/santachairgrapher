module Lib where

import Network.HTTP
import Data.List
--import Network.URI

import Publications
import Paper
import Author
import CookieList

openURL :: String -> IO String
openURL x = getResponseBody =<< simpleHTTP (getRequest x)


getPaperIdsReferencing :: String -> PaperId -> IO [PaperId]
getPaperIdsReferencing publicationsurl pid = getAllPapers publicationsurl
   >>= return . map paperid . filter ((elem (remDomain pid)).references)

getAllPapers :: String -> IO [Paper]
getAllPapers publicationsurl = openURL publicationsurl
   >>= sequence.map (getPaper.addDomain).parsePublicationsPage

getReferencingPapers :: String -> PaperId -> IO [Paper]
getReferencingPapers url pid = getPaperIdsReferencing url pid >>= sequence.map getPaper

getPaper :: String -> IO Paper
getPaper url = openURL url
  >>= return.parsePaper url


addDomain :: String -> String
addDomain url | head url == '/' = "http://santachair.offis.de" ++ url
              | otherwise       = url

remDomain :: String -> String
remDomain url | head url /= '/' = foldl (.) id 
                                      (intersperse (drop 1) $ replicate 3 (dropWhile (/= '/'))) 
                                      url
              | otherwise       = url


cookieAssignments :: String -> PaperId -> IO CookieList
cookieAssignments publicationsurl pidurl = getReferencingPapers publicationsurl pidurl 
     >>= return.assignCookies.map authors  



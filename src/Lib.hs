module Lib where

import Network.HTTP
--import Network.URI

import Publications
import Paper
import Author


openURL :: String -> IO String
openURL x = getResponseBody =<< simpleHTTP (getRequest x)


getPaperIdsReferencing :: String -> PaperId -> IO [PaperId]
getPaperIdsReferencing url pid = openURL url
   >>= sequence.map (\id -> openURL id >>= return.parsePaper id ).parsePublicationsPage
   >>= return . map paperid . filter (elem pid.references)

getReferencingPapers :: String -> PaperId -> IO [Paper]
getReferencingPapers url pid = getPaperIdsReferencing url pid >>= sequence.map getPaper

getPaper :: String -> IO Paper
getPaper url = openURL url
  >>= return.parsePaper url






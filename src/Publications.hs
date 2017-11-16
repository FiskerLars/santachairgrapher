module Publications where

import Data.Char
import Text.HTML.TagSoup

import Paper
import Html

type PubElem = PaperId --, Int, [Author])

parsePublicationsPage :: String -> [PubElem]
parsePublicationsPage = map soupPubListElem
  .soupPubListRefsTags.soupPublicationTags.parseTags


soupPublicationTags:: Html -> Html
soupPublicationTags = takeWhile (~/= "</tbody>")
  . drop 1
  . dropWhile (~/= "<tbody>")
  . dropWhile (~/= "<table class=\"table sortable\">")


soupPubListRefsTags:: Html -> [Html]
soupPubListRefsTags = map (takeWhile (~/= "</tr>").drop 1)
  . sections (~== "<tr>")

soupPubListElem :: Html -> PubElem
soupPubListElem = fromAttrib "href" . head . dropWhile (~/= "<a>")

               

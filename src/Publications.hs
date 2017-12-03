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
soupPublicationTags = drop 1
  . takeWhile (~/= "</tbody>")
  . dropWhile (~/= "<tbody>")
  . dropWhile (~/= TagText "Publication")


soupPubListRefsTags:: Html -> [Html]
soupPubListRefsTags = map (takeWhile (~/= "</tr>").drop 1)
  . sections (~== "<tr>")

soupPubListElem :: Html -> PubElem
soupPubListElem = fromAttrib "href" . head . dropWhile (~/= "<a>")

               

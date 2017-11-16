module Paper where

import Data.Char
import Text.HTML.TagSoup

import Author
import Html


type PaperContent = String
type PaperId = Url
type Title = String


data Paper = Paper {
  paperid    :: PaperId,
  authors    :: [Author],
  title      :: Title,
  references :: [PaperId]
  } deriving (Show, Read, Eq)





parsePaper :: PaperId -> String -> Paper
parsePaper id  = (\h -> Paper { paperid = id , authors = soupAuthors h, title = soupTitle h, references = soupReferenceIDs h}).parseTags

  
soupAuthors    :: Html -> [Author]
soupAuthors = map soupAuthor
  . sections (~== "<a>")
  . takeWhile (~/= "<div class\"papercontent\">")
  . dropWhile (~/= "<a href=\"http://santachair.offis.de/santachair/author")



soupTitle      :: Html -> Title
soupTitle =  innerText . take 2 . dropWhile (~/= "<span class=\"papertitle\">")




soupReferenceIDs :: Html -> [PaperId]
soupReferenceIDs = map (soupReferenceId.takeWhile (~/= "</tr>"))
  . sections (~== "<tr>")
  . soupReferenceSection
  
soupReferenceSection :: Html -> Html 
soupReferenceSection = takeWhile (~/= "</tbody>").drop 1.dropWhile (~/= "<tbody>")
  . dropWhile (~/= "<center class=\"papersection\">")


soupReferenceId :: Html -> PaperId
soupReferenceId =  fromAttrib "href" . head . last . sections (~== "<a>")
    

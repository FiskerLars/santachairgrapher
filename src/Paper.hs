module Paper where

import Data.Char
import Text.HTML.TagSoup

import Data.Maybe
import Author
import Html


type PaperContent = String
type PaperId = Url
type Title = String

data PaperState = Accepted | Submitted | Rejected 
                  deriving (Show, Read, Eq)

data Paper = Paper {
  paperid    :: PaperId,
  paperState :: Maybe PaperState,
  authors    :: [Author],
  title      :: Title,
  references :: [PaperId]
  } deriving (Show, Read, Eq)



parsePaper :: PaperId -> String -> Paper
parsePaper id  = (\h -> Paper { paperid = id , authors = soupAuthors h, title = soupTitle h, references = soupReferenceIDs h, paperState = soupPaperState h}).parseTags

  
soupAuthors    :: Html -> [Author]
soupAuthors = map (soupAuthor.takeWhile (~/= "</a>"))
  . sections (~== "<a>")
  . takeWhile (~/= TagText "Abstract")
  . dropWhile (~/= "<span class=\"papertitle\">")


{- input: whole Title -}
soupTitle      :: Html -> Title
soupTitle =  innerText . take 2 . dropWhile (~/= "<span class=\"papertitle\">")



{- input: whole Paper -}
soupReferenceIDs :: Html -> [PaperId]
soupReferenceIDs = map (soupReferenceId.takeWhile (~/= "</li>"))
  . sections (~== "<li>")
  . soupReferenceSection

{- input: whole Paper -}
soupReferenceSection :: Html -> Html 
soupReferenceSection = concat
  . map (takeWhile (~/= "</ul>").drop 1)
  . sections (~== "<ul>")
  . dropWhile (~/= TagText "References")

  {- takeWhile (~/= "</tbody>").drop 1.dropWhile (~/= "<tbody>")
  . dropWhile (~/= TagText "References")
-}

{- input: Paper-Reference table row -}
soupReferenceId :: Html -> PaperId
soupReferenceId =  fromAttrib "href" . head . last . sections (~== "<a>")
    

{- input: whole paper -}
soupPaperState :: Html -> Maybe PaperState
soupPaperState h =  listToMaybe (sections (~== "<img title=\"ACC\">") h)
  >>= const (Just Accepted) 

module Author where

import Data.Char
import Text.HTML.TagSoup
import Network.URI

import Html

type Url = String

type AuthorId = Url
type Name = String


data Author = Author {
  authorid   :: AuthorId,
  name :: Name
  } deriving (Read, Eq, Ord)


soupAuthor :: Html -> Author
soupAuthor h = Author { authorid = fromAttrib "href" (head h), name = innerText h }

instance Show Author where
	show = name
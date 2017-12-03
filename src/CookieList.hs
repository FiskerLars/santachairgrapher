{-# LANGUAGE TypeSynonymInstances,FlexibleInstances #-}

module CookieList where

import qualified Data.List as List
import qualified Data.Map.Lazy as Map 
import Author

type CookieNum = Float
type CookieList = Map.Map Author CookieNum

assignCookies :: [[Author]] -> CookieList
assignCookies = mergeCookieLists.List.map cookieFractionAssignment

cookieFractionAssignment :: [Author] -> CookieList
cookieFractionAssignment alist = let numa = 1/(fromIntegral $ List.length alist)
                    in List.foldl (\cl a -> Map.insert a numa cl) Map.empty alist

mergeCookieLists :: [CookieList] -> CookieList
mergeCookieLists = List.foldl (Map.unionWith (+)) Map.empty

instance {-# OVERLAPPING #-} Show CookieList where
     show = List.intercalate "\n "
        .Map.foldrWithKey (\author cookieNum l -> ((show author) ++ ": " ++ (show cookieNum)) : l) []


cookieSum :: CookieList -> Float
cookieSum = Map.foldr (+) 0 
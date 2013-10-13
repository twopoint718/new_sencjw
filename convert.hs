{-# LANGUAGE OverloadedStrings #-}

import Control.Applicative
import Data.Maybe
import Data.Monoid
import Data.Yaml
import qualified Data.ByteString          as B
import qualified Data.ByteString.Char8    as C
import qualified Data.ByteString.Internal as BI
import qualified Data.Text                as T
import qualified Data.Vector              as V

data Post = Post { date :: B.ByteString
                 , title :: B.ByteString
                 , postbody :: B.ByteString
                 } deriving Show

instance FromJSON Post where
    parseJSON (Object v) = Post
                           <$> v .: "date"
                           <*> v .: "title"
                           <*> v .: "postbody"

process :: IO [Post]
process = decodeFile "../sencjw.com/posts.yaml" >>= return . fromMaybe []

header post = B.intercalate "\n" [ "---"
                                 , "title: " <> title post
                                 , "---"
                                 ]

formatFile :: Post -> B.ByteString
formatFile p = header p <> "\n" <> postbody p

letters = ['a'..'z'] <> ['A'..'Z'] <> ['0'..'9']

fileName :: Post -> B.ByteString
fileName (Post d t _) = d <> "-" <> C.map dashize t <> ".markdown"
  where
    dashize c
      | c `elem` letters = c
      | otherwise        = '-'

emitPost :: Post -> IO ()
emitPost p = B.writeFile realName (formatFile p)
  where
    realName = filter (/='"') $ "posts/" ++ (show $ fileName p)

main = process >>= mapM_ emitPost

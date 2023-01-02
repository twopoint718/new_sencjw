--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Aeson.Types  (Value (String))
import qualified Data.HashMap.Lazy as M
import           Data.Monoid       ((<>))
import qualified Data.Text         as Text
import           Hakyll
import           Text.Pandoc       (Block, Pandoc, ReaderOptions, WriterOptions)
import qualified Text.Pandoc       as Pandoc
import qualified Text.Pandoc.Walk  as Walk


--------------------------------------------------------------------------------
main :: IO ()
main = hakyll $ do
    match "images/*" $ do
        route   idRoute
        compile copyFileCompiler

    -- "On Beauty" uses reveal.js which needs a bunch of subdirs
    match "talks/**" $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    -- individual "pages"
    match (fromList [ "contact.markdown"
                    , "interviews.markdown"
                    , "talks.markdown"
                    , "writings.markdown"
                    , "the_square_root_of_christmas.markdown"
                    , "transparent_web.markdown"
                    ]) $ do
        route   $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= relativizeUrls

    -- blog posts
    match "posts/*" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/post.html"    postCtx
            >>= saveSnapshot "content"
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            >>= relativizeUrls

    create ["archive.html"] $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            let archiveCtx =
                    listField "posts" postCtx (return posts)
                    <> constField "title" "Archives"
                    <> defaultContext

            makeItem ""
                >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
                >>= loadAndApplyTemplate "templates/default.html" archiveCtx
                >>= relativizeUrls

    create ["atom.xml"] $ do
        route idRoute
        compile $ do
            let feedCtx = postCtx <> bodyField "description"
            posts <- fmap (take 10) . recentFirst =<<
                loadAllSnapshots "posts/*" "content"
            renderAtom sencjwFeedConfiguration feedCtx posts

    create ["feed.rss"] $ do
        route idRoute
        compile $ do
            let feedCtx = postCtx <> bodyField "description"
            posts <- fmap (take 10) . recentFirst =<<
                loadAllSnapshots "posts/*" "content"
            renderRss sencjwFeedConfiguration feedCtx posts

    -- old blog support

    -- Public key file
    match "6D7735C5.asc" $ do
        route idRoute
        compile copyFileCompiler

    -- Keybase.io proof for sencjw.com
    match "keybase.txt" $ do
        route idRoute
        compile copyFileCompiler

    -- Github thingy for making sencjw.com work
    match "CNAME" $ do
        route idRoute
        compile copyFileCompiler

    -- links like /blog.html#2013-10-03
    match "blog.html" $ do
        route idRoute
        compile copyFileCompiler

    match "index.html" $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            let indexCtx =
                    listField "posts" postCtx (return $ take 5 posts)
                    <> constField "title" "Home"
                    <> defaultContext

            getResourceBody
                >>= applyAsTemplate indexCtx
                >>= loadAndApplyTemplate "templates/default.html" indexCtx
                >>= relativizeUrls

    match "templates/*" $ compile templateCompiler


--------------------------------------------------------------------------------
titleCtx :: Context String
titleCtx = field "title" $ \item -> do
    metadata <- getMetadata (itemIdentifier item)
    return $ case lookupString "title" metadata of
        Nothing  -> "No title"
        Just x   -> x

postCtx :: Context String
postCtx =
    titleCtx
    <> dateField "date" "%B %e, %Y"
    <> defaultContext

sencjwFeedConfiguration :: FeedConfiguration
sencjwFeedConfiguration = FeedConfiguration
    { feedTitle       = "sencjw: blog"
    , feedDescription = "This feed is for blog entries"
    , feedAuthorName  = "Chris Wilson"
    , feedAuthorEmail = "chris@sencjw.com"
    , feedRoot        = "http://sencjw.com"
    }

-- probably really Block -> IO Block
foo :: Block -> Block
foo = undefined

thing :: Pandoc -> Pandoc
thing (Pandoc.Pandoc meta blocks) =
  Pandoc.Pandoc meta (Walk.walk foo blocks)

-- transformer
--   :: FilePath       -- e.g. "/absolute/path/filter.py"
--   -> ReaderOptions  -- e.g.  defaultHakyllReaderOptions
--   -> WriterOptions  -- e.g.  defaultHakyllWriterOptions
--   -> (Pandoc -> Compiler Pandoc)
-- transformer script reader_opts writer_opts pandoc = do
--     let input_json = Pandoc.writeJSON writer_opts pandoc
--     output_json <- unixFilter script [] input_json
--     return $
--         either (error.show) id $
--             Pandoc.readJSON reader_opts output_json

-- myCompiler = Hakyll.pandocCompilerWithTransformM
--     defaultHakyllReaderOptions
--     defaultHakyllWriterOptions
--     (transformer
--         "./.stack-work/install/x86_64-osx/lts-8.13/8.0.2/bin/pandoc-include-code"
--         defaultHakyllReaderOptions
--         defaultHakyllWriterOptions)

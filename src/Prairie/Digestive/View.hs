{-# LANGUAGE FlexibleInstances #-}
module Prairie.Digestive.View
    ( View
    , getForm
    , postForm
    , subView
    , fieldInputText
    , fieldInputChoice
    , fieldInputChoiceGroup
    , fieldInputBool
    , fieldInputFile
    ) where

import           Data.Bifunctor (first)
import           Prairie        (Field, Record, recordFieldLabel)
import qualified Text.Digestive as DF

import           Data.Text      (Text)

newtype View rec v = View
    { unwrapView :: DF.View v }

getForm :: (Record rec, Monad m) => Text -> DF.Form v m rec -> m (View rec v)
getForm name = fmap View . DF.getForm name

postForm :: (Record rec, Monad m) => Text -> DF.Form v m rec -> (DF.FormEncType -> m (DF.Env m)) -> m (View rec v, Maybe rec)
postForm name form makeEnv =
    first View <$> DF.postForm name form makeEnv

subView :: (Record rec, Record subrec) => Field rec subrec -> View rec v -> View subrec v
subView field v =
    View $ DF.subView (recordFieldLabel field) (unwrapView v)

class TextLike txt
instance TextLike String
instance TextLike Text

fieldInputText :: (Record rec, TextLike txt) => Field rec txt -> View rec v -> Text
fieldInputText field v =
    DF.fieldInputText (recordFieldLabel field) (unwrapView v)

fieldInputChoice :: (Record rec) => Field rec a -> View rec v -> [(Text, v, Bool)]
fieldInputChoice field v =
    DF.fieldInputChoice (recordFieldLabel field) (unwrapView v)

fieldInputChoiceGroup :: (Record rec) => Field rec a -> View rec v -> [(Text, [(Text, v, Bool)])]
fieldInputChoiceGroup field v =
    DF.fieldInputChoiceGroup (recordFieldLabel field) (unwrapView v)

fieldInputBool :: (Record rec) => Field rec Bool -> View rec v -> Bool
fieldInputBool field v =
    DF.fieldInputBool (recordFieldLabel field) (unwrapView v)

fieldInputFile :: (Record rec) => Field rec a -> View rec v -> [FilePath]
fieldInputFile field v =
    DF.fieldInputFile (recordFieldLabel field) (unwrapView v)

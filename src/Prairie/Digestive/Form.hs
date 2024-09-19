{-# LANGUAGE RankNTypes #-}
module Prairie.Digestive.Form
    where

import           Prairie        (Field, Record, getRecordField,
                                 recordFieldLabel, tabulateRecordA)
import qualified Text.Digestive as DF

form :: (Monad m, Record rec, Monoid v) => (forall ty. Field rec ty -> DF.Formlet v m ty) -> DF.Formlet v m rec
form fieldForm mRec =
    tabulateRecordA $ \field ->
        recordFieldLabel field DF..: fieldForm field (fmap (getRecordField field) mRec)


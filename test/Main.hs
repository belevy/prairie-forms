{-# LANGUAGE DataKinds             #-}
{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE GADTs                 #-}
{-# LANGUAGE LambdaCase            #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings     #-}
{-# LANGUAGE TemplateHaskell       #-}
{-# LANGUAGE TypeFamilies          #-}
module Main (main) where

import           Data.Text              (Text)
import           Prairie
import           Prairie.Digestive.Form as F
import           Prairie.Digestive.View as View
import           Text.Digestive.Form    as DF

data Test = Test { field1 :: Text, field2 :: NestedTest }
data NestedTest = NestedTest { nestedTestField1 :: Text, nestedTestField2 :: Text }
$(mkRecord ''Test)
$(mkRecord ''NestedTest)

main :: IO ()
main = do
    let testFormlet :: DF.Formlet Text IO Test
        testFormlet = form $ \case
            TestField1 -> DF.text
            TestField2 -> form $ \case
                NestedTestField1 -> DF.text
                NestedTestField2 -> DF.text
    v  <- View.getForm "form_name" (testFormlet $ Just $ Test "test1" (NestedTest "test2" "test3"))

    print $ View.fieldInputText NestedTestField2 $ View.subView TestField2 v

{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TemplateHaskell #-}
module Lib
    ( someFunc
    , allCompanies
    ) where

import Web.Scotty
import Control.Applicative ((<$>))
import Data.Monoid ((<>))
import GHC.Generics
import Data.Aeson.TH (defaultOptions, deriveJSON)
import Data.Text.Lazy (Text)
import Data.Text.Lazy.Encoding (decodeUtf8)

data Company = Company { companyId :: Int, name :: String} deriving (Show, Generic)

$(deriveJSON defaultOptions ''Company)

testCompany :: Company
testCompany = Company { companyId = 1, name = "Test Co" }

allCompanies :: [Company]
allCompanies = [testCompany]

someFunc = do
    putStrLn "Booting up..."
    scotty 3000 $ do

        get "/hello/:name" $ do
            name <- param "name"
            text ("Hello world " <> name)
        
        get "/bye/:name" $ do
            name <- param "name"
            text ("Bye " <> name)

        get "/companies" $ do
            json allCompanies

        post "/yo" $ do
            name <- param "name"
            text ("Hi " <> name)
        
        post "/it" $ do
            t <- jsonData 
            json (t :: Company)
        
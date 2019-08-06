module Main where

import           Database.Persist               ( entityVal )

import           Schema

main :: IO ()
main = do
  users <- runAction fetchBarryUser
  mapM_ (print . entityVal) users

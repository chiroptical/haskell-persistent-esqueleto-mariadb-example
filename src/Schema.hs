{-# LANGUAGE TemplateHaskell            #-}
{-# LANGUAGE QuasiQuotes                #-}
{-# LANGUAGE TypeFamilies               #-}
{-# LANGUAGE MultiParamTypeClasses      #-}
{-# LANGUAGE GADTs                      #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE RecordWildCards            #-}
{-# LANGUAGE FlexibleInstances          #-}
{-# LANGUAGE OverloadedStrings          #-}

module Schema where

import           Control.Monad.IO.Class         ( liftIO
                                                , MonadIO
                                                )
import           Control.Monad.Logger           ( LoggingT
                                                , runStderrLoggingT
                                                )
import           Control.Monad.Reader           ( runReaderT )
import           Database.Persist               ( get
                                                , entityVal
                                                , Entity
                                                )
import           Database.Persist.MySQL         ( runMigration
                                                , ConnectInfo(..)
                                                , SqlPersistT
                                                , defaultConnectInfo
                                                , withMySQLConn
                                                , toSqlKey
                                                )
import qualified Database.Persist.TH           as PTH
import           Data.Int                       ( Int64 )
import           Database.Esqueleto             ( select
                                                , from
                                                , (^.)
                                                , (==.)
                                                , where_
                                                , val
                                                )

PTH.share [PTH.mkPersist PTH.sqlSettings, PTH.mkMigrate "migrateAll"] [PTH.persistLowerCase|
User
  name String
  email String
  age Int
  occupation String
  deriving Show Read Eq
|]

connectInfo :: ConnectInfo
connectInfo = defaultConnectInfo { connectUser     = "YOUR_USERNAME"
                                 , connectPassword = "YOUR_PASSWORD"
                                 , connectDatabase = "YOUR_DATABASE"
                                 }

runAction :: SqlPersistT (LoggingT IO) a -> IO a
runAction action = runStderrLoggingT $ withMySQLConn connectInfo $ \backend ->
  runReaderT action backend

createTable :: IO ()
createTable = runAction $ runMigration migrateAll

fetchUser :: Int64 -> IO (Maybe User)
fetchUser uid = runAction (get $ toSqlKey uid)

fetchBarryUser :: (Monad m, MonadIO m) => SqlPersistT m [Entity User]
fetchBarryUser =
  select . from $ \u -> do
    where_ (u ^. UserName ==. val "Barry Moore")
    return u
